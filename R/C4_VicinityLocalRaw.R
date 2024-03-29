#' VicinityLocalRaw
#' 
#' Object defining data to be saved in local directory in a raw (unprocessed) format.
#' 
#' @include C4_VicinityLookup.R
#' @slot a_VicinityLookup  (an instance of the VicinityLookup class)
#' @slot write_type_1L_chr Write type (a character vector of length one)
#' @slot merge_itms_chr Merge items (a character vector)
#' @slot raw_fls_dir_1L_chr Raw files directory (a character vector of length one)
#' @slot pkg_1L_chr Package (a character vector of length one)
#' @slot overwrite_1L_lgl Overwrite (a logical vector of length one)
#' @slot write_1L_lgl Write (a logical vector of length one)
#' @slot dissemination_1L_chr Dissemination (a character vector of length one)
#' @import ready4use
#' @name VicinityLocalRaw-class
#' @rdname VicinityLocalRaw-class
#' @export VicinityLocalRaw
#' @exportClass VicinityLocalRaw
VicinityLocalRaw <- methods::setClass("VicinityLocalRaw",
contains = "Ready4useRaw",
slots = c(a_VicinityLookup = "VicinityLookup",write_type_1L_chr = "character",merge_itms_chr = "character",raw_fls_dir_1L_chr = "character",pkg_1L_chr = "character",overwrite_1L_lgl = "logical",write_1L_lgl = "logical",dissemination_1L_chr = "character"),
prototype =  list(a_VicinityLookup = VicinityLookup()))


methods::setValidity(methods::className("VicinityLocalRaw"),
function(object){
msg <- NULL
if (is.null(msg)) TRUE else msg
})
