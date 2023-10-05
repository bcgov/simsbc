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

# Format https requests for Critterbase
cb_request <- function(req_url) {
  check_internet()
  check_auth()

  res <- tryCatch(
    {
      request(paste0(get_sims_api_route(), req_url)) |>
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
