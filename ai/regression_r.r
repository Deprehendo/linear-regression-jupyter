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

  cat("\nIntercept (beta_0):", coef(model)[1], "\n")
  cat("Slope (beta_1):    ", coef(model)[2], "\n")

  plot <- ggplot(df, aes(x = .data[[args$x_col]], y = .data[[args$y_col]])) +
    geom_point(size = 3, alpha = 0.8) +
    geom_abline(
      intercept = coef(model)[1],
      slope = coef(model)[2],
      color = "red",
      linewidth = 1
    ) +
    labs(
      title = paste(args$y_col, "vs", args$x_col),
      x = args$x_col,
      y = args$y_col
    ) +
    theme_minimal()

  ggsave(OUTPUT_PNG, plot, width = 8, height = 5, dpi = 150)
  cat("\nSaved plot:", OUTPUT_PNG, "\n")

  y_pred <- predict(model)
  resid <- residuals(model)

  cat("\n")
  print(summary(model))

  r2 <- summary(model)$r.squared
  rmse <- sqrt(mean(resid^2))
  mae <- mean(abs(resid))

  cat("\nR-squared:", round(r2, 4), "\n")
  cat("RMSE:     ", round(rmse, 2), "\n")
  cat("MAE:      ", round(mae, 2), "\n")
}

tryCatch(main(), error = function(e) {
  message("Error: ", conditionMessage(e))
  quit(status = 1)
})
