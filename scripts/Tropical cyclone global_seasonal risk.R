library(dplyr)
library(readr)
#library(tmap)
library(raster)
library(rgdal)
#library(sf)

##### Load the csv and shapefile
cyclone_risk <- read.csv("data/Cyclone_risk.csv")
# use -c to do the reverse
cyclone_risk = subset(cyclone_risk, select = c(ISO, Region,Country,Q1.Cyclone.Risk, Q2.Cyclone.Risk,Q3.Cyclone.Risk, Q4.Cyclone.Risk) )
adm0_wfp<-readOGR("data/shp/Global_bnd_adm0_WFP.shp")
#adm0_wfp<-st_read("data/shp/Global_bnd_adm0_WFP.shp")


# split the different Regions into a list
library(purrr)
region_list <- cyclone_risk %>%
  split(.$Region) 

# Split individual region
unique(cyclone_risk$Region)
#"ROSA"   "ESARO"  "ECARO"  "MENARO" "LACRO"  "WCARO"  "EAPRO" 
cyclone_risk_ROSA <- cyclone_risk %>%
  filter(Region == "ROSA")
cyclone_risk_ESARO <- cyclone_risk %>%
  filter(Region == "ESARO")
cyclone_risk_ECARO <- cyclone_risk %>%
  filter(Region == "ECARO")
cyclone_risk_MENARO <- cyclone_risk %>%
  filter(Region == "MENARO")
cyclone_risk_LACRO <- cyclone_risk %>%
  filter(Region == "LACRO")
cyclone_risk_WCARO <- cyclone_risk %>%
  filter(Region == "WCARO")
cyclone_risk_EAPRO <- cyclone_risk %>%
  filter(Region == "ESPRO")

#Join seasonal risk data to the shapefile
# Rename the csv to match shp
rosa_cyclone_risk <- rosa_cyclone_risk %>%
  rename(iso3 = 1)
pop_affected = left_join(vuln, pop_affe, by = "iso3")

rosa_cyclone_risk <- joi(adm0_wfp,cyclone_risk_ROSA, by.x="iso3", by.y="ISO")

names(cyclone_risk_ROSA)

plot(rosa_cyclone_risk)





#plot(adm0_wfp) # plot shapefile

# Convert the dataframe to shapefile
adm0_wfp.df <- as.data.frame(adm0_wfp)
head(adm0_wfp.df,3)

#Join seasonal risk data to the shapefile
adm0_cyclone_risk <- merge(adm0_wfp,cyclone_risk, by.x="iso3", by.y="ISO")

cyclone_risk_ESARO <- adm0_cyclone_risk %>%
    filter(Region == "ESARO")

# Convert the dataframe to shapefile
cyclone_risk_ESARO.df <- as.data.frame(adm0_cyclone_risk) %>%
  filter(Region == "ESARO")

plot(cyclone_risk_ESARO.df)

forecast_median=p_median%>%
  drop_na()%>%
  filter(Quantile == 100,mean_observed_SPI6 != 0)%>%
  left_join(y=province_district)%>%
  subset(Province != "NA") %>% # remove province "NA"
  dplyr::select(Year,Quantile,Province,Area,mean_observed_SPI6,mean_median_Forecasted_SPI6_belowQ)
head(forecast_median)
names(forecast_median)

# Ploting the Maps
#Load packages
library(tmap)
library(leaflet)


e


library(purrr)
library(purrr)

a <- mtcars %>%
  split(.$cyl) 

%>% # from base R
  map(~ lm(mpg ~ wt, data = .)) %>%
  map(summary) %>%
  map_dbl("r.squared")






d





# Library
library(leaflet)

# Create a color palette for the map:
mypalette <- colorNumeric( palette="viridis", domain=adm0_wfp$iso3, na.color="transparent")
#mypalette <- colorNumeric( palette="viridis", domain=adm0_wfp@iso3$POP2005, na.color="transparent")
mypalette(c(45,43))

# Basic choropleth with leaflet?
m <- leaflet(world_spdf) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( fillColor = ~mypalette(POP2005), stroke=FALSE )

m






