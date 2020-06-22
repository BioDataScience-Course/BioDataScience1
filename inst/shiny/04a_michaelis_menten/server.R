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

    output$trees_plot <- renderPlot({

        set.seed(42)
        micmen_exo <- tibble(
            conc = seq(0, 25, by = 0.1),
            vitesse = SSmicmen(conc, Vm = 6, K = 2) + rnorm(n = length(conc), sd = 0.05),
            vit_predit = SSmicmen(conc, Vm = input$vm_ui, K = input$k_ui)
        )

        chart::chart(micmen_exo, vitesse ~ conc) +
            ggplot2::geom_point() +
            geom_line(f_aes(vit_predit ~ conc), color = "red") +
            xlab("Concentration [mol/L]") +
            ylab("Vitesse [mol/min]")
    })

    output$micmen_model <- renderUI({
        withMathJax(
            sprintf("Ton modèle : $$Vitesse \\ = \\frac{%.02f* concentration}{%.02f + concentration}$$",
                    input$vm_ui, input$k_ui))
    })


    output$micmen_resid <- renderUI({
        set.seed(42)
        micmen_exo <- tibble(
            conc = seq(0, 25, by = 0.1),
            vitesse = SSmicmen(conc, Vm = 6, K = 2) + rnorm(n = length(conc), sd = 0.05),
            vit_predit = SSmicmen(conc, Vm = input$vm_ui, K = input$k_ui),
            distance2 = (vit_predit - vitesse)^2
        )

        value <- sum(micmen_exo$distance2)

        withMathJax(
            sprintf("La valeur de la somme des résidus au carré de ton modèle : $$%.05f$$",
                    value))
    })


    output$micmen_theo <- renderPlot({

        micmen_data <- tibble(
            conc = seq(0, 15, by = 0.1),
            v = SSmicmen(conc, Vm = 1, K = 0.5)
        )

        chart(data = micmen_data, v ~ conc) +
            geom_line() +
            labs( x = "x [input]", y = "y") +
            geom_vline(xintercept = 0, col = "darkgray") +
            geom_hline(yintercept = c(0.5, 1), col = "gray", linetype = "dashed") +
            geom_vline(xintercept = 0.4, col = "gray", linetype = "dashed") +
            annotate("text", label = "Vm", x = -0.4, y = 1) +
            annotate("text", label = "Vm/2", x = -0.5, y = 0.55) +
            annotate("text", label = "K", x = 0.5, y = 0.04)
    })

})
