# drought_index
A project to practice reproducible practices.
* Organize & Dependencies
* Bash for automated data acquisition
* Snakemake
* R

Original Project from Riffomas.

* https://www.youtube.com/watch?v=olu821RTQA8 (246)
* https://www.youtube.com/watch?v=Ft8ayhfgaqo (247)
* https://www.youtube.com/watch?v=r9PWnEmz_tc (248)
* https://www.youtube.com/watch?v=nNKwcIfcwgo&list=PLmNrK_nkqBpJTSHf3IsN_K_pjFu58z9Oq&index=34 (249)
* https://www.youtube.com/watch?v=LKprlFCLnSA&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=5 (250)
* https://www.youtube.com/watch?v=xuxMxhW0fHU&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=7 (251)
* https://www.youtube.com/watch?v=NSy-WByR8Qo&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=6 (252)
* https://www.youtube.com/watch?v=gy2jaP_OK_c&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=8 (253)
* https://www.youtube.com/watch?v=3rVvgfcpM-k&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=9 (254)
* https://www.youtube.com/watch?v=eNpt6hz-UGo&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=10 (255)
* https://www.youtube.com/watch?v=J6JIKk2MGs4&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=11 (257)
* https://www.youtube.com/watch?v=FnJKF3QfqwY&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=12 (258)
* https://www.youtube.com/watch?v=ozta7H7WK58&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=13 (259)
* https://www.youtube.com/watch?v=t1MGEVeTgQM&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=14 (260)
* https://www.youtube.com/watch?v=tYGBT1T2JvU&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=15 (261)
* https://www.youtube.com/watch?v=BLCzG5k35xw&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=16 (262)
* https://www.youtube.com/watch?v=ddJtPQ9FECQ&list=PLmNrK_nkqBpK6iqwN3QeQyXqI6DrcGgIm&index=17 (263)

## data description
https://www.ncei.noaa.gov/pub/data/ghcn/daily/readme.txt


## uses CONDA env
* Creates an env for this project
* environment.yml
* mamba env create -f environment.yml
* conda activate drought

### snakemake dags
snakemake --dag targets | dot -Tpng > dag.png
### force snakemake
snakemake -R <rules>