#' Title
#'
#' @param which
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
telemetry <- function(deployment_ids, raw = FALSE) {
  UseMethod("telemetry", deployment_ids)
}

#' @export
telemetry.default <- function(deployment_ids, raw = FALSE) {
  if(class(deployment_ids) != "list"){
    stop(paste("`deployment_ids` must be provided as a list", deployment_ids), call. = FALSE)}
  
  check_raw(raw)
  
  get_telemetry_helper(
    get_telemetry_route(),
    deployment_ids,
    format_FUN = format_telemetry,
    "You do not have access to any telemetry",
    raw = raw
  )
  
}

get_telemetry_helper <- function(route, deployment_ids, format_FUN, message, raw) {
  resp <- route |>
    sims_req_from_json(method='POST', body=list(deployment_ids))
  
  if (length(resp) == 0) message(message)
  
  if (!raw) {
    resp <- resp |>
      lapply(format_FUN) |>
      bind_rows()
  }
  
  resp
}

format_personal_telemetry <- function(x) {
  # data.frame(
  #   project_id = x$project_id,
  #   project_name = x$project_name
  # )
  x
}

format_telemetry <- function(x) {
  # data.frame(
  #   project_id = x$projectData$id,
  #   project_name = x$projectData$name,
  #   start_date = x$projectData$start_date,
  #   end_date = ifelse(is.null(x$projectData$end_date), NA, x$projectData$end_date)
  # )
  x
}