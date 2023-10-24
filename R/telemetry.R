#' Title
#'
#' @param project_id
#'
#' @return
#' @export
#'
#' @examples
telemetry <- function(survey_id, project_id, raw = FALSE) {
  UseMethod("telemetry")
}

#' @export
telemetry.default <- function(survey_id, project_id, raw = FALSE) {
  stop(paste0("No telemetry method for an object of class ", class(project_id)),
       call. = FALSE
  )
}

#' @export
telemetry.numeric <- function(survey_id, project_id, raw = FALSE) {
  check_id(survey_id, "survey_id")
  check_id(project_id, "project_id")

  resp <- get_telemetry_deployments_route(survey_id, project_id) |>
    sims_req_from_json()

  if (length(resp) == 0) {
    message(paste0("There are no Deployments in Survey ", survey_id))
  } else {
    if (!raw) {
      resp <- lapply(resp, format_deployments) |>
        bind_rows()
    }
  }

  resp
}

format_deployments <- function(x) {
  print(x)

  df <- data.frame(
    assignment_id = x$assignment_id,
    critter_id = x$critter_id,
    device_id = x$device_id,
    device_make = x$device_make,
    frequency = x$frequency,
    frequency_unit = ifelse(is.null(x$frequency_unit), NA, x$frequency_unit)
  )

  df
}
