library(tidyverse)

naics_index <- read_csv("2017_NAICS_Index_File.csv") %>% 
  mutate(naics_code = `NAICS17`) %>% 
  janitor::clean_names() %>% 
  select(naics_code, index_item_description) %>% 
  group_by(naics_code) %>% 
  summarize(value = str_c(index_item_description, collapse = ";"))

naics_descriptions <- read_csv("2017_NAICS_Descriptions.csv") %>% 
  filter(nchar(Code) == 6) %>% 
  janitor::clean_names() %>% 
  mutate(code = as.numeric(code), label = str_c(code, " - ", title)) %>% 
  select(naics_code = code, label)

naics_data_list <- naics_index %>% left_join(naics_descriptions) %>% 
  select(label, value) %>% 
  as.list() %>% 
  transpose()



naics_data_list %>% jsonlite::toJSON(auto_unbox = TRUE) %>% cat(file = "naics-autocomplete-data-list.json")
