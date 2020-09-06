#' Configure the R environment to acces my MongoDB database
#'
#' Environment variables are added with infos about my database.
#'
#' @param debug Do we issue debugging messages (by default, yes if the
#' environment variables `LEARNDOWN_DEBUG` is not `0`).
#'
#' @return `TRUE` or `FALSE` invisibly, if it succeeds or not (with database
#' access test).
#' @export
config <- function(debug = Sys.getenv("LEARNDOWN_DEBUG", 0) != 0) {
  learndown::config(
    url = "https://wp.sciviews.org/biodatascience_config",
    password = "$G8rLCuk4D7g!G%!kH@BzzvWKpa&LT6d",
    cache = "~/.biodatascience_config",
    debug = debug)
}
