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

    trees <- data.io::read("trees", package = "datasets", lang = "FR") %>.%
        dplyr::select(., -height)

    xvar <- trees$diameter
    yvar <- trees$volume

    output$trees_plot <- renderPlot({

        chart::chart(trees, volume ~ diameter) +
            ggplot2::geom_point() +
            geom_abline(aes(slope = input$slope_ui, intercept = input$intercept_ui))
    })

    output$resid_sum <- renderText({
            predict <- xvar * input$slope_ui + input$intercept_ui
            dist <- yvar - predict
            value <- sum(dist)
            print(value)
    })

    output$resid2_sum <- renderText({
            predict <- xvar * input$slope_ui + input$intercept_ui
            dist <- yvar - predict
            value <- sum(dist ^ 2)
            print(value)
    })

    output$resid_abs_sum <- renderText({
            predict <- xvar * input$slope_ui + input$intercept_ui
            dist <- yvar - predict
            value <- sum(abs(dist))
            print(value)
    })


})
