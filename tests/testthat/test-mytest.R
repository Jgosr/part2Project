data(project)
out_lm <- mytest_lm(project)
out_ttest <- mytest_ttest(project)
out_chisq <- mytest_chisq(project)
test_that("Correct Output", {
  expect_true(is.list(out_lm))
  expect_true(is.list(out_ttest))
  expect_true(is.list(out_chisq))
})
