screeningTable = function(screeningData = screeningFrame,globalCovariate,selCovariate){
  selCovariate = rlang::sym(selCovariate)
  if(class(screeningData[[selCovariate]]) == 'numeric'){
    if(globalCovariate == "Yes"){
      byArmSummary = screeningFrame %>%
        group_by(treatmentArm) %>%
        summarise('Mean' = mean(!!selCovariate),
                  'Standard Deviation' = sd(!!selCovariate),
                  'Median' = median(!!selCovariate),
                  'Minimum' = min(!!selCovariate),
                  'Maximum' = max(!!selCovariate),
                  'Total Patients' = n()
        ) %>%
        mutate_if(is.numeric,function(x){round(x,2)})
      
      overallSummary = screeningFrame %>%
        summarise('treatmentArm' = 'Overall',
                  'Mean' = mean(!!selCovariate),
                  'Standard Deviation' = sd(!!selCovariate),
                  'Median' = median(!!selCovariate),
                  'Minimum' = min(!!selCovariate),
                  'Maximum' = max(!!selCovariate),
                  'Total Patients' = n()
        ) %>%
        mutate_if(is.numeric,function(x){round(x,2)})
      
      screenTable = rbind(overallSummary,byArmSummary)
      
    }else if(globalCovariate == "No"){
      screenTable = screeningFrame %>%
        group_by(treatmentArm) %>%
        summarise('Mean' = mean(!!selCovariate),
                  'Standard Deviation' = sd(!!selCovariate),
                  'Median' = median(!!selCovariate),
                  'Minimum' = min(!!selCovariate),
                  'Maximum' = max(!!selCovariate),
                  'Total Patients' = n()
        ) %>%
        mutate_if(is.numeric,function(x){round(x,2)})
    }
  }else if(class(screeningData[[selCovariate]]) == 'factor'){
    if(globalCovariate == "Yes"){
      byArmTable = round(prop.table(table(screeningFrame[['treatmentArm']],screeningFrame[[selCovariate]])),3)
      overallTable = round(prop.table(table(screeningFrame[[selCovariate]])),3)
      screenTable = rbind(byArmTable,overallTable)
    }else if(globalCovariate == "No"){
      screenTable = round(prop.table(table(screeningFrame[['treatmentArm']],screeningFrame[[selCovariate]])),3)
    }
  }
  return(screenTable)
}

