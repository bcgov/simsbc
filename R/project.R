projects <- function(which, ...) {
  useMethod("projects")
}

projects.default <- function(which, ...) {
  stop("No projects method for an object of class ", class(which),
    call. = FALSE
  )
}

projects.character <- function(which, ...) {
  if (!(which == "personal" | raw == "all")) {
    stop(paste('`which` must be "personal" or "all", not', which), call. = FALSE)
  }

  get_projects(which)
}

get_projects <- function(which){

  if (which == 'personal') {

    resp <- get_users_projects_route(pkg.env$simsbc_auth$user$system_user_id) |>
      sims_request(req_url = req) |>
      resp_body_json() |>
      lapply(format_personal_project_resp) |>
      bind_rows()

    if (length(resp) == 0){message("You do not have any Projects. Create or be invited to one at sims.nrs.gov.bc.ca.")}

  } else if (which == 'all') {

    resp <- get_all_projects_route() |>
      sims_request(req_url = req) |>
      resp_body_json() |>
      lapply(format_all_project_resp) |>
      bind_rows()

    if (length(resp) == 0){message("You do not have access to any Projects. Create or be invited to one at sims.nrs.gov.bc.ca.")}
  }

  resp
}

#'
#' @keywords internal
format_personal_project_resp <- function(project) {
  df <- data.frame(
    project_id = project$project_id,
    project_name = project$project_name,
    project_description = NA,
    role = project$project_role_names[[1]]
  )

  df
}

#'
#' @keywords internal
format_all_project_resp <- function(project) {
  df <- data.frame(
    project_id = project$projectData$id,
    project_name = project$projectData$name,
    project_description = NA,
    start_date = project$projectData$start_date,
    end_date = ifelse(is.null(project$projectData$end_date), NA, project$projectData$end_date)
  )

  df
}


#### ----

project_details <- function(project_id, ...) {
  useMethod("project_details")
}

project_details.default <- function(project_id, ...) {
  stop("No project_details method for an object of class ", class(which),
    call. = FALSE
  )
}

project_details.character <- function(project_id, ...) {
  stop("`project_id` must be a positive integer, not a character", call. = FALSE)
}

project_details.numeric <- function(project_id, ...) {
  if (!(raw == TRUE | raw == FALSE)) {
    stop(paste("`Raw` must be TRUE or FALSE, not", raw), call. = FALSE)
  }

  check_id(project_id, "project_id")

  res <- get_project_route(project_id) |>
    sims_request(req_url = req) |>
    resp_body_json()

  ifelse(raw == FALSE, as.project(res), res)
}


#'
#' @keywords internal
as.project <- function(project) {
  p <- Project$new(
    id = as.numeric(project$projectData$project$project_id),
    name = project$projectData$project$project_name,
    start_date = as.Date(project$projectData$project$start_date),
    end_date = as.Date(project$projectData$project$end_date),
    comments = project$projectData$project$comments,
    objectives = project$projectData$objectives$objectives
  )

  p
}
