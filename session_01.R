#Load packages to enable the use of ggplot and read_excel 
library(tidyverse)
library(readxl)

#Use the read_excel function to import data from an excel document
#Assign to an object with <- ("Alt" + "-")
#Object names must start with a letter, can include letters, numbers, periods, underscores 
cyto_data <- read_excel(path = "Cytokine-Results_MULTIPL.615133.xlsx",
                        sheet = 2, 
                        skip = 1) 


#Use the ggplot function to start building a plot
ggplot(data = cyto_data)

#Complete graph by adding layers, most often "geoms"
#Layers are added with a "+"
ggplot(data = cyto_data)+
  geom_point(mapping = aes(y = CD40L,
                           x = TP))

#Adding some color
#Only columns should be mapped to aesthetics
ggplot(data = cyto_data)+
  geom_point(mapping = aes(y = CD40L,
                           x = TP,
                           color = Monkey))

#Assign shapes to different monkeys instead of color
ggplot(data = cyto_data)+
  geom_point(mapping = aes(y = CD40L,
                           x = TP,
                           shape = Monkey))

#Size instead of shape
ggplot(data = cyto_data)+
  geom_point(mapping = aes(y = CD40L,
                           x = TP,
                           size = Monkey))

#Changing the color of all shapes
ggplot(data = cyto_data)+
  geom_point(mapping = aes(y = CD40L,
                           x = TP,
                           shape = Monkey),
             color = "blue")

#Adding a trend line, se = TRUE / FALSE controls the confidence bands
ggplot(data = cyto_data)+
  geom_point(mapping = aes(y = CD40L,
                           x = TP,
                           color = Monkey))+
  geom_smooth(mapping = aes(y = CD40L,
                            x = TP),
              se = FALSE)

#Mapping a variable with a "-" in the name, using backticks
ggplot(data = cyto_data)+
  geom_point(mapping = aes(y = `G-CSF`,
                           x = TP,
                           color = Monkey))



