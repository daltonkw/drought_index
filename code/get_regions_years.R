#!/usr/bin/env Rscript

#VII. FORMAT OF "ghcnd-inventory.txt"
#
#------------------------------
#Variable   Columns   Type
#------------------------------
#ID            1-11   Character
#LATITUDE     13-20   Real
#LONGITUDE    22-30   Real
#ELEMENT      32-35   Character
#FIRSTYEAR    37-40   Integer
#LASTYEAR     42-45   Integer
#------------------------------


library(tidyverse)

readr::read_fwf("data/ghcnd-inventory.txt",
                col_positions = fwf_cols(
                    id = c(1, 11),
                    latitude = c(13, 20),
                    longitude = c(22, 30),
                    element = c(32, 35),
                    first_year = c(37, 40),
                    last_year = c(42, 45)
                )) |>
dplyr::filter(element == "PRCP") |>
dplyr::mutate(latitude = round(latitude, 0),
              longitude = round(longitude, 0)) |>
dplyr::group_by(longitude, latitude) |>
dplyr::mutate(region = cur_group_id()) |>
dplyr::select(-element) |>
readr::write_tsv("data/ghcnd_regions_years.tsv")
