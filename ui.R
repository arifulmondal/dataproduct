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
        color: #0000FF;
      }

    "))
        ),
        
        
        
        # Application title.
        headerPanel("Basic Explanatory DATA Analysis"),
      
        sidebarLayout(
                sidebarPanel(
                        tags$style(type='text/css', ".well { max-width: 20em; }"),
                        # Tags:
                        tags$head(
                                tags$style(type="text/css", "select[multiple] { width: 100%; height:10em}"),
                                tags$style(type="text/css", "select { width: 100%}"),
                                tags$style(type="text/css", "input { width: 19em; max-width:100%}")
                        ),
                        h4("Select your Own Data", style = "color:blue" ),
                        hr(),
                        # Select filetype:
                        selectInput("readFunction", "Function to read data:", c(
                                # Base R:
                                "read.table",
                                "read.csv",
                                "read.csv2",
                                "read.delim",
                                "read.delim2",
                                
                                # foreign functions:
                                "read.spss",
                                "read.arff",
                                "read.dbf",
                                "read.dta",
                                "read.epiiinfo",
                                "read.mtp",
                                "read.octave",
                                "read.ssd",
                                "read.systat",
                                "read.xport",
                                
                                # Advanced functions:
                                "scan",
                                "readLines"
                        )),
                        
                        # Argument selecter:
                        htmlOutput("ArgSelect"),
                        
                        # Argument field:
                        htmlOutput("ArgText"),
                        
                        # Upload data:
                        fileInput("file", "Upload data-file:"),
                        
                        # Variable selection:
                        htmlOutput("varselect"),
                        
                        br(),
                        
                        textInput("name","Dataset name:","Data"),
                        
                        downloadLink('downloadDump', 'Download source'),
                        downloadLink('downloadSave', 'Download binary'),
                        #Update data
                        submitButton("Update Data"),
                        hr(),
                        p("for source code of reading/writing", a(href="https://gist.github.com/SachaEpskamp/5796467", "click here")),
                        hr(),
                        
                        h4("Inputs for Basic Data Analysis", style = "color:blue" ),
                        hr(),
                        # Select Data for Analysis
                        selectInput("dataset", "Choose a dataset:", 
                                    choices = c("Insurance","airquality", "cars", "mpg", "MyData")),
                        br(),
                        br(),
                        # Number of observations to print
                        numericInput("obs", "Select Number of observations to view:", 5),
                                                
                        
                        br(),
                        br(),
                        submitButton("Update Slections"),
                        br(),
                        h4("Inputs for Cluster Analysis:",style = "color:blue"),
                        hr(),
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
                        a(href = "https://github.com/arifulmondal/dataproduct", "Source code")
                ),
                
                mainPanel(
                        p("This is an experimental app for basic data analysis and basic kmeans cluster analysis."),
                        hr(),
                        h4("Data Analysis",style = "color:blue"),
                        hr(),
                        h4("First Few Observations"),
                        tableOutput("view"),
                        h4("Basic Summary of the Data"),
                        br(),
                        verbatimTextOutput("summary"),
                        h4("Graphical Representation of the Data"),
                        plotOutput("plot"),
                        br(),
                        br(),
                        hr(),
                        h4("Cluster Analysis",style = "color:blue"),
                        hr(),
                        h5("Please select right pair of variables to get clusters.."),
                        plotOutput('plot1'),
                        h4("Clusters:"),
                        br(),
                        verbatimTextOutput("kmeans_Cluster"),
                        hr(),
                        br(),
                        p("To know more about shiny app", a(href = "http://shiny.rstudio.com/", "click here"))
                )
        )
))