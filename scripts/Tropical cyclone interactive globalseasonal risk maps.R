#----------------------------------------------------------------------------------------
# File        : Riverine_floods_pop_exposed
# Author      : Farai Marumbwa
# Email       : fmarumbwa@unicef.org
# Organisation:Risk Analysis and Preparedness Section- Office of Emergency Programmes , UNICEF 
# Purpose     : Generation of seasonal risk calendar maps as dynamic maps based on Mapview
#----------------------------------------------------------------------------------------
# Use the default world shapefile boundary >> update names to match
library(sf)
library(raster)
library(dplyr)
library(spData)
library(spDataLarge)
library(tmap)    # for static and interactive maps
library(leaflet) # for interactive maps
library(ggplot2) # tidyverse data visualization package
library(mapview)
library(here)

# pop affected data
cyclone_risk <- read.csv(here("data","Cyclone_risk.csv"))
prj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
adm0_wfp <- read_sf(here("data","shp","Global_bnd_adm0_WFP.shp"),crs = 4326)
#object.size(world)

adm0_wfp <- st_read(here("data","shp","Global_bnd_adm0_WFP.shp"))

# Rename the pop affected to match shp
cyclone_risk<- cyclone_risk %>%
  rename(iso3 = 1) %>%
  rename(name_long = 7)

cyclone_risk_shp = left_join(adm0_wfp, cyclone_risk, by = "iso3")

cyclone_risk <- subset(cyclone_risk_shp, select = c(adm0_name,Q1.Cyclone.Risk,Q2.Cyclone.Risk,Q3.Cyclone.Risk, Q4.Cyclone.Risk) )
plot(cyclone_risk_shp["Q1.Cyclone.Risk", "Q2.Cyclone.Risk"])

#facets = names(pop_affe)
facets = c("Q2.Cyclone.Risk", "Q1.Cyclone.Risk")
tm_shape(cyclone_risk_shp) + tm_polygons(facets) +
  tm_facets(nrow = 1, sync = TRUE)

#Using mapview to create maps
#mapview(world_coffee1) #
mapview(cyclone_risk_shp, zcol = "Q1.Cyclone.Risk")

cyclone_risk_shp2 = left_join(world, cyclone_risk, by = "name_long")
facets = c("Q1.Cyclone.Risk", "Q2.Cyclone.Risk","Q3.Cyclone.Risk", "Q4.Cyclone.Risk")
tm_shape(cyclone_risk_shp2) + tm_polygons(facets) +
  tm_facets(nrow = 2, sync = TRUE)



