% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mthd_metamorphose.R
\name{metamorphose.vicinity_raw}
\alias{metamorphose.vicinity_raw}
\alias{metamorphose,vicinity_raw-method}
\alias{metamorphose-VicinityLocalProcessed}
\alias{metamorphose,VicinityLocalProcessed-method}
\alias{metamorphose-VicinityLocalRaw}
\alias{metamorphose,VicinityLocalRaw-method}
\title{Metamorphose a ready4 model module to a ready4 model module of a different class}
\usage{
metamorphose.vicinity_raw(
  x,
  y_VicinityLookup = NULL,
  package_1L_chr,
  raw_fls_dir_1L_chr,
  processed_fls_dir_1L_chr = "data",
  lup_r4_name,
  crs_nbr_dbl = NA_real_,
  overwrite_1L_lgl = F
)

\S4method{metamorphose}{vicinity_raw}(
  x,
  y_VicinityLookup = NULL,
  package_1L_chr,
  raw_fls_dir_1L_chr,
  processed_fls_dir_1L_chr = "data",
  lup_r4_name,
  crs_nbr_dbl = NA_real_,
  overwrite_1L_lgl = F
)

\S4method{metamorphose}{VicinityLocalProcessed}(x)

\S4method{metamorphose}{VicinityLocalRaw}(x, imports_chr, raw_fls_dir_1L_chr, write_1L_lgl)
}
\arguments{
\item{x}{An object of class VicinityLocalRaw}

\item{y_VicinityLookup}{PARAM_DESCRIPTION, Default: NULL}

\item{package_1L_chr}{Package (a character vector of length one)}

\item{raw_fls_dir_1L_chr}{Raw files directory (a character vector of length one)}

\item{processed_fls_dir_1L_chr}{Processed files directory (a character vector of length one), Default: 'data'}

\item{lup_r4_name}{PARAM_DESCRIPTION}

\item{crs_nbr_dbl}{Coordinates reference system number (a double vector), Default: NA}

\item{overwrite_1L_lgl}{Overwrite (a logical vector of length one), Default: F}

\item{imports_chr}{Imports (a character vector)}

\item{write_1L_lgl}{Write (a logical vector of length one)}
}
\value{
Z (Look up tables for spatiotemporal data)

Y (Look up tables for spatiotemporal data)

X (Object defining data to be saved in local directory in a processed (R) format.)
}
\description{
metamorphose.vicinity_raw() is a metamorphose method that metamorphoses an instance of a class into an instance of a different (non-child) class. This method is implemented for the ready4 submodule class for tibble object lookup table of metadata about raw (un-processed) spatial data to import. The function is called for its side effects and does not return a value.

metamorphose method applied to VicinityLocalProcessed

metamorphose method applied to VicinityLocalRaw
}
