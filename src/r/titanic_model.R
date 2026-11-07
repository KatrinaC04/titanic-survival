library(dplyr)

# Load the training dataset
train <- read.csv('src/data/train.csv', na.strings= c("", "NA"))

print("Training data load successfully")

print(dim(train))
print(names(train))

# Explore the training data
print('Summary statistics:')
print(summary(train[c('Age', 'Fare', 'SibSp', 'Parch')]))

print('Survival rate by sex:')
print(aggregate(Survived ~ Sex, data = train, FUN = mean))

print('Survival rate by passenger class:')
print(aggregate(Survived ~ Pclass, data = train, FUN = mean))

# Select features
features <- c('Pclass', 'Sex', 'Age', 'SibSp', 'Parch', 'Fare', 'Embarked')

train_model <- train %>% select(Survived, all_of(features))

print('Missing values before cleaning:')
print(colSums(is.na(train_model)))

# Fill missing values
train_model$Age[is.na(train_model$Age)] <- median(train_model$Age, na.rm = TRUE)

train_model$Fare[is.na(train_model$Fare)] <- median(train_model$Fare, na.rm = TRUE)

most_common_port <- names(sort(table(train_model$Embarked), decreasing = TRUE))[1]

train_model$Embarked[is.na(train_model$Embarked)] <- most_common_port

# Convert categorical columns to factors
train_model$Sex <- factor(train_model$Sex)
train_model$Embarked <- factor(train_model$Embarked)

print("Missing values after cleaning:")
print(colSums(is.na(train_model)))

# Train hte logistic regression model
model <- glm(Survived ~ ., data = train_model, family = binomial())

# Calculate training accuracy
train_probabilities <- predict(model, newdata = train_model, type = 'response')

train_predictions <- ifelse(train_probabilities >= 0.5, 1, 0)

train_accuracy <- mean(train_predictions == train_model$Survived)

print(paste('Training accuracy:', round(train_accuracy, 2)))

# Load the test dataset
test <- read.csv('src/data/test.csv', na.strings= c("", "NA"))

print("Test data load successfully")

test_model <- test %>% select(all_of(features))

print(dim(test_model))

print("Missing values before cleaning:")
print(colSums(is.na(test_model)))

# Fill missing values in the test dataset using training data
test_model$Age[is.na(test_model$Age)] <- median(train$Age, na.rm = TRUE)

test_model$Fare[is.na(test_model$Fare)] <- median(train$Fare, na.rm = TRUE)

test_model$Embarked[is.na(test_model$Embarked)] <- most_common_port

# Use the same factor levels as the training data
test_model$Sex <- factor(test_model$Sex, levels = levels(train_model$Sex))
test_model$Embarked <- factor(test_model$Embarked, levels = levels(train_model$Embarked))

print("Missing data after cleaning:")
print(colSums(is.na(test_model)))

# Predict survival for test passengers
test_probabilities <- predict(model, newdata = test_model, type = 'response')

test_predictions <- ifelse(test_probabilities >= 0.5, 1, 0)

submission <- data.frame(
  PassengerId = test$PassengerId,
  Survived = test_predictions
)

dir.create("outputs", showWarnings = FALSE)

write.csv(submission, "outputs/titanic_predictions_r.csv",
        row.names = FALSE
)

print("First five test predictions:")
print(head(submission, 5))

print("Predictions saved to outputs/titanic_predictions_r.csv")
