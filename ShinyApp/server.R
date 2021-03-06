setwd("/Users/Admin/Documents/workspace/Sales Estimation by Geo/ShinyApp/")
source("helpers.R")

shinyServer(function(input,output){

  func <- function(input,model){
    dta <- as.matrix(crprain[crprain$DISTRICT == input$district,-1])
    dta[is.na(dta)]<-0
    dta[is.nan(dta)]<-0
    
    vec <- as.data.frame(dta)
    if(!(input$rain=="")){
      vec[,input$month] <- as.numeric(input$rain)
    }
    
    predict(lr.models[[model]], vec)
  }
  
  output$district <-renderText(input$district)
  output$month <- renderText(input$month)
  output$rain <- renderText(input$rain)
  output$FertSales <- renderText(func(input,4))
  output$PestiSales <- renderText(func(input,3))
})
