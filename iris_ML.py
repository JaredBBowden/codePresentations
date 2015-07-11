import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
import datetime
from sklearn.cross_validation import train_test_split
from sklearn.metrics import classification_report

# Load the dataset
iris = datasets.load_iris()

# Assign attributes and targets
attributes = iris.data
target = iris.target

# Spilt into test and train groups
X_train, X_test, y_train, y_test = train_test_split(attributes, target, train_size=0.8, random_state = 42)

# Make a rf object
# Not really clear
clf = clf = RandomForestClassifier(n_estimators = 10, criterion="gini", max_depth=None, n_jobs = -1, random_state=42, verbose=1)

# Train
clf.fit(X_train, y_train)

# Predict
y_pred = clf.predict(X_test)

# Score
print "/nScore:"
print classification_report(y_test, y_pred, labels=None, target_names=None)

this = pd.DataFrame(range(20))
that = pd.DataFrame((range(20) * 2))

print pd.merge(this, that)
