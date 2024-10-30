library(RSelenium)
library(wdman)
library(netstat)
library(getPass)
library(magick)
library(dplyr)
library(tesseract)
library(tidyverse)


#Perform in a loop
#Specify pages
pages = 5
start = 1

remote_driver <- rsDriver(browser = "chrome", chromever = "130.0.6723.70", verbose = FALSE, port = free_port())


remDr <- remote_driver[["client"]]
remDr$maxWindowSize()


remDr$navigate("https://scrapeme.live/shop/page/1")

names_list <- list()
price_list <- list()

while(start < pages){
  #Find names
  name = remDr$findElements(using = 'xpath', "//h2[@class='woocommerce-loop-product__title']")
  #Find prices
  price = remDr$findElements(using = 'xpath', "//span[@class='price']")
  
  #Get text for price and names
  names <- sapply(name, function(x) x$getElementText())
  prices <- sapply(price, function(x) x$getElementText())
  
  #Add to list
  names_list <- append(names_list, names)
  price_list <- append(price_list, prices)
  #Increase loop variable
  start = start + 1
  
  #Go to next page
  nextp <- remDr$findElement(using = 'xpath', "//a[@class='next page-numbers']")
  nextp$clickElement()
  
}
poke_names = unlist(names_list, recursive=FALSE)
poke_prices = unlist(price_list, recursive=FALSE)

#Create dataframe from group of vectors. 
poke_data <- data.frame(poke_names, poke_prices)

remote_driver$server$stop()
