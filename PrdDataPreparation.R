setwd("/Users/Admin/Documents/workspace/Sales Estimation by Geo/")
library(dummies)
library(reshape)
library(caret)
source("fnR.R")

###############################load Data and retain only useful fields###########################

raindta <- read.csv("RainData.csv")
raindta <- rmclmn(raindta,"STATE.UT")
cropdta <- read.csv("DistrictSeasonCrop.csv",skip = 1)

################################Aggregate  by District######################################

cropdta.pivot <- cast(cropdta,District~Crop+Season,value = "Area.in.Hectares.",fun.aggregate = mean)
#cropdta.pivot <- rapply(cropdta.pivot, function (x) ifelse(is.nan(x),0,x),how="replace")

################################Merge Data #################################################
input <- as.matrix(merge(raindta,cropdta.pivot,by.x = "DISTRICT",by.y = "District"))
input[is.na(input)] <- 0
