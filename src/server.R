## Define server function --------------------------------------------
shinyServer(function(input, output, session){

    output$choose_country <- renderUI({
        selectizeInput("country",
                       h4("For country:"),
                       choices = if (input$data_type == "Farm gate prices") {
                                     unique(farm_gate$country)
                                 } else {
                                     unique(retail$country)
                                 },
                       multiple = TRUE,
                       options = list(maxItems = 6,
                                      placeholder = 'Select a country'),
                       selected = "Canada")
    })
    
    dat <- reactive({
        if (length(input$country) == 0) {
            print("Please select at least one country.")
        } else {
            if (input$data_type == "Farm gate prices") {
                dat <- farm_gate %>%
                    filter(country %in% input$country)
                return(dat)
            } else {
                dat <- retail %>%
                    filter(country %in% input$country)
                return(dat)
            }            
        }
    })

    plotTitle <- reactive({
        if (input$data_type == "Farm gate prices") {
            plotTitle <- "Farm gate milk price"
        } else {
        plotTitle <- "Retail milk price"}
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
                   title = plotTitle())
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
