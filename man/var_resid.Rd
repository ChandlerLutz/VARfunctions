% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/var_functions.R
\name{var_resid}
\alias{var_resid}
\title{residuals from a VAR regression}
\usage{
var_resid(yy, xx)
}
\arguments{
\item{yy}{the left-hand-side variables}

\item{xx}{the right hand side variables}
}
\value{
the VAR residuals
}
\description{
\code{yy} and \code{xx} have to have the same dimensions and all
lags must already be created in \code{xx}
}

