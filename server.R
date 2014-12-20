# server.R



# Define server logic required to summarize and view the 
# selected dataset
shinyServer(function(input, output) {
        
       # Ref- for reading data  https://gist.github.com/5796467.git
        ### Argument names:
        ArgNames <- reactive({
                Names <- names(formals(input$readFunction)[-1])
                Names <- Names[Names!="..."]
                return(Names)
        })
        
        # Argument selector:
        output$ArgSelect <- renderUI({
                if (length(ArgNames())==0) return(NULL)
                
                selectInput("arg","Argument:",ArgNames())
        })
        
        ## Arg text field:
        output$ArgText <- renderUI({
                fun__arg <- paste0(input$readFunction,"__",input$arg)
                
                if (is.null(input$arg)) return(NULL)
                
                Defaults <- formals(input$readFunction)
                
                if (is.null(input[[fun__arg]]))
                {
                        textInput(fun__arg, label = "Enter value:", value = deparse(Defaults[[input$arg]])) 
                } else {
                        textInput(fun__arg, label = "Enter value:", value = input[[fun__arg]]) 
                }
        })
        
        
        ### Data import:
        Dataset <- reactive({
                if (is.null(input$file)) {
                        # User has not uploaded a file yet
                        return(data.frame())
                }
                
                args <- grep(paste0("^",input$readFunction,"__"), names(input), value = TRUE)
                
                argList <- list()
                for (i in seq_along(args))
                {
                        argList[[i]] <- eval(parse(text=input[[args[i]]]))
                }
                names(argList) <- gsub(paste0("^",input$readFunction,"__"),"",args)
                
                argList <- argList[names(argList) %in% ArgNames()]
                
                Dataset <- as.data.frame(do.call(input$readFunction,c(list(input$file$datapath),argList)))
                return(Dataset)
        })
        
        # Select variables:
        output$varselect <- renderUI({
                
                if (identical(Dataset(), '') || identical(Dataset(),data.frame())) return(NULL)
                
                # Variable selection:    
                selectInput("vars", "Variables to use:",
                            names(Dataset()), names(Dataset()), multiple =TRUE)            
        })
        
        # Show table:
        output$table <- renderTable({
                
                if (is.null(input$vars) || length(input$vars)==0) return(NULL)
                
                return(Dataset()[,input$vars,drop=FALSE])
        })
        
        
        ### Download dump:
        
        output$downloadDump <- downloadHandler(
                filename = "Rdata.R",
                content = function(con) {
                        
                        assign(input$name, Dataset()[,input$vars,drop=FALSE])
                        
                        dump(input$name, con)
                }
        )
        
        ### Download save:
        
        output$downloadSave <- downloadHandler(
                filename = "Rdata.RData",
                content = function(con) {
                        
                        assign(input$name, Dataset()[,input$vars,drop=FALSE])
                        
                        save(list=input$name, file=con)
                }
        )
        
        
        
        # datasets
        datasetInput <- reactive({
                MyData<-Dataset()
                switch(input$dataset, "Iris"=iris, "Insurance"=Insurance,
                       "airquality" = airquality,
                       "cars" = cars,
                       "MyData"= MyData)
        })
        
        # Show the first "n" observations
        output$view <- renderTable({
              
                head(datasetInput(), n = input$obs) 
                      
                
        })
        
        # display 10 rows initially
        output$DataPage <- renderDataTable(datasetInput(), options = list(pageLength = 10))
        
        # Correlation
        output$Corr <- renderTable({cor(datasetInput())})
     
        
        # Summary
        output$summary <- renderPrint({
                dataset <- datasetInput()
                summary(dataset)
                     
        })
        
        # Summary
        output$summary1 <- renderPrint({
                dataset <- datasetInput()
                str(dataset)
                
        })
        
        # plot
        output$plot <- renderPlot({
                dataset <- datasetInput()
                colors<-c("red", "yellow", "green", "violet", "orange", "blue", "pink", "cyan")
                plot(dataset, col=colors)
                
        })
        
        NumColNames<-reactive({
                # If missing input, return to avoid error later in function
                if(is.null(datasetInput()))
                        return()
                
                # Get the data set with the appropriate name
                dat <-datasetInput()[1,]
                nums<-sapply(dat,is.numeric)
                dat<- dat[,nums]
                colnames <- names(dat)
                return(colnames)
                
        })
        
        # value-selected dataset
        # Check boxes
        output$chooseX_columns <- renderUI({
               
                
                # Create the checkboxes and select them all by default
                selectInput("xcol", "Choose Column 1", 
                                   choices  = NumColNames(),
                                   selected = NumColNames()[1])
        })
             
      
   
        output$chooseY_columns <- renderUI({   
                
                # Create the checkboxes and select them all by default
                selectInput("ycol", "Choose Column 2", 
                            choices  = NumColNames(),
                            selected = NumColNames()[2])
        })
 
        # Combine the selected variables into a new data frame
        selectedData <- reactive({
                dataset <- datasetInput()
                dataset<- dataset[, c(input$xcol, input$ycol)]
                dataset <- na.omit(dataset) # listwise deletion of missing
                dataset <- scale(dataset) # standardize variables
                return(dataset)
        })
        
        #kMeans Clustering
        clusters <- reactive({
                #dataset <- datasetInput()
                kmeans(selectedData(), input$clusters)
        })
        
        # plotting histogram and normal curve on the selected variables
        
        # Add a Normal Curve (Thanks to Peter Dalgaard)
        output$plot0 <- renderPlot({
               
               dt<- selectedData()
                x <-  dt[,c(1)]
                y<- dt[,c(2)]
             
               colors<-c("red", "yellow", "green", "violet", "orange", "blue", "pink", "cyan")
                par(mfrow=c(3,2))
                h<-hist(x, breaks=10, col=colors, xlab=input$xcol, 
                        main="Histogram with Normal Curve") 
                xfit<-seq(min(x),max(x),length=40) 
                yfit<-dnorm(xfit,mean=mean(x),sd=sd(x)) 
                yfit <- yfit*diff(h$mids[1:2])*length(x) 
                lines(xfit, yfit, col="blue", lwd=2)
                
                h1<-hist(y, breaks=10, col=colors, xlab=input$ycol, 
                         main="Histogram with Normal Curve") 
                xfit<-seq(min(y),max(y),length=40) 
                yfit<-dnorm(xfit,mean=mean(y),sd=sd(y)) 
                yfit <- yfit*diff(h1$mids[1:2])*length(y) 
                lines(xfit, yfit, col="red", lwd=2)
                
               boxplot(x, main="Boxplot",data=dt,xlab=input$xcol,col="red")
               boxplot(y, main="Boxplot",data=dt,xlab=input$ycol,col="blue")
                
               #plot(x,y, main="Scatterplot", data=dt,xlab=input$xcol, ylab=input$ycol)
               
               
                
        })
             
             
        output$plot1 <- renderPlot({
                #dataset <- datasetInput()
                par(mar = c(5.1, 4.1, 0, 1))
                plot(selectedData(),
                     col = clusters()$cluster,
                     pch = 20, cex = 3)
                points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
        })
        
        # Summary
        output$kmeans_Cluster <- renderPrint({
                summary(clusters()$cluster)
                
                
        })
        
        # Cluster Plot against 1st 2 principal components
        
        # vary parameters for most readable graph
        output$plot2 <- renderPlot({
        library(cluster) 
        clusplot(selectedData(), clusters()$cluster, color=TRUE, shade=TRUE, 
                 labels=2, lines=0)
        })
        
        # # Centroid Plot against 1st 2 discriminant functions
        output$plot3 <- renderPlot({
                library(fpc)
                plotcluster(selectedData(), clusters()$cluster)
        })
        
              
       # Ward Hierarchical Clustering
       whclusters <- reactive({
       d <- dist(selectedData(), method = "euclidean") # distance matrix
       fit <- hclust(d, method="ward.D2") 
       summ<-summary(fit)
       plt<-plot(fit) # display dendogram
       groups <- cutree(fit, k=input$clusters) # cut tree into 3 clusters by default
       # draw dendogram with red borders around the 3 clusters  by default
       rhc<-rect.hclust(fit, k=input$clusters, border="red")
       }) 
       
       output$plot4 <- renderPlot({
               whclusters()$plt
       })   
       
       # Summary
       output$whcls_summ <- renderPrint({
               whclusters()$summ
               
               
       })
    
          
})