library(ggplot2)
library(gganimate)
theme_set(theme_bw())
library(png)
library(shinydashboard)
library(gifski)
library(shinythemes)
library(plotly)
library(shinythemes)
library(forcats)
library(shiny)
library(shinyjs)
library(ggplot2)
library(plotly)
library(DT)
library(shinythemes)
library(tidyverse)
library(shinyalert)
dashHeader=dashboardHeader(title = 'ACGG Project Dashboard',
                           titleWidth = 450,
                      
                           dropdownMenu(
                             type = "notifications",
                             notificationItem(
                               text = "This is the dashboard for all ACGG dataset",
                               icon =   icon("warning"),
                               status='warning'
                             ),
                             notificationItem(
                               text = "We used linear mixed model to analyse the data",
                               icon =   icon("dashboard"),
                               status='success'
                             ),
                             notificationItem(text = "This dashboard will be automated",
                                              icon =   icon("dashboard"),
                                              status='info'
                             )
                           ),
                           
                           dropdownMenu(
                             type = "task",
                             taskItem(
                               value = 80,
                               color = 'blue' ,
                               'Based on this result, ACGG II will be launched very soon'
                             ),
                             taskItem(
                               value = 90,
                               color = 'green' ,
                               'Most of the work related to dashboard is accomplished'
                             ),
                             taskItem(
                               value = 50,
                               color = 'red' ,
                               'What remains to be done is include GIS result in dashboard'
                             )
                           )       
                           
                           
)                 
dashSidebar=dashboardSidebar(

  sidebarMenu(
    menuItem(text='On farm testing',
             tabName = 'onfarm',
             icon=icon('dashboard')),
    menuItem(text='On station experiment',
             tabName = 'onstation',
             icon=icon('dashboard')),
    menuItem(text='Animated survival plot',
             tabName='animate',
             icon=icon('bar-chart-o'))
    
))
dashBody=dashboardBody(
  useShinyjs(),
  useShinyalert(),
 
  list(
    actionButton(inputId = "showh", label = "Show hidden text"),
    actionButton(inputId = "hideh", label = "Hide text"),
    br(),
    hidden(tags$div(id="txt", style='color:blue;', list(helpText("This app is scalable and repeatable. If you want to print this app result, you need 38 pages of word document."),hr())))),
  
  tabItems(
    tabItem(
      tabName='onfarm',
      fluidRow(
        box( width=3,
             collapsible = TRUE,
             title='Controls',
             status='success',solidHeader = TRUE,
      
             selectInput("country", "Country", choices = c('Ethiopia','Nigeria','Tanzania'),selected='Ethiopia'),
             selectInput("trait", "Trait", choices = c('wt','eggs'),selected='wt'),
             uiOutput('AEZ'),
             actionButton("gobutton","Toggle the Table")),
        box( width=9,
            plotlyOutput("plotf"),
            br(),
            dataTableOutput(outputId = "tableDTf")  
       ) 
      )

  
     ), 
    tabItem(
      tabName='onstation',
      fluidRow(
        box( width=3,
             collapsible = TRUE,
             title='Controls',
             status='success',solidHeader = TRUE,
           
             selectInput("country2", "Country", choices = c('Ethiopia','Nigeria','Tanzania'),selected='Ethiopia'),
             uiOutput('stationui'),
             uiOutput('traitui'),
             actionButton("gobutton2","Toggle the Table")),
        
        
        box( width=9,
        plotlyOutput("plots"),
        br(),
        dataTableOutput(outputId = "tableDTs")  
             
        ))),
    tabItem(
      tabName='animate',
      fluidRow(
        box( width=3,
             collapsible = TRUE,
             title='Controls',
             status='success',solidHeader = TRUE,
     
             selectInput("country3", "Country", choices = c('Ethiopia','Nigeria','Tanzania'),selected='Ethiopia'),
             uiOutput('stationuia')),
            # actionButton("gobutton3","Toggle the Table")),
       box( width=9,

                         plotlyOutput('plotanim')))
                
        )))
   
  





ui<- dashboardPage(
  header= dashHeader,
  sidebar=dashSidebar,
  body=dashBody,
  title="ACGG Dashboard"
)