#'
has_internet <- function() {
  i <- try(suppressWarnings(readLines("https://www.google.com", n = 1)),
    silent = TRUE
  )

  !inherits(i, "try-error")
}

#'
check_internet <- function() {
  if (!has_internet()) stop("You are not connected to the internet", call. = F)
}

#'
has_auth <- function() {
  !is.null(pkg.env$simsbc_auth$user$id)
}

#'
check_auth <- function() {
  if (!has_auth()) stop("You are not logged in. Call `login_simsbc()` and try again.", call. = F)
}

#'
is_id <- function(id) {
  if (is.numeric(id)) {
    id %% 1 == 0
  } else {
    FALSE
  }
}

#'
check_id <- function(id, var) {
  if (!is_id(id)) stop(paste(var, "is not a valid ID."), call. = F)
}

## Format API response from SIMS
# format_response <- function(res) {
#   lapply(res, unlist)
# }

check_raw <- function(raw) {
  if (!(raw == TRUE | raw == FALSE)) {
    stop(paste("`raw` must be TRUE or FALSE, not", raw), call. = FALSE)
  }
}
