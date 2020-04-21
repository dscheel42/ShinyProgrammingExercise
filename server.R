function(session,input,output){
  #Tab1 Patient Screening Characteristics
  output$selScreeningGraph = renderPlot({
    #screeningFrame is included in global
    screeningGraph(screeningData = screeningFrame,
                   globalCovariate = input$globalCovariate,
                   selCovariate = input$selCovariate)
  })
  output$selScreeningTable = renderTable({
    screeningTable(screeningData = screeningFrame,
                   globalCovariate = input$globalCovariate,
                   selCovariate = input$selCovariate)
  },
  rownames = T)
}

