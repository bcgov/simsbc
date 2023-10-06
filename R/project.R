#' Title
#'
#' @param which
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
projects <- function(all = FALSE, raw = FALSE) {
  UseMethod("projects", all)
}

#' @export
projects.default <- function(all = FALSE, raw = FALSE) {
  stop(paste("`all` must be TRUE or FALSE, not", all), call. = FALSE)
}

#' @export
projects.logical <- function(all = FALSE, raw = FALSE) {
  check_raw(raw)

  if (all) {
    get_projects_helper(
      get_all_projects_route(),
      format_FUN = format_all_projects,
      "You do not have access to any Projects",
      raw = raw
    )
  } else {
    get_projects_helper(
      get_users_projects_route(),
      format_FUN = format_personal_projects,
      "You do not have any Projects",
      raw = raw
    )
  }
}

get_projects_helper <- function(route, format_FUN, message, raw) {
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

format_personal_projects <- function(x) {
  data.frame(
    project_id = x$project_id,
    project_name = x$project_name
  )
}

format_all_projects <- function(x) {
  data.frame(
    project_id = x$projectData$id,
    project_name = x$projectData$name,
    start_date = x$projectData$start_date,
    end_date = ifelse(is.null(x$projectData$end_date), NA, x$projectData$end_date)
  )
}


#### ----

#' Title
#'
#' @param project_id
#'
#' @return
#' @export
#'
#' @examples
project_details <- function(project_id, raw = FALSE) {
  UseMethod("project_details")
}

#' @export
project_details.default <- function(project_id, raw = FALSE) {
  stop(paste("`project_id` must be a positive integer, not of class", class(project_id)),
    call. = FALSE
  )
}

#' @export
project_details.numeric <- function(project_id, raw = FALSE) {
  check_id(project_id, "project_id")
  check_raw(raw)

  res <- get_project_route(project_id) |>
    sims_req_from_json()

  if (!raw) {
    res <- format_project(res)
  }

  as.project(res)
}

as.project <- function(x) {
  class(x) <- "project"
  x
}

format_project <- function(x) {
  x
}
