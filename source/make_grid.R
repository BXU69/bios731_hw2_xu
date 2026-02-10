make_grid <- function() {
  tidyr::expand_grid(
    n = c(10, 50, 500),
    beta_trt = c(0, 0.5, 2),
    err = c("normal", "t3")
  )
}
