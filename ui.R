library(shiny)
library(shinydashboard)
library(mapdeck) 
library(colourvalues)
library(tidyverse)
library(googleVis)
library(colourvalues)
library(jsonify)
library(geojsonsf)
library(spatialwidget)
library(googlePolylines)
library(maps)
library(ggplot2)
library(ggmap)
library(ggalt)
library(ggthemes)
library(ggiraph)
library(mapproj)

initialCH4Change = 556

shinyUI(dashboardPage(skin='blue',
  dashboardHeader(
    title = "Assessment of Environmental and Societal Impacts of Methane Reductions",
    titleWidth = 800
  ),
  
  
  dashboardSidebar(width = 300,
  sidebarMenu(
    menuItem("Home", tabName = "Home", icon = icon('align-justify')),

    menuItem("Impacts", tabName = "Impacts", icon = icon('map'))
  )),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "Home",
                HTML(
                "<h2>Impacts of Methane Reduction on Climate, Health, Ecosystems and the Economy</h2> 
                <p>This site provides a tool to display analyses from the UN Environment-supported Global Methan
e Assessment to support decision making regarding methane emissions. Users enter the potential methane emissions
 reductions (or increases) associated with any action of interest, ranging from individual projects to national 
or international action plans. The tool then provides quantitative values for multiple impacts of those emission
s reductions. These include their effects on climate change and ground-level ozone concentrations, and then via 
those environmental changes the resulting impacts on human health, agricultural crops and the economy. Results a
re based upon a set of coordinated modeling studies undertaken using the following models: the CESM2 model devel
oped at the National Center for Atmospheric Research in Boulder, CO, USA; the GFDL AM3/CM3 model developed by th
e National Oceanographic and Atmospheric Administration in Princeton, NJ, USA; the GISS E2.1/E2.1-G model develo
ped by the National Aeronautics and Space Agency in New York, NY, USA; the MIROC-CHASER model developed by the M
eteorological Research Institute in Tsukuba, Japan; and the HadGEM3 model developed by the UK Meteorological Off
ice, Exeter, UK.</p> 

<p>We thank our sponsors: UN Environment, the Climate and Clean Air Coalition, NASA. </p>
             "),
HTML("<img src=/srv/shiny-server/shindell/methane/www/CCAC_logo.png>"),
#img(src="./www/CCAC_logo.png),
width = 12),
     
      tabItem(tabName = "Impacts", 
            
              h3("Mt methane reduction (input a negative number)"),
              numericInput("obs", "", -1*initialCH4Change, min = -2000, max = 0),            
              fluidRow(
                box(title = "Change in Premature Deaths Due to Ozone Exposure", 
                    width = 12, 
                    ggiraphOutput("dMortCountry_2040"))
              ),
 
              h4("The above map shows the change in premature deaths due to respiratory and cardiovascular illne
sses caused by ozone. Results are based upon the relationship between ozone exposure and health impacts determin
ed from the American Cancer Society Cancer Prevention Study II that followed more than 660,000 people for 22 yea
rs and quantified the increased risk of heart disease, cerebrovascular disease, pneumonia and influenza, chronic
 obstructive pulmonary disease and lung cancer with increased ozone exposure. Those increased risks are combined
 with data on public health conditions and population distributions to evaluate worldwide health burdens."),
              fluidRow(
              
                box(title = "Change in Ground-level Ozone Concentration (ppb)", 
                    width = 12,
                    ggiraphOutput("ozoneCountry_2040"))
              ),
             h4("The above map shows the change in ground-level ozone in response to the input methane emissions
 changes. Values are based on the multi-model mean of the five participating models. Additional analyses demonst
rated that ozone responses are approximately linearly proportional to methane emissions changes, so that these i
nterpolated results are highly accurate for current background atmospheric conditions."),
 
              )
    
      
    )
    )
  )
  
)
