#' Title
#'
#' @return
#' @export
#'
#' @examples
measurements <- function(critter, survey_id, project_id){
  UseMethod('measurements')
}

#' @export
measurements.default <- function(critter, survey_id, project_id){
  stop(paste0("No survey_details method for an object of class ", class(critter)),
       call. = FALSE
  )
}

#' @export
measurements.animal <- function(critter, survey_id, project_id, raw = FALSE){
  res <- get_survey_critters_route(survey_id, project_id) |>
    sims_request() |>
    resp_body_json() |>
    filter(critter_id == critter)

  if (!raw) {
    res <- format_measurements(res)
  }

  res
}

#' @export
measurements.character <- function(critter, survey_id, project_id){
  # animals(survey_id, project_id) |>
  #   lapply(function(x) x$critter_id = critter))

  as.animal(critter)
}

format_measurements <- function(x){
  x
}
