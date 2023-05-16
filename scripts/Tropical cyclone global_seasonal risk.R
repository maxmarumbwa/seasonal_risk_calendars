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

##### Load the csv and shapefile
cyclone_risk <- read.csv("data/Cyclone_risk.csv")%>%
  rename(iso3 = 1)
names(cyclone_risk)
# use -c to do the reverse
cyclone_risk <- subset(cyclone_risk, select = c(iso3, Region,Country,Q1.Cyclone.Risk, Q2.Cyclone.Risk,Q3.Cyclone.Risk, Q4.Cyclone.Risk) )
# good for jointing text files
adm0_wfp<-read_sf("data/shp/Global_bnd_adm0_WFP_simplify_0.05.shp")

#Join seasonal risk data to the shapefile
adm0_cyclone_risk <- merge(adm0_wfp,cyclone_risk, by.x="iso3", by.y="iso3")
adm0_cyclone_risk_fin= adm0_cyclone_risk
unique(adm0_cyclone_risk$Region)
#"ROSA"   "ESARO"  "ECARO"  "MENARO" "LACRO"  "WCARO"  "EAPRO" 

ROSA_cylone_risk <- adm0_cyclone_risk[adm0_cyclone_risk$Region %in% c("ROSA"), ]
plot(ROSA_cylone_risk)
ESARO_cylone_risk <- adm0_cyclone_risk[adm0_cyclone_risk$Region %in% c("ESARO"), ]
plot(ESARO_cylone_risk)
########################  MAP 2 #################################
library(tmap)
library(leaflet)
tm_shape(adm0_wfp) + tm_fill("iso3")
tm_shape(ESARO_cylone_risk) + tm_fill("Q1.Cyclone.Risk")
tm_shape(OA.Census) + tm_fill("Qualification", style = "quantile", palette = "Reds")

# "Q1.Cyclone.Risk" "Q2.Cyclone.Risk" "Q3.Cyclone.Risk" "Q4.Cyclone.Risk"













