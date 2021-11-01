#' Hypothesis for chi squared
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#'
#' @examples
hypothesis_chisq <- function(mydata){
  cat("HYPOTHESIS\nThe null hypothesis H0 is there is no difference between gender and physical activity, and the alternative hypothesis H1 is that there is a relationship between gender and physical activity.")
}


#' Assumptions for chi square
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @import ggplot2
#' @examples
assumptions_chisq <- function(mydata){
  cat("ASSUMPTIONS\nPlease check the plots.\n")
  # drawing the histogram
  mydata2 <- as.data.frame(table(mydata$gender, mydata$phys))
  colnames(mydata2) <- c("gender", "phys", "count")
  mybar <- ggplot2::ggplot(mydata2,aes(x = gender, y=count, fill=phys, group=phys)) +
    geom_col(stat='identity', position='dodge')
  mybar
}



#' Fitting for chi square
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @examples
fit_chisq <- function(mydata){
  fit0 <- chisq.test(table(mydata$gender, mydata$phys),correct=FALSE)
  # Shortcut: using broom::tid, or students can compute all the required results
  cat("\nFIT - Chi Squared Test\n")
  cat("Chi Squared Test = ", fit0$statistic, "\n")
  cat("p_value = ", fit0$p.value, "\n")
  cat("df = ",fit0$parameter, "\n")

  # Create output object
  myfit <- list(x_stat =  fit0$statistic, p_val = fit0$p.value)
  return(myfit)
}


#' Decision for Chi Squared Test
#'
#' @param myfit a Chi Squared Test
#'
#' @return
#' @export
#' @examples
decision_chisq <- function(myfit){
  cat("DECISION\n")
  p_val <- myfit$p_val
  if (p_val>=0.05) {
    decision <- "Do not reject NULL hypothesis"
  } else {
    decision <- "Reject NULL hypothesis"
  }
  cat(decision, "\n\n")
}



#' Conclusion for Chi Squared Test
#'
#' @param myfit a Chi Squared Test
#'
#' @return
#' @export
#' @examples
conclusion_chisq <- function(myfit){
  x_stat <- myfit$x_stat
  p_val <- myfit$p_val
  cat("CONCLUSION\n")
  if (p_val >= 0.05) {
    conclusion <- glue::glue("There is no significant relationship between physical activity and gender")
  } else {
    conclusion <- glue::glue("There is a significant relationship between physical activity and gender.")
  }
  cat(conclusion, "\n")
}

#' Wrapper for Chi Squared Test
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @examples
mytest_chisq <- function(mydata){
  out <- list()
  out$hypothesis <- hypothesis_chisq(mydata)
  # ggplot are treated as objects in R.
  # It needs an explicit call to print for it to show up as a plot
  out$assumptions <- print(assumptions_chisq(mydata))
  out$fit <- fit_chisq(mydata)
  out$decision <- decision_chisq(fit_lm(mydata))
  out$conclusion <- conclusion_chisq(fit_chisq(mydata))
  out
}

