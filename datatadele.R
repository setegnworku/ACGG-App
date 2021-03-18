library(leaflet.extras)
library(shinyWidgets)
library(flexdashboard)
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
library(leaflet)
library(sf)
library(raster)
library(dplyr)
carto = "http://a.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png"
addTiles(carto) %>% 

setwd("/home/user/Documents/dashboard/shinyv2")
places<- c("Kundudo","Dabat","Shambu","Fiche","Gobarobe","Masha","mega","Kebri beyan")
lat<-c(9.43,12.98,9.56,9.78,7.01,7.73,4.05,9.09)
long<-c(42.3,37.76,37.09,38.73,39.97,35.48,38.3,43.17)
elevation<- c('2467-4455','2467-4455','2467-4455','2467-4455','2467-4455','1833-2466','1264-1832',
              '1264-1832')
dattadele<- data.frame(places,lat,long,elevation)
write.table(dattadele,'Dattadele.txt',row.names=F,col.names=T,quote=F)
mymap<- leafletOutput("mymap", width="100%", height="100%")
pal=factor(palette=c('green','red','yellow','blue','purple','brown','orange'),domain=dattadele$places)

Kundudo<- dattadele[dattadele$places=="Kundudo",]
Dabat<-  dattadele[dattadele$places=="Dabat",]
Shambu<-  dattadele[dattadele$places=="Shambu",]
Goberobe<-  dattadele[dattadele$places=="Gobarobe",]
Masha<-  dattadele[dattadele$places=="Masha",]
mega<-  dattadele[dattadele$places=="mega",]
kebribeyan<- dattadele[dattadele$places=="Kebri beyan",]

  mymap <-  leaflet(dattadele) %>% addTiles(group = "OSM") %>%
      addProviderTiles("OpenTopoMap", group = "OpenTopoMap") %>%
      addProviderTiles("Thunderforest.Transport", group = "Thunderforest.Transport") %>%
      addProviderTiles('Esri.WorldImagery',group='Imagery') %>%
      addProviderTiles("CartoDB", group = "Carto") %>%
      addProviderTiles("Esri", group = "Esri")%>% setView(lng = 40.48, lat = 9.14, zoom = 3) %>% 
      addCircleMarkers(data =Kundudo, radius =  15,label = ~'Kundudo',
                       
                       color = "green", group = "Kundudo",
                       labelOptions = labelOptions(noHide = TRUE, offset=c(0,-12), textOnly = TRUE)   ) %>%
      addCircleMarkers(data = Dabat, radius = 15,
                       label = ~"Dabat",
                       color = "red", group = "Dabat",
                       labelOptions = labelOptions(noHide = TRUE, offset=c(0,-12), textOnly = TRUE)  ) %>%
      
      addCircleMarkers(data =Shambu, radius = 17,label = ~"Shambu",
                       color = 'yellow', group = "Shambu") %>%
      addCircleMarkers(data = Goberobe, radius = 19,label = ~"Gobe Robe",
                       color = 'blue', group = 'Goberobe') %>% 
      addCircleMarkers(data =Masha, radius = 13,label = ~"Masha",
                       color = "purple", group = "Masha") %>%
      addCircleMarkers(data = mega, radius =13,label = ~"Mega",
                       color = 'brown', group = "mega") %>%
      addCircleMarkers(data = kebribeyan, radius = 12,label = ~"Kebri beyan",
                       color = 'orange', group = "kebribeyan") %>% 
    
      # add layer controls for base and overlay groups
      addLayersControl(baseGroups = c("OSM", "Carto", "Esri",'OpenTopoMap',"Thunderforest.Transport",'Imagery'),
                       overlayGroups = c("Kundudo","Dabat","Shambu","Goberobe","Masha","mega",'kebribeyan') )%>%   addLegend(position = "bottomright",pal = pal, opacity = 0.5, title = "Places",
                                                                                                                                                                     values =c("Kundudo","Dabat","Shambu","Goberobe","Masha","mega",'kebribeyan')) 
