#' Hypothesis for t test
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#'
#' @examples
hypothesis_ttest <- function(mydata){
  cat("HYPOTHESIS\nThe null hypothesis H0 whereby there in no difference between the mean height of male and female, and the alternative hypothesis H1 whereby there is a differnce in the mean height of male and female." )
}



#' Assumptions for t test
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @import ggplot2
#' @examples
assumptions_ttest <- function(mydata){
  cat("ASSUMPTIONS\nPlease check the plots.\n")
  plot_box <- ggplot2::ggplot(mydata, aes(x = height, y = gender)) +
    geom_boxplot() +
    ggtitle("Boxplot of height vs gender")
  # drawing the histogram
  plot_hist <- ggplot2::ggplot(mydata,aes(x = height)) +
    geom_histogram() +
    ggtitle("Histogram of height")
  # Putting the plots in 3 x 1 format with patchwork
  patchwork::wrap_plots(plot_box, plot_hist, ncol = 1)
}


#' Fitting for T Test
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @examples
fit_ttest <- function(mydata){
  fit0 <- t.test(height ~ gender, data=project)
  # Shortcut: using broom::tid, or students can compute all the required results
  cat("\nFIT - T Test\n")
  cat("T Stat = ", fit0$statistic, "\n")
  cat("95% CI = (", fit0$conf.int[1], ", ", fit0$conf.int[2], ")\n")
  cat("p_value = ", fit0$p.value, "\n")
  cat("mean_female = ", fit0$estimate[1], ", mean_male = ", fit0$estimate[2],"\n")

  # Create output object
  myfit <- list(t_stat =  fit0$statistic, p_val = fit0$p.value)
  class(myfit) <- "mylm"
  return(myfit)
}



#' Decision for T Test
#'
#' @param myfit a T Test
#'
#' @return
#' @export
#' @examples
decision_ttest <- function(myfit){
  cat("DECISION\n")
  p_val <- myfit$p_val
  if (p_val>=0.05) {
    decision <- "Do not reject NULL hypothesis"
  } else {
    decision <- "Reject NULL hypothesis"
  }
  cat(decision, "\n\n")
}



#' Conclusion for T Test
#'
#' @param myfit a linear model
#'
#' @return
#' @export
#' @examples
conclusion_ttest <- function(myfit){
  t_stat <- myfit$t_stat
  p_val <- myfit$p_val
  cat("CONCLUSION\n")
  if (p_val >= 0.05) {
    conclusion <- glue::glue("There is no significant difference between the mean height of males and females")
  } else {
    conclusion <- glue::glue("There is a significant difference between height and gender.")
  }
  cat(conclusion, "\n")
}

#' Wrapper for T Test
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @examples
mytest_ttest <- function(mydata){
  out <- list()
  out$hypothesis <- hypothesis_ttest(mydata)
  # ggplot are treated as objects in R.
  # It needs an explicit call to print for it to show up as a plot
  out$assumptions <- print(assumptions_ttest(mydata))
  out$fit <- fit_ttest(mydata)
  out$decision <- decision_ttest(fit_lm(mydata))
  out$conclusion <- conclusion_ttest(fit_ttest(mydata))
  out
}


