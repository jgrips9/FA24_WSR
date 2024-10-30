#RVest using another page.
#Set directory. This will be where you save results.  
#setwd("Z:\\jrg363\\Workshops Sp24\\WSR")

#Install and load packages. RVest for web scraping. 
#install.packages("rvest")

library(rvest)

#https://webscraper.io/test-sites/e-commerce/static

tech <- read_html("https://webscraper.io/test-sites/e-commerce/static")

#Extract price, item name, item description
title <- tech %>% html_nodes(xpath = "//*[@class='title']") %>% 
  html_text2() 
price <- tech %>% html_nodes(xpath = "//*[@class='float-end price card-title pull-right']")%>% 
  html_text2() 
desc <- tech %>% html_nodes(xpath = "//*[@class='description card-text']")%>% 
  html_text2() 

#Now create dataframe. 
products <- data.frame( 
  title, 
  price, 
  desc 
)

#Export dataframe
write.csv(products, "tech_products.csv")