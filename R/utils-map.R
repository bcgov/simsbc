#' Title
#'
#' @import bcmaps
#' @import ggplot2
#' @return
#' @export
#'
#' @examples
create_nr_basemap <- function(sa) {
  wmus <- get_wmus(sa)

  colors <- RColorBrewer::brewer.pal(9, "Set3")

  LIGHT_GRAY <- "#D1D1D1"

  bc_bounds <- bc_bound(ask = F)
  nr <- nr_regions(ask = F) |>
    st_set_crs(st_crs(bc_bounds)) |>
    st_intersection(bc_bounds)

  nr_int <- nr |>
    filter(st_intersects(geometry, sa, sparse = F))

  ggplot() +
    geom_sf(
      data = nr,
      fill = LIGHT_GRAY,
      alpha = 0.5
    ) +
    geom_sf(
      data = nr_int,
      aes(fill = REGION_NAME, col = REGION_NAME), alpha = 0.5
    ) +
    geom_sf(
      data = wmus,
      aes(
        col = WILDLIFE_MGMT_UNIT_ID,
        fill = WILDLIFE_MGMT_UNIT_ID
      ),
      alpha = 0.5
    ) +
    geom_sf_text(
      data = wmus, aes(label = WILDLIFE_MGMT_UNIT_ID)
    ) +
    geom_sf_text(data = nr_int, aes(label = gsub(" Natural Resource Region", "", REGION_NAME)), alpha = 0.75) +
    scale_fill_manual(values = colors) +
    scale_color_manual(values = colors) +
    theme_void() +
    theme(legend.position = "none")
}

#' Title
#'
#' @param basemap
#' @param sa
#'
#' @return
#' @export
#'
#' @examples
create_study_area_map <- function(basemap, sa, zoom = F) {
  if (zoom == T) {
    sa_bbox <- sa |>
      st_bbox()

    gg <- basemap +

      geom_sf(
        data = sa,
        col = "red", fill = "red", alpha = 0.6, linewidth = 2
      ) +
      coord_sf(
        xlim = c(sa_bbox[1], sa_bbox[3]),
        ylim = c(sa_bbox[2], sa_bbox[4])
      )
  } else {
    gg <- basemap +
      geom_sf(
        data = sa,
        col = "red", fill = "red", alpha = 0.2, linewidth = 5
      )
  }

  gg
}

#' Title
#'
#' @param sa
#'
#' @import bcdata
#' @return
#'
#' @examples
get_wmus <- function(sa) {
  try(
    options(bcdata.max_geom_pred_size = 1E6)
  )

  bcdc_query_geodata("028d4791-1241-437a-9f7b-fdf08b0d6dfb") |>
    filter(BBOX(local(st_bbox(sa)))) |>
    collect()
}

#'
#' @param crs crs to use for map projections
#
#' @keywords internal
get_crs <- function(crs = 3005) {
  st_crs(crs)
}
