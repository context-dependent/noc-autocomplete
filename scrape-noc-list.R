library(tidyverse)
library(rvest)

noc_finder_page <- read_html("https://www.canada.ca/en/immigration-refugees-citizenship/services/immigrate-canada/express-entry/eligibility/find-national-occupation-code.html#find")

table_node <- html_node(noc_finder_page, "#noc")

noc_table <- html_table(table_node) %>% as_tibble()

noc_list <- noc_table %>% 
  janitor::clean_names() %>%
  mutate(label = str_c(noc, " - ", title)) %>% 
  rename(value = keywords) %>% 
  select(-noc, -title, -skill_level_or_type) %>% 
  select(label, value) %>% 
  as.list() %>% 
  transpose()

noc_list %>% jsonlite::toJSON(auto_unbox = TRUE) %>% jsonlite::prettify() %>% cat(file = "noc-autocomplete-data-list.json")
