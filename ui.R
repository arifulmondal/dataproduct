# ui.R

library(shiny)
library(datasets)

shinyUI(fluidPage(
        tags$head(
                tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
      
      h1 {
        font-family: 'Lobster', cursive;
        font-weight: 500;
        line-height: 1.1;
        color: #48ca3b;
      }

    "))
        ),
        
        
        
        # Application title.
        headerPanel("Explanatory Analysis"),
      
        sidebarLayout(
                sidebarPanel(
                        selectInput("dataset", "Choose a dataset:", 
                                    choices = c("airquality", "BioChemicalQxygen", "cars", "mpg")),
                        br(),
                        br(),
                        
                        numericInput("obs", "Select Number of observations to view:", 5),
                                                
                        
                        br(),
                        br(),
                        
                        # For clustering
                       
                        selectInput('xcol', 'X Variable', names(verbatimTextOutput("value"))),
                        selectInput('ycol', 'Y Variable', names(verbatimTextOutput("value")),
                                    selected=names(verbatimTextOutput("value"))[[2]]),
                        numericInput('clusters', 'Cluster count', 3,
                                     min = 1, max = 9),
                        br(),
                        submitButton("Update")
                ),
                
                mainPanel(
                      
                        
                        h4("Observations"),
                        tableOutput("view"),
                        h4("Summary"),
                        verbatimTextOutput("summary"),
                        h4("Graphical Representation"),
                        plotOutput("plot"),
                        plotOutput('plot1')
                )
        )
))