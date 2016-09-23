# Make an untitled ternary SVG map for inclusion in print graphics

library(maptools)
library(WDI)
library(rgdal)
library(svglite)
library(Cairo)

#Use basic world map from maptools and project to winkel tripel

data("wrld_simpl")
proj4string(wrld_simpl) <- CRS("+proj=longlat")
winkel <- "+proj=wintri"
countries_winkel <- spTransform(wrld_simpl, CRS(winkel))
par(mar=c(0,0,0,0))

#get data on forest protected areas from WDI and join with map data on ISO code

forestdata <- WDI(country = "all", indicator = "ER.LND.PTLD.ZS", start = 2014, end = 2014)
forestdata.o <- forestdata[match(wrld_simpl$ISO2,forestdata$iso2c),]



#Colorbrewer Colors
#ffeda0 <- light orange
#feb24c <- medium orange
#f03b20 <- dark orange

findColors3 <- function(x) {
 if (!is.na(x)){
     if (x < 5) {
      col <- "#ffeda0"
    } else if (x > 5 & x < 20) {
      col <- "#feb24c"
    } else if (x > 20) {
      col <- "#f03b20"
    } else {
      col <- "black" #catch any screw ups
    }
    return(col)
 }
  col <-"white" #shade nulls
  return(col)
}

ternaryColors <- sapply(forestdata.o$ER.LND.PTLD.ZS, findColors3)

svg(filename="ER.LND.PTLD.ZS.svg", 
    width=25, 
    height=20, 
    pointsize=12)
plot(countries_winkel, col=ternaryColors, lwd=0.3)
dev.off()
