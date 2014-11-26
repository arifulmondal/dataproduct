# server.R

library(shiny)
library(datasets)

# Define server logic required to summarize and view the 
# selected dataset
shinyServer(function(input, output) {
        
        # datasets
        datasetInput <- reactive({
                switch(input$dataset,
                       "airquality" = airquality,
                       "BioChemicalQxygen" = BOD,
                       "cars" = cars,
                       "mpg"=mpg)
        })
        
        # Show the first "n" observations
        output$view <- renderTable({
                head(datasetInput(), n = input$obs)
        })
        
        # Summary
        output$summary <- renderPrint({
                dataset <- datasetInput()
                summary(dataset)
                
        })
        
        # plot
        output$plot <- renderPlot({
                dataset <- datasetInput()
                plot(dataset)
                
        })
        # value-selected dataset
        output$value <- renderPrint({  datasetInput()})
      
        # Combine the selected variables into a new data frame
        selectedData <- reactive({
                dataset <- datasetInput()
                dataset[, c("input$xcol", "input$ycol")]
        })
        
        clusters <- reactive({
                #dataset <- datasetInput()
                kmeans(selectedData(), input$clusters)
        })
        
        output$plot1 <- renderPlot({
                #dataset <- datasetInput()
                par(mar = c(5.1, 4.1, 0, 1))
                plot(selectedData(),
                     col = clusters()$cluster,
                     pch = 20, cex = 3)
                points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
        })
        
        
       
})