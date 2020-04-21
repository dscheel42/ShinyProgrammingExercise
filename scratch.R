ui <- dashboardPage(
  dashboardHeader(
    title = "Simulated Clinical Trial Shiny Application",
    titleWidth = 300
  ),
  dashboardSidebar(disable = T
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
                              ')
    )
    ),
    fluidRow( 
      tabBox(
        width = 12,
        title = "",
        tabPanel(title = 'Patient Characteristics'),
        tabPanel(title = "Longitudinal Graphs and Tables",
                 fluidRow(
                   width = 12,
                   box(title = "Population Filters",
                       width = 3),
                   tabBox(
                     title = "",
                     tabPanel(title="Across Treatment Arms"),
                     tabPanel(title="Within Treatment Arm"),
                     width = 9
                   )
                 )
        )
      ))))

