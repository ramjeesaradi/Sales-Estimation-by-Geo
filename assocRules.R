setwd("/Users/Admin/Documents/workspace/Sales Estimation by Geo/")
library(dummies)
library(datasets)
library(reshape)
library(arules)
library(arulesViz)
library(caret)
source("fnR.R")

###############################load Data and retain only useful fields###########################
cora.dta <- read.csv("Coromandel Salesdata.csv")
cora.dta$value <- 1
# cora.trns.dt <- cast(cora.dta, Store + Date_ID ~ PRODUCTGROUP.Level3,
#                                 fun.aggregate = max,
#                                 fill = 0)
cora.trns <- cast(cora.dta, Store ~ PRODUCTGROUP.Level3,
                     fun.aggregate = max,
                     fill = 0)

cora.trns <- rmclmn(cora.trns,c("Store", "Date_ID"," "))
cora.trns <- cora.trns == 1
rules <- apriori(cora.trns,
                 parameter = list(minlen=2, supp = 0.9, conf = 0.99, target = "rules"))
plot(rules,method = "graph")
