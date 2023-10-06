#' Title
#'
#' @param animal_id
#'
#' @return
#' @export
#'
#' @examples
animals <- function(survey_id, project_id, raw = FALSE) {
  UseMethod("animals")
}

#' @export
animals.default <- function(survey_id, project_id, raw = FALSE) {
  stop(paste0("No animals method for an object of class ", class(survey_id)),
    call. = FALSE
  )
}

#' @export
animals.numeric <- function(survey_id, project_id, raw = FALSE) {
  check_id(survey_id, "survey_id")
  check_id(project_id, "project_id")
  check_raw(raw)

  res <- get_survey_critters_route(survey_id, project_id) |>
    sims_req_from_json()

  if (length(res) == 0) {
    message(paste0("There are no Marked or Known Animals in Survey ", survey_id))
  } else {
    if (!raw) {
      res <- lapply(res, format_critters) |>
        bind_rows()
    }
  }

  res
}

#'
format_critters <- function(x) {
  data.frame(
    critter_id = x$critter_id,
    species = x$taxon,
    wlh_id = x$wlh_id,
    alias = x$animal_id,
    sex = x$sex
  )
}

#### ----

#' Title
#'
#' @param critter_id
#'
#' @return
#' @export
#'
#' @examples
animal_details <- function(critter_id, survey_id, project_id, raw = FALSE) {
  UseMethod("animal_details")
}

#' @export
animal_details.default <- function(critter_id, survey_id, project_id, raw = FALSE) {
  stop(paste0("No animal_details method for an object of class ", class(critter_id), ". Did you forget to put quotes around the critter_id?"),
    call. = FALSE
  )
}

#' @export
animal_details.character <- function(critter_id, survey_id, project_id, raw = FALSE) {
  check_id(survey_id, "survey_id")
  check_id(project_id, "project_id")
  check_raw(raw)

  c <- animals(survey_id, project_id, raw = TRUE) |>
    lapply(function(x) x[x$critter_id == critter_id]) |>
    purrr::compact()

  if (length(c) != 1) stop(paste("Could not find Critter", critter_id))

  if (!raw) {
    c <- c |>
      lapply(format_critter)
  }

  if (length(c) == 1) {
    as.animal(c[[1]])
  }
}

#'
as.animal <- function(x) {
  class(x) <- "animal"
  x
}

#'
format_critter <- function(x) {
  list(
    critter_id = x$critter_id,
    taxon = x$taxon,
    wlh_id = x$wlh_id,
    alias = x$animal_id,
    sex = x$sex,
    comment = x$critter_comment,
    measurement = x$measurement,
    marking = x$marking,
    capture = x$capture,
    mortality = x$mortality
  )
}
