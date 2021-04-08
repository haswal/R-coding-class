library(tidyverse)
library(MASS)

subjectID <- paste0("SID_", "100", 1:99)

diagnosis <- 
  c(
    rep(
      c("TD", "ASD"),
      each = 47),
    "Typ_Dev", "A_S", "ASDisorder", "TypD", "T_D", "Autism") %>% 
  tibble() %>% 
  sample_n(99, replace = FALSE) %>% 
  pull(1)

sex <- 
  c(rep(c("Male", "Female"),
        each = 45),
    "MALE", "MALE", "Girl", "Boy", "FEMALE", "FEMALE", "boy", "girl", "boy", "girl")%>% 
  tibble() %>% 
  sample_n(99, replace = FALSE) %>% 
  pull(1) 

age <- round(rnorm(99, 6, 0.5),1)

meta <- tibble(subjectID, diagnosis, sex, age)

meta2 <- tibble(subjectID = rep(unique(subjectID), each = 4),
       Tissue = rep(c("blood", "saliva"), 198),
       Gene = rep(c("SHANK3", "SHANK3", "MECP2", "MECP2"),99))

meta_clean <- 
  meta %>% 
  mutate(temp_sex = str_replace_all(sex, 
                                    ".oy", 
                                    "Male"),
         temp_sex_2 = str_replace_all(temp_sex, 
                                      ".irl", 
                                      "Female"),
         sex = str_to_sentence(temp_sex_2),
         temp_diag = str_replace_all(diagnosis,
                                     "^A.*",
                                     "ASD"),
         diagnosis = str_replace_all(temp_diag,
                                     "^T.*",
                                     "TD")) %>%
  dplyr::select(subjectID, diagnosis, sex)


s1 <- diag(4)
s1[1,2] <- s1[2,1] <-  0.4
s1[1,3] <- s1[3,1] <-  0.9
s1[1,4] <- s1[4,1] <-  0.3

s1[2,3] <- s1[3,2] <-  0.3
s1[2,4] <- s1[4,2] <-  0.9

s1[3,4] <- s1[4,3] <-  0.4

expr <- mvrnorm(50, mu=c(6,14.5,6,14.5), Sigma = s1)
ex <- as.vector(expr)

expr2 <- mvrnorm(49, mu=c(5.5,14,5.5,14), Sigma = s1)
ex2 <- as.vector(expr2)

mm <- left_join(meta2, meta_clean) %>% 
  arrange(diagnosis, Tissue, Gene) %>% 
  mutate(expression = c(ex, ex2))

mm %>% 
  pivot_wider(names_from = Tissue,
              values_from = expression) %>% 
  group_by(Gene, diagnosis) %>% 
  summarise(cor = cor(blood,
                      saliva, 
                      use = "pairwise.complete.obs"))

mm <- mm %>%
  mutate(expression=replace(expression, 
                            subjectID == "SID_10047" & Tissue == "blood", 
                            "Failed"))

mm <- mm %>%
  mutate(expression=replace(expression, 
                            subjectID == "SID_10092" & Gene == "MECP2", 
                            "Failed"))

mm <- mm %>%
  mutate(expression=replace(expression, 
                            subjectID == "SID_10092" & Gene == "MECP2", 
                            "Failed"))

mm <- mm %>%
  mutate(expression=replace(expression, 
                            subjectID == "SID_10034" & Gene == "MECP2" & Tissue == "saliva", 
                            63.8132416451188))

mm <- mm %>%
  mutate(expression=replace(expression, 
                            subjectID == "SID_10026" & Gene == "MECP2" & Tissue == "saliva", 
                            58.9825325083544))

mm %>% 
  filter(subjectID %in% c("SID_10047", "SID_10092", "SID_10034", "SID_10026"))




gene_expression_data <- 
  mm %>% 
  mutate(sampleID = paste0("ID",
                           str_sub(sex,1,1),
                           str_replace(subjectID,
                                       "SID_100",
                                       ""))) %>% 
  dplyr::select(sampleID, Tissue, Gene, expression)


gene_expression_data <- 
  gene_expression_data %>% 
  pivot_wider(names_from = sampleID,
              values_from = expression)


write_csv(gene_expression_data, 
          "gene_expression_data.csv")

write_csv(gene_expression_data, 
          "/Users/Hasse/Documents/The Marcus Autism Center/R_solutions/gene_expression_data.csv")

write_csv(meta, 
          "meta_data.csv")

write_csv(meta, 
          "/Users/Hasse/Documents/The Marcus Autism Center/R_solutions/meta_data.csv")

  
