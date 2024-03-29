#' VicinityMicro
#' @name VicinityMicro
#' @description An S4 class to represent Micro level context
#' @include C4_VicinityMesoArea.R
#' @slot geom_dist_km_cuts numeric
#' @slot travel_time_mins_cuts numeric
#' @slot travel_mode character
#' @slot area_type character
#' @slot area character
#' @slot area_bound_year numeric
#' @slot region_type character
#' @slot region character
#' @slot region_bound_year numeric
#' @slot global_region character
#' @slot country character
#' @slot country_bound_year numeric
#' @slot lookup_tb VicinityLookup
#' @slot crs_nbr numeric
#' @slot temporal_min POSIXt
#' @slot temporal_max POSIXt
VicinityMicro <- methods::setClass("VicinityMicro",
contains = "VicinityMesoArea",
slots = c(geom_dist_km_cuts = "numeric",travel_time_mins_cuts = "numeric",travel_mode = "character",area_type = "character",area = "character",area_bound_year = "numeric",region_type = "character",region = "character",region_bound_year = "numeric",global_region = "character",country = "character",country_bound_year = "numeric",lookup_tb = "VicinityLookup",crs_nbr = "numeric",temporal_min = "POSIXt",temporal_max = "POSIXt"),
prototype =  list(geom_dist_km_cuts = NA_real_,travel_time_mins_cuts = NA_real_,travel_mode = NA_character_))


methods::setValidity(methods::className("VicinityMicro"),
function(object){
msg <- NULL
if (is.null(msg)) TRUE else msg
})
