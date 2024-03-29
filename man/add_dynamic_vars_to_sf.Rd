% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fn_add.R
\name{add_dynamic_vars_to_sf}
\alias{add_dynamic_vars_to_sf}
\title{Add dynamic variables to simple features object}
\usage{
add_dynamic_vars_to_sf(
  dynamic_vars_sf,
  crs_nbr_dbl,
  data_year_1L_chr,
  dynamic_var_nm_1L_chr,
  dynamic_var_rsl_1L_chr,
  featured_var_pfx_1L_chr,
  profiled_sf,
  reference_vals_chr
)
}
\arguments{
\item{dynamic_vars_sf}{Dynamic variables (a simple features object)}

\item{crs_nbr_dbl}{Coordinates reference system number (a double vector)}

\item{data_year_1L_chr}{Data year (a character vector of length one)}

\item{dynamic_var_nm_1L_chr}{Dynamic variable name (a character vector of length one)}

\item{dynamic_var_rsl_1L_chr}{Dynamic variable resolution (a character vector of length one)}

\item{featured_var_pfx_1L_chr}{Featured variable prefix (a character vector of length one)}

\item{profiled_sf}{Profiled (a simple features object)}

\item{reference_vals_chr}{Reference values (a character vector)}
}
\value{
Profiled (a simple features object)
}
\description{
add_dynamic_vars_to_sf() is an Add function that updates an object by adding new values to new or empty fields. Specifically, this function implements an algorithm to add dynamic variables to simple features object. The function returns Profiled (a simple features object).
}
\keyword{internal}
