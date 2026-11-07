# Titanic Survival Prediction
This project uses logistic regression to predict passenger survival in the Titanic disaster. The model is implemented in both Python and R, with a separate Docker environment for each implementation.

## Project Structure
```text
titanic-survival/
├── src/
│   ├── data/
│   │   └── .gitkeep
│   ├── python/
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── titanic_model.py
│   └── r/
│       ├── Dockerfile
│       ├── install_packages.R
│       └── titanic_model.R
├── .dockerignore
├── .gitignore
└── README.md
```
The Titanic CSV files are intenionally excluded from this repository.

## Model Overview
Both implementations perform the following steps:
1. Load the Titanic training and test datasets.
2. Display summary statistics and survival rates
3. Select the following model features:
    - Passenger class
    - Sex
    - Age
    - Number of siblings or spouces
    - Number of parents or children
    - Fare
    - Port of embarkation
4. Fill missing numerical values
5. Fill missing embarkation values with the most common training value
6. Convert categorical features into dummy variables
7. Train a logistic regression model.
8. Display training accuracy.
9. Predict survival for passengers in test.csv
10. Save the test predictions as CSV files.

The Kaggle test dataset doesn't contain the true Survived values. So test accuracy cannot be calculated locally.

## Requirements
Before running this project, install both [Git] and [Docker Desktop] if you haven't done so.

## 1. Clone the Repository
Open a terminal and run:
```bash
git clone https://github.com/KatrinaC04/titanic-survival.git
cd titanic-survival
```

## 2. Download the Titanic data
1. Open the [Kaggle Titanic competition](https://www.kaggle.com/competitions/titanic/data).
2. Download the ZIP file
3. Copy `train.csv` and `test.csv` into:
```text
src/data/
```

The resulting data directory should look like:

```text
src/data/
├── .gitkeep
├── train.csv
└── test.csv
```

Do not commit the CSV files. The repository's `.gitignore` excludes them.

## 3. Run the Python Model with Docker
Build the Python Dokcer image:
```bash
docker build \
  -f src/python/Dockerfile \
  -t titanic-python \
  .
```

Create the local output directory:
```bash
mkdir -p outputs
```

Run the Python container:
```bash
docker run --rm \
  -v "$(pwd)/src/data:/app/src/data:ro" \
  -v "$(pwd)/outputs:/app/outputs" \
  titanic-python
```

The terminal will show dataset summary statistics, clean up missing values, create the feature set, and display the training results

The Python predictions will be saved to:

```text
outputs/titanic_predictions.csv
```

## 4. Run the R Model with Docker
Build the R Docker image:

```bash
docker build \
  -f src/r/Dockerfile \
  -t titanic-r \
  .
```

Run the R container:

```bash
docker run --rm \
  -v "$(pwd)/src/data:/app/src/data:ro" \
  -v "$(pwd)/outputs:/app/outputs" \
  titanic-r
```

The terminal will display the R data exploration, cleaning results, training accuracy, and test predictions.

The R predictions will be saved to:

```text
outputs/titanic_predictions_r.csv
```

## 5. Verify the Outputs

After running both containers, check the output directory:

```bash
ls outputs
```

Expected files:

```text
titanic_predictions.csv
titanic_predictions_r.csv
```

Each prediction file contains:

- `PassengerId`
- Predicted `Survived` value, where `0` means did not survive and `1` means survived