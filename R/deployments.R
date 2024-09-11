#' Title
#'
#' @param which
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
deployments <- function(projectId, surveyId, raw = FALSE) {
  UseMethod("deployments")
}

#' @export
deployments.default <- function(projectId, surveyId, raw = FALSE) {
  check_id(projectId)
  check_id(surveyId)
  check_raw(raw)
  
  get_deployments_helper(
    get_survey_deployments_route(projectId, surveyId),
    format_FUN = format_deployments,
    "There are no deployments in the Survey",
    raw = raw
  )
}

get_deployments_helper <- function(route, format_FUN, message, raw) {
  resp <- route |>
    sims_req_from_json()
  
  if (length(resp) == 0) message(message)
  
  if (!raw) {
    resp <- resp |>
      lapply(format_FUN) |>
      bind_rows()
  }
  
  resp
}

format_personal_deployments <- function(x) {
  # data.frame(
  #   project_id = x$project_id,
  #   project_name = x$project_name
  # )
  x
}

format_deployments <- function(x) {
  # data.frame(
  #   project_id = x$projectData$id,
  #   project_name = x$projectData$name,
  #   start_date = x$projectData$start_date,
  #   end_date = ifelse(is.null(x$projectData$end_date), NA, x$projectData$end_date)
  # )
  x
}