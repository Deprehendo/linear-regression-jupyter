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

formula <- as.formula(paste(y_col, "~", x_col))
model <- lm(formula, data=dataset)

plot <- ggplot () +
    geom_point(aes(x = dataset$YearsExperience, y = dataset$Salary), colour = 'red') +
    geom_line(aes(x = dataset$YearsExperience, y = predict(model, newdata = dataset)), colour = 'blue') +
    ggtitle('Salary vs Experience') +
    xlab('Years of experience') +
    ylab('Salary')

ggsave("linear_regression_r_output.png", plot)
print(plot)
summary(model)

