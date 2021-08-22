# RStudio addins

run_addin <- function() {
  #library(shiny)
  #library(miniUI)

  selectItem <- function() {
    package <- "BioDataScience1"

    items <- character(0)
    tutorials <- dir(system.file("tutorials", package = package))
    if (length(tutorials))
      items <- paste(tutorials, "(tutorial)")
    apps <- dir(system.file("shiny", package = package))
    if (length(apps))
      items <- c(items, paste(apps, "(Shiny app)"))
    if (!length(items)) return()

    ui <- miniPage(
      miniContentPanel(
        selectInput("item", paste0("Items in ", package, ":"),
          selectize = FALSE, size = 11, items)
      ),
      gadgetTitleBar("",
        left  = miniTitleBarCancelButton(),
        right = miniTitleBarButton("done", "Select", primary = TRUE)
      )
    )

    server <- function(input, output, session) {
      observeEvent(input$done, {
        returnValue <- input$item
        if (!is.null(returnValue)) {
          if (grepl(" \\(tutorial\\)$", returnValue)) {
            run(sub(" \\(tutorial\\)$", "", returnValue))
          } else {# Must be an app then
            run_app(sub(" \\(Shiny app\\)$", "", returnValue))
          }
        }
        stopApp(returnValue)
      })
    }

    runGadget(ui, server,
      viewer = dialogViewer("Select an item",
        width = 300, height = 250))
  }

  # Update both BioDataScience & BioDataScience1
  learnitdown::update_pkg("BioDataScience",
    github_repos = "BioDataScience-course/BioDataScience")
  update_pkg()

  item <- try(suppressMessages(selectItem()), silent = TRUE)
  if (!is.null(item) && !inherits(item, "try-error"))
    message("Running item ", item)
}
