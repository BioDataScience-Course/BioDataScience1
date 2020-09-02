learndown::learndownShinyVersion("0.0.9000") # Set app version
BioDataScience::init()

library(shiny)
library(learndown)

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
    submitQuitButtons() # The learndown-specific buttons
  ),

  mainPanel(
    plotOutput("limits_plot")
  )
)


server <- function(input, output, session) {

  urchin <- data.io::read("urchin_bio", package = "data.io", lang = "fr")

  output$limits_plot <- renderPlot({

    # generate bins based on input$bins from ui.R

    # plot
    chart::chart(data = urchin, height ~  weight) +
      ggplot2::geom_point() +
      ggplot2::scale_x_continuous(limits = input$limits_x) +
      ggplot2::scale_y_continuous(limits = input$limits_y)

  })


  # This is the learndown-specific behaviour
  # Track start, stop, inputs, errors (and possibly outputs)
  trackEvents(session, input, output)
  # Track the submit button and check answer
  trackSubmit(session, input, output,
              solution = list(limits_x = c(0,100), limits_y = c(0,40)),
              comment = "Choix des limits de x et y",
              message.success = "Correct, vous avez sélectionné les limites les plus adaptées",
              message.error = "Incorrect, de meilleures limites existent.")
  # Track the quit button, save logs and close app after a delay (in sec)
  trackQuit(session, input, output, delay = 60)

}

shinyApp(ui, server)
