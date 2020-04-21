names(drugXFrame)

longitudinalFrameArm(newFrame,measurementType = "medianByTimepoint")

longitudinalFrameArm = function(filteredData,measurementType){
  if(length(grep("mean",measurementType)) > 0){
    summaryFrame = filteredData %>%
      group_by(daysFromBaseline,LabTest) %>%
      summarise(avgValue = mean(LabValue))
    summaryFrame = round(reshape2::acast(summaryFrame,
                                         LabTest ~ daysFromBaseline,
                                         value.var = 'avgValue'),
                         3)
    
  }else if(length(grep("median",measurementType)) > 0){
    summaryFrame = filteredData %>%
      group_by(daysFromBaseline,LabTest) %>%
      summarise(medianValue = median(LabValue))
    summaryFrame = round(reshape2::acast(summaryFrame,
                                         LabTest ~ daysFromBaseline,
                                         value.var = 'medianValue'),
                         3)
    
  }
  return(summaryFrame)
}
