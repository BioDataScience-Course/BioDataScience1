# RStudio addins

run_addin <- function() {
  #library(shiny)
  #library(miniUI)

  selectItem <- function() {
    package <- "BioDataScience1"

    items <- character(0)
    tutorials <- dir(system.file("tutorials", package = package))
    is_active <- function(dir, subdir, pattern)
      length(dir(system.file(dir, subdir, package = package),
        pattern = pattern)) > 0
    keep <- logical(length(tutorials))
    for (i in seq_along(tutorials))
      keep[i] <- is_active("tutorials", tutorials[i], "\\.Rmd$")
    tutorials <- tutorials[keep]
    if (length(tutorials))
      items <- paste(tutorials, "(tutorial)")
    apps <- dir(system.file("shiny", package = package))
    keep <- logical(length(apps))
    for (i in seq_along(apps))
      keep[i] <- is_active("shiny", apps[i], "^app.R$")
    apps <- apps[keep]
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

sdd1_issue <- function() {
  # Get year (two digits)
  # We shift the academic year (starting mid-september) by 250 days
  # and get the year using two last digits
  acad_year <- format(Sys.Date() - 250, "%y")
  new_issue_url <- paste0("https://github.com/BioDataScience-Course/a00qa_",
    acad_year, "m_issues-a", acad_year, "/issues/new")
  # Display a message with short instructions + url
  rstudioapi::showDialog(title = "Nouvelle issue du cours BioDataScience1",
    url = new_issue_url,
    message = paste0(
      "Cliquez sur le lien ci-dessous pour cr\u00e9er l'issue. ",
      "Indiquez un titre et commencez le message par ",
      "@BioDataScience-Course/teachers pour notifier ",
      "imm\u00e9diatement vos enseignants de votre question. ",
      "Ajoutez \u00e9ventuellement une capture d'\u00e9cran explicite."))
  invisible(TRUE)

}
