#' Create the template of a report for a Survey.
#'
#' @param survey_id
#' @param project_id
#'
#' @import glue
#'
#' @return
#' @export
#'
#' @examples
create_report_template <- function(survey_id, project_id, prepared_for) {
  resp <- prep_survey_details(survey_id, project_id)

  title <- resp$surveyData$survey_details$survey_name
  authors <- resp$surveyData$participants[[2]]$display_name
  start_date <- resp$surveyData$survey_details$start_date
  end_date <- resp$surveyData$survey_details$end_date

  species <- resp$surveyData$species$focal_species_names[[1]]
#
#   study_area_description <- resp$surveyData$location$survey_area_name
#   prepared_for <- 'Ministry of Forests'
#
#   background <- 'Custom background text'
#
#   study_area_geometry <- create_polygon(resp$surveyData$locations[[1]]$geojson[[1]]$geometry$coordinates[[1]])
#
#   timestamp <- 1 # gsub(':', '-', Sys.time())

  file <- system.file("rmarkdown", "templates", "report", "skeleton", "skeleton.Rmd", package = "simsbc")

  rmarkdown::render(file, output_file = glue("report_template_{timestamp}"))
  # rmarkdown::draft(file = 'report_template', template = 'rmarkdown/templates', package = 'simsbc')
}

#' #'
#' #' @keywords internal
#' create_polygon <- function(vertices) {
#'   coords <- list()
#'   for (c in 1:length(vertices)) {
#'     print(vertices)
#'     coords[[c]] <- c(vertices[[c]][[1]], vertices[[c]][[2]])
#'   }
#'   coords
#' }
