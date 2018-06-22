## Define server function --------------------------------------------
shinyServer(function(input, output, session){

    dat <- reactive({
        if (length(input$country) == 0) {
            print("Please select at least one country.")
        } else {
            dat <- farm_gate %>%
                filter(country %in% input$country)
            return(dat)
            }
    })

    output$price_plot <- renderPlotly({
        plot_ly(dat(), x = ~time,
                y = ~price,
                color = ~country,
                type = "scatter", mode = "lines") %>%
            layout(xaxis = list(showgrid = FALSE, ticklen = 4, nticks = 30,
                                ticks = "outside",
                                tickmode = "array",
                                tickvals = dat()$time,
                                tickangle = 0,
                                title = ""),
                   yaxis = list(title = "CAD/litre"),
                   title = "Farm gate milk price")
    })
#    plotInput <- reactive({
#        p <- farmGate_usa %>%
#            ggplot() +
#            geom_line(aes(x = ))
#    })
       
## Output ##############################################################
########################################################################
#    output$downloadPlot <- downloadHandler(
#        filename = function() {paste(input$risk_type, '.png', sep = '')},
#        content = function(file) {
#            ggsave(file, plot = plotInput(), width = 8, height = 6, dpi = 300,
#                   bg = "transparent", device = "png")
#        })
})
