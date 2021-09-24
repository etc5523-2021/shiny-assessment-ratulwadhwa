
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ETC5523: Communicating with Data- Assignment 2

## Ratul Wadhwa + 32055587

This is a template that contains materials to create a shiny gadget
application for assessment 2. You will need the following packages
installed to generate the gadget from this template:

``` r
install.packages(c("shiny", "crosstalk", "plotly", "DT", "tidyverse", "here", "scales", "glue"))
```

## How to run the app

This assessment is an interactive web application using the shiny
framework, I have tired to reproduce two interactive graphics from the
Our World in Data website on the topic of air pollution. The shiny frame
work can be found at [Github
repository](https://github.com/etc5523-2021/shiny-assessment-ratulwadhwa).
The ‘Chart’ panel contains a plot created with plotly which shows Access
to clean fuels for cooking vs. GDP per capita. The ‘Table’ panel
contains an interactive table that give details about Access to clean
fuels and technologies for cooking (% of population).

To run the shiny framework, open the **app.R** present in the
folder(shiny-assessment-ratuwadhwa) and click on Run App(top right on
editor). This will pop a new window where we can explore the interactive
graphics and play around the different features of the plot. The
features include toggling between a linear axis and a log axis on the
chart, hides data points, selects a year on the slider, hovering and
highlighting etc.

## Session Info

Add the session info here.

``` r
sessioninfo::session_info()
#> ─ Session info ───────────────────────────────────────────────────────────────
#>  setting  value                       
#>  version  R version 4.0.5 (2021-03-31)
#>  os       macOS Big Sur 10.16         
#>  system   x86_64, darwin17.0          
#>  ui       X11                         
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  ctype    en_US.UTF-8                 
#>  tz       Asia/Kolkata                
#>  date     2021-09-24                  
#> 
#> ─ Packages ───────────────────────────────────────────────────────────────────
#>  package     * version date       lib source        
#>  cli           3.0.1   2021-07-17 [1] CRAN (R 4.0.2)
#>  digest        0.6.27  2020-10-24 [2] CRAN (R 4.0.2)
#>  evaluate      0.14    2019-05-28 [2] CRAN (R 4.0.1)
#>  htmltools     0.5.1.1 2021-01-22 [2] CRAN (R 4.0.2)
#>  knitr         1.33    2021-04-24 [1] CRAN (R 4.0.2)
#>  magrittr      2.0.1   2020-11-17 [2] CRAN (R 4.0.2)
#>  rlang         0.4.11  2021-04-30 [1] CRAN (R 4.0.2)
#>  rmarkdown     2.10    2021-08-06 [1] CRAN (R 4.0.2)
#>  rstudioapi    0.13    2020-11-12 [2] CRAN (R 4.0.2)
#>  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 4.0.2)
#>  stringi       1.7.3   2021-07-16 [1] CRAN (R 4.0.2)
#>  stringr       1.4.0   2019-02-10 [2] CRAN (R 4.0.2)
#>  withr         2.4.2   2021-04-18 [1] CRAN (R 4.0.2)
#>  xfun          0.21    2021-02-10 [2] CRAN (R 4.0.2)
#>  yaml          2.2.1   2020-02-01 [2] CRAN (R 4.0.2)
#> 
#> [1] /Users/ratulwadhwa/Library/R/4.0/library
#> [2] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
```
