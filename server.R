function(session,input,output){
  #Tab1 Patient Screening Characteristics
  output$selScreeningGraph = renderPlot({
    #screeningFrame is included in global
    screeningGraph(screeningData = screeningFrame,
                   globalCovariate = input$globalCovariate,
                   selCovariate = input$selCovariate)
  })
  
  output$graphTitle = renderText({
    paste("Distribution Plot of ",input$selCovariate," Across Treatment Arms",sep = "")
  })
  
  output$tableTitle = renderText({
    paste("Summary Table for ", input$selCovariate)
  })
  
  output$selScreeningTable = renderDataTable(
    datatable(screeningTable(screeningData = screeningFrame,
                   globalCovariate = input$globalCovariate,
                   selCovariate = input$selCovariate,
                   countOrProportion = input$countOrProportion),
    options = list(searching = FALSE, paging = FALSE))
  )
  
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
  
  output$graphLongitudinalTitle = renderText({
    if(input$betweenWithin == "betweenArms"){
      paste("Graph of ", names(which(aggList == input$measurementType)), " for ",
          input$selectedValue, " Across Treatment Groups", sep = "")
    }else if(input$betweenWithin == "withinArm"){
      paste("Graph of ", names(which(aggList == input$measurementType)), " for ",
            "Lab Measurements in ", input$selTreatmentArm, sep = "")
      }
  })
  
  output$tableLongitudinalTitle = renderText({
    if(input$betweenWithin == "betweenArms"){
      paste("Table of ", names(which(aggList == input$measurementType)), " for ",
          input$selectedValue, "Across Treatment Groups", sep = "")
    }else if(input$betweenWithin == "withinArm"){
      paste("Table of ", names(which(aggList == input$measurementType)), " for ",
            "Lab Measurements in ", input$selTreatmentArm, sep = "")      
    }
  })
  
  aggList = list('Average At Each Time Point' = 'meanByTimepoint',
       'Median At Each Time Point' = 'medianByTimepoint',
       'Average Change Between Time Points' = 'meanChangeTimepoint',
       'Median Change Between Time Points' = 'medianChangeTimepoint',
       'Mean Change Across Full Trial' = 'meanChangeOverall',
       'Median Change Across Full Trial' = 'medianChangeOverall')  
    
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
  
  output$longitudinalTable = renderDataTable({
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
    colnames(p) = c("Day 0","Day 7","Day 14","Day 21", "Day 28")
    datatable(p,options = list(searching = FALSE, paging = FALSE,sorting = F))})
}