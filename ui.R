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
                       
                        
                        h4("Inputs for Basic Data Analysis", style = "color:blue" ),
                        hr(),
                        # Select Default Data for Analysis from R datasets library
                        selectInput("dataset", "Choose a dataset:", 
                                    choices = c("Iris","Insurance","airquality", "cars", "MyData")),
                        h6("(Help: Please select MyData from the list to import your own dataset)", style="color:red"),
                        br(),
                        # Number of observations to print
                        numericInput("obs", "Select Number of observations to view:", 5),
                                                
                        
                        br(),
                        submitButton("Update Slections"),
                        br(),
                        
                        # Cluster Analysis
                        h4("Inputs for Cluster Analysis:",style = "color:blue"),
                        hr(),
                        h5("Select X and Y Variables for Cluster Analysis."),
                        h6("(Both X and Y should be numeric)",style = "color:red"),
                        # For clustering
                        uiOutput("chooseX_columns"),
                        uiOutput("chooseY_columns"),
                        numericInput('clusters', 'Write Number of Clusters To be Generated', 3,
                                     min = 1, max = 9),
                        br(),
                        #Update Selection
                        submitButton("Update Clusters"),
                        h6("(Help:you must click on the Update button to see the clusters. 
                           By Default clusters are not generated. Each time you change any 
                           selection you would need to update the clusters.)", style="color:red"),
                        br(),
                        a(href = "https://github.com/arifulmondal/dataproduct", "Source code"),
                        hr(),
                        h4("Select your Own Data", style = "color:red" ),
                        hr(),
                        
                        # Reading external Data
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
                        downloadLink('downloadSave', '|Download binary'),
                        #Update data
                        submitButton("Update Data"),
                        hr(),
                        p("Thank You. For original source code for reading/writing files", a(href="https://gist.github.com/SachaEpskamp/5796467", "click here")),
                        hr()
                ),
                
                mainPanel(
                        p("This is an experimental app for basic data analysis and basic kmeans cluster analysis.
                          Some preselected datasets are used from R datasets library and you can upload your own data to do analysis. 
                          You would need to update the selection, clusters and data using update buttons. To import your
                          own data you would need to select 'MyData' and then Upload data using Menu Tab at the bottom left, once 
                          upload is completed, update selection and then upload clusters to see the results."),
                        hr(),
                        h4("Data Analysis",style = "color:blue"),
                        hr(),
                   
                        tabsetPanel(
                                tabPanel("Observations", tableOutput("view")), 
                                tabPanel("Summary", verbatimTextOutput("summary")), 
                                tabPanel("Summary Str", verbatimTextOutput("summary1")), 
                                tabPanel("Scatter Plots",  plotOutput("plot")),
                                tabPanel("Correlation",  tableOutput("Corr"))
                        )
                        
                        
                        br(),  
                        hr(),
                        h4("Search in Data", style="color:blue"),
                        tabsetPanel( tabPanel('Display Data', dataTableOutput('DataPage'))),
                      
                        hr(),
                        # K-means Cluster Analysis
                        h4("K-Means Clustering (2-Variables only)",style = "color:blue"),
                        h6("(Help:Please click on 'Update Clusters' to see results)",style = "color:red"),
                        tabsetPanel(
                                tabPanel("Distribution",     plotOutput('plot0')), 
                                tabPanel("K-Means", plotOutput('plot1')), 
                                tabPanel("K-means Summary",  verbatimTextOutput("kmeans_Cluster")), 
                                tabPanel("Principal Components",  plotOutput("plot2")),
                                tabPanel("Centroid Plot",  plotOutput("plot3"))
                        ),
                        
                        hr(),
                                              
                        # Ward Hierarchical Clustering
                        h4("Ward Hierarchical Clustering",style = "color:blue"),
                        h6("(Help:Please click on 'Update Clusters' to see results)",style = "color:red"),
                                    
                        tabsetPanel(
                              tabPanel("Dendogram",  plotOutput("plot4"))
                        ),
                   
                        br(),
                                         
                        p("To know more about shiny app", a(href = "http://shiny.rstudio.com/", "click here"))
                )
        )
))