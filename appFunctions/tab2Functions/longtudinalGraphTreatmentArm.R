createArmFrame = function(measurementType,filteredData){
  if(measurementType %in% c('meanByTimepoint','medianByTimepoint')){
    armFrame = rbind(data.frame("LabTest"="ALT","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$ALT),
                     data.frame("LabTest"="CRP","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$CRP),
                     data.frame("LabTest"="IGA","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$IGA)
                     )
  }else if(measurementType %in% c('meanChangeTimepoint','medianChangeTimepoint')){
    armFrame = rbind(data.frame("LabTest"="ALT","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$diffALT),
                     data.frame("LabTest"="CRP","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$diffCRP),
                     data.frame("LabTest"="IGA","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$diffIGA)
                     )
  }else if(measurementType %in% c('meanChangeOverall','medianChangeOverall')){
    armFrame = rbind(data.frame("LabTest"="ALT","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$endDiffBaselineALT),
                     data.frame("LabTest"="CRP","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$endDiffBaselineCRP),
                     data.frame("LabTest"="IGA","daysFromBaseline"=filteredData$daysFromBaseline,"LabValue"=filteredData$endDiffBaselineIGA)
                     )
  }
  return(armFrame)
}

longitudinalGraphArm = function(filteredData,graphTypeLongitudinal){
  if(graphTypeLongitudinal == 'boxPlot'){
    longGraph = ggplot(data = filteredData, aes_string(x = "daysFromBaseline",
                                                       y = "LabValue",
                                                       colour = "LabTest")
                       ) +
      geom_boxplot()
  }else if(graphTypeLongitudinal == 'scatter'){
    longGraph = ggplot(data = filteredData, aes_string(x = "daysFromBaseline",
                                                       y = "LabValue",
                                                       colour = "LabTest")
                       ) +
      geom_point()
  }else if(graphTypeLongitudinal == 'summaryLine'){
    longGraph = ggplot(data = filteredData, aes_string(x = "daysFromBaseline",
                                                       y = "LabValue",
                                                       colour = "LabTest",
                                                       group = "LabTest")
                       ) +
      stat_summary(fun.y = 'mean',geom='point') +
      stat_summary(fun.y = 'mean',geom='line')
  }
  return(longGraph)
}