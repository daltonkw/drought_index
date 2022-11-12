#!/usr/bin/env Rscript

library(tidyverse)
#library(httpgd)
library(lubridate)
library(glue)

prcp_data <- readr::read_tsv("data/ghcnd_tidy.tsv.gz")
station_data <- readr::read_tsv("data/ghcnd_regions_years.tsv")

end <- format(lubridate::today(), "%B %d")
start <- format(lubridate::today() - 30, "%B %d")

lat_long_prcp <- dplyr::inner_join(
    x = prcp_data,
    y = station_data,
    by = "id"
) |>
dplyr::filter(
    (year != first_year & year != last_year) | year == 2022
) |>
dplyr::group_by(latitude, longitude, year) |>
dplyr::summarise(mean_prcp = mean(prcp), .groups = "drop")

lat_long_prcp |>
    dplyr::group_by(latitude, longitude) |>
    dplyr::mutate(
        z_score = (mean_prcp - mean(mean_prcp)) / sd(mean_prcp),
        n = n()
    ) |>
    dplyr::ungroup() |>
    dplyr::filter(n >= 50 & year == 2022) |>
    dplyr::select(-n, -year, -mean_prcp) |>
    dplyr::mutate(z_score =
                    if_else(z_score > 2, 2, z_score),
                    if_else(z_score < -2, -2, z_score)) |>
    ggplot2::ggplot(aes(x = longitude, y = latitude, fill = z_score)) +
        ggplot2::geom_tile() +
        coord_fixed() +
        scale_fill_gradient2(
            name = NULL,
            low = "#d8b365",
            mid = "#f5f5f5",
            high = "#5ab4ac",
            midpoint = 0,
            breaks = c(-2, -1, 0, 1, 2),
            labels = c("<-2", "-1", "0", "1", ">2")
        ) +
        theme(
            plot.background = element_rect(fill = "black", color = "black"),
            panel.background = element_rect(fill = "black"),
            plot.title = element_text(color = "#f5f5f5", size = 16),
            plot.subtitle = element_text(color = "#f5f5f5"),
            plot.caption = element_text(color = "#f5f5f5"),
            panel.grid = element_blank(),
            legend.background = element_blank(),
            legend.text = element_text(color = "#f5f5f5"),
            legend.position = c(0.15, 0.0),
            legend.direction = "horizontal",
            legend.key.height = unit(0.25, "cm"),
            axis.text = element_blank()
        ) +
        labs(
            title = glue::glue("Amount of precipitation for {start} to {end}"),
            subtitle = "Standardized Z-scores for at least the past 50 years",
            caption = "Precipitation data collected from GHCN daily data at NOAA"
        )

ggplot2::ggsave("figures/world_drought.png", 
    width = 8, height = 4, device = "png")
# colorbrewer2.org good color advice for cartography