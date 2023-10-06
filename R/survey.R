#' Title
#'
#' @param project_id
#'
#' @return
#' @export
#'
#' @examples
surveys <- function(project_id) {
  UseMethod("surveys")
}

#' @export
surveys.default <- function(project_id) {
  check_id(project_id, "project_id")

  stop(paste0("No surveys method for an object of class ", class(project_id)),
    call. = FALSE
  )
}

#' @export
surveys.numeric <- function(project_id) {
  resp <- get_all_surveys_route(project_id) |>
    sims_req_from_json()

  if (length(resp) == 0) {
    message(paste0("There are no Surveys in Project ", project_id))
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

#' Title
#'
#' @param survey_id
#' @param project_id
#' @param raw
#'
#' @return
#' @export
#'
#' @examples
survey_details <- function(survey_id, project_id, raw = FALSE) {
  UseMethod("survey_details")
}

#' @export
survey_details.default <- function(survey_id, project_id, raw = FALSE) {
  stop(paste0("No survey_details method for an object of class ", class(survey_id)),
    call. = FALSE
  )
}
#'
#' #' @export
#' survey_details.character <- function(survey_id, project_id, raw = FALSE){
#'   stop("`survey_id` must be a positive integer, not a character", call. = FALSE)
#' }

#' @export
survey_details.numeric <- function(survey_id, project_id, raw = FALSE) {
  if (!(raw == TRUE | raw == FALSE)) {
    stop(paste("`raw` must be TRUE or FALSE, not", raw), call. = FALSE)
  }

  check_id(survey_id, "survey_id")
  check_id(project_id, "project_id")

  res <- get_survey_route(survey_id, project_id) |>
    sims_req_from_json()

  if (!raw) {
    res <- format_survey(res)
  }

  as.survey(res)
}

#'
#' @keywords internal
as.survey <- function(x) {
  class(x) <- "survey"
  x
}

#'
#' @keywords internal
format_survey <- function(x) {
  x
}
