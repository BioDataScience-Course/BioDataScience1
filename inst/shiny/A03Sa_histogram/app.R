# Histogram with variable classes
learnitdown::learnitdownShinyVersion("1.0.0")
conf <- BioDataScience::config()

library(shiny)
library(learnitdown)
library(BioDataScience1)
library(ggplot2)
library(chart)

geyser <- data.io::read("geyser", package = "MASS", lang = "fr")

ui <- fluidPage(
  learnitdownShiny("Choix des classes pour un histogramme"),

  sidebarPanel(
    sliderInput(inputId = "bins", label = "Nombre de classes :",
      min = 2, max = 100, step = 2, value = 4),
    hr(),
    submitQuitButtons()
  ),

  mainPanel(
    plotOutput(outputId = "histogram")
  )
)

server <- function(input, output, session) {
  output$histogram <- renderPlot({
    chart::chart(data = geyser, ~ waiting) +
      ggplot2::geom_histogram(bins = input$bins,
        col = "white", fill = "#75AADB") +
      ggplot2::ylab("Fréquence")
  })

  trackEvents(session, input, output,
    sign_in.fun = BioDataScience::sign_in, config = conf)
  trackSubmit(session, input, output, max_score = 2, solution =
      list(bins = c(min = 12, max = 32)),
    comment = "largeur de classe pour un histogramme",
    message.success = "Votre choix produit un histogramme lisible. Vous avez remarqué que des valeurs trop petites ou trop grandes rendent l'histogramme peu lisible ?",
    message.error = "Je pense que vous pouvez obtenir un histogramme plus lisible avec d'autres valeurs...")
  trackQuit(session, input, output, delay = 20)
}

shinyApp(ui, server)
