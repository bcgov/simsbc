#' Title
#'
#' @param which
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
projects <- function(all = FALSE) {
  UseMethod("projects", all)
}

#' @export
projects.default <- function(all = FALSE) {
  stop(paste0("No projects method for an object of class ", class(all)),
    call. = FALSE
  )
}

#' @export
projects.logical <- function(all = FALSE) {
  if (!(all == TRUE | all == FALSE)) {
    stop(paste("`all` must be TRUE or FALSE, not", all), call. = FALSE)
  }

  get_projects(all)
}

get_projects <- function(all = FALSE) {
  if (all) {
    get_projects_helper(
      get_all_projects_route() ,
      format_all_projects,
      "You do not have access to any Projects")
  } else {
    get_projects_helper(
      get_users_projects_route(pkg.env$simsbc_auth$user$system_user_id),
      format_personal_projects,
      "You do not have any Projects")
  }
}

get_projects_helper <- function(route, lapply_FUN, message){
  resp <- route |>
    sims_request() |>
    resp_body_json() |>
    lapply(lapply_FUN) |>
    bind_rows()

  if (length(resp) == 0) {
    message(message)
  }

  resp
}

#'
#' @keywords internal
format_personal_projects <- function(project) {
  data.frame(
    project_id = project$project_id,
    project_name = project$project_name,
    project_description = NA
    # role = project$project_role_names[[1]]
  )
}

#'
#' @keywords internal
format_all_projects <- function(project) {
  data.frame(
    project_id = project$projectData$id,
    project_name = project$projectData$name,
    project_description = NA,
    start_date = project$projectData$start_date,
    end_date = ifelse(is.null(project$projectData$end_date), NA, project$projectData$end_date)
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
  stop(paste0("No project_details method for an object of class ", class(project_id)),
    call. = FALSE
  )
}

#' @export
project_details.character <- function(project_id, raw = FALSE) {
  stop("`project_id` must be a positive integer, not a character", call. = FALSE)
}

#' @export
project_details.numeric <- function(project_id, raw = FALSE) {
  if (!(raw == TRUE | raw == FALSE)) {
    stop(paste("`raw` must be TRUE or FALSE, not", raw), call. = FALSE)
  }

  check_id(project_id, "project_id")

  res <- get_project_route(project_id) |>
    sims_request() |>
    resp_body_json()

  if (!raw) {
    res <- format_project(res)
  }

  res$surveys <- surveys(project_id) |>
    nrow()

  as.project(res)
}

#'
#' @keywords internal
as.project <- function(x) {
  class(x) <- "project"
  x
}

#'
format_project <- function(x) {
  x
}
