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
dplyr::summarise(mean_prcp = mean(prcp))
