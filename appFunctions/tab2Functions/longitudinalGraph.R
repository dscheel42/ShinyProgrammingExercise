longitudinalGraph = function(filteredData,selectedValue,measurementType,graphTypeLongitudinal){
  if(measurementType %in% c('meanByTimepoint','medianByTimepoint')){
    selectedValue = selectedValue
  }else if(measurementType %in% c('meanChangeTimepoint','medianChangeTimepoint')){
    selectedValue = paste("diff",selectedValue,sep="")
  }else if(measurementType %in% c('meanChangeOverall','medianChangeOverall')){
    selectedValue = paste("endDiffBaseline",selectedValue,sep="")
  }
  if(graphTypeLongitudinal == 'boxPlot'){
    longGraph = ggplot(data = filteredData, aes_string(x = "daysFromBaseline",
                                                       y = selectedValue,
                                                       colour = "treatmentArm")
                       ) +
      geom_boxplot()
  }else if(graphTypeLongitudinal == 'scatter'){
    longGraph = ggplot(data = filteredData, aes_string(x = "daysFromBaseline",
                                                       y = selectedValue,
                                                       colour = "treatmentArm")
                       ) +
      geom_point()
  }else if(graphTypeLongitudinal == 'summaryLine'){
    longGraph = ggplot(data = filteredData, aes_string(x = "daysFromBaseline",
                                                       y = selectedValue,
                                                       colour = "treatmentArm",
                                                       group = "treatmentArm")
                       ) +
      stat_summary(fun = 'mean',geom='point') +
      stat_summary(fun = 'mean',geom='line')
  }
  if(selectedValue == "ALT"){
    ylabel = "ALT U/L"
  }else if(selectedValue == "CRP"){
    ylabel = "CRP mg/L"
  }else if(selectedValue == "IGA"){
    ylabel = "IGA g/L"
  }
  
  longGraph = longGraph  +
    scale_colour_discrete(name = 'Treatment Arm') +
    xlab('Days From Baseline') +
    ylab(ylabel)
  return(longGraph)
}
