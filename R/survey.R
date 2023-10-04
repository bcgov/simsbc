#' Title
#'
#' @param project_id
#'
#' @return
#' @export
#'
#' @examples
surveys <- function(project_id){
  useMethod("survey")
}

surveys.default <- function(project_id){
  stop("No surveys method for an object of class ", class(project_id),
       call. = FALSE)
}

surveys.numeric <- function(project_id){

  resp <- get_all_surveys_route(project_id) |>
    sims_request() |>
    resp_body_json()

  if (length(resp) == 0) {
    message(paste0("You do not have any Surveys in Project ", project_id))
  } else {
    resp <- lapply(resp, format_surveys) |>
      bind_rows()
  }

  resp
}

#'
#' @keywords internal
format_surveys <- function(x) {
  details <- x$surveyData$survey_details

  df <- data.frame(
    survey_id = details$id,
    project_id = details$project_id,
    survey_name = details$survey_name,
    start_date = details$start_date,
    end_date = details$end_date
  )

  df
}


#### ---

survey_details <- function(...) {
  useMethod("survey_details")
}

survey_details.default <- function(survey_id, project_id, raw = FALSE){
  stop("No survey_details method for an object of class ", class(survey_id),
       call. = FALSE)
}

survey_details.character <- function(survey_id, project_id, raw = FALSE){
  if (!(raw == TRUE | raw == FALSE)) stop(paste('`Raw` must be TRUE or FALSE, not', raw), call. = FALSE)

  check_id(project_id, "project_id")
  check_id(survey_id, "survey_id")

  res <- get_survey_route(survey_id, project_id) |>
    sims_request() |>
    resp_body_json()

  ifelse(raw == FALSE, as.survey(res), res)
}

#'
#' @keywords internal
as.survey <- function(survey) {
  s <- format_survey(survey)
  class(s) <- "survey"
  s
}
