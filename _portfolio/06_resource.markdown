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
- [Using Jekyll in Github Pages](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/){:target="_blank"}
- [Selector Gadget to identify CSS objects](http://selectorgadget.com/){:target="_blank"}

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
- [ggrepel](https://github.com/slowkow/ggrepel): extends ggplot2 to avoid overlapping text
- [ggvis](ggvis.rstudio.com): data visualization package that enables interactive graphics
- [d3heatmap](https://github.com/rstudio/d3heatmap): creates D3-based heatmaps in R
- [htmlwidgets](http://www.htmlwidgets.org/): suite of packages that port javascript visualization packages into R
- [metricsgraphics](http://hrbrmstr.github.io/metricsgraphics/): creates interactive plots based on the MetricsGraphics.js / D3 chart library
- [rCharts](http://rcharts.io/): creates interactive plots based on several javascript charting libraries
- [DiagrammeR](http://rich-iannone.github.io/DiagrammeR/): creates graph diagrams using a Markdown-like syntax
- [packcircles](https://github.com/mbedward/packcircles): creates non-overlapping packed circles
- [waffle](https://github.com/hrbrmstr/waffle): creates isotype graphs (a single object repeated N times)
- [hexbin](https://github.com/edzer/hexbin): hexbin data

#### Geospatial analysis and mapping
- [ggmap](https://github.com/dkahle/ggmap): geocoding and geospatial library
- [leaflet](https://rstudio.github.io/leaflet/): R wrapper to embed dynamic maps using leaflet.js
- [choroplethr](https://github.com/trulia/choroplethr), choroplethrAdmin1: easy way to create choropleths (heatmaps for a map) at the Admin 0- (country) and Admin 1-level (states/provinces)
- [RgoogleMaps](https://cran.r-project.org/web/packages/RgoogleMaps/RgoogleMaps.pdf): overlays plots on a Google map

#### Interactivity
- [shiny](http://shiny.rstudio.com/): easy way to create custom, interactive web applications in R
- [shinydashboard](https://rstudio.github.io/shinydashboard/): uses Shiny to create customized dashboards
- [shinythemes](https://rstudio.github.io/shinythemes/): customize appearance of Shiny apps

#### Reporting, publication, and custom appearance
- *[knitr](http://yihui.name/knitr/): helper function to produce RMarkdown documents
- [formattable](http://renkun.me/formattable/): better tables for RMarkdown documents
- [animation](http://yihui.name/animation/): make GIFs in R
- [RColorBrewer](https://cran.r-project.org/web/packages/RColorBrewer/index.html): imports [Cynthia Brewer's excellent color palettes](http://colorbrewer2.org/) as R objects
- [extrafont](https://www.r-project.org/nosvn/pandoc/extrafont.html): allows you to use a font other than Helvetica in plots


#### Importing files
- [haven](https://github.com/hadley/haven): imports in files from Stata, SAS, and SPSS
- [foreign](https://cran.r-project.org/web/packages/foreign/foreign.pdf): an alternative to haven to import from Stata, SAS, and SPSS. Doesn't support Stata 14 (yet?)
- [readr](https://github.com/hadley/readr): an advanced form of the base `read.csv` function with some added functionality.
- [readxl](https://github.com/hadley/readxl): imports in multiple sheets from Excel
- [googlesheets](https://github.com/jennybc/googlesheets): connects to Google Drive spreadsheets.
- [rvest](https://github.com/hadley/rvest): scrapes websites
- [pdftools](https://github.com/ropensci/pdftools): scrapes .pdf files
- [jsonlite](https://cran.r-project.org/web/packages/jsonlite/vignettes/json-aaquickstart.html): converts between JSON objects and R ones

#### Developer libraries
- *[devtools](https://www.rstudio.com/products/rpackages/devtools/): makes writing and releasing R packages a breeze. For casual users, allows you to install packages directly from Github using `install_github`
- [roxygen2](https://github.com/klutometis/roxygen): allows for easy commenting of functions and packages
- [testthat](https://github.com/hadley/testthat): reproducible testing functions for package development 
- [microbenchmark](https://cran.r-project.org/web/packages/microbenchmark/index.html): timing function to profile how long functions take to execute
- [profvis](https://rpubs.com/wch/123888): allows visual profiling of function timing to optimize performance

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
