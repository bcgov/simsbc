#' @export
print.survey <- function(x, ...) {
  p <- x$surveyData

  cat(
    paste("Name: ", p$survey_details$survey_name),
    paste("Start date: ", p$survey_details$start_date),
    paste("End date: ", p$survey_details$end_date),
    sep = "\n"
  )
}

#' @export
print.project <- function(x, ...) {
  p <- x$projectData

  cat(
    paste0("Name: ", p$project$name),
    paste0("Objectives: ", p$objectives$objectives),
    paste0("Start date: ", p$project$start_date),
    paste0("End date: ", p$project$end_date),
    paste("Number of surveys: ", x$surveys),
    sep = "\n"
  )
}

#' #' @export
#' print.animal <- function(x, ...) {
#'   cat(
#'     paste0("Critter ID: ", x$critter_id),
#'     paste0("Species: ", x$taxon),
#'     paste0("Wildlife Health ID: ", x$wlh_id),
#'     paste0("Alias: ", x$animal_id),
#'     paste0("Sex: ", x$sex),
#'     sep = "\n"
#'   )
#' }
#'

#'
summary.project <- function(x){

}
