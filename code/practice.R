library(tidyverse)
library(archive, lib.loc = '/usr/lib/R/site-library')

archive::archive_write_files("write_files.tar.gz", 
    c(
        "data/ghcnd_all/ASN00008255.dly",
        "data/ghcnd_all/ASN00017066.dly",
        "data/ghcnd_all/ASN00040510.dly"
        )
)

archive::archive_write_dir("write_dir.tar.gz",
                            "data/ghcnd_all")

archive::archive("data/ghcnd_all.tar.gz")

readr::read_tsv(archive::archive_read("write_dir.tar.gz", "ASN00040510.dly"))
readr::read_tsv(archive::archive_read("write_dir.tar.gz", 1))

archive::archive("write_dir.tar.gz") %>%
    dplyr::pull(path) %>%
    map_dfr(., readr::read_tsv(archive::archive_read("write_dir.tar.gz", .x)))
