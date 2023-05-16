#----------------------------------------------------------------------------------------
# File        : Seasonal Risk calendar maps
# Author      : Farai Marumbwa
# Email       : fmarumbwa@unicef.org
# Organisation:Risk Analysis and Preparedness Section- Office of Emergency Programmes , UNICEF 
# Purpose     : Generation of seasonal risk calendar maps
#----------------------------------------------------------------------------------------

library(dplyr)
library(readr)
#library(tmap)
library(raster)
library(rgdal)
library(sf)
library(here)

##### Load the csv and shapefile (world shapefile from the SP package)
# Note  WFP shp has a problem in LARCRO with WFP File
# Upate names in orig xls Tanzania >> United Republic of Tanzania & Congo DR >> Democratic Republic of the Congo
# Congo >> Republic of the Congo    Côte d'Ivoire >> Ivory Coast - issues with special characters

cyclone_risk <- read.csv("data/Cyclone_risk.csv")%>%
  rename(name_long = 7)
names(cyclone_risk)
World_shp <- st_read(here("data","shp","world_shp.shp"))
plot(World_shp["iso_a2"])
# use -c to do the reverse
cyclone_risk <- subset(cyclone_risk, select = c(ISO, name_long, Region,Q1.Cyclone.Risk, Q2.Cyclone.Risk,Q3.Cyclone.Risk, Q4.Cyclone.Risk) )
# good for jointing text files 

#Join seasonal risk data to the shapefile
adm0_cyclone_risk <- merge(World_shp,cyclone_risk, by.x="name_long", by.y="name_long")
adm0_cyclone_risk_fin= adm0_cyclone_risk
unique(adm0_cyclone_risk$Region)
#"ROSA"   "ESARO"  "ECARO"  "MENARO" "LACRO"  "WCARO"  "EAPRO" 

ROSA_cylone_risk <- adm0_cyclone_risk[adm0_cyclone_risk$Region %in% c("ROSA"), ]
plot(ROSA_cylone_risk[c("Q1.Cyclone.Risk","Q2.Cyclone.Risk","Q3.Cyclone.Risk", "Q4.Cyclone.Risk")])
names(ROSA_cylone_risk)

ESARO_cylone_risk <- adm0_cyclone_risk[adm0_cyclone_risk$Region %in% c("ESARO"), ]
plot(ESARO_cylone_risk[c("Q1.Cyclone.Risk","Q2.Cyclone.Risk","Q3.Cyclone.Risk", "Q4.Cyclone.Risk")])

########################  MAP 2 #################################
library(tmap)
library(leaflet)
tm_shape(global_cylone_risk) + tm_fill("Q1.Cyclone.Risk")
tm_shape(ESARO_cylone_risk) + tm_fill("Q1.Cyclone.Risk")
tm_shape(global_cylone_risk) + tm_fill("Q2.Cyclone.Risk", style = "jenks", palette = "Reds")











