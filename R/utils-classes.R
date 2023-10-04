#' @export
print.survey_details <- function(x, ...) {
  cat(
    paste("Name: ", x$name),
    paste("Start date: ", x$start_date),
    paste("End date: ", x$end_date),
    sep = "\n"
  )
}

#' @export
print.project_details <- function(x, ...) {
  cat(
    paste("Name: ", x$name),
    paste("Start date: ", x$start_date),
    paste("End date: ", x$end_date),
    sep = "\n"
  )
}
