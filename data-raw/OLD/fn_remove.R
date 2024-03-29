#' Remove grouped popl vars
#' @description remove_grouped_popl_vars() is a Remove function that edits an object, removing a specified element or elements. Specifically, this function implements an algorithm to remove grouped popl vars. Function argument profiled_sf specifies the object to be updated. Argument featured_var_pfx_1L_chr provides the object to be updated. The function is called for its side effects and does not return a value.
#' @param profiled_sf Profiled (a simple features object)
#' @param featured_var_pfx_1L_chr PARAM_DESCRIPTION
#' @return NULL
#' @rdname remove_grouped_popl_vars
#' @export 
#' @importFrom dplyr select
remove_grouped_popl_vars <- function (profiled_sf, featured_var_pfx_1L_chr) 
{
    var_names_vec <- profiled_sf %>% names()
    keep_vars_vec <- var_names_vec[!var_names_vec %>% startsWith("whl_") & 
        !var_names_vec %>% startsWith("grp_by_") & !var_names_vec %>% 
        startsWith("dupl_")]
    keep_vars_vec <- keep_vars_vec[!keep_vars_vec %>% startsWith("inc_") | 
        keep_vars_vec %>% startsWith(featured_var_pfx_1L_chr)]
    dplyr::select(profiled_sf, keep_vars_vec)
}
