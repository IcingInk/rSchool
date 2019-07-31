# rSchool
1. Testing out R , Starting out using R version 3.6.1.
2. RStudio version 1.2.1335

***
## resources
1. https://r4ds.had.co.nz/

## library and packages
1. rgdal , https://cran.r-project.org/web/packages/rgdal/rgdal.pdf
2. $ sudo apt-get upgrade libgdal-dev &&  sudo apt-get upgrade libproj-dev && sudo apt-get upgrade gdal-bin
3. install.packages("lattice")
4. library(ggmap) -> Google maps .....

***
The first goal is to understand the lefalet-library

***
## datasets are from kaggle.com

1. https://www.kaggle.com/murderaccountability/homicide-reports (database.csv)

## Shapefiles for counties

1. shapefiles (county lines) https://catalog.data.gov/dataset/tiger-line-shapefile-2013-state-alaska-current-county-subdivision-state-based 


***

# from youtube - Greg Sward.
https://www.youtube.com/watch?v=wUE71sTs1dE&list=PLmrGRg8An3QG5pZ5_sTzWyjqGTRsPJfSf&index=7

## adding a basemap, map of Alaska
```
library(leaflet)

m <- leaflet()
m

m <- leaflet() %>% 
    addTiles() %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4)
m
```

## adding a basemap with a theme 

```

m <- leaflet() %>% 
    addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4)
m

m <- leaflet() %>% 
    addProviderTiles(providers$Stamen.Toner) %>%
    setView(lng = -149.4937, lat = 64.2008, zoom = 4)
m
```

more themese are found here <p>
 https://leaflet-extras.github.io/leaflet-providers/preview/ 


## Fetching the homocide data from the csv-file

```
fbi_data <- read.csv("data/database.csv") # video #7
View(fbi_data)
```

1. filter the data-frame with the 'dplyr'-package and 'filter'
2. the fbi_data has the column 'State', we want to filter out 'Alaska' - ak innehåller endast 'Alaska'
3. ak <- mutate() :  Adds the column 'address' where the data is  'city + state 'United States' (concatenated)

```

library(dplyr) ( https://dplyr.tidyverse.org/ -AND- https://blog.exploratory.io/filter-data-with-dplyr-76cf5f1a258e )
ak <- filter(fbi_data, State == "Alaska") ## Filter på kolumnen 'State'
ak <- mutate(ak, address = paste(City,State, "United States")) # skapar den kolumnen i datasettet

```

 
