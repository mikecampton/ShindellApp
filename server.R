# Read files into global memory
countries_dMort <-read.csv("csvData/GISS_Run3_2000.csv")
countries_mmm <-read.csv("csvData/MMMresults.csv")
initialmort <- read.csv("csvData/InitialMort.csv")
agebinpop <- read.csv("csvData/AgeBinnedPop.csv")
initialO3 <- read.csv("csvData/InitialO3.csv")
baselinemortality <- read.csv("csvData/BaselineMortality.csv")
afFormat <-read.csv("csvData/AFFormatted.csv")


shinyServer(function(input, output){

cat("\nEXECUTION ", format(Sys.time(), "%a %b %d %X %Y"), "\n", file=stderr())
#cat("\n\nAAAAAAAAAAAAAAAAAAAA\n\n", file=stderr())
  #Environment variables
  EpiHR = 1.12
  EpiHRLow = 1.08
  EpiHRHigh = 1.16
  EpiTMREL = 26.3
  InputCH4Change = 556
  EpiBeta = .01133
  
  #text render
  n = renderText({input$obs})
  dataSetMMM <-reactive({switch(input$countries_dMort)})
  output$caption <- renderText({
    input$obs
  })
  df<-data.frame(countries_mmm["Country"],countries_mmm["ANN_MDA8Sim2.Sim1.Diff."])
  dfO3 <-data.frame(initialO3["Country"],initialO3["MMM.Initial.O3..ppb."])
  #Ozone Delta Map

  output$ozoneCountry_2040 <- renderggiraph({
    world <- map_data("world")
    ozoneDF<-setNames(data.frame(df[1],df[2]*-1*input$obs*(1/556)),c("Country","OzoneReduction"))
    map.world_joined <- left_join(world, ozoneDF, by = c('region' = 'Country'))
    # using width="auto"y and height="auto" to
    # automatically adjust the map size
    gg<-ggplot() + geom_polygon_interactive(data = map.world_joined, 
                                            aes(x = long, y = lat, group = group, fill = OzoneReduction, tooltip=sprintf("%s<br/>%s",region,OzoneReduction)))
    gg<-gg+ coord_proj("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
    gg<-gg+theme_map()
    ggiraph(code = print(gg), width_svg=10)
  })

  #Delta Mortality Map
  
  dfAF <- data.frame(afFormat["TotalOAF"],afFormat["InitialMort"])
  #avoided deaths - 2045 is just temporary
  output$dMortCountry_2040 <-renderggiraph({
    #how it's done in the excel sheet below
    #recomment what calculations I did and what the dataframes mean
    #=IF((Input!C10-Input!$C$7+$C4)<0,0,1-EXP(-Input!$G$4*(Input!C10-Input!$C$7+$C4)))
    #=IF((Input!C162-Input!$C$7+$C156)<0,0,1-EXP(-Input!$G$4*(Input!C162-Input!$C$7+$C156)))
    #=$J4*Population!C4*'Baseline Mortality'!C4
    #=X4-AK4
    
    #below sets up the two columns of the truth statement for Mean AF
    meanAF<-data.frame((data.frame((df[2]*-1*input$obs*(1/556))-EpiTMREL)+dfO3[2]))
    tempExpFrame<-data.frame(1-exp((data.frame((df[2]*-1*input$obs*(1/556))-EpiTMREL)+dfO3[2])*-1*EpiBeta))
    #below is the Mean AF
    meanAF[2] <- ifelse(meanAF[1]<0,0,tempExpFrame[1])
    deathCol<-ceiling(-1*data.frame(meanAF[2])*dfAF[1]+dfAF[2])
    deathFram <- data.frame(df[1],deathCol)
    dfDeaths <- setNames(deathFram,c("Country","AvoidedDeaths"))
    
    #plot everything below
    world <- map_data("world")
    map.world_joined <- left_join(world, dfDeaths, by = c('region' = 'Country'))
    gg<-ggplot() + geom_polygon_interactive(data = map.world_joined, 
                                            aes(x = long, y = lat, group = group, fill = AvoidedDeaths, tooltip=sprintf("%s<br/>%s",region,AvoidedDeaths)))
    gg<-gg+ coord_proj("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
    gg<-gg+theme_map() 
    ggiraph(code = print(gg), width_svg=10)
  })
})
#geom_sf will work for netcdf files likely.

