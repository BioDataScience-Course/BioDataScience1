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

    output$gomp_plot <- renderPlot({

        set.seed(42)

        gomp_data <- tibble(
            t = seq(0, 10, by = 0.1),
            y = SSgompertz(t, Asym = 1, b2 = 5, b3 = 0.5) + rnorm(
                n = length(t), sd = 0.05),
            y_predit = SSgompertz(x = t, Asym = input$asym_ui, b2 = input$b2_ui,
                                  b3 = input$b3_ui)
        )

        chart(data = gomp_data, y ~ t) +
            geom_point() +
            geom_line(f_aes(y_predit ~ t), color = "red") +
            xlab("Temps") +
            ylab("Population")

    })

    output$gomp_model <- renderUI({
        withMathJax(
            sprintf(
                "Ton modèle  :
                  $$%.02f \\times e^{- %.02f \\times %.02f^{Temps}}$$",
                input$asym_ui, input$b2_ui, input$b3_ui))
    })


    output$gomp_resid <- renderUI({

        set.seed(42)


        set.seed(42)

        gomp_data <- tibble(
            t = seq(0, 10, by = 0.1),
            y = SSgompertz(t, Asym = 0.95, b2 = 5, b3 = 0.5) + rnorm(
                n = length(t), sd = 0.05),
            y_predit = SSgompertz(x = t, Asym = input$asym_ui, b2 = input$b2_ui,
                                  b3 = input$b3_ui),
            distance2 = (y_predit - y)^2
        )

        value <- sum(gomp_data$distance2)

        withMathJax(
            sprintf("La valeur de la somme des résidus au carré de ton modèle : $$%.05f$$",
                    value))
    })


    output$gomp_theo <- renderPlot({

        gomp_data <- tibble(
            t = seq(0, 10, by = 0.1),
            y = SSgompertz(t, Asym = 1, b2 = 5, b3 = 0.5)
        )

        chart(data = gomp_data, y ~ t) +
            geom_line() +
            geom_vline(xintercept = 0, col = "darkgray") +
            geom_hline(yintercept = c(0, 0.95/exp(1), 0.95), col = "gray",
                       linetype = "dashed") +
            geom_vline(xintercept = 2.3, col = "gray", linetype = "dashed") +
            annotate("text", label = "Asym", x = -0.4, y = 0.95) +
            annotate("text", label = "Asym/e", x = -0.5, y = 0.95/exp(1)) +
            annotate("text", label = "point d'inflexion", x = 3.5, y = 0.32) +
            labs( x = "x")
    })

})
