#' Create the template of a report for a Survey.
#'
#' @param survey_id
#' @param project_id
#'
#' @import glue
#' @import sf
#' @import dplyr
#' @import ggplot2
#' @import bcmaps
#'
#' @return
#' @export
#'
#' @examples
create_report_template <- function(
    survey_id,
    project_id,
    abstract_text = 'abstract',
    prepared_for_text = 'sample',
    background_text = 'background'
    ) {
  resp <- prep_survey_details(survey_id, project_id)

  title <- resp$surveyData$survey_details$survey_name
  authors <- lapply(resp$surveyData$participants, function(x) x$display_name)
  start_date <- resp$surveyData$survey_details$start_date
  end_date <- resp$surveyData$survey_details$end_date
  species <- lapply(resp$surveyData$species$focal_species_names, function(x) x)
  study_area_description <- resp$surveyData$locations[[1]]$description
  objectives <- resp$surveyData$purpose_and_methodology$additional_details

  study_area_geometry <- create_polygon(resp$surveyData$locations[[1]]$geojson[[1]]$geometry$coordinates[[1]])

  #
  timestamp <- 1 # gsub(':', '-', Sys.time())

  file <- system.file("rmarkdown", "templates", "report", "skeleton", "skeleton.Rmd", package = "simsbc")

  # rmarkdown::render(file, output_file = glue("report_template_{timestamp}"))
  rmarkdown::render(file, output_file = paste0("report_template_", timestamp),
                    output_dir = getwd())
  # rmarkdown::draft(file = 'report_template', template = 'rmarkdown/templates', package = 'simsbc')
}

#' @keywords internal
create_polygon <- function(vertices) {

  coords <- list()
  for (c in 1:length(vertices)) {
    coords[[c]] <- c(vertices[[c]][[1]], vertices[[c]][[2]])
    names(coords[[c]]) <- c('lon', 'lat')
  }
  df <- do.call(rbind.data.frame, coords)
  names(df) <- c('lon', 'lat')

  df |>
    mutate(group = 1) |>
    st_as_sf(coords = c("lon", "lat"),
             crs = 4326) |>
    group_by(group) |>
    summarise(geometry = st_combine(geometry)) |>
    st_cast("POLYGON")
}
