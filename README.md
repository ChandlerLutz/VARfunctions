---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



## Installation


```r
library(devtools)
install_github("ChandlerLutz/VARfunctions")
```


```r
library(VARfunctions)
```

## Load the Data

Load the data directly from the package

```r
data(us.macro.data)
#Industrial Production, CPI less food and energy,
#and the Fed funds rate downloaded from the FRED
#(see below for how the data was downloaed)
head(us.macro.data)
#>                INDPRO  CPILFESL UNRATE FEDFUNDS
#> 1957-02-01  0.9745162 0.3502631    3.9     3.00
#> 1957-03-01 -0.1215136 0.3490405    3.7     2.96
#> 1957-04-01 -1.3438454 0.3478264    3.9     3.00
#> 1957-05-01 -0.3699405 0.0000000    4.1     3.00
#> 1957-06-01  0.2466321 0.3466208    4.3     3.00
#> 1957-07-01  0.6141511 0.3454235    4.2     2.99
```

The data is an xts object

```r
is.xts(us.macro.data)
#> [1] TRUE
```

## Local Projection Impulse Response

The `lp_irf()` function returns the local projection impulse response
of Jorda (2005) for forecast horizon `h` and `max.lags` max lags

```r
lp_irf(us.macro.data, h = 1, max.lags = 14)
#>                 INDPRO    CPILFESL       UNRATE    FEDFUNDS
#> INDPRO.1    0.21171391  0.01301449 -0.070674763  0.05570750
#> CPILFESL.1 -0.18674398  0.08414340  0.127010120  0.05930266
#> UNRATE.1   -0.56634206 -0.04103560  0.752356608 -0.59786410
#> FEDFUNDS.1  0.01619017  0.02575645 -0.007780288  1.29636912
```
The functions returns the IRFs for each variable following a reduced
form disturbance in every other variable. Reading the bottom row for
`FEDFUNDS.1`, we can see that a 1 unit (1 percentage point increase)
in the fed funds rate is associated with a 0.016 percent increase in
industrial production, a 0.025 percent increase in the inflation rate,
a -0.0077 percentage point decline in the unemployment rate, and a 1.3
percentage point increase in the fed funds rate the next month.

## Local Projection Impulse Response $h=1,\cdots,12$


```r
LP.irfs.out <- lapply(1:12, function(h) {
    lp_irf(y = us.macro.data, h = h,
           max.lags = 14))
LP.irfs.out <- do.call("rbind", LP.irfs.out)
head(LP.irfs.out)



## How the data was downloaded

The following code shows how to download the package data
#> Error: <text>:3:26: unexpected ')'
#> 2:     lp_irf(y = us.macro.data, h = h,
#> 3:            max.lags = 14))
#>                             ^
```

```r
#Load packages
library(quantmod)
#Time Series that we want to download
#Note: ORDER MATTERS for structural identification
#Industrial Production, CPI less food and energy,
#and the Fed funds rate
ts <- c("INDPRO", "CPILFESL", "UNRATE", "FEDFUNDS")
getSymbols(ts, src="FRED")
#Log first difference of industrial production
INDPRO <- na.omit(diff(log(INDPRO)) * 100)
#Log first difference of CPI
CPILFESL <- na.omit(diff(log(CPILFESL)) * 100)
#Merge all of the time series
us.macro.data <- INDPRO
for (i in 2:length(ts))
    us.macro.data <- na.omit(merge(us.macro.data, get(ts[i])))
us.macro.data <- us.macro.data["/2008-01-01"] ##Up to 2008-01-01
```
