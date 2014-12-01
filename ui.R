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
                        # Select Data for Analysis
                        selectInput("dataset", "Choose a dataset:", 
                                    choices = c("airquality", "BioChemicalQxygen", "cars", "mpg")),
                        br(),
                        br(),
                        # Number of observations to print
                        numericInput("obs", "Select Number of observations to view:", 5),
                                                
                        
                        br(),
                        br(),
                        submitButton("Update Slections"),
                        br(),
                        h4("Inputs for Cluster Analysis:"),
                        h5("Select X and Y Variables for Cluster Analysis"),
                        # For clustering
                        uiOutput("chooseX_columns"),
                        uiOutput("chooseY_columns"),
                        numericInput('clusters', 'Write Number of Clusters To be Generated', 3,
                                     min = 1, max = 9),
                        br(),
                        #Update Selection
                        submitButton("Update Clusters"),
                        br(),
                        br(),
                        a(href = "https://gist.github.com/4211337", "Source code")
                ),
                
                mainPanel(
                      
                        
                        h4("First Few Observations"),
                        tableOutput("view"),
                        h4("Basic Summary of the Data"),
                        br(),
                        verbatimTextOutput("summary"),
                        h4("Graphical Representation of the Data"),
                        plotOutput("plot"),
                        br(),
                        h4("Cluster Analysis. Please select right pair of variables to get clusters."),
                        plotOutput('plot1'),
                        h4("Clusters:"),
                        br(),
                        verbatimTextOutput("kmeans_Cluster")
                )
        )
))