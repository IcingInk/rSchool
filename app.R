# from youtube - Greg Sward.
# https://www.youtube.com/watch?v=wUE71sTs1dE&list=PLmrGRg8An3QG5pZ5_sTzWyjqGTRsPJfSf&index=7

library(leaflet)

m <- leaflet()
m

# adding the basemap
# adding a view, with coordinates ( lng = -149.4937, lat = 64.2008 ) for alaska
# the pipe-operator ... funkar bara med vissa bibliotek , 'chainar' ...
# pipe -> https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html 

m <- leaflet() %>% 
    addTiles() %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4)
m

# istället för pipes, knepigare syntax .... försök undika detta ....
#m <- setView(addTiles(leaflet()), lng = -120.4937, lat = 64.2008, zoom = 4)
#m

# här finns flera themese : https://leaflet-extras.github.io/leaflet-providers/preview/ 
m <- leaflet() %>% 
    addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4)
m

m <- leaflet() %>% 
    addProviderTiles(providers$Stamen.Toner) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4)
m

# https://www.kaggle.com/murderaccountability/homicide-reports
# lektion 6, hämtar han shapefiler från sitt 'repo'
# kör library(rgdal) -> https://cran.r-project.org/web/packages/rgdal/rgdal.pdf 
# använder readOGR från rgdal biblioteket  readOGR(data/.... .shp)
# använder county-lines från shape-filen, så ritas dessa ut på kartan med hjälp av addPolygons, han ändrar också färg och bredd på linjerna ....

# install.packages("rgdal") https://stackoverflow.com/questions/44382368/rgdal-installation-difficulty-on-ubuntu-16-04-lts 
#  sudo apt-get install libgdal-dev libproj-dev
# shapefiles (county lines ) https://catalog.data.gov/dataset/tiger-line-shapefile-2013-state-alaska-current-county-subdivision-state-based 
# går tillbaka till lektion 6, shapefiles.

library(rgdal) # 'Geospatial' Data Abstractaction Library , read shape-files ( readOGR)
ak_counties <- readOGR("data/tl_2013_02_cousub/tl_2013_02_cousub.shp")
m <- leaflet() %>% 
    addProviderTiles(providers$Stamen.Toner) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4) %>% 
    addPolygons(data = ak_counties,
                color = "#660000",
                weight =1,
                smoothFactor = 1) 
m

# han har homocide-data från sitt 'repo', hämtas från kaggle.com , men inga koordinater ...
fbi_data <- read.csv("data/database.csv") # video nummer 7

library(dplyr)
library(ggmap) # Please cite ggmap if you use it! See citation("ggmap") for details.

# filter the homocide dataset, interested in alaska
ak <- filter(fbi_data, State == "Alaska") ## Filtrerar på kolumnen 'State'
ak <- mutate(ak, address = paste(City,State, "United States")) # skapar den kolumnen i datasettet

# Installare ggmap -> install.packages("ggmap")
# vill ha en lista med de unika adresserna
addresses <- unique(ak$address)
addresses
# https://www.r-bloggers.com/geocoding-with-ggmap-and-the-google-api/
# I create the project rIngimar at https://cloud.google.com/maps-platform/?apis=maps
# https://lucidmanager.org/geocoding-with-ggmap/

api <- readLines("data/google.api")
register_google(key=api)
getOption("ggmap")
geocodes <- geocode(as.character(addresses), source="google")
# OBS: testade den 20190703, verkar inte funka, måste köra 'enable' på  'Google Places API Web Service'
# Jag kikar på geocodes -> View(gecodes) - och vissa är 'NA'
addresses_and_coords <- data.frame(address = addresses,
                                  lon = geocodes$lon,
                                  lat = geocodes$lat)
# Loop-structure to query - lektion 7, skippar nu eftersom inga är 'NA'
#counter <- 0
#while (sum(is.na(addresses_and_coords$lon)) > 0 && counter < 10 ){
#    missing_addresses <- addresses_and_coords %>%
#        filter(is.na(lon)==TRUE)
#    addresses <- missing_addresses$address
#    geocodes <- geocode(as.character(addresses), source ="google")
#}

rm(geocodes,addresses,missing_addresses,counter)

#left-join function, joinar på 'address'
ak <- left_join(ak, addresses_and_coords, by="address")
ak$lon <- jitter(ak$lon, factor = 1) # the higher factor the more noise
ak$lat <- jitter(ak$lat, factor = 1)


#Lektion 8, lägga ut punkterna på kartan. 'Crime.Type' och 'Crime.Solved'='yes'/'no'
#unsolved crimes.
ak_unsolved <- ak %>%
    filter(Crime.Type == "Murder or Manslaughter") %>%
    filter(Crime.Solved == "No")

library(htmltools) # label = lapply(ak_unsolved$label,HTML))
## Lägger till label i dataframen - visas sen som 'text', vi måste installera ett paket ... library(htmltools)
ak_unsolved$label <- paste("<p>", ak_unsolved$City, "</p>",
                           "<p>", ak_unsolved$Month, " ", ak_unsolved$Year, "</p>",
                           "<p>", ak_unsolved$Victim.Sex," ", ak_unsolved$Victim.Age, "</p>",
                           "<p>", ak_unsolved$Victim.Race, "</p>",
                           "<p>", ak_unsolved$Weapon, "</p>",
                           "<p>", ak_unsolved$City, "</p>")
# Med label
m <- leaflet() %>% 
    addProviderTiles(providers$Stamen.Toner) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4) %>%
    addCircleMarkers(lng=ak_unsolved$lon, 
                     lat = ak_unsolved$lat,
                     color = "ffffff",
                     weight = 1,
                     radius = 5,
                     label = lapply(ak_unsolved$label,HTML)) # convert the number to text (se hjälpen)
m
# second challenge ,of the dataset : alla observationer är 'unika' så för Anchorage hamnar alla på samma punkt ....
# add some 'white'-noise ...

# Lesson 9, add popup labels - använda 'year' - går upp till leaflet
# skriver in ?addCircleMarkers
# we can store the 'label' in the dataframe (html-widget) - använder sen library(htmltools) -> label med html
## Go through the leaflet-page -> 'popups and labels'

# Lesson 10, clustering (video=3:26) -> clusterOptions = markerClusterOptions() 
# you can finetune the clustering

m <- leaflet() %>% 
    addProviderTiles(providers$Stamen.Toner) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4) %>%
    addCircleMarkers(lng=ak_unsolved$lon, 
                     lat = ak_unsolved$lat,
                     color = "ffffff",
                     weight = 1,
                     radius = 5,
                     label = lapply(ak_unsolved$label,HTML),  # convert the number to text (se hjälpen)
                     clusterOptions = markerClusterOptions()
                     )
m

# Adding show -> 


m <- leaflet() %>% 
    addProviderTiles(providers$Stamen.Toner) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4) %>%
    addCircleMarkers(lng=ak_unsolved$lon, 
                     lat = ak_unsolved$lat,
                     color = "ffffff",
                     weight = 1,
                     radius = 5,
                     label = lapply(ak_unsolved$label,HTML),  # convert the number to text (se hjälpen)
                     clusterOptions = markerClusterOptions(showCoverageOnHover = FALSE)
    )
m


# Video 11/16 : Solved and UnSolved

ak_solved <- ak %>%
    filter(Crime.Solved == "Yes") %>% 
    filter(Crime.Type == "Murder or Manslaughter")

# next we need to creae a label ...
ak_solved$label <- paste("<p>", ak_solved$City, "</p>",
                   "<p>", ak_solved$Month, " ", ak_solved$Year, "</p>",
                   "<p>", ak_solved$Victim.Sex," ", ak_solved$Victim.Age, "</p>",
                   "<p>", ak_solved$Victim.Race, "</p>",
                   "<p>", ak_solved$Weapon, "</p>",
                   "<p>", ak_solved$City, "</p>")

# lägga ut på kartan, lägga till ett nytt lager ...
# 1. tar bort clustret.  2. lägger till en ny 'addCircleMarkers' 3. ändra färg 4. varsitt group-name
# 5. lägger till controller 

m <- leaflet() %>% 
    addProviderTiles(providers$Stamen.Toner) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4) %>%
    addCircleMarkers(lng=ak_unsolved$lon, 
                     lat = ak_unsolved$lat,
                     color = "red",
                     weight = 1,
                     radius = 5,
                     group = "Unsolved",
                     label = lapply(ak_unsolved$label,HTML)) %>% 
    addCircleMarkers(lng=ak_solved$lon, 
                     lat = ak_solved$lat,
                     color = "blue",
                     weight = 1,
                     radius = 5,
                     group = "Solved",
                     label = lapply(ak_solved$label,HTML)) %>%
    addLayersControl(overlayGroups = c("Unsolved","Solved"),
                     options = layersControlOptions(collapsed = FALSE)
                     )
    
m

# VI ser endast 'blue'-markers, den ligger 'on-top' ....
 
# Video 12/16 : Choropleths ? https://rstudio.github.io/leaflet/choropleths.html ( https://en.wikipedia.org/wiki/Choropleth_map )
# the dplyr-library , skapar en ny 'us' med kolumner 
us <- fbi_data %>% 
    mutate(Solved = ifelse (Crime.Solved == "Yes",1,0)) %>%
    filter(Crime.Type == "Murder or Manslaughter") %>%
    group_by(State)%>%
    summarise(Num.Murders = n(),
              Num.Solved = sum(Solved)) %>%
    mutate(Num.UnSolved = Num.Murders - Num.Solved,
           Solve.Rate = Num.Solved/Num.Murders)

states <- readOGR("data/us-states/cb_2016_us_state_500k.shp")
levels(us$State)[40] <- "Rhode Island"
states <- subset(states, is.element(states$NAME, us$State))
us <- us[order(match(us$State, states$NAME)),]
# tittar på 'us' i vyn, ser att den lägsta 'solve-rate' är 0.34 ... varje 'bin' får en färgkategori
bins <- c(0.3,0.4,0.5,0.6,0.7,0.8,1.0)
pal <- colorBin("RdYlBu",domain=us$Solve.Rate, bins = bins) # returns a function

# funkar inte riktigt med highlight
m <- leaflet() %>%
    setView(-96,37.8,4) %>%
    addProviderTiles(providers$Stamen.Toner) %>%
    addPolygons(data =states,
                weight = 1,
                smoothFactor = 0.5,
                color = "white",
                fillOpacity = 0.8,
                fillColor = pal(us$Solve.Rate)
                )

#highlight = highlightOptions(
#    weight = 5,
#    color =  "#666666",
#    dashArray = "",
#    fillOpacity = 0.8,
#    bringToFront = TRUE

m

labels <- paste ("<p>",us$State,"</p","<p>","Solve Rate:", round(us$Solve.Rate, digits=3), "</p>")

# lägger till både 'labels' på mouse-over och sen legend i översta-högra hörnet ...
m <- leaflet() %>%
    setView(-96,37.8,4) %>%
    addProviderTiles(providers$Stamen.Toner) %>%
    addPolygons(data =states,
                weight = 1,
                smoothFactor = 0.5,
                color = "white",
                fillOpacity = 0.8,
                fillColor = pal(us$Solve.Rate),
                label=lapply(labels, HTML)) %>%
    addLegend(pal = pal,
              values = us$Solve.Rate,
              opacity = 0.7,
              position = "topright")
m

# Video 14 av 16 - Basic Exporting ( https://www.youtube.com/watch?v=pTpgF04gj90&list=PLmrGRg8An3QG5pZ5_sTzWyjqGTRsPJfSf&index=14 )

