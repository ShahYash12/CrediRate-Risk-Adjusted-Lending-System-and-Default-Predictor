# Load Required Libraries
install.packages("dplyr")
install.packages("ggplot2")
install.packages("leaps")

library(dplyr)
library(ggplot2)
library(leaps)

# Load Data
loan_data <- read.csv("~/Documents/Loan_Default.csv", as.is = TRUE)

# Select relevant columns

# Convert 'Status' to a factor variable
loan_data$Status <- as.factor(loan_data$Status)
loan_data$Gender <- as.factor(loan_data$Gender)

# Remove unrealistic LTV values
loan_data <- filter(loan_data, LTV <= 100)

# Remove rows with missing values
loan_data <- na.omit(loan_data)
table(loan_data$Status)



#1.  Logistic Regression Model (Baseline)

# Fit Logistic Regression Model
logistic_model <- glm(Status ~ LTV + Credit_Score + income + age + dtir1 + property_value , 
                      data = loan_data, family = binomial(link = "logit"))

# Predict probability of loan default
loan_data$predicted_prob <- predict(logistic_model, type="response")

#2. Visualizing Probability of Default

# Scatterplot: Interest Rate vs. Default Probability
ggplot(loan_data, aes(x=rate_of_interest, y=predicted_prob)) +
  geom_point(alpha=0.5, color="blue") +
  geom_smooth(method="lm", color="red") +
  ggtitle("Loan Default Probability by Interest Rate") +
  xlab("Interest Rate (%)") +
  ylab("Predicted Default Probability") +
  theme_minimal()

# Scatterplot: LTV vs. Default Probability
ggplot(loan_data, aes(x=LTV, y=predicted_prob)) +
  geom_point(alpha=0.5, color="green") +
  geom_smooth(method="lm", color="red") +
  ggtitle("Loan Default Probability by Loan-to-Value (LTV)") +
  xlab("Loan-to-Value Ratio (%)") +
  ylab("Predicted Default Probability") +
  theme_minimal()

#3. Multiple Linear Regression (LTV & Interest Rate vs Default)

# Fit Multiple Linear Regression Model
mlr_model <- lm(predicted_prob ~ LTV + Credit_Score + income + age + dtir1 + property_value + Interest_rate_spread + approv_in_adv, data = loan_data)
summary(mlr_model)

# Scatterplot with Regression Line: Interest Rate vs. Default Probability
ggplot(loan_data, aes(x=rate_of_interest, y=predicted_prob)) +
  geom_point(color="blue") +
  geom_smooth(method="lm", color="red") +
  ggtitle("Linear Relationship: Interest Rate vs. Default Probability") +
  xlab("Interest Rate (%)") +
  ylab("Predicted Default Probability") +
  theme_minimal()

# Scatterplot with Regression Line: LTV vs. Default Probability
ggplot(loan_data, aes(x=LTV, y=predicted_prob)) +
  geom_point(color="green") +
  geom_smooth(method="lm", color="red") +
  ggtitle("Linear Relationship: LTV vs. Default Probability") +
  xlab("Loan-to-Value Ratio (%)") +
  ylab("Predicted Default Probability") +
  theme_minimal()

#4. Best Subset Selection (Model Optimization)

# Perform Best Subset Selection
best_subset_model <- regsubsets(Status ~ rate_of_interest + LTV + Credit_Score + income + age + dtir1 + property_value + Gender + Interest_rate_spread, 
                                data = loan_data, nvmax = 6)
summary(best_subset_model)
which.max(model_summary$adjr2)
coef(best_subset_model, best_model_size)

# Plot Adjusted R-Squared for different model sizes
model_summary <- summary(best_subset_model)
plot(model_summary$adjr2, xlab="Model Size", ylab="Adjusted R-Squared", type="b", col="purple",
     main="Best Subset Selection: Adjusted R-Squared")

# Identify the best model size
best_model_size <- which.max(model_summary$adjr2)

# Print the coefficients of the best subset model
coef(best_subset_model, best_model_size)

# Create a clean numeric-only dataframe
subset_data <- loan_data %>%
  dplyr::select(Status, rate_of_interest, LTV, Credit_Score, income, age, dtir1, property_value, Interest_rate_spread) %>%
  mutate(Status = as.numeric(as.character(Status))) # Convert factor to numeric

# Remove NAs again to be safe
subset_data <- na.omit(subset_data)

# Run best subset selection
library(leaps)
best_subset_model <- regsubsets(Status ~ ., data = subset_data, nvmax = 6)

# Summarize and extract best model size
model_summary <- summary(best_subset_model)
valid_adjr2 <- model_summary$adjr2[!is.na(model_summary$adjr2)]
best_model_size <- which.max(valid_adjr2)

# Get best model coefficients
coef(best_subset_model, best_model_size)

# Step 1: Create a clean numeric-only subset of the data
subset_data <- loan_data %>%
  dplyr::select(Status, rate_of_interest, LTV, Credit_Score, income, dtir1, property_value, Interest_rate_spread) %>%
  mutate(Status = as.numeric(as.character(Status)))  # Convert factor to numeric (0/1)

# Step 2: Remove NAs just in case
subset_data <- na.omit(subset_data)

# Step 3: Run best subset selection
library(leaps)
best_subset_model <- regsubsets(Status ~ ., data = subset_data, nvmax = 6)

# Step 4: Summarize and extract model details
model_summary <- summary(best_subset_model)

# Step 5: Check for actual usable adjusted R² values
print(model_summary$adjr2)

# Step 6: If still failing, print out to debug
if (all(is.na(model_summary$adjr2))) {
  cat("All adjusted R-squared values are NA — check if columns are constant or if data is too small.\n")
} else {
  best_model_size <- which.max(model_summary$adjr2)
  print(coef(best_subset_model, best_model_size))
}


#5. Conclusion & Summary

# Print Logistic Regression Summary
summary(logistic_model)



library(dplyr)       # for data wrangling
library(DescTools)   # for descriptive statistics and visualization
library(rpart)       # for decision tree application
library(caret)       # for decision tree application
library(rpart.plot)  # for plotting decision trees
library(vip)         # for feature importance
library(ISLR2)       # for accessing Carseats data
library(rattle)      # for plotting fancier decision trees
library(RColorBrewer)



# Load and prepare data
loan_data <- read.csv("Documents/Loan_Default.csv", as.is = TRUE)
names(loan_data)

# Select relevant columns
loan_data <- loan_data %>%
  dplyr::select(Status, LTV, Gender, Credit_Score, income, age, dtir1, property_value, Interest_rate_spread, approv_in_adv)


# Factorize Status and Gender
loan_data$Status <- as.factor(loan_data$Status)
loan_data$Gender <- as.factor(loan_data$Gender)


# Split data
set.seed(123)
index <- sample(1:nrow(loan_data), size = 0.7 * nrow(loan_data))
train_data <- loan_data[index, ]
test_data <- loan_data[-index, ]


# Verify both classes exist in training data
table(train_data$Status)



# Fit classification tree
tree_model <- rpart(Status ~ ., data = train_data, method = "class",
                    control = rpart.control(cp = 0.001, minsplit = 20))

# Plot the tree
rpart.plot(tree_model, main = "Loan Default Classification Tree")



# Predict and evaluate
predicted <- predict(tree_model, newdata = test_data, type = "class")
confusionMatrix(predicted, test_data$Status)


# View variable importance
importance <- tree_model$variable.importance
print(importance)

# Plot variable importance (optional barplot)
barplot(importance, main = "Variable Importance", verti = TRUE, col = "skyblue")

cm <- confusionMatrix(predicted, test_data$Status)
cm$overall['Accuracy']


importance <- mlr_model$variable.importance
print(importance)






