#' Make 1 clstr 1 srvc trvl tm
#' @description make_1_clstr_1_srvc_trvl_tm() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make 1 clstr 1 srvc trvl tm. The function returns One service (a simple features object).
#' @param cluster_tb Cluster (a tibble)
#' @param service PARAM_DESCRIPTION
#' @param time_min PARAM_DESCRIPTION
#' @param time_max PARAM_DESCRIPTION
#' @param nbr_time_steps PARAM_DESCRIPTION
#' @return One service (a simple features object)
#' @rdname make_1_clstr_1_srvc_trvl_tm
#' @export 
#' @importFrom dplyr filter select pull
make_1_clstr_1_srvc_trvl_tm <- function (cluster_tb, service, time_min, time_max, nbr_time_steps) 
{
    one_service <- cluster_tb %>% dplyr::filter(service_name == 
        service)
    one_service_sf <- make_isochrs(long = one_service %>% dplyr::select(long) %>% 
        dplyr::pull(), lat = one_service %>% dplyr::select(lat) %>% 
        dplyr::pull(), time_min = time_min, time_max = time_max, 
        nbr_time_steps = nbr_time_steps)
    return(one_service_sf)
}
#' Make agt coords
#' @description make_agt_coords_tb() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make agt coords tibble. The function returns Agent coordinates (a tibble).
#' @param profiled_area_sf Profiled area (a simple features object)
#' @param disorder PARAM_DESCRIPTION
#' @param year PARAM_DESCRIPTION
#' @param case_type PARAM_DESCRIPTION, Default: 'expected.incidence'
#' @param person_type PARAM_DESCRIPTION, Default: 'p'
#' @param resolution_unit PARAM_DESCRIPTION
#' @return Agent coordinates (a tibble)
#' @rdname make_agt_coords_tb
#' @export 
#' @importFrom stringr str_sub
#' @importFrom sf st_set_geometry
#' @importFrom dplyr select pull filter
#' @importFrom rlang sym
#' @importFrom purrr map2_dfr
make_agt_coords_tb <- function (profiled_area_sf, disorder, year, case_type = "expected.incidence", 
    person_type = "p", resolution_unit) 
{
    unit_col_name <- paste0(resolution_unit, "_MAIN", stringr::str_sub(year, 
        3, 4))
    cases_col_name <- paste0("proj_", disorder, "_", person_type, 
        "_", year)
    profiled_area_df <- profiled_area_sf %>% sf::st_set_geometry(NULL) %>% 
        dplyr::select(!!rlang::sym(unit_col_name), !!rlang::sym(cases_col_name))
    agent_coordinates_tb <- purrr::map2_dfr(profiled_area_df %>% 
        dplyr::select(!!unit_col_name) %>% dplyr::pull(), profiled_area_df %>% 
        dplyr::select(!!rlang::sym(cases_col_name)) %>% dplyr::pull(), 
        ~sample_agent_coords(profiled_sf = profiled_area_sf %>% 
            dplyr::filter(!!rlang::sym(unit_col_name) == .x), 
            incident_cases = .y))
    return(agent_coordinates_tb)
}
#' Make attr data
#' @description make_attr_data_xx() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make attr data output object of multiple potential types. The function is called for its side effects and does not return a value.
#' @param lookup_tb_r4 Lookup (a ready4 S4 collection of tibbles)
#' @param lookup_ref PARAM_DESCRIPTION
#' @param starter_sf Starter (a simple features object)
#' @return NULL
#' @rdname make_attr_data_xx
#' @export 
#' @importFrom stats setNames
#' @importFrom ready4fun get_from_lup
#' @importFrom dplyr filter pull
make_attr_data_xx <- function (lookup_tb_r4, lookup_ref, starter_sf) 
{
    data_lookup_tb <- sp_data_pack_lup(lookup_tb_r4)
    attr_data_xx <- get_data(data_lookup_tb, col_chr = "name", 
        value_chr = lookup_ref)
    if (is.data.frame(attr_data_xx)) {
        attr_data_xx <- list(attr_data_xx) %>% stats::setNames(ready4fun::get_from_lup(data_lookup_tb = data_lookup_tb, 
            lookup_reference = lookup_ref, lookup_variable = "name", 
            target_variable = "year", evaluate = FALSE))
    }
    region_short_nm <- ready4fun::get_from_lup(data_lookup_tb = data_lookup_tb, 
        lookup_reference = lookup_ref, lookup_variable = "name", 
        target_variable = "region", evaluate = FALSE)
    region_short_long_vec <- c(region_short_nm, ready4fun::get_from_lup(data_lookup_tb = sp_abbreviations_lup(lookup_tb_r4), 
        lookup_reference = region_short_nm, lookup_variable = "short_name", 
        target_variable = "long_name", evaluate = FALSE))
    area_names_var_str <- ready4fun::get_from_lup(data_lookup_tb = data_lookup_tb, 
        lookup_reference = lookup_ref, lookup_variable = "name", 
        target_variable = "area_type", evaluate = FALSE) %>% 
        ready4fun::get_from_lup(data_lookup_tb = sp_starter_sf_lup(lookup_tb_r4), 
            lookup_reference = ., lookup_variable = "area_type", 
            target_variable = "sf_main_sub_div", evaluate = FALSE)
    area_names_var_str <- area_names_var_str[area_names_var_str %in% 
        names(starter_sf)]
    boundary_year <- ready4fun::get_from_lup(data_lookup_tb = data_lookup_tb, 
        lookup_reference = lookup_ref, lookup_variable = "name", 
        target_variable = "area_bound_yr", evaluate = F)
    area_names_var_str <- sp_uid_lup(lookup_tb_r4) %>% dplyr::filter(var_name %in% 
        area_names_var_str) %>% dplyr::filter(as.numeric(year) == 
        max(as.numeric(year)[as.numeric(year) <= as.numeric(boundary_year)])) %>% 
        dplyr::pull(var_name)
    updateAttrDataXx(lookup_tb_r4, attr_data_xx = attr_data_xx, 
        alt_names_sf = starter_sf, area_names_var_str = area_names_var_str, 
        region_short_long_vec = region_short_long_vec, lookup_ref = lookup_ref)
}
#' Make distance based bands
#' @description make_distance_based_bands() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make distance based bands. The function is called for its side effects and does not return a value.
#' @param distance_km_outer PARAM_DESCRIPTION
#' @param nbr_distance_bands PARAM_DESCRIPTION
#' @param service_cluster_tb Service cluster (a tibble)
#' @param profiled_sf Profiled (a simple features object)
#' @param crs_nbr PARAM_DESCRIPTION
#' @return NA ()
#' @rdname make_distance_based_bands
#' @export 
#' @importFrom dplyr pull filter arrange
#' @importFrom purrr map
#' @importFrom stats setNames
make_distance_based_bands <- function (distance_km_outer, nbr_distance_bands, service_cluster_tb, 
    profiled_sf, crs_nbr) 
{
    distances_vec <- seq(from = distance_km_outer/nbr_distance_bands, 
        to = distance_km_outer, by = distance_km_outer/nbr_distance_bands)
    service_clusters_vec <- service_cluster_tb %>% dplyr::pull(cluster_name) %>% 
        unique()
    service_clusters_tbs_list <- purrr::map(service_clusters_vec, 
        ~service_cluster_tb %>% dplyr::filter(cluster_name == 
            .x)) %>% stats::setNames(service_clusters_vec)
    service_clusters_by_distance_list <- purrr::map(distances_vec, 
        ~make_srvc_clstr_geomc_dist_boundrs(distance_km = .x, 
            clusters_vec = service_clusters_vec, clusters_tbs_list = service_clusters_tbs_list, 
            land_boundary_sf = profiled_sf, crs_nbr = crs_nbr)) %>% 
        stats::setNames(., paste0("km_", distances_vec, "from_service"))
    geometric_distance_by_cluster_circles <- purrr::map(1:length(service_clusters_vec), 
        ~reorder_distance_list_by_cluster(look_up_ref = .x, clusters_by_distance_list = service_clusters_by_distance_list, 
            distances_vec = distances_vec)) %>% stats::setNames(., 
        service_clusters_tbs_list %>% names())
    geometric_distance_by_cluster_bands <- purrr::map(geometric_distance_by_cluster_circles, 
        ~transform_circles_to_bands(geom_distance_circle_sfs_list = .x)) %>% 
        stats::setNames(., service_clusters_tbs_list %>% names())
    geometric_distance_by_cluster_circles_merged_list <- purrr::map(geometric_distance_by_cluster_circles, 
        ~do.call(rbind, .x)) %>% stats::setNames(., service_clusters_tbs_list %>% 
        names()) %>% purrr::map(., ~.x %>% dplyr::arrange(desc(distance_km)))
    geometric_distance_by_cluster_bands_merged_list <- purrr::map(geometric_distance_by_cluster_bands, 
        ~do.call(rbind, .x)) %>% stats::setNames(., service_clusters_tbs_list %>% 
        names()) %>% purrr::map(., ~.x %>% dplyr::arrange(desc(distance_km)) %>% 
        simplify_sf(crs = crs_nbr[1]))
    return(geometric_distance_by_cluster_bands_merged_list)
}
#' Make each uid a poly
#' @description make_each_uid_a_poly_sf() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make each uid a poly simple features object. The function is called for its side effects and does not return a value.
#' @param sf Simple features object (a simple features object)
#' @param uid_chr Uid (a character vector)
#' @return NULL
#' @rdname make_each_uid_a_poly_sf
#' @export 
#' @importFrom dplyr filter pull summarise_all first
#' @importFrom sf st_is_valid st_sf st_set_geometry st_union st_sfc
#' @importFrom rlang sym
#' @importFrom purrr map reduce
make_each_uid_a_poly_sf <- function (sf, uid_chr) 
{
    sf <- sf %>% dplyr::filter(sf::st_is_valid(sf))
    duplicate_chr_vec <- sf %>% dplyr::filter(!!rlang::sym(uid_chr) %>% 
        duplicated()) %>% dplyr::pull(!!rlang::sym(uid_chr)) %>% 
        unique()
    sf_1 <- sf %>% dplyr::filter(!(!!rlang::sym(uid_chr) %in% 
        duplicate_chr_vec))
    sf_2 <- sf %>% dplyr::filter(!!rlang::sym(uid_chr) %in% duplicate_chr_vec)
    purrr::map(duplicate_chr_vec, ~sf::st_sf(sf_2 %>% dplyr::filter(!!rlang::sym(uid_chr) == 
        .x) %>% sf::st_set_geometry(NULL) %>% dplyr::summarise_all(.funs = dplyr::first), 
        geometry = sf_2 %>% dplyr::filter(!!rlang::sym(uid_chr) == 
            .x) %>% sf::st_union() %>% sf::st_sfc())) %>% append(list(sf_1)) %>% 
        purrr::reduce(~rbind(.x, .y))
}
#' Make env param
#' @description make_env_param_tb() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make env param tibble. The function is called for its side effects and does not return a value.
#' @param n_its_int N its (an integer vector)
#' @param env_str_par_tb Env setter parameter (a tibble)
#' @param mape_str_par_tb Mape setter parameter (a tibble)
#' @param jt_dist PARAM_DESCRIPTION
#' @return NULL
#' @rdname make_env_param_tb
#' @export 
#' @importFrom dplyr bind_rows
make_env_param_tb <- function (n_its_int, env_str_par_tb, mape_str_par_tb, jt_dist) 
{
    par_val_mape <- gen_par_vals(x = mape_str_par_tb, n_its_int = n_its_int, 
        jt_dist = jt_dist)
    par_val_env <- gen_par_vals(x = env_str_par_tb, n_its_int = n_its_int)
    dplyr::bind_rows(par_val_env, par_val_mape)
}
#' Make geomc dist boundrs
#' @description make_geomc_dist_boundrs() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make geomc dist boundrs. The function returns Distance from prototypes on land (a simple features object).
#' @param point_locations PARAM_DESCRIPTION
#' @param land_sf Land (a simple features object)
#' @param distance PARAM_DESCRIPTION
#' @param crs_nbr PARAM_DESCRIPTION
#' @return Distance from prototypes on land (a simple features object)
#' @rdname make_geomc_dist_boundrs
#' @export 
#' @importFrom sf st_as_sf st_transform st_buffer st_union st_intersection st_sf
make_geomc_dist_boundrs <- function (point_locations, land_sf, distance, crs_nbr) 
{
    distance_from_pts_sf <- sf::st_as_sf(point_locations, coords = c("long", 
        "lat"), crs = crs_nbr[1]) %>% sf::st_transform(crs_nbr[2])
    distance_from_pts_on_land_sf <- sf::st_buffer(distance_from_pts_sf, 
        dist = distance) %>% sf::st_union() %>% sf::st_intersection(land_sf %>% 
        sf::st_transform(crs_nbr[2])) %>% sf::st_transform(crs_nbr[1]) %>% 
        sf::st_sf()
    return(distance_from_pts_on_land_sf)
}
#' Make isochrs
#' @description make_isochrs() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make isochrs. The function returns Iso (a simple features object).
#' @param long PARAM_DESCRIPTION
#' @param ... Additional arguments
#' @param time_min PARAM_DESCRIPTION
#' @param time_max PARAM_DESCRIPTION
#' @param nbr_time_steps PARAM_DESCRIPTION
#' @return Iso (a simple features object)
#' @rdname make_isochrs
#' @export 
#' @importFrom osrm osrmIsochrone
#' @importFrom sf st_as_sf
#' @importFrom dplyr mutate arrange
make_isochrs <- function (long, lat, time_min, time_max, nbr_time_steps) 
{
    time_step <- (time_max - time_min)/nbr_time_steps
    iso <- osrm::osrmIsochrone(loc = c(long, lat), breaks = seq(from = time_min, 
        to = time_max, by = time_step))
    iso_sf <- sf::st_as_sf(iso) %>% dplyr::mutate(drive_times = paste0(min, 
        " to ", max, " mins")) %>% dplyr::arrange(id)
    return(iso_sf)
}
#' Make nse objects
#' @description make_nse_objs_ls() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make nse objects list. The function is called for its side effects and does not return a value.
#' @param sp_unit PARAM_DESCRIPTION
#' @param concept PARAM_DESCRIPTION
#' @param tot_pop_col PARAM_DESCRIPTION, Default: NULL
#' @param grouping_1 PARAM_DESCRIPTION, Default: NULL
#' @param data_year PARAM_DESCRIPTION
#' @param popl_var_prefix PARAM_DESCRIPTION
#' @return NULL
#' @rdname make_nse_objs_ls
#' @export 

make_nse_objs_ls <- function (sp_unit, concept, tot_pop_col = NULL, grouping_1 = NULL, 
    data_year, popl_var_prefix) 
{
    if (concept == "age_sex") {
        popl_multiplier <- paste0("inc_", sp_unit, "_prop")
        whl_pop_str_1 <- paste0("whl_", sp_unit, "_", popl_var_prefix, 
            "y", data_year, ".Females.")
        whl_pop_str_2 <- paste0("whl_", sp_unit, "_", popl_var_prefix, 
            "y", data_year, ".Males.")
        inc_str_to_delete <- paste0("whl_", sp_unit, "_")
        grouping_1_age_sex_pop_str <- NA_character_
    }
    if (concept == "tot_pop") {
        popl_multiplier <- "pop_prop_multiplier_tot_pop"
        grouping_1_age_sex_pop_str <- paste0("grp_by_", grouping_1, 
            "_inc_age_sex_")
        whl_pop_str_1 <- paste0(grouping_1_age_sex_pop_str, "y", 
            data_year, ".Females.")
        whl_pop_str_2 <- paste0(grouping_1_age_sex_pop_str, "y", 
            data_year, ".Males.")
        inc_str_to_delete <- grouping_1_age_sex_pop_str
        grouping_1_age_sex_pop_str <- paste0("grp_by_", grouping_1, 
            "_inc_age_sex_")
    }
    list(area_whl_unit = paste0("whl_", sp_unit, "_area"), area_inc_unit = paste0("inc_", 
        sp_unit, "_area"), prop_inc_unit = paste0("inc_", sp_unit, 
        "_prop"), popl_inc_unit = paste0("inc_", sp_unit, "_popl"), 
        popl_whl_unit = paste0("whl_", sp_unit, "_", tot_pop_col), 
        popl_multiplier = popl_multiplier, popl_whl_starts_with_1 = ifelse(is.null(whl_pop_str_1), 
            NA_character_, whl_pop_str_1), popl_whl_starts_with_2 = ifelse(is.null(whl_pop_str_2), 
            NA_character_, whl_pop_str_2), grouping_1_concept_tot = ifelse(is.null(grouping_1), 
            NA_character_, paste0("grp_by_", grouping_1, "_inc_", 
                concept)), grouping_1_age_sex_pop = grouping_1_age_sex_pop_str, 
        inc_str_to_delete = inc_str_to_delete)
}
#' Make profiled area objects
#' @description make_profiled_area_objs() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make profiled area objects. The function is called for its side effects and does not return a value.
#' @param pa_r4 Pa (a ready4 S4)
#' @return NULL
#' @rdname make_profiled_area_objs
#' @export 
#' @importFrom ready4fun get_from_lup
#' @importFrom dplyr filter pull
#' @importFrom rlang sym
#' @importFrom sf st_transform
make_profiled_area_objs <- function (pa_r4) 
{
    group_by_var <- get_group_by_var_from_pai(pa_r4 = pa_r4)
    st_profiled_sf <- get_starter_sf_for_profiled_area(pa_r4 = pa_r4, 
        group_by_var = group_by_var)
    main_sub_div_var <- ifelse(use_coord_lup(pa_r4), pa_r4@lookup_tb@sp_uid_lup %>% 
        ready4fun::get_from_lup(lookup_variable = "spatial_unit", 
            lookup_reference = pa_r4@region_type, target_variable = "var_name", 
            evaluate = F), ready4fun::get_from_lup(data_lookup_tb = pa_r4 %>% 
        lookup_tb() %>% sp_starter_sf_lup() %>% dplyr::filter(country == 
        country(pa_r4)) %>% dplyr::filter(area_bound_yr == area_bound_year(pa_r4)), 
        lookup_variable = "area_type", lookup_reference = area_type(pa_r4), 
        target_variable = "sf_main_sub_div", evaluate = FALSE))
    if (!use_coord_lup(pa_r4)) {
        profiled_sf <- st_profiled_sf
        profiled_area_bands_list <- subset_sf_by_feature(profiled_sf = profiled_sf, 
            group_by_var = group_by_var)
        sub_div_units_vec <- profiled_sf %>% dplyr::pull(!!rlang::sym(main_sub_div_var)) %>% 
            as.character() %>% unique()
    }
    else {
        cluster_tb = lookup_tb(pa_r4) %>% sp_site_coord_lup() %>% 
            dplyr::filter(service_name %in% features(pa_r4))
        if (!is.na(geom_dist_limit_km(pa_r4))) {
            profiled_sf <- make_distance_based_bands(distance_km_outer = geom_dist_limit_km(pa_r4), 
                nbr_distance_bands = nbr_bands(pa_r4), service_cluster_tb = cluster_tb, 
                profiled_sf = st_profiled_sf, crs_nbr = crs_nbr(pa_r4))[[1]]
            profiled_area_bands_list <- subset_sf_by_feature(profiled_sf = profiled_sf, 
                group_by_var = group_by_var)
        }
        if (!is.na(drive_time_limit_mins(pa_r4))) {
            profiled_area_bands_list <- make_servc_clstr_isochrs_ls(cluster_tbs_list = list(cluster_tb), 
                look_up_ref = 1, time_min = 0, time_max = drive_time_limit_mins(pa_r4), 
                nbr_time_steps = nbr_bands(pa_r4))
            names(profiled_area_bands_list) <- paste0("dt_band_", 
                1:length(profiled_area_bands_list))
            profiled_sf <- do.call(rbind, profiled_area_bands_list) %>% 
                sf::st_transform(crs_nbr(pa_r4)[1]) %>% simplify_sf()
        }
        sub_div_units_vec <- intersect_lon_lat_sfs(sf_1 = st_profiled_sf, 
            sf_2 = profiled_sf, crs_nbr_dbl = crs_nbr(pa_r4)) %>% 
            dplyr::pull(!!rlang::sym(main_sub_div_var)) %>% as.vector() %>% 
            unique()
    }
    return(list(sub_div_units_vec = sub_div_units_vec, profiled_sf = profiled_sf, 
        profiled_area_bands_list = profiled_area_bands_list))
}
#' Make raw format directory
#' @description make_raw_format_dir_chr() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make raw format directory character vector. The function is called for its side effects and does not return a value.
#' @param raw_data_dir PARAM_DESCRIPTION
#' @param category PARAM_DESCRIPTION
#' @return NULL
#' @rdname make_raw_format_dir_chr
#' @export 

make_raw_format_dir_chr <- function (raw_data_dir, category) 
{
    paste0(raw_data_dir, "/", category)
}
#' Make servc clstr isochrs
#' @description make_servc_clstr_isochrs_ls() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make servc clstr isochrs list. The function is called for its side effects and does not return a value.
#' @param cluster_tbs_list PARAM_DESCRIPTION
#' @param look_up_ref PARAM_DESCRIPTION
#' @param time_min PARAM_DESCRIPTION, Default: 0
#' @param time_max PARAM_DESCRIPTION, Default: 60
#' @param nbr_time_steps PARAM_DESCRIPTION, Default: 5
#' @return NA ()
#' @rdname make_servc_clstr_isochrs_ls
#' @export 
#' @importFrom purrr pluck map accumulate prepend
#' @importFrom dplyr select pull
#' @importFrom stats setNames
#' @importFrom sf st_union st_difference
make_servc_clstr_isochrs_ls <- function (cluster_tbs_list, look_up_ref, time_min = 0, time_max = 60, 
    nbr_time_steps = 5) 
{
    require(osrm)
    one_cluster_services_vec <- cluster_tbs_list %>% purrr::pluck(look_up_ref) %>% 
        dplyr::select(service_name) %>% dplyr::pull()
    cluster_tb = cluster_tbs_list %>% purrr::pluck(look_up_ref)
    one_cluster_travel_time_sf_list <- purrr::map(one_cluster_services_vec, 
        ~make_isochrs_for_1_srvc(cluster_tb = cluster_tb, service = .x, 
            time_min = time_min, time_max = time_max, nbr_time_steps = nbr_time_steps)) %>% 
        stats::setNames(., one_cluster_services_vec)
    detach("package:osrm", unload = TRUE)
    one_cluster_time_bands_list <- purrr::map(1:length(one_cluster_travel_time_sf_list), 
        ~make_time_band_sf_ls(look_up_ref = .x, one_cluster_travel_time_sf_list = one_cluster_travel_time_sf_list)) %>% 
        stats::setNames(one_cluster_travel_time_sf_list %>% names())
    one_cluster_unioned_time_bands_list <- purrr::map(1:(one_cluster_time_bands_list %>% 
        purrr::pluck(1) %>% length()), ~union_one_travel_time_band_across_sites(time_band_ref = .x, 
        one_cluster_time_bands_list = one_cluster_time_bands_list)) %>% 
        stats::setNames(paste0("tb_", 1:(one_cluster_time_bands_list %>% 
            purrr::pluck(1) %>% length())))
    one_cluster_up_to_xmin_list <- purrr::accumulate(one_cluster_unioned_time_bands_list, 
        ~sf::st_union(.x, .y)) %>% stats::setNames(paste0("tb_", 
        1:(one_cluster_unioned_time_bands_list %>% length())))
    one_cluster_up_to_xmin_list <- purrr::map(1:length(one_cluster_up_to_xmin_list), 
        ~update_sf_boundary_descr(look_up_ref = .x, one_cluster_up_to_xmin_list = one_cluster_up_to_xmin_list)) %>% 
        stats::setNames(paste0("tb_", 1:(one_cluster_up_to_xmin_list %>% 
            length())))
    one_cluster_joint_travel_time_list <- purrr::map(1:(length(one_cluster_unioned_time_bands_list) - 
        1), ~sf::st_difference(one_cluster_unioned_time_bands_list %>% 
        purrr::pluck(.x + 1), one_cluster_up_to_xmin_list %>% 
        purrr::pluck(.x)) %>% dplyr::select(id, min, max, center, 
        drive_times)) %>% stats::setNames(paste0("tb_", 2:(one_cluster_up_to_xmin_list %>% 
        length()))) %>% purrr::prepend(list(tb_1 = one_cluster_unioned_time_bands_list %>% 
        purrr::pluck(1)))
    return(one_cluster_joint_travel_time_list)
}
#' Make sp data list
#' @description make_sp_data_list() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make sp data list. The function is called for its side effects and does not return a value.
#' @param input_ls Input (a list)
#' @param sub_div_units_vec PARAM_DESCRIPTION
#' @return NA ()
#' @rdname make_sp_data_list
#' @export 
#' @importFrom purrr map transpose map_chr map_dbl prepend
#' @importFrom stats setNames
make_sp_data_list <- function (input_ls, sub_div_units_vec) 
{
    lists_to_merge <- purrr::map(sub_div_units_vec, ~get_spatial_data_list(input_ls = input_ls, 
        sub_div_unit = .x, require_year_match = FALSE, excl_diff_bound_yr = TRUE))
    lists_to_merge <- purrr::transpose(lists_to_merge)
    merged_list <- purrr::map(lists_to_merge[2:length(lists_to_merge)], 
        ~do.call(rbind, .x))
    names_ppr <- purrr::map_chr(lists_to_merge[[1]], ~ifelse(length(.x[1]) == 
        0, NA_character_, names(.x[1])))
    ppr_ref <- purrr::map_dbl(lists_to_merge[[1]], ~ifelse(length(.x[1]) == 
        0, NA_real_, .x[1])) %>% stats::setNames(names_ppr)
    sp_data_list <- purrr::prepend(merged_list, list(ppr_ref = ppr_ref))
    return(sp_data_list)
}
#' Make srvc clstr geomc dist boundrs
#' @description make_srvc_clstr_geomc_dist_boundrs() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make srvc clstr geomc dist boundrs. The function is called for its side effects and does not return a value.
#' @param distance_km PARAM_DESCRIPTION
#' @param clusters_vec PARAM_DESCRIPTION
#' @param clusters_tbs_list PARAM_DESCRIPTION
#' @param land_boundary_sf Land boundary (a simple features object)
#' @param crs_nbr PARAM_DESCRIPTION
#' @return NULL
#' @rdname make_srvc_clstr_geomc_dist_boundrs
#' @export 
#' @importFrom purrr map pluck
#' @importFrom stats setNames
make_srvc_clstr_geomc_dist_boundrs <- function (distance_km, clusters_vec, clusters_tbs_list, land_boundary_sf, 
    crs_nbr) 
{
    purrr::map(1:length(clusters_vec), ~make_geomc_dist_boundrs(point_locations = clusters_tbs_list %>% 
        purrr::pluck(.x), land_sf = land_boundary_sf, distance = distance_km * 
        1000, crs_nbr = crs_nbr)) %>% stats::setNames(., clusters_tbs_list %>% 
        names())
}
#' Make time band
#' @description make_time_band_sf_ls() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make time band simple features object list. The function returns Time band (a list of simple features objects).
#' @param look_up_ref PARAM_DESCRIPTION
#' @param one_cluster_travel_time_sf_list PARAM_DESCRIPTION
#' @return Time band (a list of simple features objects)
#' @rdname make_time_band_sf_ls
#' @export 
#' @importFrom purrr pluck map
#' @importFrom dplyr pull filter
#' @importFrom stats setNames
#' @importFrom stringr str_replace_all
make_time_band_sf_ls <- function (look_up_ref, one_cluster_travel_time_sf_list) 
{
    travel_time_bands <- one_cluster_travel_time_sf_list %>% 
        purrr::pluck(look_up_ref) %>% dplyr::pull(drive_times)
    time_band_sf_ls <- purrr::map(travel_time_bands, ~one_cluster_travel_time_sf_list %>% 
        purrr::pluck(look_up_ref) %>% dplyr::filter(drive_times == 
        .x)) %>% stats::setNames(paste0("tb_", stringr::str_replace_all(travel_time_bands, 
        " ", "_")))
    return(time_band_sf_ls)
}
#' Make trvl tm isochrs
#' @description make_trvl_tm_isochrs() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make trvl tm isochrs. The function returns New (a simple features object).
#' @param appID PARAM_DESCRIPTION
#' @param apiKey PARAM_DESCRIPTION
#' @param origin PARAM_DESCRIPTION
#' @param mode_of_transport PARAM_DESCRIPTION, Default: 'driving'
#' @param travel_time_hours PARAM_DESCRIPTION
#' @param ... Additional arguments
#' @return New (a simple features object)
#' @rdname make_trvl_tm_isochrs
#' @export 
#' @importFrom httr POST add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom googleway encode_pl
#' @importFrom dplyr pull
#' @importFrom purrr map reduce
make_trvl_tm_isochrs <- function (appID, apiKey, origin, mode_of_transport = "driving", 
    travel_time_hours, crs) 
{
    location <- origin
    travel_time_secs <- travel_time_hours * 60 * 60
    url <- "http://api.traveltimeapp.com/v4/time-map"
    requestBody <- paste0("{\n                        \"departure_searches\" : [\n                        {\"id\" : \"test\",\n                        \"coords\": {\"lat\":", 
        origin[1], ", \"lng\":", origin[2], " },\n                        \"transportation\" : {\"type\" : \"", 
        mode_of_transport, "\" } ,\n                        \"travel_time\" : ", 
        travel_time_secs, ",\n                        \"departure_time\" : \"2017-05-03T08:00:00z\"\n                        }\n                        ]\n}")
    res <- httr::POST(url = url, httr::add_headers(`Content-Type` = "application/json"), 
        httr::add_headers(Accept = "application/json"), httr::add_headers(`X-Application-Id` = appId), 
        httr::add_headers(`X-Api-Key` = apiKey), body = requestBody, 
        encode = "json")
    res <- jsonlite::fromJSON(as.character(res))
    pl <- lapply(res$results$shapes[[1]]$shell, function(x) {
        googleway::encode_pl(lat = x[["lat"]], lon = x[["lng"]])
    })
    df <- data.frame(polyline = unlist(pl))
    polyline_vec <- df %>% dplyr::pull(polyline)
    list_of_sfs <- purrr::map(polyline_vec, ~transform_tt_polygon_to_sf(tt_polyline = .x, 
        mode_of_transport = mode_of_transport, travel_time_hours = travel_time_hours, 
        crs = crs))
    new_sf <- purrr::reduce(list_of_sfs, rbind)
    return(new_sf)
}
#' Make valid new
#' @description make_valid_new_sf() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make valid new simple features object. The function is called for its side effects and does not return a value.
#' @param sf Simple features object (a simple features object)
#' @return NULL
#' @rdname make_valid_new_sf
#' @export 
#' @importFrom dplyr filter distinct
#' @importFrom sf st_is_valid st_make_valid st_geometry_type st_collection_extract st_cast
make_valid_new_sf <- function (sf) 
{
    valid_sf <- sf %>% dplyr::filter(sf::st_is_valid(.))
    if (nrow(valid_sf) != nrow(sf)) {
        fixed_sf <- sf %>% dplyr::filter(!sf::st_is_valid(.)) %>% 
            sf::st_make_valid()
        valid_sf <- rbind(valid_sf, fixed_sf)
    }
    gc_sf <- valid_sf %>% dplyr::filter(sf::st_geometry_type(.) == 
        "GEOMETRYCOLLECTION")
    if (nrow(gc_sf) > 0) {
        valid_sf <- gc_sf %>% sf::st_collection_extract(type = c("POLYGON")) %>% 
            rbind(valid_sf %>% dplyr::filter(sf::st_geometry_type(.) != 
                "GEOMETRYCOLLECTION"))
    }
    valid_sf %>% dplyr::filter(sf::st_geometry_type(.) %in% c("POLYGON", 
        "MULTIPOLYGON")) %>% sf::st_cast("MULTIPOLYGON") %>% 
        dplyr::distinct(.keep_all = T)
}
#' Make year filter logic vec
#' @description make_year_filter_logic_vec() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make year filter logic vec. The function is called for its side effects and does not return a value.
#' @param data_tb Data (a tibble)
#' @param included_years_vec PARAM_DESCRIPTION
#' @return NULL
#' @rdname make_year_filter_logic_vec
#' @export 
#' @importFrom purrr map2_lgl
make_year_filter_logic_vec <- function (data_tb, included_years_vec) 
{
    purrr::map2_lgl(data_tb$year, data_tb$year_start, ~(.x %in% 
        included_years_vec | .y %in% included_years_vec))
}
#' Make year vec
#' @description make_year_vec() is a Make function that creates a new R object. Specifically, this function implements an algorithm to make year vec. The function is called for its side effects and does not return a value.
#' @param input_ls Input (a list)
#' @return NULL
#' @rdname make_year_vec
#' @export 
#' @importFrom lubridate year
#' @importFrom dplyr filter pull
#' @importFrom stringr str_length
#' @importFrom purrr pluck
make_year_vec <- function (input_ls) 
{
    data_year <- data_year(input_ls$pa_r4)
    lookup_tb_r4 <- input_ls$pa_r4 %>% lookup_tb()
    spatial_lookup_tb <- sp_data_pack_lup(lookup_tb_r4)
    pop_projs_str <- input_ls$pop_projs_str
    model_end_year <- get_model_end_ymdhs(input_ls = input_ls) %>% 
        lubridate::year()
    year_opts <- spatial_lookup_tb %>% dplyr::filter(main_feature == 
        pop_projs_str) %>% dplyr::pull(year_end)
    year_opts <- year_opts[stringr::str_length(year_opts) == 
        4]
    year_opts_ref <- which((year_opts %>% as.numeric() %>% sort()) >= 
        model_end_year) %>% min()
    model_end_year <- year_opts %>% as.numeric() %>% sort() %>% 
        purrr::pluck(year_opts_ref) %>% as.character()
    as.character(as.numeric(data_year):as.numeric(model_end_year))
}