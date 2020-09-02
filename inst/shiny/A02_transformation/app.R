#
learndown::learndownShinyVersion("1.0.0") # Set app version
BioDataScience::init()

library(shiny)
library(learndown)

ui <- fluidPage(
  learndownShiny("Transformation des données : linéarisation"),

  sidebarPanel(
    selectInput(
      "scalex", "x",
      choices = c(
        "Aucune", "Logarithme népérien", "Racine carrée",
        "Carré", "Exponentiel")),
    selectInput(
      "scaley", "y",
      choices = c(
        "Aucune", "Logarithme népérien", "Racine carrée",
        "Carré", "Exponentiel")),
    hr(),

    submitQuitButtons() # The learndown-specific buttons
  ),

    mainPanel(
      fluidRow(
        column(width = 6,
               plotOutput("plot")
               ),
        column(width = 6,
               plotOutput("plot_transfo")
               )
        )
      )
)

server <- function(input, output, session) {

  urchin <- data.io::read("urchin_bio", package = "data.io", lang = "fr")

  urchin_transfo <- reactive({

    transformer <- function(
      x, method = c(
        "Aucune", "Logarithme népérien", "Racine carrée",
        "Carré", "Exponentiel"), label, units) {

      method <- match.arg(method)

      if (method == "Aucune") {
        labs <- label
      } else {
        labs <- paste(method, "de", label, sep = " ")
      }

      data.io::labelise(switch(method,
             "Aucune" = x,
             "Logarithme népérien"= log(x),
             "Racine carrée" = sqrt(x),
             "Carré"  = x^2,
             "Exponentiel" = exp(x)),
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

  # This is the learndown-specific behaviour
  # Track start, stop, inputs, errors (and possibly outputs)
  trackEvents(session, input, output)
  # Track the submit button and check answer
  trackSubmit(session, input, output,
              solution = list(scalex = "Logarithme népérien", scaley = "Logarithme népérien"),
              comment = "transformation double-logarithmique",
              message.success = "Correct, c'est la meilleur transformation. La transformation double-logarithmique est très souvent utilisée en biologie.",
              message.error = "Incorrect, une meilleure transformation existe.")
  # Track the quit button, save logs and close app after a delay (in sec)
  trackQuit(session, input, output, delay = 60)

  }

shinyApp(ui, server)
