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
                                           choices = list("Sex" = "sex",
                                                          "Age" = "age",
                                                          "Race" = "race",
                                                          "ALT" = "ALT",
                                                          "CRP" = "CRP",
                                                          "IGA" = "IGA",
                                                          "Biomarker 1" = "firstBiomarker",
                                                          "Biomarker 2" = "secondBiomarker"
                                                          ),
                                           selected = "age")
                              ),
                          box(status = 'primary',
                              solidHeader = T,
                              width = 9,
                              title = "Graph and Summary Statistics",
                              box(status = 'primary',
                                  solidHeader = T,
                                  width = 12,
                                  title = "Distribution Plot",
                                  plotOutput('selScreeningGraph')
                                  ),
                              box(status = 'primary',
                                  solidHeader = T,
                                  width = 12,
                                  title = "Summary Table",
                                  tableOutput('selScreeningTable')
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
                                          choices = list("Compare Test Type Across Treatment Arms" = "betweenArms",
                                                         "Compare Three Tests Within A Single Treatment Arm" = "withinArm"),
                                          selected = "betweenArms"
                                          ),
                              #need to make this a conditional panel
                              conditionalPanel(condition = "input.betweenWithin == 'withinArm'",
                                selectInput(inputId = 'selTreatmentArm',
                                            label = "Treatment Arm",
                                            choices = list("All" = "All",
                                                           "Placebo" = "placebo",
                                                           "Drug X" = "drugX",
                                                           "Combination" = "combination"),
                                            selected = c("All")
                                            )
                                ),
                              conditionalPanel(condition = "input.betweenWithin == 'betweenArms'",
                                selectInput(inputId = 'selectedValue',
                                            label = 'Laboratory Measurement',
                                            choices = list("Alanine Aminotransferase Measurement" = "ALT",
                                                           "C-Reactive Protein Measurement" = "CRP",
                                                           "Immunoglobulin A Measurement" = "IGA"),
                                            selected = "ALT"
                                            )
                              ),
                              sliderInput(inputId = 'firstBiomarker',
                                          label = "Biomarker 1 Filter",
                                          #values chosen based on observed min/max
                                          min = 0,
                                          max = 23,
                                          value = c(0,23)
                                          ),
                              selectInput(inputId = 'secondBiomarker',
                                          label = "Biomarker 2 Filter",
                                          choices = c("All","Low","Medium","High"),
                                          selected = "All"
                                          ),
                              selectInput(inputId = 'measurementType',
                                          label = 'Type of Aggregation',
                                          choices = list('Average At Each Time Point' = 'meanByTimepoint',
                                                      'Median At Each Time Point' = 'medianByTimepoint',
                                                      'Average Change Between Time Points' = 'meanChangeTimepoint',
                                                      'Median Change Between Time Points' = 'medianChangeTimepoint',
                                                      'Mean Change Across Full Trial' = 'meanChangeOverall',
                                                      'Median Change Across Full Trial' = 'medianChangeOverall'),
                                          selected = 'meanByTimePoint'
                                          ),
                              selectInput(inputId = 'graphTypeLongitudinal',
                                          label = 'Type of Graph',
                                          choices = list("Box Plot" = 'boxPlot',
                                                      "Summary Line" = 'summaryLine',
                                                      "Scatter Plot" = 'scatter'),
                                          selected = 'boxPlot')
                              ),
                          box(status = 'primary',
                              solidHeader = T,
                              width = 9,
                              title = "Graph and Tables",
                              box(status = 'primary',
                                  solidHeader = T,
                                  width = 12,
                                  title = "Plot of Aggregate Measurements Across the Trial",
                                  plotOutput('longitudinalGraph')
                                  ),
                              box(status = 'primary',
                                  solidHeader = T,
                                  width = 12,
                                  title = "Summary Statistics Using The Selected Type of Aggregation",
                                  tableOutput('longitudinalTable')
                                  )
                              )
                          )
                 )
      )
    )
  )
)
