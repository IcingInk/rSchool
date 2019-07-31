# rSchool
1. Testing out R , Starting out using R version 3.6.1.
2. RStudio version 1.2.1335

***
The first goal is to understand the lefalet-library

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
