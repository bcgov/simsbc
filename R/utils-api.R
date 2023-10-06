#
sims_req_from_json <- function(route) {
  route |>
    sims_request() |>
    resp_body_json()
}

# Format https requests for SIMS
#' Title
#'
#' @param req_url
#' @param client
#'
#' @import dplyr
#'
#' @examples
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

  if ("500" %in% res | inherits(res, "try-error")) stop("Sorry, something went wrong! The data you requested might not exist.")

  res
}
