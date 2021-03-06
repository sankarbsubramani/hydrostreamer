% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/accumulate_runoff_muskingum.R
\name{accumulate_runoff_muskingum}
\alias{accumulate_runoff_muskingum}
\title{Apply Muskingum river routing}
\usage{
accumulate_runoff_muskingum(HS, velocity = 1, x, verbose = FALSE)
}
\arguments{
\item{HS}{A \code{HS} object.}

\item{velocity}{Flow velocity applied to compute parameter x. Can be a 
constant, or a vector of flow velocity at each unique river segments.
Flow velocity defaults at 1.}

\item{x}{Value for parameter x.}

\item{verbose}{Whether or not to print progress information. Defaults to 
\code{FALSE}.}
}
\value{
Returns the input object \code{HS}) with an added list column
  \code{discharge_ts} containing routed discharge estimates for each river
   segment.
}
\description{
The function implements Muskingum routing scheme where the storage parameter
\emph{k} is computed using user input flow velocity, and the length of a 
river segment. Using Muskingum for runoff data with time interval day may 
cause instability in the output. If the interval is too high, it is advised 
to use another routing algorithm.
}
\details{
Warning: The function is experimental and has not been thoroughly tested yet.
}
