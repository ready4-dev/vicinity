#' data_year
#' @description S4 Generic function to get the value of the slot data_year
#' @rdname data_year-methods
#' @param x An object 
#' 
#' @export

methods::setGeneric("data_year", function(x) standardGeneric("data_year"))
#' data_year
#' @name data_year-VicinityProfile
#' @description Get the value of the slot data_year for S4 objects of class VicinityProfile
#' @param x An object of class VicinityProfile
#' @rdname data_year-methods
#' @aliases data_year,VicinityProfile-method
methods::setMethod("data_year", methods::className("VicinityProfile"), function (x) 
{
    x@data_year
})
#' data_year<-
#' @description S4 Generic function to set the value of the slot data_year
#' @rdname data_year_set-methods
#' @param x An object 
#' @param value Value to be assigned to x
#' 
#' @export

methods::setGeneric("data_year<-", function(x, value) standardGeneric("data_year<-"))
#' data_year<-
#' @name data_year<--VicinityProfile
#' @description Set the value of the slot data_year for S4 objects of class VicinityProfile
#' @param x An object of class VicinityProfile
#' @rdname data_year_set-methods
#' @aliases data_year<-,VicinityProfile-method
methods::setMethod("data_year<-", methods::className("VicinityProfile"), function (x, value) 
{
    x@data_year <- value
    methods::validObject(x)
    x
})
