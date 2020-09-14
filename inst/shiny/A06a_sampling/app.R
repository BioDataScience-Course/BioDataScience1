learndown::learndownShinyVersion("1.0.0")
conf <- BioDataScience::config()

library(shiny)
library(learndown)
library(BioDataScience1)
library(tibble)
library(ggplot2)
library(chart)

set.seed(50)
pop <- rnorm(n = 1000000L, mean = 150, sd = 35)
mean_pop <- mean(pop)
sd_pop <- sd(pop)

ui <- fluidPage(
  learndownShiny("Population & Echantillon"),

  sidebarPanel(
    p("Effet de la taille d'un échantillon sur l'estimation de la moyenne."),
    hr(),
    sliderInput("n",
      "Nombre d'observations",
      min = 10,
      max = 1000,
      step = 10,
      value = 10),
    hr(),
    submitQuitButtons()
  ),

  mainPanel(
    plotOutput("density_plot"),
    div("Le graphique de densité représente la distribution d'une population
    Normale de moyenne 150 et d'écart type 35. La ligne rouge montre la moyenne
    de la population et la ligne verte la moyenne de l'échantillon" ),
    div(
      strong("Moyenne de l'échantillon :"), verbatimTextOutput("mean_sample"),
      strong("Ecart-type de l'échantillon :"), verbatimTextOutput("sd_sample")),

    h4(),
    verbatimTextOutput("numb_val2")
  )
)

server <- function(input, output, session) {

  get_sample <- reactive({
    set.seed(647)
    sample <- sample(pop, size = input$n)
  })

  output$mean_sample <- renderPrint(mean(get_sample()))

  output$sd_sample <- renderPrint(sd(get_sample()))

  output$density_plot <- renderPlot({
    sample <- get_sample()
    mean_smp <- mean(sample)
    sd_smp <- sd(sample)
    chart::chart(tibble::enframe(pop), ~ value) +
      ggplot2::geom_density() +
      ggplot2::geom_hline(yintercept = 0) +
      ggplot2::geom_vline(xintercept = mean_pop, color = "red") +
      ggplot2::geom_vline(xintercept = mean_pop - sd_pop, color = "red",
        alpha = 0.5, linetype = "twodash") +
      ggplot2::geom_vline(xintercept = mean_pop + sd_pop, color = "red",
        alpha = 0.5, linetype = "twodash") +
      ggplot2::geom_vline(xintercept = mean_smp, color = "green") +
      ggplot2::geom_vline(xintercept = mean_smp - sd_smp,
        color = "green", alpha = 0.5, linetype = "twodash") +
      ggplot2::geom_vline(xintercept = mean_smp + sd_smp,
        color = "green", alpha = 0.5, linetype = "twodash")
  })

  trackEvents(session, input, output,
    sign_in.fun = BioDataScience::sign_in, config = conf)
  trackSubmit(session, input, output, max_score = 1, solution = NULL,
    comment = "all solutions are correct",
    message.success = "La taille d'échantillon doit toujours être la plus grande possible, mais en pratique nous sommes limité par le temps, le coût, ou le nombre de sujets disponibles.",
    message.error = "Incorrect.")
  trackQuit(session, input, output, delay = 20)
}

shinyApp(ui, server)
