#!/usr/bin/env Rscript

library(tidyverse)

readr::read_fwf("data/ghcnd-stations.txt",
                col_positions = fwf_cols(
                    id = c(1, 11),
                    latitude = c(13, 20),
                    longitude = c(22, 30),
                    elevation = c(32, 37),
                    state = c(39, 40),
                    gsn_flag = c(73, 75),
                    hcn_flag = c(77, 79),
                    wmo_id = c(81, 85)
                ),
                col_select = c(id, latitude, longitude)) |>
dplyr::mutate(latitude = round(latitude, 0),
              longitude = round(longitude, 0)) |>
dplyr::group_by(longitude, latitude) |>
dplyr::mutate(region = cur_group_id()) |>
readr::write_tsv("data/ghcnd_regions.tsv")
