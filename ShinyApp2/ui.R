library(shiny)


districtList <- as.matrix(unique(crprain$DISTRICT))

shinyUI(fluidPage(
  titlePanel(title=h1("Coromandel Sales Data - POC", align="center")),
  sidebarLayout(
    sidebarPanel(
      selectInput("district","Select the District to calculate the sales",choices=districtList),
      selectInput("month","Select Month of Rainfall",c("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")),
      
      textInput("rain","Enter rainfall in cms")
    ),
    mainPanel(type="tab",
      tabsetPanel(
        tabPanel("Estimated Sales",
                  h3("You have entered the following values:"),br(),
                  h4("District:",textOutput("district")),
                  h4("Month:",textOutput("month")),
                  h4("Rainfall in cms:",textOutput("rain")),br(),
                                   h3("Total Estimated Fertiliser Sales",textOutput("FertSales")),br(),br(),
                  h3("Total Estimated Pesticides Sales",textOutput("PestiSales"))),
        tabPanel("Plot")))
  ) 
))