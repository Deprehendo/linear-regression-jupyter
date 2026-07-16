#!/usr/bin/env Rscript
# Simple linear regression from CSV with scatter plot and regression line output.

library(ggplot2)

script_path <- sub("^--file=", "", commandArgs(trailingOnly = FALSE)[grep("^--file=", commandArgs(trailingOnly = FALSE))])
OUTPUT_PNG <- file.path(if (length(script_path)) dirname(script_path) else ".", "regression_r.png")

parse_args <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) == 0 || "--help" %in% args || "-h" %in% args) {
    cat(
      "Usage: Rscript regression_r.r --filepath PATH --x-col COL --y-col COL\n",
      "\n",
      "Fit a linear regression model and save a scatter plot with fitted line.\n",
      sep = ""
    )
    quit(status = 0)
  }

  get_arg <- function(flag) {
    idx <- match(flag, args)
    if (is.na(idx) || idx >= length(args)) {
      stop("Missing required argument: ", flag, call. = FALSE)
    }
    args[[idx + 1]]
  }

  list(
    filepath = get_arg("--filepath"),
    x_col = get_arg("--x-col"),
    y_col = get_arg("--y-col")
  )
}

validate_inputs <- function(args) {
  if (!file.exists(args$filepath)) {
    stop("File not found: ", args$filepath, call. = FALSE)
  }

  df <- read.csv(args$filepath, stringsAsFactors = FALSE)
  for (col in c(args$x_col, args$y_col)) {
    if (!col %in% names(df)) {
      stop("Column not found in CSV: ", col, call. = FALSE)
    }
    df[[col]] <- suppressWarnings(as.numeric(df[[col]]))
    if (any(is.na(df[[col]]))) {
      stop("Column must be numeric: ", col, call. = FALSE)
    }
  }

  df
}

main <- function() {
  args <- parse_args()
  df <- validate_inputs(args)

  cat("Rows:", nrow(df), " Columns:", ncol(df), "\n")
  cat("\nHead:\n")
  print(head(df))
  cat("\nSummary:\n")
  print(summary(df))

  formula <- as.formula(paste(args$y_col, "~", args$x_col))
  model <- lm(formula, data = df)

  intercept <- coef(model)[1]
  slope <- coef(model)[2]

  cat("\nIntercept (beta_0):", intercept, "\n")
  cat("Slope (beta_1):    ", slope, "\n")

  y_pred <- predict(model)
  resid <- residuals(model)

  r2 <- summary(model)$r.squared
  mse <- mean(resid^2)
  rmse <- sqrt(mse)
  mae <- mean(abs(resid))

  annotation <- paste0(
    args$y_col, " = ", format(intercept, big.mark = ",", nsmall = 2, trim = TRUE),
    " + ", format(slope, big.mark = ",", nsmall = 2, trim = TRUE),
    " \u00d7 ", args$x_col, "\n",
    "R\u00b2 = ", format(round(r2, 4), nsmall = 4, trim = TRUE), "\n",
    "MSE = ", format(round(mse, 2), big.mark = ",", nsmall = 2, trim = TRUE)
  )

  plot <- ggplot(df, aes(x = .data[[args$x_col]], y = .data[[args$y_col]])) +
    geom_point(size = 3, alpha = 0.8) +
    geom_abline(
      intercept = intercept,
      slope = slope,
      color = "red",
      linewidth = 1
    ) +
    annotate(
      "label",
      x = min(df[[args$x_col]]),
      y = max(df[[args$y_col]]),
      label = annotation,
      hjust = 0,
      vjust = 1,
      fill = "white",
      alpha = 0.85,
      size = 3.5
    ) +
    labs(
      title = paste(args$y_col, "vs", args$x_col),
      x = args$x_col,
      y = args$y_col
    ) +
    theme_minimal()

  ggsave(OUTPUT_PNG, plot, width = 8, height = 5, dpi = 150)
  cat("\nSaved plot:", OUTPUT_PNG, "\n")

  cat("\n")
  print(summary(model))

  cat("\nR-squared:", round(r2, 4), "\n")
  cat("MSE:      ", round(mse, 2), "\n")
  cat("RMSE:     ", round(rmse, 2), "\n")
  cat("MAE:      ", round(mae, 2), "\n")
}

tryCatch(main(), error = function(e) {
  message("Error: ", conditionMessage(e))
  quit(status = 1)
})
