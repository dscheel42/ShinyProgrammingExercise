screeningGraph = function(screeningData,globalCovariate,selCovariate,graphType){
  if(class(screeningData[[selCovariate]]) == 'numeric'){
    if(globalCovariate == "Yes"){
      p <- ggplot(data = screeningData, aes_string(x = selCovariate, colour = "treatmentArm")) +
        geom_density() +
        geom_density(aes(colour = "Overall"))
    }else if(globalCovariate == "No"){
      p <- ggplot(data = screeningData, aes_string(x = selCovariate, colour = "treatmentArm")) +
        geom_density()
    }
  }else if(class(screeningData[[selCovariate]]) == 'factor'){
    if(globalCovariate == "Yes"){
      p <- ggplot(data = screeningData, aes_string(x = "treatmentArm",fill = selCovariate)) +
        geom_bar(position = 'fill')  +
        geom_bar(aes(x = "Overall"),position='fill')
    }else if(globalCovariate == "No"){
      p <- ggplot(data = screeningData, aes_string(x = "treatmentArm",fill = selCovariate)) +
        geom_bar(position = 'fill')
    }
  }
  return(p)
}