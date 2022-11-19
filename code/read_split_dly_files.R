#!/usr/bin/env  Rscript

# Notes

# https://www.ncei.noaa.gov/pub/data/ghcn/daily/readme.txt
# https://archive.r-lib.org/

# Setup

library(tidyverse)
library(glue)

# Functions
x <- 20
quadruple <- function(x) {
    c(glue("VALUE{x}"),
      glue("MFLAG{x}"),
      glue("QFLAG{x}"),
      glue("SFLAG{x}")
    )
}


widths <- c(11, 4, 2, 4, rep(c(5, 1, 1, 1), 31))
headers <- c("ID", "YEAR", "MONTH", "ELEMENT", unlist(map(1:31, quadruple)))

tday_julian <- lubridate::yday(lubridate::today() - 5)
window <- 30

#archive::archive("write_dir.tar.gz") %>%
#    dplyr::pull(path) %>%
#    purrr::map_dfr(., ~read_tsv(archive_read("write_dir.tar.gz", .x)))
#start <- Sys.time()

#dly_files <- archive("data/ghcnd_all.tar.gz") %>%
#    dplyr::filter(stringr::str_detect(path, "dly")) %>%
#    dplyr::slice_sample(n = 12) %>%
#    dplyr::pull(path)

#dly_files %>%
#    purrr::map_dfr(
#        ., ~read_fwf(archive_read("data/ghcnd_all.tar.gz", .x),
#                fwf_widths(widths, headers),
#                na = c("NA", "-9999"),
#                col_types = cols(.default = col_character()),
#                col_select = c(ID, YEAR, MONTH, ELEMENT, starts_with("VALUE"))
#                )
#    )

#end <- Sys.time()
#end - start

#dly_files <-list.files("data/ghcnd_all", full.names = TRUE)

process_xfiles <- function(x) {

  print(x)
  readr::read_fwf(x,
                readr::fwf_widths(widths, headers),
                na = c("NA", "-9999"),
                col_types = cols(.default = readr::col_character()),
                col_select = c(ID, YEAR, MONTH, ELEMENT, starts_with("VALUE"))
                ) |>
  dplyr::rename_all(tolower) |>
# dplyr::filter(element == "PRCP") |>
# dplyr::select(-element) |>
  tidyr::pivot_longer(cols = starts_with("value"), names_to = "day",
                    values_to = "prcp") |>
  # tidyr::drop_na() |>
  # dplyr::filter(prcp != 0) |>
  dplyr::mutate(day = stringr::str_replace(day, "value", ""),
              date = lubridate::ymd(glue("{year}-{month}-{day}"), quiet = TRUE),
              prcp = tidyr::replace_na(prcp, "0"),
              prcp = as.numeric(prcp) / 100) |> # prcp now in cm
  tidyr::drop_na(date) |>
  dplyr::select(id, date, prcp) |>
  dplyr::mutate(julian_day = lubridate::yday(date),
                diff = tday_julian - julian_day,
                is_in_window = dplyr::case_when(
                  diff < window & diff > 0 ~ TRUE,
                  diff > window ~ FALSE,
                  tday_julian < window & diff + 365 < window ~ TRUE,
                  diff < 0 ~ FALSE
                ),
                year = lubridate::year(date),
                year = if_else(diff < 0 & is_in_window, year + 1, year)) |>
  dplyr::filter(is_in_window) |>
  dplyr::group_by(id, year) |>
  dplyr::summarise(prcp = sum(prcp), .groups = "drop")
}

x_files <- list.files("data/temp", full.names = TRUE)

purrr::map_dfr(x_files, process_xfiles) |>
  dplyr::group_by(id, year) |>
  dplyr::summarise(prcp = sum(prcp), .groups = "drop") |>
  readr::write_tsv("data/ghcnd_tidy.tsv.gz")
