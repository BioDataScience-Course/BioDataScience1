#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
SciViews::R()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$exo_plot <- renderPlot({

        set.seed(42)

        exponent <- function(x, y0, k)
            y0 * exp(k * x)


        expo_exo <- tibble(
            time = seq(0, 2.5, by = 0.1),
            popu = exponent(time, y0 = 8, k = 1.25) + rnorm(n = length(time), sd = 4),
            popu_predit = exponent(time, y0 = input$y0_ui, k = input$k_ui)
        )

        chart::chart(expo_exo, popu ~ time) +
            ggplot2::geom_point() +
            geom_line(f_aes(popu_predit ~ time), color = "red") +
            xlab("Temps") +
            ylab("Population")
    })

    output$expo_model <- renderUI({
        withMathJax(
            sprintf("Ton modèle : $$population \\ = %.02f \\ e^{%.02f \\ temps}$$",
                    input$y0_ui, input$k_ui))
    })


    output$expo_resid <- renderUI({
        set.seed(42)

        set.seed(42)

        exponent <- function(x, y0, k)
            y0 * exp(k * x)


        expo_exo <- tibble(
            time = seq(0, 2.5, by = 0.1),
            popu = exponent(time, y0 = 8, k = 1.25) + rnorm(n = length(time), sd = 4),
            popu_predit = exponent(time, y0 = input$y0_ui, k = input$k_ui),
            distance2 = (popu_predit - popu)^2
        )

        value <- sum(expo_exo$distance2)

        withMathJax(
            sprintf("La valeur de la somme des résidus au carré de ton modèle : $$%.05f$$",
                    value))
    })


    output$expo_theo <- renderPlot({

        exponent <- function(x, y0, k)
            y0 * exp(k * x)

        exponent_data <- tibble(
            t = seq(0, 3, by = 0.1),
            y = exponent(t, y0 = 1.5, k = 0.9)
        )

        chart(data = exponent_data, y ~ t) +
            geom_line() +
            geom_vline(xintercept = 0, col = "darkgray") +
            geom_hline(yintercept = 1.5, col = "gray", linetype = "dashed") +
            annotate("text", label = "y0", x = -0.05, y = 1.5)
    })

})
