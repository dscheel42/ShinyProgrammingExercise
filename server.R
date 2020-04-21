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
  
  filteredData = reactive({
    selFrame = noScreenFrame %>% 
      filter(firstBiomarker >= input$firstBiomarker[1], firstBiomarker <= input$firstBiomarker[2])
    if(input$secondBiomarker != "All"){
      selFrame = selFrame %>%
        filter(tolower(secondBiomarker) == tolower(input$secondBiomarker))
    }
    if(input$measurementType %in% c("meanChangeOverall","medianChangeOverall")){
      selFrame = selFrame %>%
        filter(daysFromBaseline == '28')
    }
    if(input$betweenWithin == 'withinArm' & input$selTreatmentArm != "All"){
      selFrame = selFrame %>%
        filter(treatmentArm == input$selTreatmentArm)
    }
    selFrame
  })
  
  #Tab2 Longitudinal Analysis
  output$longitudinalGraph = renderPlot({
    if(input$betweenWithin == "betweenArms"){
      p=longitudinalGraph(filteredData = filteredData(),
                      selectedValue = input$selectedValue,
                      measurementType = input$measurementType,
                      graphTypeLongitudinal = input$graphTypeLongitudinal
                      )
    }else if(input$betweenWithin == "withinArm"){
      armFrame = createArmFrame(measurementType = input$measurementType,
                                filteredData = filteredData()
                                )
      p=longitudinalGraphArm(filteredData = armFrame,
                             graphTypeLongitudinal=input$graphTypeLongitudinal
                             )      
    }
    p
  })
  
  output$longitudinalTable = renderTable({
    if(input$betweenWithin == "betweenArms"){
      p = longitudinalFrame(filteredData = filteredData(),
                            selectedValue = input$selectedValue,
                            measurementType = input$measurementType
                            )
    }else if(input$betweenWithin == "withinArm"){
      armFrame = createArmFrame(measurementType = input$measurementType,
                                filteredData = filteredData()
                                )
      p = longitudinalFrameArm(filteredData = armFrame,
                               measurementType = input$measurementType
                               )
    }
    p
  },
  rownames = T,
  caption = "Days From Baseline",
  caption.placement = "top")
}