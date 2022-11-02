# drought_index
A project to practice reproducible practices.
* Organize & Dependencies
* Bash for automated data acquisition

Original Project from Riffomas.

* https://www.youtube.com/watch?v=olu821RTQA8 (246)
* https://www.youtube.com/watch?v=Ft8ayhfgaqo (247)
* https://www.youtube.com/watch?v=r9PWnEmz_tc (248)
* https://www.youtube.com/watch?v=nNKwcIfcwgo&list=PLmNrK_nkqBpJTSHf3IsN_K_pjFu58z9Oq&index=34 (249)

## data description
https://www.ncei.noaa.gov/pub/data/ghcn/daily/readme.txt


## uses CONDA env
* Creates an env for this project
* environment.yml
* mamba env create -f environment.yml
* conda activate drought

snakemake --dag targets | dot -Tpng > dag.png