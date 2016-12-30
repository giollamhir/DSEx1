#load libraries
library(tidyr)
library(dplyr)


#rstudio run code > 1 chunk at a time options: 
   #Select the lines and press the Ctrl+Enter key (or use the Run toolbar button); or
   #To run the entire document press the Ctrl+Shift+Enter key (or use the Source toolbar button).

#Step 0 Load 
dat <- read.csv("refine_original.csv")
#Step 1 Standardize names to lowercase standard spellings: 
#philips, akzo, van houten and unilever 
#pattern matching was easy but everything kept reverting except the most recent change. 
#then I couldn't figure out how to update / save as new variable until I realized I needed the c() around the whole pattern matching thing.
dat2 <- dat
#not sure that duplication was necessary
dat2$company <- tolower(dat2$company)
# optional utils::View(dat2)
dat2$company <- c(sub(pattern = ".*ps$", replacement = "philips", x = dat2$company))
dat2$company <- c(sub(pattern = "ak.*", replacement = "akzo", x = dat2$company))
#using the outer parens to trigger a console print without the extra command
(dat2$company <- c(sub(pattern = "uni.*", replacement = "unilever", x = dat2$company)))
# optional utils::View(dat2$company) or #utils::View(dat2)


#Step 2:Separate the product code and product number into separate columns 
#cheatsheet example:   tidyr::separate(storms, date, c("y", "m", "d"))
# Note: first time around to execute I needed to  install.packages("tidyr") as I didn't have it yet.
#    code was  install.packages("tidyr")
dat2 <- tidyr::separate(dat2, Product.code...number, c("product_code", "product_number"))

#Step 3: Add product categories
# Is there  a smarter way to do this?
dat2 <- dplyr::mutate(dat2, product_category = product_code)
dat2$product_category <- c(sub(pattern = "p", replacement = "Smartphone", x = dat2$product_category))
dat2$product_category <- c(sub(pattern = "v", replacement = "TV", x = dat2$product_category))
dat2$product_category <- c(sub(pattern = "x", replacement = "Laptop", x = dat2$product_category))
(dat2$product_category <- c(sub(pattern = "q", replacement = "Tablet", x = dat2$product_category)))

#Step 4: Add full address for geocoding
# Create a new column full_address that concatenates the three address fields
#   (address, city, country), separated by commas.
dat2 <- unite(dat2, "full_address", address, city, country, sep = ",")

# Step 5: Create dummy variables for company and product category
#Add four binary (1 or 0) columns for company: 
#     company_philips, company_akzo, company_van_houten and company_unilever

dat2$company_philips <- ifelse(dat2$company == "philips", 1, 0)
dat2$company_akzo <- ifelse(dat2$company == "akzo", 1, 0)
dat2$company_van_houten <- ifelse(dat2$company == "van houten", 1, 0)
dat2$company_unilever <- ifelse(dat2$company == "unilever", 1, 0)

# Add four binary (1 or 0) columns for product category:
dat2$product_smartphone <- ifelse(dat2$product_code == "p", 1, 0)
dat2$product_tv <- ifelse(dat2$product_code == "v", 1, 0)
dat2$product_laptop <- ifelse(dat2$product_code == "x", 1, 0)
dat2$product_tablet <- ifelse(dat2$product_code == "q", 1, 0)

#Submission instructions include instrux to store results in refine_clean.csv
write.csv(dat2, file = "refine_clean.csv")



#Installed and set up git/github when I had a working draft of exercise
# ref see http://r-pkgs.had.co.nz/git.html
# ref see https://www.r-bloggers.com/rstudio-and-github/







