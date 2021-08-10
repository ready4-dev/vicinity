#' Write attr
#' @description write_attr_tb() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write attr tibble. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param attr_tb Attr (a tibble)
#' @param obj_name PARAM_DESCRIPTION
#' @param processed_dir PARAM_DESCRIPTION
#' @param overwrite_lgl Overwrite (a logical vector)
#' @return NULL
#' @rdname write_attr_tb
#' @export 

write_attr_tb <- function (attr_tb, obj_name, processed_dir, overwrite_lgl) 
{
    path_to_attr_tb_chr <- get_r_import_path_chr(r_data_dir_chr = processed_dir, 
        name_chr = obj_name, data_type_chr = "Attribute")
    if (overwrite_lgl | !file.exists(path_to_attr_tb_chr)) 
        saveRDS(attr_tb, file = path_to_attr_tb_chr)
}
#' Write directories for import
#' @description write_dirs_for_imp() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write directories for import. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param directory_paths PARAM_DESCRIPTION
#' @return NULL
#' @rdname write_dirs_for_imp
#' @export 
#' @importFrom purrr walk
write_dirs_for_imp <- function (directory_paths) 
{
    purrr::walk(directory_paths, ~dir.create(.x))
}
#' Write files and make sngl row data
#' @description write_fls_and_mk_sngl_row_data_lup() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write files and make sngl row data lookup table. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param merge_with PARAM_DESCRIPTION
#' @param pckg_name PARAM_DESCRIPTION
#' @param raw_data_dir PARAM_DESCRIPTION
#' @param processed_dir PARAM_DESCRIPTION
#' @param crs_nbr_dbl PARAM_DESCRIPTION, Default: NA
#' @param overwrite_lgl Overwrite (a logical vector), Default: F
#' @return NULL
#' @rdname write_fls_and_mk_sngl_row_data_lup
#' @export 
#' @importFrom ready4use assert_single_row_tb get_import_type_ls
#' @importFrom rlang exec
write_fls_and_mk_sngl_row_data_lup <- function (x, merge_with, pckg_name, raw_data_dir, processed_dir, 
    crs_nbr_dbl = NA_real_, overwrite_lgl = F) 
{
    ready4use::assert_single_row_tb(x)
    lookup_tbs_r4 <- ready4_lookup()
    lookup_tbs_r4 <- `sp_import_lup<-`(lookup_tbs_r4, x)
    import_type_ls <- ready4use::get_import_type_ls(x)
    if (names(import_type_ls) == "script_chr") {
        make_class_fn_chr <- eval(parse(text = import_type_ls))
        script_args_ls <- list(lup_tbs_r4 = lookup_tbs_r4, merge_with_chr_vec = merge_with, 
            proc_data_dir_chr = processed_dir, raw_data_dir_chr = raw_data_dir, 
            pckg_chr = pckg_name, overwrite_lgl = overwrite_lgl, 
            crs_nbr_dbl = crs_nbr_dbl)
        script_data_r4 <- rlang::exec(make_class_fn_chr, !!!script_args_ls)
        import_data(script_data_r4)
    }
    else {
        ready4_sp_local_raw(lup_tbs_r4 = lookup_tbs_r4, merge_with_chr_vec = merge_with, 
            raw_data_dir_chr = raw_data_dir, pckg_chr = pckg_name, 
            overwrite_lgl = overwrite_lgl) %>% write_fls_from_imp_and_upd_r4(processed_dir_chr = processed_dir, 
            crs_nbr_dbl = crs_nbr_dbl)
    }
}
#' Write files for import
#' @description write_fls_for_imp() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write files for import. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param data_lookup_ref PARAM_DESCRIPTION
#' @param lookup_variable PARAM_DESCRIPTION
#' @param directory_path PARAM_DESCRIPTION
#' @param overwrite_lgl Overwrite (a logical vector), Default: F
#' @return NULL
#' @rdname write_fls_for_imp
#' @export 
#' @importFrom purrr map_chr
#' @importFrom ready4fun get_from_lup
#' @importFrom ready4use get_data
#' @importFrom utils download.file unzip
write_fls_for_imp <- function (x, data_lookup_ref, lookup_variable, directory_path, 
    overwrite_lgl = F) 
{
    save_lgl <- F
    download_components_vec <- purrr::map_chr(c("file_name", 
        "file_type", "download_url_chr", "inc_file_main_chr", "local_file_src_chr", 
        "data_repo_db_ui"), ~ready4fun::get_from_lup(data_lookup_tb = x, 
        lookup_reference = data_lookup_ref, lookup_variable = lookup_variable, 
        target_variable = .x, evaluate = FALSE))
    dest_file <- paste0(directory_path, "/", download_components_vec[1], 
        download_components_vec[2])
    if (!is.na(download_components_vec[5])) {
        if (overwrite_lgl | file.exists(dest_file)) 
            file.copy(from = download_components_vec[5], to = dest_file)
    }
    else {
        if (!is.na(paste0(directory_path, "/", download_components_vec[4]))) {
            if (overwrite_lgl | !file.exists(paste0(directory_path, 
                "/", download_components_vec[4]))) {
                if (!is.na(download_components_vec[6])) {
                  ready4use::get_data(x, save_dir_path_chr = directory_path, 
                    unlink_lgl = F)
                }
                else {
                  utils::download.file(download_components_vec[3], 
                    destfile = dest_file, mode = "wb")
                }
                if (download_components_vec[2] == ".zip") {
                  utils::unzip(dest_file, exdir = directory_path)
                }
                write_to_rnm_fls_for_imp(x = x, data_lookup_ref = data_lookup_ref, 
                  lookup_variable = lookup_variable, directory_path = directory_path, 
                  overwrite_lgl = overwrite_lgl)
                save_lgl <- T
            }
        }
    }
    save_lgl
}
#' Write files from import and update
#' @description write_fls_from_imp_and_upd_r4() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write files from import and update ready4 s4. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param processed_dir_chr Processed directory (a character vector)
#' @param crs_nbr_dbl PARAM_DESCRIPTION
#' @return NULL
#' @rdname write_fls_from_imp_and_upd_r4
#' @export 
#' @importFrom ready4use `proc_data_dir_chr<-`
write_fls_from_imp_and_upd_r4 <- function (x, processed_dir_chr, crs_nbr_dbl) 
{
    save_raw(x, return_r4_lgl = T) %>% ready4use::`proc_data_dir_chr<-`(processed_dir_chr) %>% 
        import_data(crs_nbr_dbl = crs_nbr_dbl) %>% update_this()
}
#' Write files from local import
#' @description write_fls_from_local_imp() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write files from local import. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param raw_data_dir_chr Raw data directory (a character vector)
#' @param save_lgl Save (a logical vector)
#' @return NULL
#' @rdname write_fls_from_local_imp
#' @export 
#' @importFrom ready4use `save_lgl<-` `raw_data_dir_chr<-`
write_fls_from_local_imp <- function (x, raw_data_dir_chr, save_lgl) 
{
    x %>% ready4use::`save_lgl<-`(save_lgl) %>% ready4use::`raw_data_dir_chr<-`(raw_data_dir_chr)
}
#' Write files from sp import and update import
#' @description write_fls_from_sp_imp_and_upd_imp_ls() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write files from sp import and update import list. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param crs_nbr_dbl PARAM_DESCRIPTION
#' @param return_r4_lgl Return ready4 S4 (a logical vector), Default: T
#' @return NULL
#' @rdname write_fls_from_sp_imp_and_upd_imp_ls
#' @export 
#' @importFrom ready4use assert_single_row_tb `path_to_starter_sf_chr<-` `import_this_ls<-`
#' @importFrom stats setNames
write_fls_from_sp_imp_and_upd_imp_ls <- function (x, crs_nbr_dbl, return_r4_lgl = T) 
{
    sp_import_lup <- x@lup_tbs_r4@sp_import_lup
    ready4use::assert_single_row_tb(sp_import_lup)
    import_this_ls <- import_data(x = sp_import_lup, included_items_names = x@import_chr_vec, 
        item_data_type = sp_import_lup$data_type, data_directory = x@raw_data_dir_chr, 
        r_data_dir_chr = x@proc_data_dir_chr, save_lgl = x@save_lgl) %>% 
        stats::setNames(x@import_chr_vec)
    if (sp_import_lup$data_type == "Geometry") {
        path_to_starter_sf_chr <- get_r_import_path_chr(r_data_dir_chr = x@proc_data_dir_chr, 
            name_chr = names(import_this_ls)[1], data_type_chr = "Geometry")
    }
    else {
        path_to_starter_sf_chr <- NA_character_
    }
    write_procsd_imp_xx(x = sp_import_lup, import_this_ls = import_this_ls, 
        path_to_starter_sf_chr = path_to_starter_sf_chr, merge_with = x@merge_with_chr_vec, 
        processed_dir = x@proc_data_dir_chr, crs_nbr_dbl = crs_nbr_dbl, 
        overwrite_lgl = x@overwrite_lgl)
    if (return_r4_lgl) 
        ready4use::`path_to_starter_sf_chr<-`(x, path_to_starter_sf_chr) %>% 
            ready4use::`import_this_ls<-`(import_this_ls)
}
#' Write procsd geom import
#' @description write_procsd_geom_imp() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write procsd geom import. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param import_this_ls Import this (a list)
#' @param path_to_starter_sf_chr Path to starter simple features object (a character vector)
#' @param merge_with_chr_vec PARAM_DESCRIPTION
#' @param crs_nbr_dbl PARAM_DESCRIPTION
#' @param overwrite_lgl Overwrite (a logical vector)
#' @return NULL
#' @rdname write_procsd_geom_imp
#' @export 
#' @importFrom ready4use assert_single_row_tb
#' @importFrom purrr reduce
#' @importFrom sf st_geometry_type st_area
#' @importFrom dplyr mutate filter pull
#' @importFrom units set_units
write_procsd_geom_imp <- function (x, import_this_ls, path_to_starter_sf_chr, merge_with_chr_vec, 
    crs_nbr_dbl, overwrite_lgl) 
{
    ready4use::assert_single_row_tb(x)
    if (overwrite_lgl | !file.exists(path_to_starter_sf_chr)) {
        if (is.na(merge_with_chr_vec) %>% all()) {
            starter_sf <- import_this_ls[[1]]
        }
        else {
            starter_sf <- purrr::reduce(merge_with_chr_vec, .init = import_this_ls[[1]], 
                ~intersect_lon_lat_sfs(.x, eval(parse(text = .y)), 
                  crs_nbr_dbl = crs_nbr_dbl, validate_lgl = T))
            if ((sf::st_geometry_type(starter_sf) %>% as.character() != 
                "POINT") %>% any()) {
                starter_sf <- starter_sf %>% dplyr::mutate(area = sf::st_area(.)) %>% 
                  dplyr::filter(area > units::set_units(0, m^2))
            }
        }
        if (x %>% dplyr::pull(main_feature) == "Boundary") 
            starter_sf <- starter_sf %>% simplify_sf(crs = crs_nbr_dbl[1])
        saveRDS(starter_sf, file = path_to_starter_sf_chr)
    }
}
#' Write procsd import
#' @description write_procsd_imp_xx() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write procsd import output object of multiple potential types. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param import_this_ls Import this (a list)
#' @param path_to_starter_sf_chr Path to starter simple features object (a character vector)
#' @param merge_with PARAM_DESCRIPTION
#' @param pckg_name PARAM_DESCRIPTION
#' @param raw_data_dir PARAM_DESCRIPTION
#' @param processed_dir PARAM_DESCRIPTION
#' @param crs_nbr_dbl PARAM_DESCRIPTION, Default: NA
#' @param overwrite_lgl Overwrite (a logical vector), Default: F
#' @return NULL
#' @rdname write_procsd_imp_xx
#' @export 
#' @importFrom dplyr pull
#' @importFrom purrr walk2
write_procsd_imp_xx <- function (x, import_this_ls, path_to_starter_sf_chr, merge_with, 
    pckg_name, raw_data_dir, processed_dir, crs_nbr_dbl = NA_real_, 
    overwrite_lgl = F) 
{
    if (x %>% dplyr::pull(data_type) == "Geometry") {
        write_procsd_geom_imp(x, import_this_ls = import_this_ls, 
            path_to_starter_sf_chr = path_to_starter_sf_chr, 
            merge_with_chr_vec = merge_with, crs_nbr_dbl = crs_nbr_dbl, 
            overwrite_lgl = overwrite_lgl)
    }
    if (x %>% dplyr::pull(data_type) == "Attribute") {
        purrr::walk2(import_this_ls, names(import_this_ls), ~write_attr_tb(attr_tb = .x, 
            obj_name = .y, processed_dir = processed_dir, overwrite_lgl = overwrite_lgl))
    }
}
#' Write raw data from sp local
#' @description write_raw_data_from_sp_local_r4() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write raw data from sp local ready4 s4. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param return_r4_lgl Return ready4 S4 (a logical vector)
#' @return NULL
#' @rdname write_raw_data_from_sp_local_r4
#' @export 
#' @importFrom ready4use assert_single_row_tb
write_raw_data_from_sp_local_r4 <- function (x, return_r4_lgl) 
{
    sp_import_lup <- x@lup_tbs_r4@sp_import_lup
    ready4use::assert_single_row_tb(sp_import_lup)
    raw_format_sp_dir <- write_raw_format_dir(data_type_chr = sp_import_lup$data_type, 
        raw_data_dir = x@raw_data_dir_chr)
    import_chr_vec <- get_import_chr_vec(x@lup_tbs_r4, data_type_chr = sp_import_lup$data_type)
    save_lgl <- save_raw(x = sp_import_lup, required_data = import_chr_vec, 
        destination_directory = raw_format_sp_dir, overwrite_lgl = x@overwrite_lgl)
    if (return_r4_lgl) {
        make_local_proc_r4(x, import_chr_vec = import_chr_vec, 
            raw_data_dir_chr = raw_format_sp_dir, save_lgl = save_lgl)
    }
}
#' Write raw format directory
#' @description write_raw_format_dir() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write raw format directory. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param data_type_chr Data type (a character vector)
#' @param raw_data_dir PARAM_DESCRIPTION
#' @return NULL
#' @rdname write_raw_format_dir
#' @export 

write_raw_format_dir <- function (data_type_chr, raw_data_dir) 
{
    directory_chr <- switch(data_type_chr, Geometry = "Geometries", 
        Attribute = "Attributes")
    raw_format_sp_dir <- make_raw_format_dir_chr(raw_data_dir, 
        directory_chr)
    if (!dir.exists(raw_format_sp_dir)) 
        dir.create(raw_format_sp_dir)
    raw_format_sp_dir
}
#' Write to rnm files for import
#' @description write_to_rnm_fls_for_imp() is a Write function that writes a file to a specified local directory. Specifically, this function implements an algorithm to write to rnm files for import. The function is called for its side effects and does not return a value. WARNING: This function writes R scripts to your local environment. Make sure to only use if you want this behaviour
#' @param x PARAM_DESCRIPTION
#' @param data_lookup_ref PARAM_DESCRIPTION
#' @param lookup_variable PARAM_DESCRIPTION
#' @param directory_path PARAM_DESCRIPTION
#' @param overwrite_lgl Overwrite (a logical vector), Default: F
#' @return NULL
#' @rdname write_to_rnm_fls_for_imp
#' @export 
#' @importFrom ready4fun get_from_lup
#' @importFrom purrr walk2
write_to_rnm_fls_for_imp <- function (x, data_lookup_ref, lookup_variable, directory_path, 
    overwrite_lgl = F) 
{
    old_names_list <- ready4fun::get_from_lup(data_lookup_tb = x, 
        lookup_reference = data_lookup_ref, lookup_variable = lookup_variable, 
        target_variable = "inc_fls_to_rename_ls", evaluate = FALSE)
    new_names_list <- ready4fun::get_from_lup(data_lookup_tb = x, 
        lookup_reference = data_lookup_ref, lookup_variable = lookup_variable, 
        target_variable = "new_nms_for_inc_fls_ls", evaluate = FALSE)
    if (!is.na(old_names_list)) {
        purrr::walk2(old_names_list, new_names_list, ~if (overwrite_lgl | 
            !file.exists(paste0(directory_path, "/", .y))) 
            file.rename(paste0(directory_path, "/", .x), paste0(directory_path, 
                "/", .y)))
    }
}