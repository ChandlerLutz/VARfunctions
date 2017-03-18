## c:/Dropbox/Rpackages/VARfunctions/tests/testthat/testhat_lp_irf_works.R

##    Chandler Lutz
##    Questions/comments: cl.eco@cbs.dk
##    $Revisions:      1.0.0     $Date:  2017-03-18



library(VARfunctions)
data(us.macro.data)
lp_irf(us.macro.data, h = 1, max.lags = 14)
lp_irf(us.macro.data, h = 2, max.lags = 14)
lp_irf(us.macro.data, h = 10, max.lags = 14)
lp_irf(us.macro.data, h = 20, max.lags = 14)
