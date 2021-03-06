#' hydrostreamer: A package for downscaling distributed runoff products on to 
#' explicit river segments.
#'
#' hydrostreamer provides functions to downscale distributed runoff 
#' data on to an explicitly represented river network. Downscaling is done by the 
#' spatial relationship between an areal unit of runoff and an overlaid river 
#' network. Value of the runoff unit is divided among intersecting river segments
#' using weighted interpolation. hydrostreamer provides several methods for the 
#' assignment. Simple river routing algorithms are also provided to estimate 
#' discharge at arbitrary segment.
#'
#' @import raster
#' @import hydroGOF
#' @import sf
#' @importFrom dplyr %>%
#' @importFrom utils setTxtProgressBar txtProgressBar hasName write.csv
#' @importFrom quadprog solve.QP
#' @importFrom dplyr bind_rows
#' @importFrom lubridate %m+%
#' @importFrom methods hasArg
#' @importFrom stats complete.cases
#' @useDynLib hydrostreamer, .registration = TRUE
#' @docType package
#' @name hydrostreamer
NULL
