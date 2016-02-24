setwd("/Users/Admin/Documents/workspace/Sales Estimation by Geo/")
library(shiny)


# salesEst <- function(input,output){
#   load("LinearModels.rda")
#   load("alldist.rda")
#   dta <- as.matrix(crprain[crprain$DISTRICT == "ADILABAD",-1])
#   dta[is.na(dta)]<-0
#   dta[is.nan(dta)]<-0
#   #dta <- dta.model[[4]]
#   vec <- as.data.frame(dta)
#   #Vec[,input$month] <- input$rain
#   preds <- sapply(names(lr.models),function (x) predict(lr.models[[x]], vec), USE.NAMES = TRUE)
#   
#   
#   output$FertSales <- renderText(preds[4])
#   output$PestiSales <- renderText(preds[3])
# }

shinyServer(function(input,output){
  load("LinearModels.rda")
  load("alldist.rda")
  dta <- as.matrix(crprain[crprain$DISTRICT == "ADILABAD",-1])
  dta[is.na(dta)]<-0
  dta[is.nan(dta)]<-0

  vec <- as.data.frame(dta)

  preds <- sapply(names(lr.models),function (x) predict(lr.models[[x]], vec), USE.NAMES = TRUE)
  
  
  output$FertSales <- renderText(preds[4])
  output$PestiSales <- renderText(preds[3])
})
