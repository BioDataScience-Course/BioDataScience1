#' Run learnr tutorials from the BioDataScience1 package
#'
#' @param tutorial The name of the tutorial to use. If not provided, a list of
#' available tutorials is displayed.
#' @param ... Further arguments passed to `learnr::run_tutorial()`.
#' @param update Do we check for an updated version first, and if it is found,
#' update the package automatically?
#' @param ask In case `tutorial` is not provided, do we ask to select in a list?
#'
#' @description Start the learnr R engine in the current R session with the
#' selected tutorial.
#'
#' @return If `tutorial` is not provided, in interactive mode with `ask = TRUE`,
#' you have to select one in a list, and in non interactive mode, or
#' `ask = FALSE`, it returns the list of all available tutorials.
#' @export
#' @keywords utilities
#' @concept run interactive learnr documents from the BioDataScience package
#' @examples
#' # To start from a list of available tutorials:
#' run()
#' \dontrun{
#' run("00a_learnr")
#' }
run <- function(tutorial, ..., update = ask, ask = interactive()) {
  #BioDataScience::init()
  if (missing(tutorial))
    tutorial <- NULL
  learndown::run(tutorial = tutorial, package = "BioDataScience1",
    repos = "BioDataScience-course/BioDataScience1", ..., update = update,
    ask = ask)
}
