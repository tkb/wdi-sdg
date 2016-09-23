
# use ggsave to output svg file. 

library(maptools)
library(WDI)
library(rgdal)

#use basic world map from maptools

data("wrld_simpl")

#get data on forest protected areas from WDI and join with map data on ISO code

forestdata <- WDI(country = "all", indicator = "ER.LND.PTLD.ZS", start = 2014, end = 2014)
forestdata.o <- forestdata[match(wrld_simpl$ISO2,forestdata$iso2c),]

# create vector of map colors based on data
mapCol <- c()
for (i in 1:length(forestdata.o$ER.LND.PTLD.ZS)){
  if (!is.na(forestdata.o$ER.LND.PTLD.ZS[i])){  
    if(forestdata.o$ER.LND.PTLD.ZS[i] > 20){
      mapCol <- c(mapCol,"#d95f0e")
    } else if(forestdata.o$ER.LND.PTLD.ZS[i] > 5 & forestdata.o$ER.LND.PTLD.ZS[i] < 20){
      mapCol <- c(mapCol,"#fec44f")
    } else {
      mapCol <- c(mapCol,"#fff7bc")
    }
  } else{
    mapCol <- c(mapCol,"#ccccc")
  }
}

mapCol2 <- c()
for (i in 1:length(forestdata.o$ER.LND.PTLD.ZS)){
  if (!is.na(forestdata.o$ER.LND.PTLD.ZS[i])){
    mapCol2 <- c(mapCol2,"red")
  } else {
    mapCol2 <- c(mapCol2,"blue")
  }
}

for (i in 1:length(forestdata.o$ER.LND.PTLD.ZS)){
    if(forestdata.o$ER.LND.PTLD.ZS[i]>50){
      mapCol <- c(mapCol,"#d95f0e")
    } else {
      mapCol <- c(mapCol,"#fff7bc")
    }
}

if(forestdata.o$ER.LND.PTLD.ZS[2]>5){
  mapCol <- c(mapCol,"#d95f0e")
} else {
  mapCol <- c(mapCol,"#fff7bc")
}


# World map
proj4string(wrld_simpl) <- CRS("+proj=longlat")
winkel <- "+proj=wintri"
countries_winkel <- spTransform(wrld_simpl, CRS(winkel))
par(mar=c(0,0,0,0))
plot(countries_winkel, col=mapCol, lwd=0.3)


svg(filename="output.svg", 
    width=25, 
    height=20, 
    pointsize=12)
plot(countries_winkel, col=mapCol, lwd=0.3)
dev.off()


