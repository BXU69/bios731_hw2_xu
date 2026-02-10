gen_data <- function(n,
                     beta0 = 0,
                     beta_trt = 0,
                     err = c("normal", "t3"),
                     sigma2 = 2,
                     p_trt = 0.5) {
  err <- match.arg(err)
  
  x1 <- rbinom(n, size = 1, prob = p_trt)
  
  if (err == "normal") {
    eps <- rnorm(n, mean = 0, sd = sqrt(sigma2))
  } else {
    nu <- 3
    u <- rt(n, df = nu)
    # scale so Var(eps) = sigma2 (here sigma2=2)
    eps <- u * sqrt(sigma2 * (nu - 2) / nu)
  }
  
  y <- beta0 + beta_trt * x1 + eps
  data.frame(y = y, x1 = x1)
}
