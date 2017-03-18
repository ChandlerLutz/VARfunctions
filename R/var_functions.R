## c:/Dropbox/MonetaryPolicy_Housing/VARfunctions/R/var_functions.R

##    Chandler Lutz
##    Questions/comments: cl.eco@cbs.dk
##    $Revisions:      1.0.0     $Date:  2017-03-18

## VAR functions



#' regression coefficients from a VAR regression
#'
#' \code{yy} and \code{xx} have to have the same dimensions and all
#' lags must already be created in \code{xx}
#'
#' @param yy the left-hand-side variables
#' @param xx the right hand side variables
#' @return the VAR betas
#' @export
var_betas <- function(yy, xx) {
    if (nrow(yy) != nrow(xx)) {
        stop("Error: yy and xx need to have the same dimensions")
    }
    return((solve(t(xx) %*% xx) %*% t(xx)) %*% yy)
}

#' residuals from a VAR regression
#'
#' \code{yy} and \code{xx} have to have the same dimensions and all
#' lags must already be created in \code{xx}
#'
#' @param yy the left-hand-side variables
#' @param xx the right hand side variables
#' @return the VAR residuals
#' @export
var_resid <- function(yy, xx) {

    if (nrow(yy) != nrow(xx)) {
        stop("Error: yy and xx need to have the same dimensions")
    }

    return(yy - xx %*% var_betas(yy, xx))
}

#' AIC from a VAR regression
#'
#' \code{yy} and \code{xx} have to have the same dimensions and all
#' lags must already be created in \code{xx}
#'
#' @param yy the left-hand-side variables
#' @param xx the right hand side variables
#' @return The AIC for the VAR
#' @export
var_aic <- function(yy, xx) {
    K <- ncol(yy) #Number of variables
    p <- (ncol(xx) - 1) / K #Assuming that the VAR only has a constant
    resid.mat <- var_resid(yy, xx)
    #The determinant of the residual var-cov matrix
    sigma <- crossprod(resid.mat) * (1/(nrow(resid.mat) - (K*p+1)))
    sigma.det <- det(sigma)
    aic.out <- log(sigma.det) + ((2 / nrow(yy)) * p * (K ^ 2))
    return(aic.out)
}


#' Local Projection VAR impulse responses
#'
#' VAR impulse responses using the local projection method of Jorda
#' (2005). The lags within each horizon will be chosen by the AIC
#'
#' @param y \code{xts} object with the data
#' @param h the impulse response (IRF) horizon
#' @param max.lags the maximum number of lags to be considered in the
#'     VAR
#' @export
lp_irf <- function(y, h, max.lags) {

    if (!is.xts(y))
        stop("Error: y needs to be an xts object")

    K <- ncol(y) ##Number of variables in y

    ##All possible lags of the data
    y.temp <- lag(y, 0:(h + max.lags)) %>% na.omit %>%
        as.matrix(.)
    ##The LHS variables
    yy <- y.temp[, 1:K];
    ##The RHS variables up to max.lags
    xx <- y.temp[, (K * h  + 1):ncol(y.temp)]

    ##Remove y.temp
    rm(y.temp)

    ## - The betas and AIC for no extra lags - ##
    temp.xx <- xx[, 1:K];
    temp.xx <- cbind(rep(1, nrow(temp.xx)), temp.xx)
    best.betas <- var_betas(yy, temp.xx) ##The betas
    best.aic <- var_aic(yy, xx) #The AIC
    ## - Loop and look for a better lag length  (use the AIC) - ##
    for (i in 2:max.lags) {
        temp.xx <- xx[, 1:(i * K)]
        temp.xx <- cbind(rep(1, nrow(temp.xx)), temp.xx)
        temp.betas <- var_betas(yy, temp.xx) ##The Betas
        temp.aic <- var_aic(yy, temp.xx) ##The AIC
        if (temp.aic < best.aic) ##If smaller AIC, update
            best.betas <- temp.betas; best.aic <- temp.aic
    }
    return(best.betas[2:(K + 1), ]) #Return F0 (the IRF for h)
}
