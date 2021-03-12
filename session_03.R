# Session 03, March 12, 2021

library(tidyverse)
library(cowplot)

#Import csv file using read_csv
cyto_data_small <- read_csv("Cytokine-Results_small.csv", 
                            skip = 1)

#Use brackets to both assign a plot to an object and show it
(p1 <- ggplot(data = cyto_data_small, 
              aes(x = TP, 
                  y = `FGF-2`))+
    geom_smooth())

(p2 <- ggplot(data = cyto_data_small, 
              aes(x = TP, 
                  y = CD40L))+
    geom_smooth())

#Use the plot_grid function from the cowplot package to combine plots
plot_grid(p1, p2)

#Add a label
plot_grid(p1, p2, 
          labels = "AUTO")

#Add custom label
plot_grid(p1, p2, 
          labels = c("A.", "B."))

#Change layout
plot_grid(p1, p2, 
          labels = c("A.", "B."), 
          ncol = 1)

#Making a bar plot using geom_bar
#The default settings with only "x" aesthetic is to count number of obs
ggplot(data = cyto_data_small)+
  geom_bar(aes(x = Monkey))

#Works with continues x variable but isn't ideal
ggplot(data = cyto_data_small)+
  geom_bar(aes(x = CD40L))

#Better to use geom_histogram
ggplot(data = cyto_data_small)+
  geom_histogram(aes(x = CD40L))

#geom_bar with both x and y aesthetics
#Throws an error because of the default counting
ggplot(data = cyto_data_small)+
  geom_bar(aes(x = TP, 
               y = CD40L))

#We need to specify "stat" for it to work
#stat = "identity" use data values for plotting
#If multiple values per group, they are summed. 
ggplot(data = cyto_data_small)+
  geom_bar(aes(x = TP, 
               y = CD40L), 
           stat = "identity")

#More useful to be specific about what to plot
ggplot(data = cyto_data_small)+
  geom_bar(aes(x = TP, 
               y = CD40L), 
           stat = "summary",
           fun = "mean")

#How about making a bar plot including multiple cytokines
#Lets first transform data to long format
cyto_data_sl <- pivot_longer(cyto_data_small, 
                             cols = 5:9,
                             names_to = "Cytokines",
                             values_to = "Concentration" 
)

#Color by cytokine, here specified using "fill"
#Stacked by default
ggplot(data = cyto_data_sl)+
  geom_bar(aes(x = TP, 
               y = Concentration, 
               fill = Cytokines), 
           stat = "summary",
           fun = "mean")

#Color specifies outline
ggplot(data = cyto_data_sl)+
  geom_bar(aes(x = TP, 
               y = Concentration, 
               fill = Cytokines), 
           stat = "summary",
           fun = "mean",
           color = "black")

#Use position = "fill" to display cytokine proportion per time point.
ggplot(data = cyto_data_sl)+
  geom_bar(aes(x = TP, 
               y = Concentration, 
               fill = Cytokines), 
           stat = "summary",
           fun = "mean",
           color = "black", 
           position = "fill")

#Use position = "dodge" to display bars side-by-side
ggplot(data = cyto_data_sl)+
  geom_bar(aes(x = TP, 
               y = Concentration, 
               fill = Cytokines), 
           stat = "summary",
           fun = "mean",
           color = "black", 
           position = "dodge")

#Add errorbars using geom_errorbar
ggplot(data = cyto_data_sl)+
  geom_bar(aes(x = TP, 
               y = Concentration, 
               fill = Cytokines), 
           stat = "summary",
           fun = "mean",
           color = "black", 
           position = "dodge")+
  geom_errorbar(aes(x = TP, 
                    y = Concentration, 
                    group = Cytokines),
                stat = "summary",
                fun.data = "mean_se",
                position = "dodge")

# Identify outliers
ggplot(data = cyto_data_sl, 
       aes(x = TP, 
           y = Concentration, 
           color = Monkey)) +
  geom_smooth(se = FALSE)

# Data transformations with dplyr package (https://dplyr.tidyverse.org/) 
# Filter rows with == 
filter(cyto_data_small, Monkey == "RFv13")

# Filter rows with !=
filter(cyto_data_small, Monkey != "RFv13")

# "coding way" to do same thing as button in environment pane
View(filter(cyto_data_small, Monkey != "RFv13")) 

# Filter doesn't alter original data set if not assigning 
cyto_data_small

a <- filter(cyto_data_small, Monkey != "RFv13")
a

# Other comparisons: ==, !=, >, <, >=, <= 
# E.g. Use filter() to subset all the rows with non-zero values of `GM-CSF` 
filter(cyto_data_small, `GM-CSF` != 0) 
filter(cyto_data_small, `GM-CSF` > 0)

# Comparisons happen across the same row
filter(cyto_data_small, Eotaxin > CD40L & Eotaxin < `FGF-2`)

# An impossible criterion
filter(cyto_data_small, Eotaxin > CD40L & Eotaxin == CD40L)

# |, logical OR: rows where AT LEAST ONE statement is TRUE will be returned
filter(cyto_data_small, TP == 1 | TP == 2)

# A shortcut: %in%
filter(cyto_data_small, TP == 1 | TP == 4 | TP == 7)  
filter(cyto_data_small, TP %in% c(1, 4, 7))

# Can also use logical operator !
filter(cyto_data_small, !TP %in% c(1, 4, 7))

# Cannot use variable == NA, must use is.na()
# is.na() evaluates to either TRUE or FALSE 
# More info in section 5.2.3 of R4DS textbook

filter(cyto_data_small, Eotaxin != NA)

# E.g. Find observations of Eotaxin with missing values
filter(cyto_data_small, is.na(Eotaxin))
filter(cyto_data_small, !is.na(Eotaxin))

#Combining filter and ggplot
ggplot(data = filter(cyto_data_small, TP %in% 1:5))+
  geom_point(aes(x = TP, 
                 y = CD40L))

# arrange() 
# Primarily for exploring the data
# Will arrange a column's values in ascending order by default
arrange(cyto_data_small, CD40L)

# To view in descending order, use desc() around the column name
arrange(cyto_data_small, desc(CD40L))

#Creating a function
my_square <- function(input){
  result <- input^2
  return(result)
}

my_square(10)
