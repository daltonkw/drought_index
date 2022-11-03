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

readr::read_fwf("data/ghcnd_cat.gz",
                fwf_widths(widths, headers),
                na = c("NA", "-9999"),
                col_types = cols(.default = col_character()),
                col_select = c(ID, YEAR, MONTH, ELEMENT, starts_with("VALUE"))
                ) |>
dplyr::rename_all(tolower) |>
dplyr::filter(element == "PRCP") |>
dplyr::select(-element) |>
tidyr::pivot_longer(cols = starts_with("value"), names_to = "day",
                    values_to = "prcp") |>
drop_na() |>
dplyr::mutate(day = stringr::str_replace(day, "value", ""),
              date = lubridate::ymd(glue("{year}-{month}-{day}")),
              prcp = as.numeric(prcp)/100) |> # prcp now in cm
dplyr::select(id, date, prcp) |>
readr::write_tsv("data/composite_dly.tsv")

