library(RSelenium)
library(wdman)
library(netstat)
library(getPass)
library(magick)
library(dplyr)
library(tesseract)
library(tidyverse)

#Install drivers. 
#selenium()
#selenium_object = selenium(retcommand = TRUE, check = FALSE)
#binman::list_versions("chromedriver")

#Input version of chromedriver. 
remote_driver = rsDriver(browser = "chrome", chromever = "114.0.5735.90", verbose = FALSE, port = free_port())
remDr <- remote_driver[["client"]]
remDr$maxWindowSize()


##This is the link to go to. 
remDr$navigate('https://www.webscraper.io/test-sites/e-commerce/static/phones/touch?page=1')

title_list <- list()
price_list <- list()
desc_list <- list()

title<-remDr$findElements(using = 'xpath', "//a[@class='title']")
titles <- sapply(title, function(x) x$getElementText())
title_list <- append(title_list, titles)

price <- remDr$findElements(using = 'xpath', "//h4[@class='float-end price card-title pull-right']")
prices <- sapply(price, function(x) x$getElementText())
price_list <- append(price_list, prices)

desc <- remDr$findElements(using = 'xpath', "//p[@class='description card-text']")
descs <- sapply(desc, function(x) x$getElementText())
desc_list <- append(desc_list, descs)

#Click captcha
cookie <- remDr$findElement(using = 'xpath', "//div[@class='acceptContainer']")
cookie$clickElement()

#Click to the next page.
nextp<-remDr$findElement(using = 'xpath', "//a[@rel='next']")
nextp$clickElement()

#extract content again. 
title<-remDr$findElements(using = 'xpath', "//a[@class='title']")
titles <- sapply(title, function(x) x$getElementText())
title_list <- append(title_list, titles)

price <- remDr$findElements(using = 'xpath', "//h4[@class='float-end price card-title pull-right']")
prices <- sapply(price, function(x) x$getElementText())
price_list <- append(price_list, prices)

desc <- remDr$findElements(using = 'xpath', "//p[@class='description card-text']")
descs <- sapply(desc, function(x) x$getElementText())
desc_list <- append(desc_list, descs)

#now combine the data
tech_titles = unlist(title_list, recursive=FALSE)
tech_prices = unlist(price_list, recursive=FALSE)
tech_descs = unlist(desc_list, recursive=FALSE)

#Create dataframe from group of vectors. 
tech_data <- data.frame(tech_titles, tech_prices, tech_descs)
remote_driver$server$stop()

#Now brought into a function. 


#Input version of chromedriver. 
remote_driver = rsDriver(browser = "chrome", chromever = "114.0.5735.90", verbose = FALSE, port = free_port())
remDr <- remote_driver[["client"]]
remDr$maxWindowSize()


##This is the link to go to. 
remDr$navigate('https://www.webscraper.io/test-sites/e-commerce/static/phones/touch?page=1')

title_list <- list()
price_list <- list()
desc_list <- list()

url <- "https://www.webscraper.io/test-sites/e-commerce/static/phones/touch?page=1"
test_scrape <- function(url){
  #Go to page.
  remote_driver = rsDriver(browser = "chrome", chromever = "114.0.5735.90", verbose = FALSE, port = free_port())
  remDr <- remote_driver[["client"]]
  remDr$maxWindowSize()
  remDr$navigate(url)
  #Create empty lists for storing data.
  title_list <- list()
  price_list <- list()
  desc_list <- list()
  
  #Extract content of first page.
  title<-remDr$findElements(using = 'xpath', "//a[@class='title']")
  titles <- sapply(title, function(x) x$getElementText())
  title_list <- append(title_list, titles)
  
  price <- remDr$findElements(using = 'xpath', "//h4[@class='float-end price card-title pull-right']")
  prices <- sapply(price, function(x) x$getElementText())
  price_list <- append(price_list, prices)
  
  desc <- remDr$findElements(using = 'xpath', "//p[@class='description card-text']")
  descs <- sapply(desc, function(x) x$getElementText())
  desc_list <- append(desc_list, descs)
  
  #Get number of pages.
  pages<-remDr$findElements(using = 'xpath', "//li[@class='page-item']")
  pages<- sapply(pages, function(x) x$getElementText())
  #Get the second to last element.
  max_page <- as.numeric(pages[length(pages)-1])
  
  start = 1
  while(start < max_page){
    start = start + 1
    nextp<-remDr$findElement(using = 'xpath', "//a[@rel='next']")
    nextp$clickElement()
    
    title<-remDr$findElements(using = 'xpath', "//a[@class='title']")
    titles <- sapply(title, function(x) x$getElementText())
    title_list <- append(title_list, titles)
    
    price <- remDr$findElements(using = 'xpath', "//h4[@class='float-end price card-title pull-right']")
    prices <- sapply(price, function(x) x$getElementText())
    price_list <- append(price_list, prices)
    
    desc <- remDr$findElements(using = 'xpath', "//p[@class='description card-text']")
    descs <- sapply(desc, function(x) x$getElementText())
    desc_list <- append(desc_list, descs)
  
  }
  
  #Create dataframe
  #now combine the data
  tech_titles = unlist(title_list, recursive=FALSE)
  tech_prices = unlist(price_list, recursive=FALSE)
  tech_descs = unlist(desc_list, recursive=FALSE)
  
  #Create dataframe from group of vectors. 
  tech_data <- data.frame(tech_titles, tech_prices, tech_descs)
  return(tech_data)
  remote_driver$server$stop()
}


#Test with different urls. 
tech_data1 = test_scrape(url)
url = "https://www.webscraper.io/test-sites/e-commerce/static/computers/laptops"
tech_data2 = test_scrape(url)
