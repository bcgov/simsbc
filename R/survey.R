#' Get Surveys in a specific Project
#'
#' @param project_id The integer ID of a Project from which to get Surveys.
#'
#' @return A dataframe
#' @export
get_surveys <- function(project_id) {
  check_id(project_id, "project_id")

  req <- get_all_surveys_route(project_id)
  resp <- sims_request(req_url = req) |>
    resp_body_json()

  if (length(resp) == 0) {
    message(paste0("You do not have any Surveys in Project ", project_id, "."))
  } else {
    resp <- lapply(resp, format_survey_resp) |> bind_rows()
  }

  resp
}

#' Get details for a specific Survey
#'
#' @param survey_id The integer ID of a Survey for which to get details.
#' @param project_id The integer ID of a Project from which to get Surveys.
#'
#' @return An object of class Survey
#' @export
get_survey_details <- function(survey_id, project_id) {

  resp <- prep_survey_details(survey_id, project_id)

  use_survey(resp)
}

#' Get details for a specific Survey
#'
#' @param survey_id The integer ID of a Survey for which to get details.
#' @param project_id The integer ID of a Project from which to get Surveys.
#'
#' @return An object of class Survey
#' @export
prep_survey_details <- function(survey_id, project_id) {

  check_id(project_id, "project_id")
  check_id(survey_id, "survey_id")

  req <- get_survey_route(survey_id, project_id)
  resp <- sims_request(req_url = req) |>
    resp_body_json()

  resp
}

#'
#' @keywords internal
Survey <- setRefClass("Survey",
  fields =
    list(
      id = "numeric",
      name = "character",
      start_date = "Date",
      end_date = "Date"
      # comments = "ANY",
      # objectives = "ANY",
      # participants = "list",
      # partnerships = 'list',
      # funding_sources = "list"
    ),
  methods = list(show = function() {
    cat(
      # paste("Survey", survey_id, "with", runif(1), "observations"),
      paste("Name: ", name),
      paste("Start date: ", start_date),
      paste("End date: ", end_date),
      sep = "\n"
    )
  })
)

#'
#' @keywords internal
format_survey_resp <- function(survey) {
  details <- survey$surveyData$survey_details

  df <- data.frame(
    survey_id = details$id,
    project_id = details$project_id,
    survey_name = details$survey_name,
    start_date = details$start_date,
    end_date = details$end_date
  )

  df
}

#'
#' @keywords internal
use_survey <- function(survey) {
  details <- survey$surveyData$survey_details

  surv <- Survey$new(
    id = as.numeric(details$survey_id),
    name = details$survey_name,
    start_date = as.Date(details$start_date),
    end_date = as.Date(details$end_date)
  )

  surv
}
