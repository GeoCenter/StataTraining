---
layout: post
title: Tools
description: things that make Stata and R better
img: /StataTraining/img/tools.svg
---


### Stats and data quality resources
- [Statistical Test Selector](http://www.ats.ucla.edu/stat/mult_pkg/whatstat/){:target="_blank"}: UCLA's guide to what statistical test should be used, with example code in Stata, R, SPSS, and SAS
- [Bad data and how to fix them](https://github.com/Quartz/bad-data-guide){:target="_blank"}: Encyclopedia of all the things that can and do go wrong with data, and suggestions on how to fix.
- [DataBasic](https://www.databasic.io/en/){:target="_blank"}: Suite of web tools for beginners to work with data



### R resources
- If you're new to R, one of the first things you should do is install [RStudio](https://www.rstudio.com/products/rstudio/){:target="_blank"}.  It'll make your life a whole lot better.
- [Introduction to R functions](http://adv-r.had.co.nz/Vocabulary.html){:target="_blank"}
- [swirl](http://swirlstats.com/){:target="_blank"}: A package to learn R within R.
- [RStudio cheatsheets](https://www.rstudio.com/resources/cheatsheets/){:target="_blank"}
- [R for Matlab users](http://mathesaurus.sourceforge.net/octave-r.html){:target="_blank"}
- [Analysis and Stats in R, Python (numpy), Matlab, and Julia](http://hyperpolyglot.org/numerical-analysis){:target="_blank"}
- [Evaluating regressions in R](http://www.statmethods.net/stats/rdiagnostics.html){:target="_blank"}


### Markdown and Github resources
- [Markdown encyclopedia](http://daringfireball.net/projects/markdown/){:target="_blank"}
- [Git cheatsheet](http://ndpsoftware.com/git-cheatsheet.html){:target="_blank"}
- [Using R with Github](http://r-pkgs.had.co.nz/git.html){:target="_blank"}
- [Building an automatic Github.io page](https://help.github.com/articles/creating-pages-with-the-automatic-generator/){:target="_blank"}
- [Using Jekyll in Github Pages] (https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/){:target="_blank"}

### Useful Stata packages


### Useful R packages
R has a long list of libraries that extend the functionality of base R and make it easier to use. Here's a running list of packages that we find particularly helpful, broken down by category. Core libraries are indicated with an asterisk, and are particularly recommended for all users.

To install any of the packages, use `install.packages("<package name>")`, as in: `install.packages("ggplot2")`. All packages can be found on R's [CRAN](https://cran.r-project.org/){:target="_blank"}

#### A lazy way to install and load all these packages
- Laura is in the process of creating an R library called [llamar](https://github.com/flaneuse/llamar){:target="_blank"} to make it easier to load the most useful libraries at once (and also to create some custom plotting themes and functions). It's under development now, so apologies for any lack of documentation and/or anything that breaks in the future.
- To load the packages listed here, copy this code into R:
`install.packages("devtools")`
`library(devtools)`
`devtools::install_github("flaneuse/llamar")`
`library(llamar)`
`loadPkgs()`
- If you have any comments, feel free to [email us](mailto:flaneuseks@gmail.com){:target="_blank"}

#### Data Wrangling
- *[dplyr](https://github.com/hadley/dplyr): filter, create new variables, summarise, ... Basically, anything you can think to do to a dataset
- *[tidyr](https://github.com/hadley/tidyr): reshape and merge datasets
- [data.table](https://github.com/Rdatatable/data.table): similar to dplyr but good for large datasets; some extra functionality
- [stringr](https://github.com/hadley/stringr): string manipulation
- [lubridate](https://github.com/hadley/lubridate): better way to work with dates
- [zoo](https://cran.r-project.org/web/packages/zoo/index.html): running averages, amongst other things


#### Visualization and Interactive plots
- **[ggplot2](http://ggplot2.org/){:target="_blank"}: Hadley Wickham's incredibly powerful plotting library built off of the [Grammar of Graphics](http://www.amazon.com/The-Grammar-Graphics-Statistics-Computing/dp/0387245448){:target="_blank"}. So useful and well-designed it gets two asterisks.
- [ggplot2 extension packages](http://www.ggplot2-exts.org/){:target="_blank"}: Running list of extensions to ggplot2
- ggrepel
- ggvis:
- htmltools
- htmlwidgets
- d3heatmap
- metricsgraphics
- rCharts
- DiagrammeR
- packcircles
- waffle
- RgoogleMaps
- hexbin
- lattice
- latticeExtra

#### Geospatial analysis and mapping
- ggmap: geocoding and geospatial library
- [leaflet](https://rstudio.github.io/leaflet/): R wrapper to embed dynamic maps using leaflet.js
- [choroplethr](https://github.com/trulia/choroplethr), choroplethrAdmin1: easy way to create choropleths (heatmaps for a map) at the Admin 0- (country) and Admin 1-level (States/Provinces)

#### Interactivity
- shiny
- shinydashboard
- shinythemes

#### Reporting, publication, and custom appearance
- knitr: helper function to produce RMarkdown documents
- kable: basic markdown tables
- [formattable](http://renkun.me/formattable/): better tables for RMarkdown documents
- animation
- gridExtra
- grid
- colorspace
- RColorBrewer
- extrafont


#### Importing files
- haven: imports in files from Stata, SAS, and SPSS
- foreign: an alternative to haven to import from Stata, SAS, and SPSS.
- readr: An advanced form of the base 'read.csv' file with some added functionality.
- readxl: Functions to import in multiple sheets from Excel
- googlesheets: Functions to connect to Google Drive spreadsheets.
- rvest: Scrapes websites
- pdftools: Scrapes pdf files

#### Developer libraries
- *[devtools](https://www.rstudio.com/products/rpackages/devtools/): makes writing and releasing R packages a breeze. For casual users, allows you to install packages directly from Github using `install_github`
- roxygen2
- testthat
- jsonlite 
- microbenchmark
- profvis

#### Fitting libraries
- *[broom](https://github.com/dgrtwo/broom): cleans up results from any fitted model into something neat and organized
- MASS
- sandwich 
- lmtest
- plm
- ggalt
- coefplot
- cluster
- GWmodel

#### Misc.
- [swirl](http://swirlstats.com/){:target="_blank"}: A package to learn R within R.
