---
title: "Shiny Data Analysis and Clustering"
author: "Ariful Mondal"
highlighter: highlight.js
output: beamer_presentation
job: This is a Basic data analysis and clustering application built on Shiny. 
knit: slidify::knit2slides
mode: selfcontained
hitheme: tomorrow
subtitle: Apps- https://arifulmondal.shinyapps.io/projects/
framework: io2012
widgets: []


---

## Feature 1: Basic Data Analysis

First feature is to analyze data and display some observations, basic summary, scatter plots and correlations. For example.  


```r
summary(iris)
```

```
##   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
##  Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
##  1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
##  Median :5.800   Median :3.000   Median :4.350   Median :1.300  
##  Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
##  3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
##  Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
##        Species  
##  setosa    :50  
##  versicolor:50  
##  virginica :50  
##                 
##                 
## 
```

--- .class #id 

## Feature 2: Create A Searchable Datasheet

This feature of the application would provide functionality to visualize entire datatables and with search functionalities. Visualize entire datasets with 10 records per page.

```
 - Using  `renderDataTable()` to display data on the webpage.

```
One can increase the number of rows to be viewed from the menu "records per page".

--- .class #id 

## Feature 3: Cluster Analysis

The second section of the application is cluster analysis of the data using 2 numeric columns of the dataset selected using two different clustering techniques viz. K-means and Ward.


. K-Means Clustering 

```r
clust<-kmeans(iris[, c("Sepal.Length", "Sepal.Width")], 3)
summary(clust$cluster)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1.00    1.00    2.00    2.02    3.00    3.00
```

. Ward Clustering: plot dendogram

 I have used `hclust(data, method="ward.D2")` to generate dendogram


--- .class #id 

### Import-Export Data into the application

I have ammended import/export feature of user's data to use in the application using the codes from <https://gist.github.com/SachaEpskamp/5796467>. Thanks to the developer Epskamp. 

```
- Upload a data by choosing formats from the dropdown menu

- You can give your own name of the data

- Save source code/binary data after uploading


```



--- .class #id 

## Additional Slide: 

### References 

1.RMarkdown <http://rmarkdown.rstudio.com>

2.Slidify <http://slidify.org/>

3.Shiny RStudio <http://shiny.rstudio.com>

### Packages Used

`library(shiny)` `library(foreign)` `library(rCharts)`

`library(datasets)` `require(graphics)` `library(MASS)`



