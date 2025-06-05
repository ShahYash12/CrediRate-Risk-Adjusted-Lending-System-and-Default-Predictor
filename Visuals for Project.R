# Load Required Libraries
install.packages("dplyr")
install.packages("ggplot2")
install.packages("leaps")

library(dplyr)
library(ggplot2)
library(leaps)

# Load Data
loan_data <- read.csv("~/Documents/Loan_Default.csv", as.is = TRUE)
table(loan_data$Status)
library(ggplot2)
ggplot(loan_data, aes(x = as.factor(Status), y = dtir1, fill = as.factor(Status))) +
  geom_boxplot() +
  labs(
    title = "DTI vs Loan Default",
    x = "Default Status (0 = Non-Default, 1 = Default)",
    y = "Debt-to-Income Ratio"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("#56B4E9", "#E69F00"), name = "Status", labels = c("Non-Default", "Default"))

ggplot(loan_data, aes(x = Credit_Score, fill = Status)) +
  geom_density(alpha = 0.5) +
  labs(
    title = "Distribution of Credit Score by Default Status",
    x = "Credit Score",
    y = "Density"
  ) +
  scale_fill_manual(values = c("#009E73", "#D55E00"), 
                    name = "Status", labels = c("Non-Default", "Default")) +
  theme_minimal()


# Create credit score bins
loan_data$score_bin <- cut(loan_data$Credit_Score, breaks = seq(500, 900, 50))

# Calculate default rate per bin
library(dplyr)
score_summary <- loan_data %>%
  group_by(score_bin) %>%
  summarise(DefaultRate = mean(as.numeric(as.character(Status))))

# Plot
ggplot(score_summary, aes(x = score_bin, y = DefaultRate)) +
  geom_bar(stat = "identity", fill = "#0072B2") +
  labs(
    title = "Default Rate by Credit Score Range",
    x = "Credit Score Bin",
    y = "Default Rate"
  ) +
  theme_minimal()

loan_data$Status <- as.numeric(as.character(loan_data$Status))

loan_data$score_bin <- cut(loan_data$Credit_Score,
                           breaks = c(500, 600, 650, 700, 750, 800, 850, 900),
                           include.lowest = TRUE)
library(dplyr)

score_summary <- loan_data %>%
  group_by(score_bin) %>%
  summarise(DefaultRate = mean(Status, na.rm = TRUE),
            Count = n()) %>%
  filter(!is.na(score_bin))  # remove NA bin

ggplot(score_summary, aes(x = score_bin, y = DefaultRate)) +
  geom_bar(stat = "identity", fill = "#0072B2") +
  labs(
    title = "Meaningful Default Rate by Credit Score Range",
    x = "Credit Score Bin",
    y = "Default Rate"
  ) +
  theme_minimal()

ggplot(loan_data, aes(x = income, fill = as.factor(Status))) +
  geom_density(alpha = 0.5) +
  labs(
    title = "Distribution of Income by Loan Default Status",
    x = "Income",
    y = "Density",
    fill = "Default Status"
  ) +
  scale_fill_manual(values = c("#56B4E9", "#D55E00"), labels = c("Non-Default", "Default")) +
  theme_minimal()

ggplot(loan_data, aes(x = log1p(income), fill = as.factor(Status))) +
  geom_density(alpha = 0.5) +
  labs(
    title = "Log-Transformed Income Distribution by Default Status",
    x = "Log(Income + 1)",
    y = "Density",
    fill = "Default Status"
  ) +
  scale_fill_manual(values = c("#56B4E9", "#D55E00"), labels = c("Non-Default", "Default")) +
  theme_minimal()

ggplot(loan_data, aes(x = LTV, fill = as.factor(Status))) +
  geom_density(alpha = 0.5) +
  labs(
    title = "Distribution of LTV by Loan Default Status",
    x = "Loan-to-Value Ratio",
    y = "Density",
    fill = "Default Status"
  ) +
  scale_fill_manual(values = c("#009E73", "#D55E00"), labels = c("Non-Default", "Default")) +
  theme_minimal()

ggplot(loan_data[loan_data$LTV <= 150, ], aes(x = LTV, fill = as.factor(Status))) +
  geom_density(alpha = 0.5) +
  labs(
    title = "LTV Distribution by Default Status (Capped at 150)",
    x = "Loan-to-Value Ratio",
    y = "Density",
    fill = "Default Status"
  ) +
  scale_fill_manual(values = c("#009E73", "#D55E00"), labels = c("Non-Default", "Default")) +
  theme_minimal()

ggplot(loan_data, aes(x = log1p(LTV), fill = as.factor(Status))) +
  geom_density(alpha = 0.5) +
  labs(
    title = "Log-Transformed LTV Distribution by Default Status",
    x = "Log(LTV + 1)",
    y = "Density",
    fill = "Default Status"
  ) +
  scale_fill_manual(values = c("#56B4E9", "#E69F00"), labels = c("Non-Default", "Default")) +
  theme_minimal()


