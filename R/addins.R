# RStudio addins

run_addin <- function() {
  #library(shiny)
  #library(miniUI)

  selectTutorial <- function() {
    tutorials <- dir(system.file("tutorials", package = "BioDataScience1"))
    if (!length(tutorials)) return(NULL)

    ui <- miniPage(
      miniContentPanel(
        selectInput("tutorial", "Tutorials in BioDataScience1:",
          selectize = FALSE, size = 11, tutorials)
      ),
      gadgetTitleBar("", left = miniTitleBarCancelButton(), right =
          miniTitleBarButton("done", "Select", primary = TRUE))
    )

    server <- function(input, output, session) {
      observeEvent(input$done, {
        returnValue <- input$tutorial
        if (!is.null(returnValue))
          BioDataScience1::run(returnValue)
        stopApp(returnValue)
      })
    }

    runGadget(ui, server,
      viewer = dialogViewer("Select a tutorial",
        width = 300, height = 250))
  }

  tutorial <- try(suppressMessages(selectTutorial()), silent = TRUE)
  if (!is.null(tutorial) && !inherits(tutorial, "try-error"))
    message("Running tutorial ", tutorial)
}

run_app_addin <- function() {
  #library(shiny)
  #library(miniUI)

  selectApp <- function() {
    apps <- dir(system.file("shiny", package = "BioDataScience1"))
    if (!length(apps)) return(NULL)

    ui <- miniPage(
      miniContentPanel(
        selectInput("app", "Shiny apps in BioDataScience1:",
          selectize = FALSE, size = 11, apps)
      ),
      gadgetTitleBar("", left = miniTitleBarCancelButton(), right =
        miniTitleBarButton("done", "Select", primary = TRUE))
    )

    server <- function(input, output, session) {
      observeEvent(input$done, {
        returnValue <- input$app
        if (!is.null(returnValue))
          BioDataScience1::run_app(returnValue)
        stopApp(returnValue)
      })
    }

    runGadget(ui, server,
      viewer = dialogViewer("Select a Shiny application",
        width = 300, height = 250))
  }

  app <- try(suppressMessages(selectApp()), silent = TRUE)
  if (!is.null(app) && !inherits(app, "try-error"))
    message("Running Shiny application ", app)
}

update_pkg_addin <- function() {
  # Update both BioDataScience & BioDataScience1
  learndown::update_pkg("BioDataScience",
    github_repos = "BioDataScience-course/BioDataScience")
  update_pkg()
}

sign_out_addin <- function()
  BioDataScience::sign_out()
