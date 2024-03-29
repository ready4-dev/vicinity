% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fn_update.R
\name{update_isochrone_tbl}
\alias{update_isochrone_tbl}
\title{Update isochrone table}
\usage{
update_isochrone_tbl(index_val_1L_int, temporal_bands_ls, travel_mode_1L_chr)
}
\arguments{
\item{index_val_1L_int}{Index value (an integer vector of length one)}

\item{temporal_bands_ls}{Temporal bands (a list)}

\item{travel_mode_1L_chr}{Travel mode (a character vector of length one)}
}
\value{
Isochrone (a tibble)
}
\description{
update_isochrone_tbl() is an Update function that edits an object, while preserving core object attributes. Specifically, this function implements an algorithm to update isochrone table. The function returns Isochrone (a tibble).
}
\keyword{internal}
