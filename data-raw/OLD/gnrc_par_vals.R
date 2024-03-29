#' param_vals
#' @description S4 Generic function to get the value of the slot param_vals
#' @rdname param_vals-methods
#' @param x An object 
#' 
#' @export

methods::setGeneric("param_vals", function(x) standardGeneric("param_vals"))
#' param_vals
#' @name param_vals-VicinitySpaceTime
#' @description Get the value of the slot param_vals for S4 objects of class VicinitySpaceTime
#' @param x An object of class VicinitySpaceTime
#' @rdname param_vals-methods
#' @aliases param_vals,VicinitySpaceTime-method
methods::setMethod("param_vals", methods::className("VicinitySpaceTime"), function (x) 
{
    x@param_vals
})
#' param_vals<-
#' @description S4 Generic function to set the value of the slot param_vals
#' @rdname param_vals_set-methods
#' @param x An object 
#' @param value Value to be assigned to x
#' 
#' @export

methods::setGeneric("param_vals<-", function(x, value) standardGeneric("param_vals<-"))
#' param_vals<-
#' @name param_vals<--VicinitySpaceTime
#' @description Set the value of the slot param_vals for S4 objects of class VicinitySpaceTime
#' @param x An object of class VicinitySpaceTime
#' @rdname param_vals_set-methods
#' @aliases param_vals<-,VicinitySpaceTime-method
methods::setMethod("param_vals<-", methods::className("VicinitySpaceTime"), function (x, value) 
{
    x@param_vals <- value
    methods::validObject(x)
    x
})
