% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/C3_vicinity_processed.R
\name{vicinity_processed}
\alias{vicinity_processed}
\alias{make_pt_vicinity_processed}
\alias{is_vicinity_processed}
\title{ready4 submodule class for tibble object lookup table of meta-data for spatial data packs (imported and pre-processed data).}
\usage{
vicinity_processed(x = make_pt_vicinity_processed())

make_pt_vicinity_processed(
  name_chr = character(0),
  country_chr = character(0),
  area_type_chr = character(0),
  area_bndy_yr_chr = character(0),
  region_chr = character(0),
  data_type_chr = character(0),
  main_feature_chr = character(0),
  year_chr = character(0),
  year_start_chr = character(0),
  year_end_chr = character(0),
  source_reference_chr = character(0),
  additional_detail_chr = character(0)
)

is_vicinity_processed(x)
}
\arguments{
\item{x}{An object of any type}

\item{name_chr}{Name (a character vector), Default: character(0)}

\item{country_chr}{Country (a character vector), Default: character(0)}

\item{area_type_chr}{Area type (a character vector), Default: character(0)}

\item{area_bndy_yr_chr}{Area boundary year (a character vector), Default: character(0)}

\item{region_chr}{Region (a character vector), Default: character(0)}

\item{data_type_chr}{Data type (a character vector), Default: character(0)}

\item{main_feature_chr}{Main feature (a character vector), Default: character(0)}

\item{year_chr}{Year (a character vector), Default: character(0)}

\item{year_start_chr}{Year start (a character vector), Default: character(0)}

\item{year_end_chr}{Year end (a character vector), Default: character(0)}

\item{source_reference_chr}{Source reference (a character vector), Default: character(0)}

\item{additional_detail_chr}{Additional detail (a character vector), Default: character(0)}
}
\value{
A validated instance of the ready4 submodule class for tibble object lookup table of meta-data for spatial data packs (imported and pre-processed data).

A prototype for ready4 submodule class for tibble object lookup table of meta-data for spatial data packs (imported and pre-processed data).

A logical value, TRUE if a valid instance of the ready4 submodule class for tibble object lookup table of meta-data for spatial data packs (imported and pre-processed data).
}
\description{
Create a new valid instance of the ready4 submodule class for tibble object lookup table of meta-data for spatial data packs (imported and pre-processed data).
}
\details{
ready4 submodule for tibble object lookup table of meta-data for spatial data packs (imported and pre-processed data).
}
