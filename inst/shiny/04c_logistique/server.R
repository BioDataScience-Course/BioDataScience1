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

    output$logis_plot <- renderPlot({

        set.seed(42)

        logis_exo <- tibble(
            time = seq(0, 8, by = 0.1),
            popu = SSlogis(time, Asym = 5, xmid = 4, scal = 0.5) + rnorm(
                n = length(time), sd = 0.1),
            popu_predit = SSlogis(time, Asym = input$asym_ui,
                                  xmid = input$xmid_ui, scal = input$k_ui)
        )

        chart::chart(logis_exo, popu ~ time) +
            ggplot2::geom_point() +
            geom_line(f_aes(popu_predit ~ time), color = "red") +
            xlab("Temps") +
            ylab("Population")
    })

    output$logis_model <- renderUI({
        withMathJax(
            sprintf(
                "Ton modèle  :
                  $$population = \\frac{%.02f}{1 + e^{\\frac{%.02f - temps}{%.02f}}}$$",
                    Asym = input$asym_ui,
                    xmid = input$xmid_ui, scal = input$k_ui))
    })


    output$logis_resid <- renderUI({

        set.seed(42)

        logis_exo <- tibble(
            time = seq(0, 8, by = 0.1),
            popu = SSlogis(time, Asym = 5, xmid = 4, scal = 0.5) + rnorm(
                n = length(time), sd = 0.1),
            popu_predit = SSlogis(time, Asym = input$asym_ui,
                                  xmid = input$xmid_ui, scal = input$k_ui),
            distance2 = (popu_predit - popu)^2
        )

        value <- sum(logis_exo$distance2)

        withMathJax(
            sprintf("La valeur de la somme des résidus au carré de ton modèle : $$%.05f$$",
                    value))
    })


    output$logis_theo <- renderPlot({

        logis_data <- tibble(
            t = seq(0, 10, by = 0.1),
            y = SSlogis(t, Asym = 0.95, xmid = 5, scal = 0.95)
        )

        chart(data = logis_data, y ~ t) +
            geom_line() +
            geom_vline(xintercept = 0, col = "darkgray") +
            geom_hline(yintercept = c(0, 0.95/2, 0.95), col = "gray", linetype = "dashed") +
            geom_vline(xintercept = 5, col = "gray", linetype = "dashed") +
            annotate("text", label = "Asym", x = -0.4, y = 0.95) +
            annotate("text", label = "Asym/2", x = -0.5, y = 0.95/2) +
            annotate("text", label = "xmid", x = 5.4, y = 0.03) +
            annotate("text", label = "point d'inflexion", x = 6, y = 0.45) +
            labs(x = "input")
    })

})
