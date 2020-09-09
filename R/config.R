#' Configure the R environment to access my MongoDB database, and provide or
#' cache user information for reuse in learnr and shiny applications that are
#' run locally.
#'
#' Environment variables are added with infos about my database and files
#' are written in the user's directory with cache data.
#'
#' @param data Fingerprint data (user information) either in clear, or ciphered. In
#' this case, the string must start with "fingerprint=".
#' @param debug Do we issue debugging messages (by default, yes if the
#' environment variables `LEARNDOWN_DEBUG` is not `0`).
#' @param cap The caption of learnr R code widgets.
#' @param simple Do we use a simple banner without title or not?
#'
#' @return `TRUE` or `FALSE` invisibly, if it succeeds or not (with database
#' access test).
#' @export
config <- function(debug = Sys.getenv("LEARNDOWN_DEBUG", 0) != 0) {
  learndown::config(
    url = "https://wp.sciviews.org/biodatascience_config",
    password = .pass_conf,
    cache = "~/.biodatascience_config",
    debug = debug)
}

#' @rdname config
#' @export
fingerprint <- function(data, debug = Sys.getenv("LEARNDOWN_DEBUG", 0) != 0) {
  learndown::fingerprint(data = data,
    password = .pass_user, iv = .iv_user,
    cache = "~/.biodatascience_user",
    debug = debug)
}

# These items should better be hidden... but how?
.pass_conf <- "$G8rLCuk4D7g!G%!kH@BzzvWKpa&LT6d"
.pass_user <- "R*.px_#:4hVXZ#d#&,0fU52lEzc6.,Qv"
.iv_user <- "1638369746832634"

#' @rdname config
#' @export
learnr_setup <- function(cap = "Code R",
debug = Sys.getenv("LEARNDOWN_DEBUG", 0) != 0) {
  learndown::learndownLearnrSetup(config = BioDataScience1::config(),
    fingerprint = BioDataScience1::fingerprint(), cap = cap, debug = debug)
}

#' @rdname config
#' @export
learnr_banner <- function(simple = FALSE) {
  if (isTRUE(simple)) {
    learndownLearnrBanner(
      msg.nologin = 'Utilisateur anonyme, aucun enregistrement !',
      msg.login = 'Enregistrement actif pour ')
  } else {
    learndownLearnrBanner(
      title = "Science des donn\u00e9es biologiques I",
      text = "R\u00e9alis\u00e9 par le service d'\u00c9cologie num\u00e9rique, Universit\u00e9 de Mons (Belgique)",
      image = "https://wp.sciviews.org/BioDataScience-96.png",
      msg.nologin = 'Utilisateur anonyme, aucun enregistrement !',
      msg.login = 'Enregistrement actif pour ')
  }
}

#' @rdname config
#' @export
#' @param input The Shiny input.
#' @param output The Shiny output.
#' @param session The Shiny session.
learnr_server <- function(input, output, session)
  learndownLearnrServer(input, output, session)
