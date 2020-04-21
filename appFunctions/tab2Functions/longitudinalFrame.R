longitudinalFrame = function(filteredData,selectedValue,measurementType){
  if(measurementType %in% c('meanByTimepoint','medianByTimepoint')){
    selectedValue = selectedValue
  }else if(measurementType %in% c('meanChangeTimepoint','medianChangeTimepoint')){
    selectedValue = paste("diff",selectedValue,sep="")
  }else if(measurementType %in% c('meanChangeOverall','medianChangeOverall')){
    selectedValue = paste("endDiffBaseline",selectedValue,sep="")
  }
  selectedValue = rlang::sym(selectedValue)
  if(length(grep("mean",measurementType)) > 0){
    summaryFrame = filteredData %>%
      group_by(daysFromBaseline,treatmentArm) %>%
      summarise(avgValue = mean(!!selectedValue))
    summaryFrame = round(reshape2::acast(summaryFrame,
                                         treatmentArm ~ daysFromBaseline,
                                         value.var = 'avgValue'),
                         3)
    
  }else if(length(grep("median",measurementType)) > 0){
    summaryFrame = filteredData %>%
      group_by(daysFromBaseline,treatmentArm) %>%
      summarise(medianValue = median(!!selectedValue))
    summaryFrame = round(reshape2::acast(summaryFrame,
                                         treatmentArm ~ daysFromBaseline,
                                         value.var = 'medianValue'),
                         3)
    
  }
  return(summaryFrame)
}