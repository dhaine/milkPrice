## Define UI ---------------------------------------------------------
shinyUI(navbarPage(
    theme = shinytheme("simplex"),
    "Milk Prices Comparison",
    tabPanel("About",
             column(1),
             column(5, br(), br(), br(),
                    h3("About this app"),
                    p("This app allows to compare farm gate milk price received in Canada, the U.S.A., New Zealand and the EU. The EU is presented as EU 15 (Belgium, France, Spain, Ireland, Portugal, Germany, Luxembourg, United Kingdom, the Netherlands, Denmark, Austria, Sweden, Italy, Finland, and Greece), and as EU 28 (the aforementioned countries plus the Czech Republic, Estonia, Cyprus, Latvia, Lithuania, Hungary, Malta, Poland, Slovenia, Slovakia, Bulgaria, Romania, and Croatia)."), br(), p("All prices are given in Canadian dollars, using currency conversion on first day of the year (obtained from", a("XE Corporation", href="https://xe.com/"), "). U.S. data are from USDA-NASS and were converted from cwt to litre (1 cwt = 44.0242 litres). Canadian data are from ", a("Les Producteurs de lait du Québec", href="http://lait.org/leconomie-du-lait/statistiques/"), ". New Zealand data are from ", a("CLAL.it", href="https://www.clal.it/en/"), ". European data are from DG Agri. Kilograms of milk were converted to litres (1 kg = 0.9708737864 litre).")),
             column(5, br(), br(), br(), br(),
             wellPanel("Please report bugs at", a("https://github.com/dhaine/milkPrice/issues", href="https://github.com/dhaine/milkPrice/issues"), br(), br(), "Shiny app by Denis Haine", br(), br()))),
    tabPanel(HTML("Graphs"),
             sidebarPanel(
                 # select state/country
                 selectizeInput("country",
                                h4("For country:"),
                                choices = unique(farm_gate$country),
                                multiple = TRUE,
                                options = list(maxItems = 6,
                                               placeholder = 'Select a country'),
                                selected = "Canada"),
                 submitButton("Submit")
             ),
             mainPanel(
                 fluidRow(
                     plotlyOutput("price_plot"))
             )
             )
)
)
