ui <- dashboardPage(
  dashboardHeader(
    title = "Simulated Clinical Trial Shiny Application",
    titleWidth = 400
  ),
  dashboardSidebar(
    disable = T
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
                              /* main sidebar */
                              .skin-blue .main-sidebar {
                              background-color: #707172;
                              }
                              dl {
                              
                              padding: 0.5em;
                              }
                              dt {
                              float: left;
                              clear: left;
                              width: 190px;
                              text-align: right;
                              font-weight: bold;
                              color: #367fa9;
                              }
                              dt::after {
                              content: ":";
                              }
                              dd {
                              margin: 0 0 0 200px;
                              padding: 0 0 0.5em 6.0em;
                              }
                              '))),    
    fluidRow(
      tabBox(
        width = 12,
        title = "",
        tabPanel(title = "Patient Screening Characteristics",
                 fluidRow(width = 12,
                          box(status = 'primary',
                              solidHeader = T,
                              width = 3,
                              title = "Covariate Selection",
                              selectInput(inputId = 'globalCovariate',
                                          label = "Include Global Comparison?",
                                          choices = c("Yes","No"),
                                          selected = "Yes"),
                              radioButtons(inputId = 'selCovariate',
                                           label = "Covariate Selection",
                                           choices = c("Sex","Age"),
                                           selected = "Age"),
                              selectInput(inputId = 'graphType',
                                          label = "Graph Display Type (Numeric)",
                                          choices = c("boxPlot","densityPlot"),
                                          selected = "densityPlot")
                              ),
                          box(status = 'primary',
                              solidHeader = T,
                              width = 9,
                              title = "Graph and Summary Statistics",
                              box(status = 'primary',
                                  solidHeader = T,
                                  width = 12,
                                  title = "Graph"
                                  ),
                              box(status = 'primary',
                                  solidHeader = T,
                                  width = 12,
                                  title = "Summary Statistics"
                                  )
                              )
                          )
                 ),
        tabPanel(title = "Longitudinal Analysis",
                 fluidRow(width = 12,
                          box(status = 'primary',
                              solidHeader = T,
                              width = 3,
                              title = "Measurement and Filters",
                              selectInput(inputId = 'betweenWithin',
                                          label = "Between or Within Treatment Arm?",
                                          choices = c("betweenArms","withinArm"),
                                          selected = "betweenArms"
                                          ),
                              selectInput(inputId = 'selectedValue',
                                          label = 'Laboratory Measurement',
                                          choices = c("alt","crp","iga"),
                                          selected = "ALT"
                                          ),
                              sliderInput(inputId = 'firstBiomarker',
                                          label = "Biomarker 1 Filter",
                                          min = 0,
                                          max = 10,
                                          value = c(0,10)
                                          ),
                              selectInput(inputId = 'secondBiomarker',
                                          label = "Biomarker 2 Filter",
                                          choices = c("all","low","medium","high"),
                                          selected = "all"
                                          ),
                              selectInput(inputId = 'measurementType',
                                          label = 'Type of Aggregation',
                                          choices = c('meanByTimepoint',
                                                      'medianByTimepoint',
                                                      'meanChangeTimepoint',
                                                      'medianChangeTimepoint',
                                                      'meanChangeOverall',
                                                      'medianChangeOverall'),
                                          selected = c('meanByTimePoint')
                                          ),
                              selectInput(inputId = 'graphType',
                                          label = 'Type of Graph',
                                          choices = c('boxPlot',
                                                      'summaryLine',
                                                      'scatter'),
                                          selected = 'boxPlot')
                              ),
                          box(status = 'primary',
                              solidHeader = T,
                              width = 9,
                              title = "Graph and Tables",
                              box(status = 'primary',
                                  solidHeader = T,
                                  width = 12,
                                  title = "Graph"
                                  ),
                              box(status = 'primary',
                                  solidHeader = T,
                                  width = 12,
                                  title = "Tables",
                                  tabBox(width = 12,
                                         tabPanel(title = "Records"),
                                         tabPanel(title = "Summary Statistics")
                                         )
                                  )
                              )
                          )
                 )
      )
    )
  )
)
