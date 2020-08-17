
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Geographically Weighted Poisson Regression

<!-- badges: start -->

<!-- badges: end -->

## Installation

You can install the package from
[GitHub](https://github.com/hoxo-m/gwpr).

``` r
install.packages("remotes") # if you have not installed "remotes" package
remotes::install_github("hoxo-m/gwpr")
```

## Example

``` r
set.seed(123)
df <- lctools::random.test.data(10, 10, 2, "poisson")
head(df)
#>   dep      vars X Y
#> 1   5 0.2387260 1 1
#> 2   9 0.9623589 1 2
#> 3   6 0.6013657 1 3
#> 4  10 0.5150297 1 4
#> 5  11 0.4025733 1 5
#> 6   3 0.8802465 1 6
```

``` r
library(gwpr)
df_coord <- df[c("X", "Y")]
params <- gwpr(df, dep ~ vars, df_coord,
               kernel = "gaussian", band_width = 3)
```

``` r
library(ggplot2)
df_gg <- cbind(params, df_coord)
ggplot(df_gg, aes(X, Y)) + geom_raster(aes(fill = vars)) +
  scale_fill_gradient2()
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="400" />

### Change bandwidth

``` r
params_bw1 <- gwpr(df, dep ~ vars, df_coord,
                   kernel = "gaussian", band_width = 1)
```

``` r
df_gg_bw1 <- cbind(params_bw1, df_coord)

p1 <- ggplot(df_gg_bw1, aes(X, Y)) + geom_raster(aes(fill = vars)) +
  scale_fill_gradient2() + ggtitle("bandwidth = 1")
p2 <- ggplot(df_gg, aes(X, Y)) + geom_raster(aes(fill = vars)) +
  scale_fill_gradient2() + ggtitle("bandwidth = 3")

cowplot::plot_grid(p1, p2)
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="800" />
