#' Get Projects that the current user belongs to
#'
#' @return A dataframe
#' @importFrom dplyr bind_rows
#' @export
#'
get_my_projects <- function() {
  req <- get_users_projects_route(pkg.env$simsbc_auth$user$system_user_id)
  resp <- sims_request(req_url = req) |> resp_body_json()
  if (length(resp) == 0) {
    message("You do not have any Projects. Create or be invited to one at sims.nrs.gov.bc.ca.")
  } else {
    resp <- lapply(resp, format_personal_project_resp) |> bind_rows()
  }

  resp
}

#' Get All Projects available to the current user
#'
#' @return A dataframe
#' @export
#'
get_all_projects <- function() {
  req <- get_all_projects_route()
  resp <- sims_request(req_url = req) |> resp_body_json()
  if (length(resp) == 0) {
    message("You do not have access to any Projects. Create or be invited to one at sims.nrs.gov.bc.ca.")
  } else {
    resp <- lapply(resp, format_all_project_resp) |> bind_rows()
  }

  resp
}

#' Get details for a specific Project
#'
#' @param project_id Unique ID of a Project for which to get details.
#'
#' @return An object of class Project
#' @export
#'
get_project_details <- function(project_id) {
  check_id(project_id, "project_id")

  req <- get_project_route(project_id)
  resp <- sims_request(req_url = req) |>
    resp_body_json()

  use_project(resp)
}

#'
#' @keywords internal
Project <- setRefClass("Project",
  fields =
    list(
      id = "numeric",
      name = "character",
      role = "character",
      start_date = "Date",
      end_date = "ANY",
      comments = "ANY",
      objectives = "ANY",
      members = "list"
    ),
  methods = list(show = function() {
    cat(
      # paste("Project", id, "with", runif(1), "Surveys"),
      paste("Name: ", name),
      paste("Start date: ", start_date),
      paste("End date: ", end_date),
      sep = "\n"
    )
  })
)

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

#'
#' @keywords internal
use_project <- function(project) {
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
