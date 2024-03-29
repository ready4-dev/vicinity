write_gtr_str_mthds_for_slots(slot_names_chr = c("sp_abbreviations_lup",
                                                 "sp_import_lup",
                                                 "sp_data_pack_lup",
                                                 "sp_resolution_lup",
                                                 "sp_site_coord_lup",
                                                 "sp_starter_sf_lup",
                                                 "sp_uid_lup"),
                              set_only_chr = c(""),
                              parent_cls_nm_1L_chr = "",
                              class_nm_1L_chr = "VicinityLookup",
                              print_gtrs_strs_1L_lgl = TRUE,
                              output_dir_1L_chr = "R",
                              nss_to_ignore_chr = c(NA_character_),
                              req_pkgs_chr = NA_character_)

first_tb <- ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                                        name_stub_chr = "lookup", # rename to sp_lups
                                                        slots_ls = c("sp_abbreviations_lup","sp_import_lup","sp_data_pack_lup","sp_resolution_lup","sp_site_coord_lup","sp_starter_sf_lup","sp_uid_lup") %>% list() %>% list(),
                                                        pt_ls = c("vicinity_abbreviations","vicinity_raw","ready4_sp_data_pack_lup","vicinity_resolutions","vicinity_points","vicinity_templates","vicinity_identifiers") %>% list() %>% list(),
                                                        class_desc_chr = "Look up tables to use throughout ready4 suite",
                                                        parent_class_chr = NA_character_) %>%
  ready4class::ready4_constructor()
##
x <- first_tb
# purrr::pwalk(x %>% dplyr::filter(make_s3_lgl != T),~print(..12))
p_lup <- first_tb %>%
  ready4class::author(dev_pkg_ns_1L_chr = ready4fun::get_dev_pkg_nm(),
                                          name_pfx_1L_chr = name_pfx_1L_chr,
                                          output_dir_1L_chr = "R",
                                          file_exists_cdn_1L_chr = "overwrite",
                                          abbreviations_lup = abbreviations_lup,
                                          init_class_pt_lup = prototype_lup)
write_scripts_to_mk_r4_cls(name_stub_1L_chr = x[[1,2]],
                           name_pfx_1L_chr = name_pfx_1L_chr,
                           output_dir_1L_chr = output_dir_1L_chr,
                           class_desc_1L_chr = x[[1,10]],
                           parent_cls_nm_1L_chr = if(is.na(x[[1,11]])){
                             NULL}else{
                               x[[1,11]]},
                           slots_chr = if(is.list(x[[1,12]][[1]])){
                             x[[1,12]][[1]] %>% purrr::flatten_chr()}else{
                               x[[1,12]][[1]]
                             },
                           type_chr = if(is.list(x[[1,3]][[1]])){
                             x[[1,3]][[1]] %>% purrr::flatten_chr()}else{
                               x[[1,3]][[1]]
                             },
                           meaningful_nms_ls = x[[1,13]],
                           vals_ls = x[[1,6]][[1]],
                           allowed_vals_ls = x[[1,7]][[1]],
                           clss_to_inc_chr = x[[1,14]][[1]],
                           prototype_lup = prototype_lup,
                           nss_to_ignore_chr = nss_to_ignore_chr,
                           req_pkgs_chr = req_pkgs_chr,
                           class_in_cache_cdn_1L_chr = class_in_cache_cdn_1L_chr)
##
s4_classes_to_make_tb <- dplyr::bind_rows(ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                                                       name_stub_chr = "lookup", # rename to sp_lups
                                                                       slots_ls = c("sp_abbreviations_lup","sp_import_lup","sp_data_pack_lup","sp_resolution_lup","sp_site_coord_lup","sp_starter_sf_lup","sp_uid_lup") %>% list() %>% list(),
                                                                       pt_ls = c("vicinity_abbreviations","vicinity_raw","ready4_sp_data_pack_lup","vicinity_resolutions","vicinity_points","vicinity_templates","vicinity_identifiers") %>% list() %>% list(),
                                                                       vals_ls = list(write_type_1L_chr ="raw") %>% list(),
                                                                       allowed_vals_ls = list(write_type_1L_chr = "raw") %>% list(),
                                                                       class_desc_chr = "Look up tables to use throughout ready4 suite",
                                                                       parent_class_chr = NA_character_),
                                          ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                                                                      name_stub_chr = "macro",
                                                                                      class_desc_chr = "Macro level context",
                                                                                      pt_ls = list(c("character","character","numeric","VicinityLookup","numeric","POSIXt","POSIXt")) %>% list(),
                                                                                      slots_ls = list(c("global_region","country","country_bound_year","lookup_tb","crs_nbr","temporal_min", "temporal_max")) %>% list(),
                                                                                      parent_class_chr = NA_character_,
                                                                                      inc_clss_ls = list("VicinityLookup") %>% list())) %>%
  ready4class::ready4_constructor()

## JOIN WITH R3 AND MAKE CLASSES
##
## PICK UP HERE
extras_1_tb <- ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                                           name_stub_chr = "meso_region",
                                                           class_desc_chr = "Meso level context - region",
                                                           pt_ls = list(c("character","character","numeric")) %>% list(),
                                                           slots_ls = list(c("region_type","region","region_bound_year")) %>% list(),
                                                           parent_class_chr = "VicinityMacro") %>%
  ready4class::ready4_constructor()



extras_r4_tb <-dplyr::bind_rows(ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                              name_stub_chr = "meso_area",
                                              class_desc_chr = "Meso level context - area",
                                              pt_ls = list(c("character","character","numeric")),
                                              slots_ls = list(c("area_type","area","area_bound_year")),
                                              parent_class_chr = "VicinityMesoRegion"),
  ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                              name_stub_chr = "micro",
                                              class_desc_chr = "Micro level context",
                                              pt_ls = list(c("numeric","numeric","character")),
                                              slots_ls = list(c("geom_dist_km_cuts","travel_time_mins_cuts", "travel_mode")),
                                              parent_class_chr  = "VicinityMesoArea"),
  ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                              name_stub_chr = "profiled_area",
                                              class_desc_chr = "Information to create a profiled area object",
                                              pt_ls = list(c("character","logical", "numeric", "numeric", "numeric", "character","POSIXt")),
                                              slots_ls = list(c("features","use_coord_lup","geom_dist_limit_km", "drive_time_limit_mins", "nbr_bands", "data_year","data_ymds")),
                                              parent_class_chr = "VicinityMicro"),
  ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                              name_stub_chr = "env",
                                              slots_ls = c("st_data","env_sf","param_vals") %>% list(),
                                              pt_ls = c("list","sf","tbl_df") %>% list(),
                                              class_desc_chr = "Spatiotemporal environment",
                                              parent_class_chr = NA_character_),
  ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                              name_stub_chr = "sp_local",
                                              slots_ls = c("lup_tbs_r4") %>% list(),
                                              pt_ls = c("VicinityLookup") %>% list(),
                                              class_desc_chr = "Object defining data to be saved in local directory.",
                                              parent_class_chr = "Ready4useFiles"),
  ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                              name_stub_chr = "spRaw",
                                              slots_ls = c("lup_tbs_r4") %>% list(),
                                              pt_ls = c("VicinityLookup") %>% list(),
                                              class_desc_chr = "Object defining data to be saved in local directory in a raw (unprocessed) format.",
                                              parent_class_chr = "Ready4useRaw"),
  ready4class::make_pt_ready4_constructor(make_s3_lgl = FALSE,
                                              name_stub_chr = "spProcessed",
                                              slots_ls = c("lup_tbs_r4") %>% list(),
                                              pt_ls = c("VicinityLookup") %>% list(),
                                              class_desc_chr = "Object defining data to be saved in local directory in a processed (R) format.",
                                              parent_class_chr = "Ready4useProcessed"))

