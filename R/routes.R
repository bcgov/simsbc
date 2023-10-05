# Login routes
get_login_route <- function() {
  return("api/user/self")
}

# Project routes
get_users_projects_route <- function(user_id) {
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
get_critter_measurements <- function(critter_id){
  return(paste0("api/measurements/", critter_id))
}
