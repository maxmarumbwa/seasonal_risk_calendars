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

# TO Do 
# Load point and roadlayers


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

# quick map using qtm
qtm(ESARO_cylone_risk, fill = "Q1.Cyclone.Risk")

tm_shape(global_cylone_risk) + tm_fill("Q1.Cyclone.Risk")
tm_shape(ESARO_cylone_risk) + tm_fill("Q1.Cyclone.Risk")
tm_shape(global_cylone_risk) + tm_fill("Q2.Cyclone.Risk", style = "jenks", palette = "Reds")


## Setting colour palette
library(RColorBrewer)
display.brewer.all()

# includes a histogram in the legend
tm_shape(ESARO_cylone_risk)+
  tm_fill("Q1.Cyclone.Risk", style = "quantile", n = 5, palette = "Reds", legend.hist = TRUE)

# add borders
tm_shape(ESARO_cylone_risk) + 
  tm_fill("Q1.Cyclone.Risk", palette = "Reds") +
  tm_borders(alpha=.4)

# north arrow
tm_shape(ESARO_cylone_risk) + 
  tm_fill("Q1.Cyclone.Risk", palette = "Reds") +
  tm_borders(alpha=.4) +
  tm_compass()


# adds in layout, gets rid of frame
tm_shape(ESARO_cylone_risk) + 
  tm_fill("Q1.Cyclone.Risk", palette = "Reds", style = "quantile",title = "% with a Qualification") +
  tm_borders(alpha=.4) +
  tm_compass() +
  tm_layout(title = "Camden, London", legend.text.size = 1.1, legend.title.size = 1.4, legend.position = c("right", "top"), frame = FALSE)

## Saving the shapefile
# Finally, we can save the shapefile with the Census data already attatched to by simply running the following code (remember to change the dsn to your working directory).
writeOGR(OA.Census, dsn = ".", layer = "Census_OA_Shapefile", driver="ESRI Shapefile")


######## PLot map legend outside #######
https://mgimond.github.io/Spatial/mapping-data-in-r.html 
tm_shape(ESARO_cylone_risk) + tm_polygons("Q1.Cyclone.Risk",  border.col = "white") + 
  tm_legend(outside = TRUE)

## Omit borders for polygons
tm_shape(ESARO_cylone_risk) + 
  tm_polygons("Q1.Cyclone.Risk", border.col = NULL) + 
  tm_legend(outside = TRUE)

### You can easily stack layers by piecing together additional tm_shapefunctions. In the following example, the railroad layer and the point layer are added to the income map. The railroad layer is mapped using the tm_lines function and the cities point layer is mapped using the tm_dots function. Note that layers are pieced together using the + symbol.
tm_shape(s.sf) + 
  tm_polygons("Income", border.col = NULL) + 
  tm_legend(outside = TRUE) +
  tm_shape(rail.sf) + tm_lines(col="grey70") +
  tm_shape(p.sf) + tm_dots(size=0.3, col="black") 


########  Tweaking classification schemes
# You can control the classification type, color scheme, and bin numbers via the tm_polygons function. For example, to apply a quantile scheme with 6 bins and varying shades of green, type:
  tm_shape(ESARO_cylone_risk) + 
  tm_polygons("Q1.Cyclone.Risk", style = "quantile", n = 10, palette = "Greens") + 
  tm_legend(outside = TRUE)

#Other style classification schemes include fixed, equal, jenks, kmeans and sd. If you want to control the breaks manually set style=fixed and specify the classification breaks using the breaks parameter. For example,

tm_shape(ESARO_cylone_risk) + 
    tm_polygons("Q1.Cyclone.Risk", style = "fixed",palette = "Greens",
                breaks = c(0, 4, 8, 10 )) + 
    tm_legend(outside = TRUE)

# If you want a bit more control over the legend elements, you can tweak the labels parameter as in,
tm_shape(ESARO_cylone_risk) + 
  tm_polygons("Q1.Cyclone.Risk", style = "fixed",palette = "Greens",
              breaks = c(0, 4, 8, 10 ),
              labels = c("less than 4", "4 to 7", "above 8"),
              text.size = 1) + 
  tm_legend(outside = TRUE)

# For example, to map the county names using the Pastel1 categorical color scheme, type:
  tm_shape(ESARO_cylone_risk) + 
  tm_polygons("name_long", palette = "Pastel1", title="EARO countries") + 
  tm_legend(outside = TRUE)
  
