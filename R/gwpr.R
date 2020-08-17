#' @export
gwpr <- function(df, formula, df_coord, offset = rep(1L, N),
                 kernel = c("gaussian"), bandwidth = 1,
                 max_iter = 100L, tot = 1e-5) {
  target_name <- formula[[2]]

  O <- df[[target_name]]
  X <- model.matrix(formula, df)

  N <- nrow(X)
  K <- ncol(X)

  beta <- matrix(rnorm(K), ncol = 1L)
  beta[1] <- sum(O) / sum(offset)

  pb <- txtProgressBar(0L, N, style = 3L)
  params <- matrix(nrow = 0, ncol = K)
  for (i in seq_len(N)) {
    ui <- df_coord[i, ]
    w <- apply(df_coord, 1, function(uj) kernel_Gaussian(ui, uj, bandwidth))
    W <- diag(w)
    tXW <- t(X) %*% W

    iter <- 1L
    while (iter < max_iter) {
      eta <- X %*% beta
      Ohat <- offset * exp(eta)
      A <- diag(as.vector(Ohat))
      z <- eta + (O - Ohat) / Ohat

      tXWA <- tXW %*% A
      beta_next <- solve(tXWA %*% X) %*% tXWA %*% z

      diff <- beta_next - beta
      beta <- beta_next
      if (all(diff < tot)) break
      iter <- iter + 1L
    }
    if (iter >= max_iter) {
      warning()
    }
    params <- rbind(params, t(beta))
    setTxtProgressBar(pb, i)
  }
  params
}

squared_euclid_distance <- function(x, y) {
  sum((x - y) ^ 2)
}

kernel_Gaussian <- function(x, y, sigma) {
  exp(-squared_euclid_distance(x, y) / (2 * sigma * sigma))
}
