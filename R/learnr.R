#' Prepare a learnr tutorial for learnitdown recording
#'
#' These functions add recording through the learnitdown approach.

#' @param cap The caption of learnr R code widgets.
#' @param debug Do we issue debugging messages (by default, yes if the
#' environment variables `LEARNITDOWN_DEBUG` is not `0`).
#'
#' @export
learnr_setup <- function(cap = "Code R",
debug = Sys.getenv("LEARNITDOWN_DEBUG", 0) != 0) {
  learnitdown::learnitdownLearnrSetup(config = BioDataScience::config(),
    sign_in = BioDataScience::sign_in(), cap = cap, debug = debug)
  # Eliminate praise sentence in English before results
  options(
    # gradethis_glue_correct = "{ random_praise() } { .message } { .correct }",
    gradethis_glue_correct = "{ .message } { .correct }",
    # gradethis_glue_incorrect = "{ .message } { .incorrect } { random_encourage() }"
    gradethis_glue_incorrect = "{ .message } { .incorrect }",
    # Set obfuscation config
    learnitdown_obfuscator = BioDataScience::obfuscator()
  )
}

#' @rdname learnr_setup
#' @export
#' @param simple Do we use a simple banner without title or not?
learnr_banner <- function(simple = FALSE) {
  if (isTRUE(simple)) {
    learnitdownLearnrBanner(
      msg.nologin = 'Utilisateur anonyme, aucun enregistrement !',
      msg.login = 'Enregistrement actif pour ')
  } else {
    learnitdownLearnrBanner(
      title = "Science des donn\u00e9es biologiques\ I",
      text = "R\u00e9alis\u00e9 par le service d'\u00c9cologie num\u00e9rique, Universit\u00e9 de Mons (Belgique)",
      image = "https://wp.sciviews.org/BioDataScience-96.png",
      msg.nologin = "Utilisateur anonyme, aucun enregistrement !",
      msg.login = "Enregistrement actif pour ",
      msg.error = "Erreur d'enregistrement de l'activit\u00e9 ! ")
  }
}

#' @rdname learnr_setup
#' @export
#' @param input The Shiny input.
#' @param output The Shiny output.
#' @param session The Shiny session.
#' @param envir The environment in which to evaluate code (by default, the
#'   parent frame).
learnr_server <- function(input, output, session, envir = parent.frame())
  learnitdownLearnrServer(input, output, session, envir)
