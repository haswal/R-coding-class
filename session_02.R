# Session 02
# Mar 5, 2021

# Load packages ----
library(tidyverse)
library(readxl)
library(wesanderson)
library(ggthemes)

# Read in the data ----
cyto_data <- read_excel(path = "Cytokine-Results_MULTIPL.615133.xlsx",
                        sheet = 2,
                        skip = 1) 

# Mapping in ggplot() ----
ggplot(data = cyto_data, 
       mapping = aes(x = TP , 
                     y = CD40L, 
                     color = Monkey)) + 
  geom_point() 

# Customizing ggplot ----
# Change or add labels for axes, title, and legend
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = Monkey)) + 
  geom_point() +
  labs(x = "Timepoint", 
       y = "CD40 ligand", 
       title = "CD40L expression", 
       subtitle = "Subtitle goes here", 
       tag = "A", 
       color = "Rhesus macaque", 
       caption = "My caption here" )


# Or remove them
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = Monkey)) + 
  geom_point() +
  labs(x = "Timepoint", 
       y = NULL, 
       title = "CD40L expression", 
       color = NULL, 
       caption = "My caption here" )

# Hide legend
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = Monkey)) + 
  geom_point() +
  labs(x = "Timepoint", 
       y = NULL, 
       title = "CD40L expression", 
       color = NULL, 
       caption = "My caption here" ) +
  guides(color = FALSE)

# Add a built-in "complete theme"
# https://ggplot2.tidyverse.org/reference/ggtheme.html
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = Monkey)) + 
  geom_point() +
  theme_classic()

# Change custom color palettes
# Predefined color name: http://sape.inf.usi.ch/quick-reference/ggplot2/colour
# Or hex color codes: https://htmlcolorcodes.com/

# discrete variables
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = Monkey)) + 
  geom_point() +
  theme_classic() +
  scale_color_manual(values = c("blue", 
                                "pink", 
                                "orchid", 
                                "#000000", 
                                "gray"))

# continuous variable
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = RANTES)) + 
  geom_point() +
  theme_classic() +
  scale_color_gradient(low = "red", 
                       high = "blue")

# Third party palettes
# install.packages("wesanderson")
# library(wesanderson) at the top of the script
# To see palettes: https://github.com/karthik/wesanderson

# discrete
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = Monkey)) + 
  geom_point() +
  theme_classic() +
  scale_color_manual(values = wes_palette("Darjeeling1"))

# continuous (scale_color_gradientn)
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = RANTES)) + 
  geom_point() + 
  theme_classic() +
  scale_color_gradientn(colors = wes_palette("Zissou1", 
                                             type = "continuous"))

# Other ways to set themes + colors
# install.packages("ggthemes")
# https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = CD40L, 
                     color = Monkey)) + 
  geom_point() + 
  scale_color_hc()

# A ggthemes theme
ggplot(data = cyto_data, 
       mapping = aes(x = TP,
                     y = CD40L,
                     color = Monkey)) + 
  geom_point() + 
  theme_excel_new()

# Save your ggplot output -------------
# Assign the plot to an R object
p <- ggplot(data = cyto_data, 
            mapping = aes(x = TP, 
                          y = CD40L, 
                          color = Monkey)) + 
  geom_point() 

# Can save directly into R project folder or subfolder
ggsave(p, 
       filename = "plot1.png", 
       width = 5, 
       height = 1)

#pivot_longer()----
#Use pivot_longer to transform data from wide to long format

cyto_data_long <- pivot_longer(cyto_data, 
                               cols = 5:49,
                               names_to = "Cytokines", 
                               values_to = "Concentration")

#Facets----
#Plot all cytokines using facet_wrap

ggplot(data = cyto_data_long)+
  geom_smooth(mapping = aes(x = TP, 
                            y = Concentration))+
  theme_minimal()+
  facet_wrap(~Cytokines)

#Let axis scales be "free" 
ggplot(data = cyto_data_long)+
  geom_smooth(mapping = aes(x = TP, 
                            y = Concentration))+
  theme_minimal()+
  facet_wrap(~Cytokines, 
             scales = "free")

#Free only y-axis
ggplot(data = cyto_data_long)+
  geom_smooth(mapping = aes(x = TP, 
                            y = Concentration))+
  theme_minimal()+
  facet_wrap(~Cytokines, 
             scales = "free_y")

#facet_grid() is another way to create faceted plots
ggplot(data = cyto_data_long)+
  geom_smooth(mapping = aes(x = TP, 
                            y = Concentration))+
  theme_minimal()+
  facet_grid(Cytokines~Monkey, scales = "free_y")

#Layering geoms----
#Adding multiple geoms of the same type
ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = `FGF-2`))+
  geom_smooth(mapping = aes(color = Monkey), up
              se = FALSE,
              size = 0.5)+
  geom_smooth()

#A silly example showing that you can add MANY geoms of the same type

ggplot(data = cyto_data, 
       mapping = aes(x = TP, 
                     y = `FGF-2`))+
  geom_smooth(color = "grey10", size = 17, se = F)+
  geom_smooth(color = "grey20", size = 15, se = F)+
  geom_smooth(color = "grey30", size = 13, se = F)+
  geom_smooth(color = "grey40", size = 11, se = F)+
  geom_smooth(color = "grey50", size = 9, se = F)+
  geom_smooth(color = "grey60", size = 7, se = F)+
  geom_smooth(color = "grey70", size = 5, se = F)+
  geom_smooth(color = "grey80", size = 3, se = F)+update.formula.lm
  geom_smooth(color = "grey90", size = 1, se = F)+
  theme_classic()+
  scale_y_continuous(expand = c(0.2, 0.2))
