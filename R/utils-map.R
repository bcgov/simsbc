#' @keywords internal
create_nr_basemap <- function(sa) {
  colors <- RColorBrewer::brewer.pal(9, "Set3")

  LIGHT_GRAY <- "#D1D1D1"

  bc_bounds <- bc_bound(ask = F)
  nr <- nr_regions(ask = F) |>
    st_set_crs(st_crs(bc_bounds)) |>
    st_intersection(bc_bounds)

  nr_int <- nr |>
    filter(st_intersects(geometry, sa, sparse = F))

  gg <- ggplot() +
    geom_sf(
      data = nr,
      fill = LIGHT_GRAY,
      alpha = 0.5
    ) +
    geom_sf(
      data = nr_int,
      aes(fill = REGION_NAME, col = REGION_NAME), alpha = 0.5
    ) +
    geom_sf_text(data = nr_int, aes(label = gsub(" Natural Resource Region", "", REGION_NAME)), alpha = 0.75) +
    scale_fill_manual(values = colors) +
    scale_color_manual(values = colors) +
    theme_void() +
    theme(legend.position = "none")
}

#' @keywords internal
add_wmus <- function(gg, wmus, sa) {
  wmus <- get_wmus()

  if (is.null(wmus)) stop("Failed to fetch Wildlife Management Units from the BC Data Catalogue.")

  wmus_int <- wmus |>
    filter(st_intersects(geometry, sa, sparse = F))

  gg +
    ggnewscale::new_scale_fill() +
    ggnewscale::new_scale_color() +
    geom_sf(
      data = wmus_int,
      aes(col = WILDLIFE_MGMT_UNIT_ID, fill = WILDLIFE_MGMT_UNIT_ID), alpha = 0.5
    ) +
    geom_sf_text(data = wmus_int, aes(label = WILDLIFE_MGMT_UNIT_ID))
}

#' @keywords internal
create_study_area_map <- function(basemap, sa, zoom = F, wmus = T) {
  linewidth <- ifelse(zoom == TRUE, 0.5, 1)

  gg <- basemap +
    geom_sf(
      data = sa,
      col = "red", fill = "red", alpha = 0.2, linewidth = linewidth
    )

  if (zoom == T) {
    sa_bbox <- sa |>
      st_bbox()

    gg <- gg +
      coord_sf(
        xlim = c(sa_bbox[1], sa_bbox[3]),
        ylim = c(sa_bbox[2], sa_bbox[4])
      )
  }

  if (wmus == T) {
    wmus <- get_wmus()
    gg <- add_wmus(gg, wmus, sa)
  }

  gg
}

#' @keywords internal
get_wmus <- function() {
  try(
    options(bcdata.max_geom_pred_size = 1E6)
  )

  try_n(bcdc_query_geodata("028d4791-1241-437a-9f7b-fdf08b0d6dfb") |>
    collect())
}

#' @keywords internal
try_n <- function(code, n = 3) {
  attempts <- 0
  success <- FALSE
  while (attempts < n | success == FALSE) {
    result <- try(code)
    success <- ifelse(inherits(result, "try-error"), FALSE, TRUE)
    attempts <- attempts + 1
  }

  if (inherits(result, "try-error")) {
    return(NULL)
  }

  result
}

#' @keywords internal
get_crs <- function(crs = 3005) {
  st_crs(crs)
}
