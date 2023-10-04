#'
has_internet <- function() {
  i <- try(suppressWarnings(readLines("https://www.google.com", n = 1)),
           silent = TRUE
  )

  !inherits(i, "try-error")
}

#'
check_internet <- function() {
  if(!has_internet()) stop("You are not connected to the internet", call. = F)
}

#'
has_auth <- function() {
  !is.null(pkg.env$simsbc_auth$user$id)
}

#'
check_auth <- function() {
  if(!has_auth()) stop("You are not logged in. Call `login_sims()` and try again.", call. = F)
}

#'
is_id <- function(id) {
  id%%1 == 0
}

#'
check_id <- function(id, var){
  if (!is_id(id)) stop(paste(var, "is not a valid ID."), call. = F)
}

# Format https requests for SIMS
sims_request <- function(req_url, client = pkg.env$simsbc_auth$client) {
  check_internet()
  check_auth()

  res <- tryCatch(
    {
      request(paste0(get_sims_api_route(), req_url)) |>
        req_oauth_auth_code(client = client, auth_url = get_keycloak_auth_url()) |>
        req_perform()
    },
    error = function(error) {
      message(error)
    },
    warning = function(warning) {
      message(warning)
    }
  )

  res
}

# Format API response from SIMS
format_response <- function(res) {
  lapply(res, unlist)
}
