#Set directory. This will be where you save results.  
#setwd("Z:\\jrg363\\Workshops Sp24\\WSR")

#Install and load packages. RVest for web scraping. 
#install.packages("rvest")

library(rvest)

#scrape the following webpages
#https://webscraper.io/test-sites/e-commerce/static
#https://scrapeme.live/shop/

#pokemon example
#Load page. 
poke <- read_html("https://scrapeme.live/shop/page/1")

#Talk about inspect feature. How to copy xpath. 

#Find each list item. Using xpath. 
html_products <- poke %>% html_nodes(xpath = "//*[@id='main']/ul/li")

#Could go by class too. Or any attribute. Then get sub elements for list items. 
html_products1 <- poke %>% html_nodes(xpath = "//*[@class='products columns-4']")
html_products1 <- html_products1 %>% html_elements("li")
  

#Extract html sub-elements. Link, title, price
# selecting the "a" HTML element storing the product URL 
a_element <- html_products %>% html_element("a") 
h2_element <- html_products %>% html_element("h2") 
span_element <- html_products %>% html_element("span")

#Extract data from html elements. 
#Extract attribute of element. 
product_urls <- html_products %>% 
  html_element("a") %>% 
  html_attr("href") 

#Extract text of element. 
product_names <- html_products %>% 
  html_element("h2") %>% 
  html_text2() 
product_prices <- html_products %>% 
  html_element("span") %>% 
  html_text2()


#Create dataframe
products <- data.frame( 
  product_urls, 
  product_names, 
  product_prices 
)

# changing the column names of the data frame before exporting it into CSV 
names(products) <- c("url", "name", "price")

#View dataset
View(products)

# export the data frame containing the scraped data to a CSV file 
write.csv(products, file = "products.csv", fileEncoding = "UTF-8")



#Now more advanced. Go through pages using base URL. Extract URL, name, price, description.
#Then go to each one. 

page = 1
url_base = "https://scrapeme.live/shop/page/"
desc_list <- list()
poke_urls <- list()
poke_names <- list()
poke_price <- list()
#Extract the data for the first 10 pages. 
while(page < 3){
  #Create url
  url = paste(url_base, as.character(page), sep = "")
  #Increment page for next. 
  page = page + 1
  
  poke <- read_html(url)
  
  html_products <- poke %>% html_nodes(xpath = "//*[@id='main']/ul/li")
  product_urls <- html_products %>% 
    html_element("a") %>% 
    html_attr("href")
  poke_urls <- append(poke_urls, list(product_urls))
  
  #Extract text of element. 
  product_names <- html_products %>% 
    html_element("h2") %>% 
    html_text2() 
  poke_names <- append(poke_names, list(product_names))
  
  product_prices <- html_products %>% 
    html_element("span") %>% 
    html_text2()
  poke_price <- append(poke_price, list(product_prices))
  
  #Go to each page. Extract description.
  for(i in 1:length(product_urls)) {
    #Go to individual page
    desc_page = read_html(product_urls[i])
    #Extract the description and store.
    product_desc <- desc_page %>% 
    html_nodes(xpath = "//*[@class='woocommerce-product-details__short-description']") %>% 
    html_text2()
    
    #Append to a list. 
    desc_list <- append(desc_list, product_desc)
  }
}
#Then create dataframes
poke_urls = unlist(poke_urls, recursive=FALSE)
poke_names = unlist(poke_names, recursive=FALSE)
poke_price = unlist(poke_price, recursive=FALSE)
desc_list = unlist(desc_list, recursive=FALSE)

#Create dataframe from group of vectors. 
poke_data <- data.frame(poke_urls, poke_names, poke_price, desc_list)

#Export data as csv
write.csv(poke_data, file = "poke_data.csv")

#Following link as tutorial for above example. Sources
#https://www.zenrows.com/blog/web-scraping-r#instal-rvest
