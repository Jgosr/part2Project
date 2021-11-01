#' Hypothesis for linear model
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#'
#' @examples
hypothesis_lm <- function(mydata){
cat("HYPOTHESIS\nThe null hypothesis H0 is beta=0, and the alternative hypothesis H1 is beta different from 0. beta is the true slope parameter as in the model Height = alpha + beta* weight  + epsilon.\n\n" )
}

#' Assumptions for linear model
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @import ggplot2
#' @examples
assumptions_lm <- function(mydata){
  cat("ASSUMPTIONS\nPlease check the plots.\n")
   fit0 <- lm(height ~ weight, data = mydata)
  plot_scatter <- ggplot2::ggplot(mydata, aes(x = weight, y = height)) +
    geom_point() +
    ggtitle("Scatterplot of height vs weight")
  # obtain the residuals in a tidy format with broom
  lm_resid <- broom::augment(fit0)
  # drawing the residual plot
  plot_resid <- ggplot2::ggplot(lm_resid, aes(x = .fitted, y = .resid)) +
    geom_point() +
    ggtitle("Scatterplot of fitted values vs residuals") +
    xlab("Fitted values") + ylab("Residuals")
  # drawing the histogram
  plot_hist <- ggplot2::ggplot(lm_resid) +
    geom_histogram(aes(x = .resid)) +
    ggtitle("Histogram of residuals") +
    xlab("Residuals")
  # Putting the plots in 3 x 1 format with patchwork
  patchwork::wrap_plots(plot_scatter, plot_resid, plot_hist, ncol = 1)
}

#' Fitting for linear model
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @import broom
#' @import dplyr
#' @import magrittr
#' @examples
fit_lm <- function(mydata){
  fit0 <- lm(height ~ weight, data = mydata)

  # Shortcut: using broom::tid, or students can compute all the required results
  summ_fit0 <- broom::tidy(fit0, conf.int = TRUE) %>%
    dplyr::filter(term == "weight")
  cat("\nFIT - Linear regression\n")
  cat("beta_hat = ", summ_fit0$estimate, "\n")
  cat("95% CI = (", summ_fit0$conf.low, ", ", summ_fit0$conf.high, ")\n")
  cat("t_value = ", summ_fit0$statistic, "\n")
  cat("df = ", broom::glance(fit0)$df.residual, "\n")
  cat("p_value = ", summ_fit0$p.value, "\n")
  # Create output object
  myfit <- list(beta_hat = summ_fit0$estimate, p_val = summ_fit0$p.value,
                name = "weight")
  class(myfit) <- "mylm"
  return(myfit)
}

#' Decision for linear model
#'
#' @param myfit a linear model
#'
#' @return
#' @export
#' @examples
decision_mylm <- function(myfit){
  cat("DECISION\n")
  p_val <- myfit$p_val
  if (p_val>=0.05) {
    decision <- "Do not reject NULL hypothesis"
  } else {
    decision <- "Reject NULL hypothesis"
  }
  cat(decision, "\n\n")
}



#' Conclusion for linear model
#'
#' @param myfit a linear model
#'
#' @return
#' @export
#' @examples
conclusion_mylm <- function(myfit){
  beta_hat <- myfit$beta_hat
  p_val <- myfit$p_val
  name <- myfit$name
  cat("CONCLUSION\n")
  if (p_val >= 0.05) {
    conclusion <- glue::glue("There is no evidence that the slope (beta) is different than 0. There is no significant linear relationship between height and weight.")
  } else {
    in_decrease <- ifelse(beta_hat > 0, "increases", "decreases")
    conclusion <- glue::glue("There is evidence that the slope (beta) is different than 0. There is a significant linear relationship between height and weight. For each unit-increse in height, weight {in_decrease} by {round(abs(beta_hat),4)}.")
  }
  cat(conclusion, "\n")
}

#' Wrapper for linear model
#'
#' @param mydata a dataframe
#'
#' @return
#' @export
#' @examples
mytest_lm <- function(mydata){
  out <- list()
  out$hypothesis <- hypothesis_lm(mydata)
  # ggplot are treated as objects in R.
  # It needs an explicit call to print for it to show up as a plot
  out$assumptions <- print(assumptions_lm(mydata))
  out$fit <- fit_lm(mydata)
  out$decision <- decision_mylm(fit_lm(mydata))
  out$conclusion <- conclusion_mylm(fit_lm(mydata))
  out
}

