setwd("/Users/Admin/Documents/workspace/Sales Estimation by Geo/")
library(dummies)
library(reshape)
library(FSelector)
library(caret)
source("fnR.R")

###############################load Data and retain only useful fields###########################
cora.dta <- read.csv("Coromandel Salesdata.csv")
cora <- cora.dta[,c("Date_ID","PRODUCTGROUP.Level3", "District","Sales..Rs.")]
cora$month <- factor(months.Date(as.Date(cora$Date_ID),abbreviate = TRUE))
attach(cora)
raindta <- read.csv("RainData.csv")
raindta <- rmclmn(raindta,"STATE.UT")
attach(raindta)
cropdta <- read.csv("DistrictSeasonCrop.csv",skip = 1)
#cropdta <- cropdta[,!(names(cropdta) %in% c("Year","State"))]
attach(cropdta)
rainDist <- read.csv("RainDistMap.csv")
cropDist <- read.csv("CropDistMap.csv")

# cropdta.pivotall <- cast(cropdta,District~Crop+Season,value = "Area.in.Hectares.",fun.aggregate = mean)
# crprain <- merge(raindta, cropdta.pivotall, by.x = "DISTRICT", by.y = "District")
# save(crprain, file="alldist.rda")

cropdta.cora <- merge(cropdta,cropDist, by.x = "District", by.y = "Crop", all.y = TRUE)
raindta <- merge(raindta,rainDist, by.x = "DISTRICT", by.y = "Rain", all.y = TRUE)
raindta <- rmclmn(raindta,"DISTRICT")
################################Aggregate  by District######################################
cora.aggr <- aggregate(Sales..Rs.~District+month+PRODUCTGROUP.Level3,cora,sum)
cora.aggr.piv <- toBool(cora.aggr,"District")

cropdta.pivot <- cast(cropdta.cora,CoraDist~Crop+Season,value = "Area.in.Hectares.",fun.aggregate = mean)
#cropdta.pivot <- rapply(cropdta.pivot, function (x) ifelse(is.nan(x),0,x),how="replace")

################################# Merge Data Frames##########################################
input <- merge(raindta,cropdta.pivot,by = "CoraDist", all = TRUE)
TrnData <- merge(input, cora.aggr.piv, by.x = "CoraDist", by.y = "District")
ForModel <- as.matrix(rmclmn(TrnData, c("CoraDist", "PRODUCTGROUP.Level1")))
#row.names(ForModel) <- TrnData$CoraDist
ForModel[is.nan(ForModel)]<-0
ForModel[is.na(ForModel)]<-0
# dta.model <- lapply(unique(cora.aggr$PRODUCTGROUP.Level1), function (x) prepData(input, cora.aggr[cora.aggr$PRODUCTGROUP.Level1 == x,]))
# names(dta.model) <- unique(cora.aggr$PRODUCTGROUP.Level1)
save(ForModel,file="Data.rda")
write.csv(ForModel,"forModel.csv", row.names = F)
