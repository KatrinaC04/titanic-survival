import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
import os

# Load the training datase
train = pd.read_csv("src/data/train.csv")

print("Training data loaded successfully")
print("Dataset shape:", train.shape)

print("Column names: ", train.columns.tolist())

# Select features for the model
features = ['Pclass', 'Sex', 'Age', "SibSp", 'Parch', 'Fare', 'Embarked']

X_train = train[features].copy()

y_train = train['Survived']

print("Missing values before cleaning:", X_train.isnull().sum())

# Fill missing numerical values with the median
X_train['Age'] = X_train['Age'].fillna(X_train['Age'].median())
X_train['Fare'] = X_train['Fare'].fillna(X_train['Fare'].median())

# Fill missing categorical values with the most common value
X_train['Embarked'] = X_train['Embarked'].fillna(
X_train['Embarked'].mode()[0])

print('Missing values after cleaning:', X_train.isnull().sum())

# Convert categorical columns into numerical columns
X_train = pd.get_dummies(X_train, columns=['Sex', 'Embarked'], drop_first= True, dtype=int,)

print("Features used by the model:", X_train.columns.tolist())

# Train the logistic model
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)

# Predict survival on the training data
train_predictions = model.predict(X_train)

# Calculate training accuracy
train_accuracy = accuracy_score(y_train, train_predictions)

print('Training accuracy:', round(train_accuracy, 2))

# Load test.csv 
test = pd.read_csv("src/data/test.csv")
X_test = test[features].copy()

print("Test data loaded sucessfully.")
print("Test dataset shape:", X_test.shape)

print("Missing values before cleaning:", X_test.isnull().sum())

# Fill missing values using trainign data
X_test['Age'] = X_test['Age'].fillna(train['Age'].median())
X_test['Fare'] = X_test['Fare'].fillna(train['Fare'].median())

most_common_port = train['Embarked'].mode()[0]
X_test['Embarked'] = X_test['Embarked'].fillna(most_common_port)

# Convert categorical columns into numerical columns
X_test = pd.get_dummies(X_test, columns=['Sex', 'Embarked'], drop_first=True, dtype=int)

# Match the test columns to teh training columns
X_test = X_test.reindex(columns=X_train.columns, fill_value=0)

print("Missing values in the test dataset after cleaning:", X_test.isnull().sum())

# Predict survival for the test passengers
test_predictions = model.predict(X_test)

# Create file fro submission
submission = pd.DataFrame({
    "PassengerId": test['PassengerId'],
    'Survived': test_predictions,
})

os.makedirs("outputs", exist_ok=True)
submission.to_csv("outputs/titanic_predictions.csv", index=False)

print("First five test predictions:", submission.head())
print("Predictions saved to outputs/titanic_predictions.csv")

