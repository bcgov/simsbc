#' Loads OAuth token and user details into memory
#'
#' @return List
#' @import httr2
#' @export
login_sims <- function() {
  client <- oauth_client(
    id = get_keycloak_client_id(),
    token_url = get_keycloak_token_url()
  )
  
  print(client)

  tryCatch(
    {
      res <- request(paste0(get_sims_api_route(), get_login_route())) |>
        req_oauth_auth_code(client, auth_url = get_keycloak_auth_url(), redirect_uri = 'https://sims.nrs.gov.bc.ca') |>
        req_perform()
      
      print(res)

      res_body <- res |>
        resp_body_json()

      if (res %>% resp_status() == 200) {
        message(
          "You succesfully logged in as ",
          res_body$user_identifier,
          " (",
          res_body$display_name,
          "). Your role is ",
          res_body$role_names[[1]],
          "."
        )
      }

      output <- list(client, res_body)
      names(output) <- c("client", "user")

      pkg.env$simsbc_auth <- output

      invisible(res_body)
    },
    error = function(error) {
      error
    },
    warning = function(warn) {
      warn
    }
  )
}
