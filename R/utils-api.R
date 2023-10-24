#'
sims_req_from_json <- function(route) {
  route |>
    sims_request() |>
    resp_body_json()
}

#'
sims_request <- function(req_url, client = pkg.env$simsbc_auth$client) {
  check_internet()
  check_auth()

  full_route <- paste0(get_sims_api_route(), req_url)

  res <- try(
    {
      request(full_route) |>
        req_oauth_auth_code(client = client, auth_url = get_keycloak_auth_url()) |>
        req_perform()
    },
    silent = T
  )

  # Once SIMS has more granular error handling, update to check for specific error codes, ie. 500, 501, etc.
  if (inherits(res, "try-error")) stop("Sorry, something went wrong! The data you requested might not exist.")

  res
}

### Variables

#'
get_keycloak_client_id <- function() "sims-4461"

#'
get_keycloak_token_url <- function() "https://dev.loginproxy.gov.bc.ca/auth/realms/standard/protocol/openid-connect/token"

#'
get_keycloak_auth_url <- function() "https://dev.loginproxy.gov.bc.ca/auth/realms/standard/protocol/openid-connect/auth"

#'
get_sims_api_route <- function() "https://api-dev-biohubbc.apps.silver.devops.gov.bc.ca/"

#'
get_cb_api_route <- function() "https://api-dev-critterbase.apps.silver.devops.gov.bc.ca/"

### SIMS Routes

# Login routes
get_login_route <- function() {
  return("api/user/self")
}

# Project routes
get_users_projects_route <- function() {
  user_id <- pkg.env$simsbc_auth$user$system_user_id
  return(paste0("api/user/", user_id, "/projects/get"))
}
get_all_projects_route <- function() {
  return("api/project/list")
}
get_project_route <- function(project_id) {
  return(paste0("api/project/", project_id, "/view"))
}

# Survey routes
get_all_surveys_route <- function(project_id) {
  return(paste0("api/project/", project_id, "/survey/list"))
}
get_survey_route <- function(survey_id, project_id) {
  return(paste0("api/project/", project_id, "/survey/", survey_id, "/view"))
}

# Critter routes
get_survey_critters_route <- function(survey_id, project_id){
  return(paste0("api/project/", project_id, "/survey/", survey_id, "/critters"))
}
get_critter_route <- function(critter_id){
  # return(paste0("api/project/", project_id, "/survey/", survey_id, "/critters/", critter_id))
  return(paste0("api/critter-data/critters/", critter_id))
}

# Critter attribute routes
# get_critter_measurements <- function(critter_id){
#   return(paste0("api/measurements/", critter_id))
# }

#
get_telemetry_deployments_route <- function(survey_id, project_id) {
  return(paste0("api/project/", project_id, "/survey/", survey_id, "/deployments"))
}

# Telemetry routes
get_telemetry_device_route <- function(device_id){
  return(paste0("api/telemetry/device/", device_id))
}
