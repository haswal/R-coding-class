# Session 04, March 19, 2021

library(tidyverse)
cyto_data <- readxl::read_excel("Cytokine-Results_MULTIPL.615133.xlsx", 
                                skip = 1, 
                                sheet = 2)

# glimpse makes is easy to copy-paste column names
glimpse(cyto_data) 

# Pick variables (columns) using select()
# By name
select(cyto_data, Monkey, TP, TGFα) 

select(cyto_data, Eotaxin:TGFα)
select(cyto_data, -(Eotaxin:TGFα))
select(cyto_data, !(Eotaxin:TGFα))

# With built-in select() helper functions:
# starts_with("abc")
# ends_with("xyz")
select(cyto_data, starts_with("M"))

# With logical expressions: &, |, or !
select(cyto_data, starts_with("M") | ends_with("2"))
select(cyto_data, starts_with("M") & ends_with("1"))

# Other helpers
# contains("ijk")
select(cyto_data, contains("-"))

# matches("x")
select(cyto_data, matches("-[a-z]"))

#combination of contains() and name
select(cyto_data, !contains("-"), `GM-CSF`)
    
# By variable type, e.g. "is.character", "is.numeric", "is.factor"
# with where()
select(cyto_data, where(is.character))

# By position (works but not recommended)
select(cyto_data, 1:3, 10)

# rename()
# new_name = old_name

rename(cyto_data, TGFalpha = TGFα)
View(rename(cyto_data, TGFalpha = TGFα)) 

# relocate
# Default position is to move the columns to the front
relocate(cyto_data, starts_with("IL-"))
relocate(cyto_data, 1:3, starts_with("IL-"))

# Move before or after a *specific* column
# .before = 
# .after = 

relocate(cyto_data, Monkey, .after = `Specimen Type`)

# $
# Pulls out a single column and turns it into a *vector*
# Good for quick calculations

cyto_data$CD40L
mean(cyto_data$CD40L)

# select does not create a vector
mean(select(cyto_data, CD40L))

# mutate()/ transmute()
# create new variables that are functions of existing columns
# mutate() adds the new column at end of dataset
# transmute() adds and prints out only columns you create

mutate(cyto_data, MIP_combined = `MIP-1α` + `MIP-1β`)
View(mutate(cyto_data, MIP_combined = `MIP-1α` + `MIP-1β`))

transmute(cyto_data, `MIP-1α`, `MIP-1β`,  MIP_combined = `MIP-1α` + `MIP-1β`) 

# mutate multiple columns at once
transmute(cyto_data, TNFα, TNFβ,  
          TNF_combined = `TNFα` + `TNFβ`, 
          TNF_combined_squared = TNF_combined^2) 

# What happens here?
a <- mutate(cyto_data, TRAIL_sd = sd(TRAIL))

# creates a column full of the constant
View(a) 

#What if we want to run multiple dplyr functions in sequence
cyto_sort <- arrange(cyto_data, CD40L)
cyto_sort
select(cyto_sort, Monkey, TP, CD40L)

#Nested functions
select(arrange(cyto_data, CD40L), Monkey, TP, CD40L)

#Introducing the "pipe" operator: %>%
#Keyboard shortcut ctrl+shift+m (PC)
#                  cmd+shift+m (Mac)

cyto_data %>% 
  arrange(CD40L) %>% 
  select(Monkey, TP, CD40L)

#Pipe to ggplot
cyto_data %>% 
  filter(Monkey != "RFv13") %>% 
  ggplot(aes(x = TP, 
             y = CD40L, 
             color = Monkey))+
  geom_smooth(se=FALSE)

#Pipe to pivot_longer, then ggplot
cyto_data %>% 
  filter(Monkey != "RFv13") %>% 
  pivot_longer(cols = 5:49,
               names_to = "Cytokines",
               values_to = "Concentration") %>% 
  ggplot(aes(x = TP, 
             y = Concentration))+
  geom_smooth(se = FALSE)+
  facet_wrap(~Cytokines, 
             scale = "free_y")

#Summarise is used to calculate summary statistics
cyto_data %>% 
  summarise(mean(Eotaxin))

#Output can be named
cyto_data %>% 
  summarise(Eotaxin_mean = mean(Eotaxin))

#Summarise is most useful together with group_by
cyto_data %>% 
  group_by(Monkey) %>% 
  summarise(mean(Eotaxin))

#Multiple summary stats can be calculated at the same time
cyto_data %>% 
  group_by(Monkey) %>% 
  summarise(mean(Eotaxin),
            sd(Eotaxin),
            n())

#And can be combined with logical operations
#sum counts
cyto_data %>% 
  group_by(Monkey) %>% 
  summarise(greater_20_eotaxin = sum(Eotaxin > 20))

#mean gives proportion
cyto_data %>% 
  group_by(Monkey) %>% 
  summarise(greater_20_eotaxin = mean(Eotaxin > 20))

#We can also group based on multiple variables
cyto_data %>% 
  pivot_longer(cols = 5:49,
               names_to = "Cytokines",
               values_to = "Concentration") %>%
  group_by(Monkey, Cytokines) %>% 
  summarise(mean(Concentration),
            n())

#Operations piped together can be assigned to an object
cyto_summary <- cyto_data %>% 
  pivot_longer(cols = 5:49,
               names_to = "Cytokines",
               values_to = "Concentration") %>%
  group_by(Monkey, Cytokines) %>% 
  summarise(mean(Concentration),
            n())

#Missing values
cyto_data_small <- read_csv("Cytokine-Results_small.csv", 
                            skip = 1)

#Results in mean = NA if any obs is NA
cyto_data_small %>% 
  group_by(Monkey) %>% 
  summarise(mean(Eotaxin))

#Solution with filter 
cyto_data_small %>%
  filter(!is.na(Eotaxin)) %>% 
  group_by(Monkey) %>% 
  summarise(mean(Eotaxin))

#Use na.rm = TRUE 
cyto_data_small %>%
  group_by(Monkey) %>% 
  summarise(mean(Eotaxin, 
                 na.rm = TRUE))


#Group_by can be used with other functions than summarise
cyto_data %>%
  group_by(Monkey) %>% 
  count()

#Group_by and transmute
cyto_data %>%
  group_by(Monkey) %>% 
  transmute(MIG, monkey_median_MIG = median(MIG))
