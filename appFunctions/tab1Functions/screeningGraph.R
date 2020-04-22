screeningGraph = function(screeningData,
                          globalCovariate,
                          selCovariate,
                          graphType){
  #Four cases based on whether the user has selected to include a global (Overall) calculation
  #and the covariate class
  if(class(screeningData[[selCovariate]]) == 'numeric'){
    if(globalCovariate == "Yes"){
      p <- ggplot(data = screeningData, aes_string(x = selCovariate, colour = "treatmentArm")) +
        geom_density() +
        geom_density(aes(colour = "All Treatment Groups")) +
        scale_colour_discrete(name = 'Treatment Arm')
    }else if(globalCovariate == "No"){
      p <- ggplot(data = screeningData, aes_string(x = selCovariate, colour = "treatmentArm")) +
        geom_density() +
        scale_colour_discrete(name = 'Treatment Arm')
    }
  }else if(class(screeningData[[selCovariate]]) == 'factor'){
    if(globalCovariate == "Yes"){
      p <- ggplot(data = screeningData, aes_string(x = "treatmentArm",fill = selCovariate)) +
        geom_bar(position = 'fill')  +
        geom_bar(aes(x = "All Treatment Groups"),position='fill') + 
        theme(axis.text.x = element_text(angle = 15))
    }else if(globalCovariate == "No"){
      p <- ggplot(data = screeningData, aes_string(x = "treatmentArm",fill = selCovariate)) +
        geom_bar(position = 'fill') + 
        theme(axis.text.x = element_text(angle = 15))
    }
  }
  return(p)
}