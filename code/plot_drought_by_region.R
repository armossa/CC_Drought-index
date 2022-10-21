#!/usr/bin/env Rscript

library(tidyverse)
library(lubridate)
library(glue)

prcp_data <- read_tsv("data/ghcnd_tidy.tsv.gz")
station_data <- read_tsv("data/ghcnd_regions_years.tsv")



# anti_join(station_data, prcp_data, by = "id") # nolint
lat_long_prcp <- inner_join(prcp_data, station_data, by = "id") %>%
    filter((year != first_year & year != last_year) | year == 2022) %>%
    group_by(latitude, longitude, year) %>%
    summarise(mean_prcp = mean(prcp), .groups = "drop")


end = format(today(), "%B %d")
start = format(today() - 30, "%B %d")

lat_long_prcp %>%
    group_by(longitude, latitude) %>%
    mutate(z_score = (mean_prcp - mean(mean_prcp)) / sd(mean_prcp),
           n = n())  %>%
    ungroup() %>%
    filter(n >= 50 & year == 2022) %>%
    select(-n , - mean_prcp, -year) %>%
    mutate(z_score = ifelse(z_score > 2, 2, z_score),
           z_score = ifelse(z_score < - 2, -2, z_score)) %>%
    ggplot(aes(x = longitude, y = latitude, fill = z_score)) +
        geom_tile() +
        coord_fixed() +
        scale_fill_gradient2(name = NULL,
                            low = "#d8b365", mid = "#f5f5f5",
                            high = "#5ab4ac", midpoint = 0, 
                            breaks = c(-2, -1, 0, 1, 2), 
                            labels = c("<-2", "-1", "0", "1", " >2")) +
        labs(title = glue("Amount of precipitation for {start} to {end}"),
            subtitle = "Standarized Z-scores for at least the past 50 years",
            caption = "Precipitation data collected from CHN daily data at NOAA") +
        theme(plot.background = element_rect(fill = "black", color = "black"),
             panel.background = element_rect(fill = "black"),
             panel.grid = element_blank(),
             legend.background = element_blank(),
             plot.title = element_text(color = "#f5f5f5", size = 18),
             plot.subtitle = element_text(color = "#f5f5f5"),
             plot.caption = element_text(color = "#f5f5f5"),
             legend.text = element_text(color = "#f5f5f5"),
             legend.direction = "horizontal",
             legend.position = c(.15, 0.0),
             legend.key.height = unit(0.25, "cm"),
             axis.text = element_blank())


ggsave("visuals/world_drought.png",
        width = 8, 
        height = 4)
