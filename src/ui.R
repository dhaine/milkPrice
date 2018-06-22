## Define UI ---------------------------------------------------------
shinyUI(navbarPage(
    theme = shinytheme("simplex"),
    "Milk Prices Comparison",
    tabPanel("About",
             column(1),
             column(5, br(), br(), br(),
                    h3("About this app"),
                    p("This app allows to compare farm gate milk price received in Canada, the U.S.A., New Zealand and the EU. The EU is presented as EU 15 (Belgium, France, Spain, Ireland, Portugal, Germany, Luxembourg, United Kingdom, the Netherlands, Denmark, Austria, Sweden, Italy, Finland, and Greece), and as EU 28 (the aforementioned countries plus the Czech Republic, Estonia, Cyprus, Latvia, Lithuania, Hungary, Malta, Poland, Slovenia, Slovakia, Bulgaria, Romania, and Croatia)."), br(), p("All prices are given in Canadian dollars, using currency conversion on first day of the year (obtained from", a("XE Corporation", href="https://xe.com/"), "). U.S. data are from USDA-NASS and were converted from cwt to litre (1 cwt = 44.0242 litres). Canadian data are from ", a("Les Producteurs de lait du Québec", href="http://lait.org/leconomie-du-lait/statistiques/"), ". New Zealand data are from ", a("CLAL.it", href="https://www.clal.it/en/"), ". European data are from DG Agri. Kilograms of milk were converted to litres (1 kg = 0.9708737864 litre)."), br(), br(), p("It also allows to visualize the retail price of milk in Canada, the U.S. and some European countries. Data for Canada are coming from Statistics Canada, for the U.S. from USDA AMS, and for Europe from Eurostat (available only on a yearly basis from 2013 to 2015). U.S. prices were converted as price per litres from the reported price for half a gallon of milk (half a gallon is 1.89270589 litre). Canadian and European prices are for semi-skimmed milk.")),
             column(5, br(), br(), br(), br(),
             wellPanel("Please report bugs at", a("https://github.com/dhaine/milkPrice/issues", href="https://github.com/dhaine/milkPrice/issues"), br(), br(), "Shiny app by Denis Haine", br(), br()))),
    tabPanel(HTML("Graphs"),
             sidebarPanel(
                 # select data
                 radioButtons("data_type",
                              h4("Choose data:"),
                              choices = c("Farm gate prices", "Retail prices"),
                              selected = "Farm gate prices"),
                 # select state/country
                 uiOutput("choose_country"),
                 submitButton("Submit")
             ),
             mainPanel(
                 tags$style(type="text/css",
                            ".shiny-output-error { visibility: hidden; }",
                            ".shiny-output-error:before { visibility: hidden; }"),
                 fluidRow(
                     plotlyOutput("price_plot"))
             )
             )
)
)
