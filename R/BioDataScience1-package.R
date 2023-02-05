#' A series of learnr tutorials and Shiny applications for BioDataScience1
#'
#' Run the tutorials using[run()].
#'
#' @docType package
#' @name BioDataScience1-package
#'
#' @importFrom learnitdown run learnitdownLearnrBanner learnitdownLearnrServer
#' @importFrom BioDataScience config sign_in sign_out
#' @importFrom shiny dialogViewer observeEvent selectInput stopApp runGadget
#' @importFrom miniUI gadgetTitleBar miniContentPanel miniPage miniTitleBarButton miniTitleBarCancelButton
#' @importFrom chart chart theme_sciviews
#' @importFrom ggplot2 aes autoplot ggplot geom_function geom_segment stat_function xlab xlim ylab
#' @importFrom stats density quantile
#' @importFrom distributional cdf support
NULL

#@importFrom BioDataScience config sign_in sign_out run run_app update_pkg
