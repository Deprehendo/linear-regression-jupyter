args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) {
  stop("Usage: Rscript linear_regression_r.R <filename> <x_column> <y_column>")
}

filename <- args[1]
x_col <- args[2]
y_col <- args[3]

library(ggplot2)

dataset <- read.csv(filename)

dataset

scatter <- plot(dataset$YearsExperience, dataset$Salary, col='red')

model <- lm(Salary ~ YearsExperience, data=dataset)
slope <- coef(model)[2]
intercept <- coef(model)[1]
r <- cor(dataset$YearsExperience, dataset$Salary)
pred <- predict(model)
mse <- mean((dataset$Salary - pred)^2)

plot <- ggplot () +
    geom_point(aes(x = dataset$YearsExperience, y = dataset$Salary), colour = 'red') +
    geom_line(aes(x = dataset$YearsExperience, y = predict(model, newdata = dataset)), colour = 'blue') +
    geom_smooth(method = "lm", se = FALSE, color = 'blue') +
    annotate("text", x = 1.5, y = max(dataset$Salary) - 0.5,
             label = paste("y =", round(slope, 2), "x+", round(intercept, 2),
                           "\nr =", round(r, 2), "\nMSE =", round(mse,2)),
             size = 4) +
    labs(title = "Linear Fit",
         x = "YearsExperience", y = "Salary") +
    theme_minimal()

ggsave("linear_regression_r_output.png", plot)
print(plot)
summary(model)

