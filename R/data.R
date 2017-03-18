## c:/Dropbox/Rpackages/VARfunctions/R/data.R

##    Chandler Lutz
##    Questions/comments: cl.eco@cbs.dk
##    $Revisions:      1.0.0     $Date:  2017-03-18


#' US macro data (xts object)
#'
#' A us macro data dataset as an xts object from 1957-02-01 to
#' 2008-01-01. Data were downloaded from the FRED. The variable names
#' correspond to FRED symbols
#'
#' @format An xts object with monthly US macro data
#' \describe{
#'     \item{INDRPO}{log first difference of industrial production}
#'     \item{CPIFESL}{log first difference of CPI less food and energy}
#'     \item{UNRATE}{the unemployment rate}
#'     \item{FEDFUNDS}{the fed funds rate}
#' }
"us.macro.data"
