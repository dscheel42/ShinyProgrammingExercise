screeningTable = function(screeningData = screeningFrame,globalCovariate,selCovariate,
                          countOrProportion){
  if(class(screeningData[[selCovariate]]) == 'numeric'){
    selCovariate = rlang::sym(selCovariate)
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
        summarise('treatmentArm' = 'All Treatment Groups',
                  'Mean' = mean(!!selCovariate),
                  'Standard Deviation' = sd(!!selCovariate),
                  'Median' = median(!!selCovariate),
                  'Minimum' = min(!!selCovariate),
                  'Maximum' = max(!!selCovariate),
                  'Total Patients' = n()
        ) %>%
        mutate_if(is.numeric,function(x){round(x,2)})
      
      screenTable = rbind(overallSummary,byArmSummary)
      rownames(screenTable) = screenTable[,1]
      screenTable = screenTable[,-1]
      
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
      
      rownames(screenTable) = screenTable[,1]
      screenTable = screenTable[,-1]
    }
  }else if(class(screeningData[[selCovariate]]) == 'factor'){
    byArmTableCount = table(screeningFrame[['treatmentArm']],screeningFrame[[selCovariate]])
    overallTableCount = table(screeningFrame[[selCovariate]])
    byArmTableProportion = round(prop.table(margin = 1, byArmTableCount),3)
    overallTableProportion = round(prop.table(overallTableCount),3)    
    if(globalCovariate == "Yes"){
      if(countOrProportion == "Proportion"){
        screenTable = rbind(overallTableProportion,byArmTableProportion)
        rownames(screenTable)[1] = "Overall Proportion"
      }else{
        screenTable = rbind(overallTableCount,byArmTableCount)
        rownames(screenTable)[1] = "Overall"
      }
    }else if(globalCovariate == "No"){
      if(countOrProportion == "Proportion"){
        screenTable = byArmTableProportion
      }else{
        screenTable = byArmTableCount
      }
    }
  }
  return(screenTable)
}

