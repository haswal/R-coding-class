# Session 05, March 26, 2021

library(tidyverse)

# Create your own 2d data
# Why? Toy data sets are useful for de-bugging
# Using tibble()
a <- c("this", "is", "a", "vector")
b <- 2
c <- 1:4

tibble(a,b,c)

# Using tribble()
# A transposed tibble
tribble(
  ~x, ~y, ~z, # your header names
  "a", 4, 3.4,
  "b", 4, 2.5,
  "c", 4, 2.1,
  "d", 4, 2.1
)

# packages often come with built in datasets
tidyr::billboard
tidyr::relig_income
tidyr::us_rent_income

# Tidy data
# Each variable must have its own column
# Each observation must have its own row
# Each value must have its own cell
# see Figure 12.1 in text https://r4ds.had.co.nz/tidy-data.html

# Is this data tidy?
table4a 

# How to make it tidy:
# pivot_longer()
table4a %>%
  pivot_longer(cols = c(`1999`, `2000`),
               names_to = "year",
               values_to = "cases")

# Is this data tidy?
table2

# Use pivot_wider() to transform data to wide format
# see Figure 12.3
table2 %>%
  pivot_wider(names_from = type,
              values_from = count)

# Next dataset
table3 

# Use separate() to split values from one column
table3 %>%
  separate(rate, 
           into = c("cases", 
                    "population"),
           sep = "/")

# More data!
table5

# Use unite() to combine values across columns
table5 %>%
  unite(new_year, century, year)

# By default, the separator is "_"
table5 %>%
  unite(new_year, century, year, sep = "")

# *_join() functions
# Can merge two datasets at a time
# Matches by "key" column

# Old data!
cyto_small <- read_csv("Cytokine-Results_small.csv", 
                                skip = 1)

# New data!
siv <- read_csv("Collaborator-data.csv")

# No single variable can serve as a key in cyto_small
cyto_small

# Create a key
cyto_key <- cyto_small %>%
  unite(Monkey_TP, Monkey, TP)
cyto_key

# Use inner_join to get rows that are common to both data sets.
inner_join(x = cyto_key, 
           y = siv, 
           by = "Monkey_TP")

# Use anti-join() to show rows in x but not y
anti_join(x = cyto_key, 
          y = siv, 
          by = "Monkey_TP")

anti_join(x = siv, 
          y = cyto_key, 
          by = "Monkey_TP")

# Use left_join to keep all x, NA for missing in y
# See "wonky monkey"
left_join(x = cyto_key, 
          y = siv, 
          by = "Monkey_TP") %>%
  View()

# Use full_join to keep everything, NAs filled in where needed
full_join(x = cyto_key, 
          y = siv,
          by = "Monkey_TP") %>%
  View()

# Let's create a new CSV for our joined results
cyto_siv <- left_join(x = cyto_key, y = siv)

write_csv(cyto_siv, "cyto_siv.csv")

#Strings
#Create a string object using quotes
string1 <- "This is a string"

#Sometimes we need to use escape characters
string2 <- c("\"", "\\")

#Use the writeLines() function to view raw content of string
writeLines(string2)

#Put multiple strings in a vector object using c().
strings <- c("First string", "b", "end")
strings2 <- c("First string", 1, "end")

#Use str_length() to calculate the number of characters per string
#All stringr functions start with "str_", making tabbing useful.
str_length(strings)

#Combine the content of strings with str_c()
str_c("Beginning", "End")
str_c("Beginning", "End", sep = "_")

#Shorter vectors are recycled
str_c("group", c("a", "b", "c"), sep = "_")
str_c("group", 1:10, sep = "_")

#Collapse vector of strings into one string
str_c(c("a", "b", "c"), collapse = ",")

#Change to upper or lower case
str_to_upper(c("a", "b", "c"))
str_to_lower(c("A", "B", "C"))
str_to_sentence("hello there")
str_to_title("hello there")

#Regex using str_view()
x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x, ".a.")

#What if you want to match a character used by regex? Double escape characters!
str_view(c("abc", "a.c", "bef"), "a.c")
str_view(c("abc", "a.c", "bef"), "a\\.c")

#Anchors
str_view(x, "^a")
str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "apple$")

#Character classes
x <- c("abc", "a.c", "a*c", "a c", "bac")
str_view(x, "a[.]c")
str_view(x, "a[*]c")
str_view(x, "a[*. ]c")

#Followed by (or not)
str_view(x, "a(?=b)")
str_view(x, "a(?!b)")

#Preceded by (or not)
str_view(x, "(?<=b)a")
str_view(x, "(?<!b)a")

#Using "or" with regex, spaces matter
str_view(c("grey", "gray"), "grey|gray")

#Detect matches
fruit
str_detect(fruit, "^c")
sum(str_detect(fruit, "^c"))
mean(str_detect(fruit, "^c"))
#Subset vector of strings
str_subset(fruit, "^c")

#The str_ function I use the most is str_replace(_all).
string <- "Python is the best coding language"
str_replace(string, "Python", "R")

#Case study
flu_data <- read_delim("flu_data.txt", delim = "\t")
flu_data$Strain %>% 
  table()

#Cleaning Strain variable to be the same for all California 07/2009 obs
flu_data$Strain %>%
  str_replace_all("_", #Replaces underscore character with "/"
                  "/") %>%
  str_replace_all("^California", #Adds "A/" if string starts with California
                  "A/California") %>%
  str_replace_all("Ca(?!l)", #Replaces "Ca" with "California"
                  "California") %>%
  str_replace_all("(?<!0)7", #Changes all "7" not preceded by "0" to "07"
                  "07") %>%
  str_replace_all("(?<!20)09", #Changes all "09" not preceded by "20" to "2009"
                  "2009") %>%
  str_replace_all("swine| \\(H1N1\\)| H1N1", #Removes virus type
                  "") %>%
  str_replace_all("/$", # If string ends with "/" change to "/2009"
                  "/2009") %>%
  table()
