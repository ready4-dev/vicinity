#' sp_abbreviations_lup
#' @description S4 Generic function to get the value of the slot sp_abbreviations_lup
#' @rdname sp_abbreviations_lup-methods
#' @param x An object 
#' 
#' @export

methods::setGeneric("sp_abbreviations_lup", function(x) standardGeneric("sp_abbreviations_lup"))
#' sp_abbreviations_lup
#' @name sp_abbreviations_lup-VicinityLookup
#' @description Get the value of the slot sp_abbreviations_lup for S4 objects of class VicinityLookup
#' @param x An object of class VicinityLookup
#' @rdname sp_abbreviations_lup-methods
#' @aliases sp_abbreviations_lup,VicinityLookup-method
methods::setMethod("sp_abbreviations_lup", methods::className("VicinityLookup"), function (x) 
{
    x@sp_abbreviations_lup
})
#' sp_abbreviations_lup<-
#' @description S4 Generic function to set the value of the slot sp_abbreviations_lup
#' @rdname sp_abbreviations_lup_set-methods
#' @param x An object 
#' @param value Value to be assigned to x
#' 
#' @export

methods::setGeneric("sp_abbreviations_lup<-", function(x, value) standardGeneric("sp_abbreviations_lup<-"))
#' sp_abbreviations_lup<-
#' @name sp_abbreviations_lup<--VicinityLookup
#' @description Set the value of the slot sp_abbreviations_lup for S4 objects of class VicinityLookup
#' @param x An object of class VicinityLookup
#' @rdname sp_abbreviations_lup_set-methods
#' @aliases sp_abbreviations_lup<-,VicinityLookup-method
methods::setMethod("sp_abbreviations_lup<-", methods::className("VicinityLookup"), function (x, value) 
{
    x@sp_abbreviations_lup <- value
    methods::validObject(x)
    x
})
