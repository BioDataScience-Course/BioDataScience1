# Limits of the axes for a scatterplot
learndown::learndownShinyVersion("0.0.9001") # Set app version
conf <- BioDataScience::config()

library(shiny)
library(learndown)
library(BioDataScience1)
library(ggplot2)
library(chart)

urchin <- data.io::read("urchin_bio", package = "data.io", lang = "fr")

ui <- fluidPage(
  learndownShiny("Ajustement manuel des limites de l'axe X et de l'axe Y"),

  sidebarPanel(
    sliderInput("limits_x",
      "x",
      min = -50,
      max = 250,
      value = c(0,250),
      step = 10),
    sliderInput("limits_y",
      "y",
      min = -50,
      max = 150,
      value = c(0,100),
      step = 10),
    hr(),
    submitQuitButtons()
  ),

  mainPanel(
    plotOutput("limits_plot")
  )
)


server <- function(input, output, session) {

  output$limits_plot <- renderPlot({
    chart::chart(data = urchin, height ~  weight) +
      ggplot2::geom_point() +
      ggplot2::scale_x_continuous(limits = input$limits_x) +
      ggplot2::scale_y_continuous(limits = input$limits_y)
  })

  trackEvents(session, input, output,
    sign_in.fun = BioDataScience::sign_in, config = conf)
  trackSubmit(session, input, output, max_score = 2, solution =
      list(limits_x = c(0, 100), limits_y = c(0, 40)),
    comment = "Choix des limits de x et y",
    message.success = "Correct, vous avez sélectionné les limites les plus adaptées",
    message.error = "Incorrect, de meilleures limites existent.")
  trackQuit(session, input, output, delay = 20)
}

shinyApp(ui, server)
