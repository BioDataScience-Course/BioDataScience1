learndown::learndownShinyVersion("1.0.0")
BioDataScience1::config()

library(shiny)
library(learndown)

urchin <- data.io::read("urchin_bio", package = "data.io", lang = "fr")

ui <- fluidPage(
  learndownShiny("Transformation des données : linéarisation"),

  sidebarPanel(
    selectInput(
      "scalex", "x",
      choices = c(
        "Aucune", "Logarithme népérien", "Racine carrée",
        "Carré", "Exponentielle")),
    selectInput(
      "scaley", "y",
      choices = c(
        "Aucune", "Logarithme népérien", "Racine carrée",
        "Carré", "Exponentielle")),
    hr(),
    submitQuitButtons()
  ),

  mainPanel(
    fluidRow(
      column(width = 6, plotOutput("plot")),
      column(width = 6, plotOutput("plot_transfo"))
    )
  )
)

server <- function(input, output, session) {

  urchin_transfo <- reactive({

    transformer <- function(
      x, method = c(
        "Aucune", "Logarithme népérien", "Racine carrée",
        "Carré", "Exponentielle"), label, units) {

      method <- match.arg(method)

      if (method == "Aucune") {
        labs <- label
      } else {
        labs <- paste(method, "de", label, sep = " ")
      }

      data.io::labelise(switch(method,
        "Aucune" = x,
        "Logarithme népérien" = log(x),
        "Racine carrée" = sqrt(x),
        "Carré"  = x^2,
        "Exponentielle" = exp(x)),
        label = labs, units = units)
    }

    dplyr::mutate(urchin,
      y_transfo = transformer(height, method = input$scaley,
        label = "la hauteur", units = ""),
      x_transfo = transformer(weight, method = input$scalex,
        label = "la masse", units = "")
    )
  })

  output$plot <- renderPlot({
    chart::chart(data = urchin, height ~  weight) +
      ggplot2::geom_point()
  })

  output$plot_transfo <- renderPlot({
    data <- urchin_transfo()
    chart::chart(data = data, y_transfo ~  x_transfo) +
      ggplot2::geom_point()
  })

  trackEvents(session, input, output,
    sign_in.fun = BioDataScience1::sign_in)
  trackSubmit(session, input, output, max_score = 2, solution =
    list(scalex = "Logarithme népérien", scaley = "Logarithme népérien"),
    comment = "transformation double-logarithmique",
    message.success = "Correct, c'est la meilleure transformation. La transformation double-logarithmique est très souvent utilisée en biologie.",
    message.error = "Incorrect, une meilleure transformation existe.")
  trackQuit(session, input, output, delay = 20)
}

shinyApp(ui, server)
