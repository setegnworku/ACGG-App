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
onfarm<- read.table("onfarm.txt",h=T)
Ethiopia<- onfarm %>% filter(country=='Ethiopia')
Ethiopia$Breed[Ethiopia$Breed == 'S-RIR'] <-'SassoXRIR'

Ethiopia$Breed<- factor(Ethiopia$Breed)
Ethiopia$AEZ<- droplevels(Ethiopia$AEZ)
Ethiopia$Breed<- droplevels(Ethiopia$Breed)

Nigeria<- onfarm %>% filter(country=='Nigeria')
Nigeria$AEZ<- droplevels(Nigeria$AEZ)
Nigeria$breed<- droplevels(Nigeria$Breed)
Tanzania<- onfarm %>% filter(country=='Tanzania')
Tanzania$AEZ<- droplevels(Tanzania$AEZ)
Tanzania$Breed<- droplevels(Tanzania$Breed)
onstation<- read.table("onstation.txt",h=T)
Ethiopias<- onstation %>% filter(country=='Ethiopia')
Ethiopias$AEZ<- droplevels(Ethiopias$AEZ)
Nigerias<-onstation%>% filter(country=='Nigeria')
Nigerias$AEZ<- droplevels(Nigerias$AEZ)
Tanzanias<- onstation %>% filter(country=='Tanzania')
Tanzanias$AEZ<- droplevels(Tanzanias$AEZ)
Tanzanias$trait<- droplevels(Tanzanias$trait)
survdat<- read.table('survdat.txt',h=T)
# levels(survdat$station)[levels(survdat$station)=="Funa" ] <- "Funaab"
# levels(survdat$station)[levels(survdat$station)=="Hope"] <- "Fol-Hope"
# levels(survdat$station)[levels(survdat$station)=="Nail"] <- "Naliendele" 
# levels(survdat$station)[levels(survdat$station)=="Sua"] <-   "Sokoine_University"
# write.table(survdat,'survdat.txt',row.names=F,col.names=T,quote=F)
server <- function(input, output) {
  library(shinyjs)
  observeEvent(input$showh,
               show("txt")) # show() is shiny js function, pass the element/widget ID as the argument

  observeEvent(input$hideh,
              hide("txt"))

  vara<- reactive({

    if (is.null(input$country)) {
      return(NULL)
    }
    if (is.null(input$trait)) {
      return(NULL)
    }
    if (input$country=='Ethiopia'&input$trait=='wt') {
      levels(droplevels((Ethiopia %>% filter(trait=='Bwt'))$AEZ))
       
    }else if (input$country=='Nigeria'&input$trait=='wt'){
     levels(droplevels((Nigeria %>% filter(trait=='Bwt'))$AEZ))

    }     else if(input$country=='Tanzania'&input$trait=='wt') {
      levels(droplevels((Tanzania %>% filter(trait=='Bwt'))$AEZ))

    }else if (input$country=='Ethiopia'&input$trait=='eggs'){
      levels(droplevels((Ethiopia %>% filter(trait=='Egg'))$AEZ))
      
    }else if (input$country=='Nigeria'&input$trait=='eggs'){
      levels(droplevels((Nigeria %>% filter(trait=='Egg'))$AEZ))
      
    }else {
    levels(droplevels((Tanzania %>% filter(trait=='Egg'))$AEZ))

      }


 })



  output$AEZ<- renderUI({
    selectInput('aez','Agro ecology zone',choices=vara())
  })
  
  

  datf<- reactive({
    onfarm%>% filter(country%in%input$country& AEZ%in%input$aez)
  })
output$plotf <- renderPlotly({
  

   
    dataf<-    datf()
    df=dataf
    ylabs<- c('Number of eggs per bird per year ','Live body weight-at-week-20(g)')
    if ( input$trait=='eggs'){
      ylabc2<- ylabs[1]
      df<- datf() %>% filter(trait=='Egg')
      maxval=df$lsmean +df$Standard_error
      minval=df$lsmean - df$Standard_error
      limits=aes(ymax = maxval, ymin=minval)
    }
    if ( input$trait=='wt'){
      ylabc2<- ylabs[2]
      df<- datf() %>% filter(trait=='Bwt')
      maxval=df$lsmean +df$Standard_error
      minval=df$lsmean - df$Standard_error
    }
        plotf= plot_ly(x=droplevels(df$Breed),y=df$lsmean,type='bar',color=df$Breed,showlegend=T, error_y=list(array=df$Standard_error)) %>%
          layout(xaxis=list(title=NA),yaxis=list(title=ylabc2),barmode='group')
        plotf
        
  
}
)
output$tableDTf <- renderDataTable({

    if( input$trait=='eggs'){
      df<- datf() %>% filter(trait=='Egg')
     }
    if( input$trait=='wt'){
      df<- datf() %>% filter(trait=='Bwt')
    }
   na.omit(df[,1:4])
    
  
})

observeEvent(input$gobutton, {
  # every time the button is pressed, alternate between hiding and showing the plot
  toggle("tableDTf")
})   
    
  ## On station server
  vars<- reactive({
    switch( input$country2,
        'Ethiopia'= factor(levels(Ethiopias$AEZ)),
        'Nigeria'=factor(levels(Nigerias$AEZ)),
        'Tanzania'=factor(levels(Tanzanias$AEZ)))
  })
  
  output$stationui<- renderUI({
    selectInput('Station','Station',choices=vars())
  })
  
  vart<- reactive({
    switch( input$country2,
            'Ethiopia'= c(levels(Ethiopias$trait),'Survival'),
            'Nigeria'=c(levels(Nigerias$trait),'Survival'),
            'Tanzania'=c(levels(Tanzanias$trait),'Survival'))
  })
  
  output$traitui<- renderUI({
    selectInput('Trait','Trait',choices=vart())
  })
  
  dats<- reactive({
    
    
if ( input$Trait!='Survival'){
    onstation %>% filter(AEZ%in%input$Station&country%in%input$country2)
    }
    
    else {

      survdat %>% filter(country%in%input$country2&station%in%input$Station)
      
    }
    
  })
  
  
  output$plots <- renderPlotly({
    
  
      
     
    dataf=dats()
      
     
      ylabs<- c('Number of eggs per bird per year egg','Live body weight-at-week-20(g)','Feed intake per bird per day(g)')
      if ( input$Trait=='Egg'){
     
        df<- dats() %>% filter(trait=='Egg')
        maxval=df$lsmean +df$Standard_error
        minval=df$lsmean - df$Standard_error
        limits=aes(ymax = maxval, ymin=minval)
        ylabc2<- ylabs[1]
      }
      if ( input$Trait=='Bwt'){
        df<- dats() %>% filter(trait=='Bwt')
        maxval=df$lsmean +df$Standard_error
        minval=df$lsmean - df$Standard_error
        limits=aes(ymax = maxval, ymin=minval)
        ylabc2<- ylabs[2]
      }
      if ( input$Trait=='RFI'){
        df<- dats() %>% filter(trait=='RFI')
        maxval=df$lsmean +df$Standard_error
        minval=df$lsmean - df$Standard_error
        limits=aes(ymax = maxval, ymin=minval)
        ylabc2<- ylabs[3]
      }
    
      if ( input$Trait!='Survival'){
        df$Breed<- droplevels(df$Breed)
        df$AEZ<- droplevels(df$AEZ)
       
          plotf= plot_ly(x=df$Breed,y=df$lsmean,type='bar',color=df$Breed,showlegend=T, error_y=list(array=df$Standard_error)) %>%
            layout(xaxis=list(title=NA),yaxis=list(title=ylabc2),barmode='group')
        plotf
      }
      
       else {
        dataf$Breed<- droplevels(dataf$Breed)
        dataf$station<- droplevels(dataf$station)
        p<-ggplot(dataf, aes(x=week, y=Proportion_survived, group=factor(Breed))) +
          geom_line(aes(color=Breed))+
          geom_point(aes(color=Breed))
        

      }
    
  })
  

  output$tableDTs <- renderDataTable({
    req(input$Trait)
      if ( input$Trait=='Egg'){
        
        df<- dats() %>% filter(trait=='Egg')
        
      }
      if ( input$Trait=='Bwt'){
        df<- dats() %>% filter(trait=='Bwt')
      }
    
      if ( input$Trait=='RFI'){
        df<- dats() %>% filter(trait=='RFI')
      }
      if ( input$Trait=='Survival'){
        df<- dats() 
      }
      na.omit(df[,1:4])
      
    
  })
  
  observeEvent(input$gobutton2, {
    toggle("tableDTs")
  })   
  

  varsa<- reactive({
    switch( input$country3,
            'Ethiopia'= factor(levels(Ethiopias$AEZ)),
            'Nigeria'=factor(levels(Nigerias$AEZ)),
            'Tanzania'=factor(levels(Tanzanias$AEZ)))
  })
  
  output$stationuia<- renderUI({
    selectInput('Stationa','Station',choices=varsa())
  })
  
  datsa<- reactive({

      survdat %>% filter(country%in%input$country3&station%in%input$Stationa)
    
  })
  

  
require(tidyverse)

output$plotanim<- renderPlotly({

if (input$country3=='Nigeria'&input$Stationa=='Fol-Hope'){
  newdat<- datsa()%>% filter(week>21)
}else{
  newdat<- datsa()
}
newdat$Breed<- droplevels(newdat$Breed)
newdat2= newdat%>% complete(Breed,week,fill=list(Proportion_survived=0))
cumulative_launches <- newdat %>%
  split(f = .$week) %>%
  accumulate(., ~bind_rows(.x, .y)) %>%
  bind_rows(.id = "frame")
# Create the cumulative animation
cumulative_launches %>%
  plot_ly(x = ~week, y = ~Proportion_survived, color = ~Breed) %>%
  add_lines(frame = ~frame)

})
}
