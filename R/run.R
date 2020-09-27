#' Run learnr tutorials, Shiny applications from the BioDataScience1 package, or
#' update it
#'
#' Start a learnr tutorial or a Shiny application from the BioDataScience1
#' package, possibly after updating it.
#'
#' @param tutorial The name of the tutorial to use. If not provided, a list of
#' available tutorials is displayed.
#' @param app The name of the Shiny application to use. If not provided, a list
#' of available applications is displayed.
#' @param ... Further arguments passed to `learnr::run_tutorial()` or to
#' `shiny::runApp()`.
#' @param update Do we check for an updated version first, and if it is found,
#' update the package automatically?
#' @param ask In case `tutorial` or `app` is not provided, do we ask to select
#' in a list?
#' @param in.job Should the application be run in a Job in RStudio (`TRUE` by
#' default)?
#'
#' @return If `tutorial` or `app` is not provided, in interactive mode with
#' `ask = TRUE`, you have to select one in a list, and in non interactive mode,
#' or `ask = FALSE`, it returns the list of all available tutorials or Shiny
#' applications in the BioDataScience1 package.
#' @export
#' @keywords utilities
#' @concept run interactive learnr or Shiny applications
#' @examples
#' \dontrun{
#' # To start from a list of available tutorials:
#' run()
#' # Idem for Shiny applications:
#' run_app()
#' }
run <- function(tutorial, ..., update = ask, ask = interactive()) {
  if (missing(tutorial))
    tutorial <- NULL
  learndown::run(tutorial = tutorial, package = "BioDataScience1",
    github_repos = "BioDataScience-course/BioDataScience1",
    ..., update = update, ask = ask)
}

#' @rdname run
#' @export
run_app <- function(app, ..., update = ask, ask = interactive(),
in.job = TRUE) {
  if (missing(app))
    app <- NULL
  learndown::run_app(app = app, package = "BioDataScience1",
    github_repos = "BioDataScience-course/BioDataScience1",
    ..., update = update, ask = ask, in.job = in.job)
}

#' @rdname run
#' @export
update_pkg <- function()
  learndown::update_pkg(package = "BioDataScience1",
    github_repos = "BioDataScience-course/BioDataScience1")
