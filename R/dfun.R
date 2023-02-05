# Temporary code to supplement distributional to plot distributions using chart()

#library(distributional)
#N1 <- dist_normal(mu = 1, sigma = 1.5)
#N1
#class(N1)
#family(N1)
#mean(N1)
#sqrt(variance(N1))
#stddev(N1)
#stddev <- function(x, ...)
#  UseMethod("stddev")
#
#stddev.default <- function(x, ...) {
#  stop("The stddev() method is not supported for objects of type ",
#    paste(deparse(class(x)), collapse = ""))
#}
#
#stddev.distribution <- function(x, ...)
#  sqrt(variance(x, ...))
#
# TODO: also tidy() and glance()
#augment.distribution <- function(x, at = NULL, ...) {
#  if (is.null(at)) {
#    range <- quantile(x, c(0.001, 0.999)) |> unlist() |> range()
#    # If range[1] is very close to 0, put it at zero
#    if (range[1] > 0 && range[1] < 0.001)
#      range[1] <- 0
#    at <- seq(from = range[1], to = range[2], length.out = 100L)
#  }
#  dens <- density(x, at = at) |> as_dtf()
#  l <- length(dens)
#  if (l == 1) {
#    names(dens) <- "density"
#  } else {
#    names(dens) <- paste0("density", c("", 2:l))
#  }
#
#  attr(dens, "dist") <- format(x)
#  dtx(quantile = at, dens)
#}

#' Create and plot density functions for distribution objects
#'
#' The **distribution** objects represnet one or more statistical distributions.
#' The functions [dfun()] and [geom_funfill()], together with [chart()] allow to
#' plot them.
#'
#' @param object A **distribution** object, as from the {distributional} package.
#' @param i The distribution to use from the list (first one by default)
#' @param n The number of points to use to draw the density functions (500 by
#'   default) of continuous distributions.
#' @param xlim Two numbers that limit the X axis.
#' @param size If `xlim=` is not provided, it is automatically calculated using
#'   the size of the CI between 0 and 100 (99.5 by default) for continuous
#'   distributions.
#' @param xlab The label of the X axis ("Quantile" by default).
#' @param ylab The label of the Y axis ("Probability density" or "Cumulative probability density" by default).
#' @param plot.it Should the densities be plotted for all the distributions
#'   (`TRUE` by default)?
#' @param use.chart Should [chart()] be used (`TRUE` by default)? Otherwise,
#'   [ggplot()] is used.
#' @param type The type of plot ("density" by default, or "cumulative").
#' @param theme The theme for the plot (ignored for now).
#' @param env The environment to use to evaluate expressions.
#' @param ... Further arguments to [stat_function()].
#' @param mapping the mapping to use (`NULL` by default.
#' @param data The data frame to use (`NULL` by default).
#' @param fun The function to use (could be `dfun(distribution_object)`).
#' @param from The first quantile to delimit the filled area.
#' @param to The second quantile to delimit the filled area.
#' @param geom The geom to use (`"area"` by default).
#' @param fill The color to fill the area (`"salmon"` by default).
#' @param alpha The alpha transparency to apply, 0.5 by default.
#'
#' @return Either a function or a ggplot object.
#' @export
#'
#' @examples
#' library(distributional)
#' library(chart)
#' di1 <- dist_normal(mu = 1, sigma = 1.5)
#' chart(di1) +
#'   geom_funfill(fun = dfun(di1), from = -5, to = 1)
#'
#' # With two distributions
#' di2 <- c(dist_normal(10, 1), dist_student_t(df = 3, 13, 1))
#' chart(di2) +
#'   geom_funfill(fun = dfun(di2, 1), from = -5, to = 0) +
#'   geom_funfill(fun = dfun(di2, 2), from = 2, to = 6, fill = "turquoise3")
#' chart$cumulative(di2)
#' # A discrete distribution
#' di3 <- dist_binomial(size = 7, prob = 0.5)
#' chart(di3)
#' chart$cumulative(di3)
#' # A continuous together with a discrete distribution
#' di4 <- c(dist_normal(mu = 4, sigma = 2), dist_binomial(size = 8, prob = 0.5))
#' chart(di4)
#' chart$cumulative(di4)
dfun <- function(object, i = 1) {
  function(x) density(object[[i]], at = x)[[1]]
}

#' @export
#' @rdname dfun
cdfun <- function(object, i = 1) {
  function(x) cdf(object[[i]], q = x)[[1]]
}

#' @export
#' @rdname dfun
autoplot.distribution <- function(object, n = 500, xlim = NULL, size = 99.5,
xlab = "Quantile", ylab = if (type == "density") "Probability density" else "Cumulative probability density",
plot.it = TRUE, use.chart = FALSE, ..., type = "density", theme = NULL) {
  if (is.null(xlim)) {
    #xlim <- unclass(hilo(object, size = size))[1:2] |> unlist() |> range()
    xlim <- quantile(object,
      p = c((1 - size/100) / 2, 1 - (1 - size/100) / 2)) |> unlist() |> range()
    xlim2 <- unclass(support(object))$lim |> unlist()
    xlim2 <- xlim2[is.finite(xlim2)]
    if (length(xlim2)) {
      xlim2 <- range(xlim2)
      xlim <- range(c(xlim, xlim2[1] - 1, xlim2[2] + 1))
    }
  }
  if (isTRUE(use.chart)) {
    fun <- chart::chart
  } else {
    fun <- ggplot2::ggplot
  }
  if (type == "density") {
    densfun <- dfun
    dens <- density
  } else if (type == "cumulative") {
    densfun <- cdfun
    dens <- function(x, at, ...) cdf(x, q = at, ...)
  } else stop("type must be 'density' or 'cumulative'")
  res <- fun(data = NULL, mapping = aes()) +
    xlim(xlim[1], xlim[2]) +
    xlab(xlab) +
    ylab(ylab)
  if (isTRUE(plot.it)) {
    prob <- NULL # This is to avoid an error in R CMD check
    l <- length(object)
    if (l == 1) {
      dist_sup <- unclass(support(object))
      dist_discrete <- is.integer(dist_sup$x[[1]])
      if (dist_discrete) {
        dist_range <- dist_sup$lim[[1]]
        if (!is.finite(dist_range[1]))
          dist_range[1] <- xlim[1]
        if (!is.finite(dist_range[2]))
          dist_range[2] <- xlim[2]
        # Generate a table with quantiles and probabilities
        dist_data <- data.frame(quantile =
            seq(from = dist_range[1], to = dist_range[2]))
        dist_data$prob <- dens(object, at = dist_data$quantile)[[1]]
        res <- res + geom_segment(aes(x = quantile, xend = quantile, y = 0,
          yend = prob), data = dist_data)
      } else {# Continuous distribution
        res <- res + geom_function(fun = densfun(object), n = n, ...)
      }
    } else {
      dist_names <- format(object)
      dist_sup <- unclass(support(object))
      for (i in 1:length(object)) {
        dist <- dist_names[[i]]
        # Is the distribution discrete or continuous?
        dist_discrete <- is.integer(dist_sup$x[[i]])
        if (dist_discrete) {
          dist_range <- dist_sup$lim[[i]]
          if (!is.finite(dist_range[1]))
            dist_range[1] <- xlim[1]
          if (!is.finite(dist_range[2]))
            dist_range[2] <- xlim[2]
          # Generate a table with quantiles and probabilities
          dist_data <- data.frame(quantile =
            seq(from = dist_range[1], to = dist_range[2]))
          dist_data$prob <- dens(object[[i]], at = dist_data$quantile)[[1]]
          res <- res + geom_segment(aes(x = quantile, xend = quantile, y = 0,
            yend = prob, colour = {{dist}}), data = dist_data)

        } else {# Continuous distribution
          dist_fun <- densfun(object, i)
          # This is needed to force evaluation of the function at each step
          dist_fun(0)
          res <- res + geom_function(aes(colour = {{dist}}), fun = dist_fun,
            n = n, ...)
        }
      }
    }
  }
  res
}

#' @export
#' @rdname dfun
chart.distribution <- function(data, ..., type = "density", env = parent.frame())
  autoplot(data, type = type, theme = theme_sciviews(), use.chart = TRUE, ...)

#' @export
#' @rdname dfun
geom_funfill <- function(mapping = NULL, data = NULL, fun, from, to,
  geom = "area", fill = "salmon", alpha = 0.5, ...) {
  stat_function(mapping = mapping, data = data, fun = fun, geom = geom,
    xlim = c(from, to), fill = fill, alpha = alpha, ...)
}
