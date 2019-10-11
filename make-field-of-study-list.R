library(tidyverse)

raw <- readLines("field-of-study-raw.txt")

dat <- tibble(raw = raw)

res <- dat %>% 
  
  mutate(
    label = case_when(
      !str_detect(raw, "^\\d") ~ raw, 
      TRUE ~ NA_character_
    )
  ) %>% 
  
  fill(label) %>% 
  
  filter(
    label != raw
  ) %>% 
  
  group_nest(
    label
  ) %>% 
  
  mutate(
    value = data %>% map_chr(~ .x$raw %>% paste0(collapse = ";"))
  ) %>%
  
  select(
    -data
  ) %>% 
  
  jsonlite::toJSON(auto_unbox = TRUE, pretty = TRUE)

res %>% writeLines("field-of-study-autocomplete-data-list.json")  
  
