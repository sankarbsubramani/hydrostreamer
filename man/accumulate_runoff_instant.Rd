% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/accumulate_runoff_instant.R
\name{accumulate_runoff_instant}
\alias{accumulate_runoff_instant}
\title{Apply instantaneous river routing}
\usage{
accumulate_runoff_instant(HS, verbose = FALSE)
}
\arguments{
\item{HS}{A 'HS' object obtained by \code{\link{downscale_runoff}}}

\item{verbose}{Whether or not to print progress information. Defaults to 
\code{FALSE}.}
}
\value{
Returns the input object \code{HS}) with an added list column
  \code{discharge_ts} containing routed discharge estimates for each river
   segment.
}
\description{
Applies the simplest possible river routing scheme, instantaenous flow, by 
adding runoff from each river segment to all of the segments downstream, for 
each timestep.
}
