#!/usr/bin/env Rscript

library(tidyverse)
# library(httpgd)
library(lubridate)
library(glue)
library(showtext)

sysfonts::font_add_google(
    "Roboto slab",
    family = "roboto-slab"
)
sysfonts::font_add_google(
    "Montserrat",
    family = "montserrat"
)

showtext::showtext_auto()
showtext::showtext_opts(dpi = 300)

prcp_data <- readr::read_tsv("data/ghcnd_tidy.tsv.gz")
station_data <- readr::read_tsv("data/ghcnd_regions_years.tsv")

buffered_today <- lubridate::today() - 5
buffered_end <- lubridate::today() - 5
buffered_start <- buffered_end - 30



end <- dplyr::case_when(
    # different month, same year & diff month, diff year
    lubridate::month(buffered_start) != lubridate::month(buffered_end) ~
        format(buffered_end, "%B %-d, %Y"),
    # same month, same year
    lubridate::month(buffered_start) == lubridate::month(buffered_end) ~
        format(buffered_end, "%-d, %Y"),
    TRUE ~ NA_character_
)
start <- dplyr::case_when(
    # different month, different year
    lubridate::year(buffered_start) != lubridate::year(buffered_end) ~
        format(buffered_start, "%B %-d, %Y"),
    # different month, same year
    lubridate::month(buffered_start) != lubridate::month(buffered_end) ~
        format(buffered_start, "%B %-d"),
    # same month, same year
    lubridate::month(buffered_start) == lubridate::month(buffered_end) ~
        format(buffered_start, "%B %-d"),
    TRUE ~ NA_character_
)

date_range <- glue::glue("{start} to {end}")

world_map <- ggplot2::map_data("world") |>
    dplyr::filter(region != "Antarctica")
#    dplyr::mutate(lat = round(lat), long = round(long))

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
    dplyr::filter(n >= 50 & year == lubridate::year(buffered_end)) |>
    dplyr::select(-n, -year, -mean_prcp) |>
    dplyr::mutate(z_score =
                    if_else(z_score > 2, 2, z_score),
                    if_else(z_score < -2, -2, z_score)) |>
    ggplot2::ggplot(aes(x = longitude, y = latitude, fill = z_score)) +
        ggplot2::geom_map(
            data = world_map,
            aes(map_id = region),
            map = world_map,
            fill = NA,
            color = "#f5f5f5",
            size = 0.05,
            inherit.aes = FALSE) +
        expand_limits(x = world_map$long, y = world_map$lat) +
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
            plot.title = element_text(color = "#f5f5f5",
                                      size = 18,
                                      family = "roboto-slab"),
            plot.subtitle = element_text(color = "#f5f5f5",
                                         size = 10,
                                         family = "montserrat"),
            plot.caption = element_text(color = "#f5f5f5",
                                        family = "montserrat"),
            panel.grid = element_blank(),
            legend.background = element_blank(),
            legend.text = element_text(color = "#f5f5f5",
                                       family = "montserrat"),
            legend.position = c(0.15, 0.0),
            legend.direction = "horizontal",
            legend.key.height = unit(0.25, "cm"),
            axis.text = element_blank()
        ) +
        labs(
            title = glue::glue("Amount of precipitation for {date_range}"),
            subtitle = "Standardized Z-scores for at least the past 50 years",
            caption = "Precipitation data collected from GHCN daily data at NOAA"
        )

ggplot2::ggsave("figures/world_drought.png",
    width = 8, height = 4, device = "png")
# colorbrewer2.org good color advice for cartography




#ggplot2::ggplot(data = world_map,
#                aes(x = long, y = lat, map_id = region)) +
#        ggplot2::geom_map(map = world_map, fill = NA, color = "white") +
#        ggplot2::coord_fixed() +
#        theme(panel.background = element_rect(fill = "black"),
#              plot.background = element_rect(fill = "black"))
