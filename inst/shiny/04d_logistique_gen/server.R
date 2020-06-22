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

    output$logis_gen_plot <- renderPlot({

        set.seed(42)

        logis_gen_exo <- tibble(
            time = seq(0, 8, by = 0.1),
            popu = SSfpl(time, A = 2, B = 8, xmid = 4, scal = 0.5) + rnorm(
                n = length(time), sd = 0.1),
            popu_predit = SSfpl(time, A = input$a_ui, B = input$b_ui,
                                  xmid = input$xmid_ui, scal = input$scal_ui)
        )

        chart::chart(logis_gen_exo, popu ~ time) +
            ggplot2::geom_point() +
            geom_line(f_aes(popu_predit ~ time), color = "red") +
            xlab("Temps") +
            ylab("Population")
    })

    output$logis_gen_model <- renderUI({
        withMathJax(
            sprintf(
                "Ton modèle  :
                  $$population = \\frac{%.02f + (%.02f - %.02f) }{1 + e^{\\frac{%.02f - temps}{%.02f}}}$$",
                input$a_ui, input$b_ui, input$a_ui,
                input$xmid_ui, input$scal_ui))
    })


    output$logis_gen_resid <- renderUI({

        set.seed(42)

        logis_gen_exo <- tibble(
            time = seq(0, 8, by = 0.1),
            popu = SSfpl(time, A = 2, B = 8, xmid = 4, scal = 0.5) + rnorm(
                n = length(time), sd = 0.1),
            popu_predit = SSfpl(time, A = input$a_ui, B = input$b_ui,
                                xmid = input$xmid_ui, scal = input$scal_ui),
            distance2 = (popu_predit - popu)^2
        )

        value <- sum(logis_gen_exo$distance2)

        withMathJax(
            sprintf("La valeur de la somme des résidus au carré de ton modèle : $$%.05f$$",
                    value))
    })


    output$logis_gen_theo <- renderPlot({

        fpl_data <- tibble(
            t = seq(0, 10, by = 0.1),
            y = SSfpl(t, A = 0.15, B = 0.95, xmid = 5, scal = 1)
        )
        chart(data = fpl_data, y ~ t) +
            geom_line() +
            geom_vline(xintercept = 0, col = "darkgray") +
            geom_hline(yintercept = c(0.15, 0.8/2 + 0.15, 0.95), col = "gray",
                       linetype = "dashed") +
            geom_vline(xintercept = 5, col = "gray", linetype = "dashed") +
            annotate("text", label = "A", x = -0.4, y = 0.15) +
            annotate("text", label = "B", x = -0.4, y = 0.95) +
            annotate("text", label = "xmid", x = 5.4, y = 0.13) +
            annotate("text", label = "point d'inflexion", x = 6.1, y = 0.53) +
            labs(x = "input")
    })

})
