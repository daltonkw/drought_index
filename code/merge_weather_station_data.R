#!/usr/bin/env Rscript

library(tidyverse)

prcp_data <- readr::read_tsv("data/ghcnd_tidy.tsv.gz")
station_data <- readr::read_tsv("data/ghcnd_regions_years.tsv")

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

this_year <- lat_long_prcp |>
    dplyr::filter(year == 2022) #|>
#    dplyr::select(-year)

dplyr::inner_join(
    x = lat_long_prcp,
    y = this_year,
    by = c("latitude", "longitude")
) |>
dplyr::rename(all_years = mean_prcp.x, this_year = mean_prcp.y) |>
dplyr::group_by(latitude, longitude) |>
dplyr::summarise(
    z_score = (min(this_year) - mean(all_years)) / sd(all_years),
    n = n(),
    .groups = "drop"
) |>
dplyr::filter(n >= 50)
