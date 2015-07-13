import pandas as pd
from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import train_test_split
from sklearn.metrics import classification_report

import numpy as np

from time import time
from operator import itemgetter
from scipy.stats import randint as sp_randint

from sklearn.grid_search import GridSearchCV, RandomizedSearchCV
from sklearn.datasets import load_digits
#===============================================
# Script settings
# This option is not yet functional
opt_grid_search = False
#===============================================
# Load the dataset
iris = datasets.load_iris()

# Assign attributes and targets
attributes = iris.data
target = iris.target

This = "is just me testing if git is working"

# Spilt into test and train groups
X_train, X_test, y_train, y_test = train_test_split(attributes, target,
train_size=0.8, random_state = 42)

# Make a rf object
clf = clf = RandomForestClassifier(n_estimators = 10, criterion="entropy",
max_depth=None, n_jobs = -1, random_state = 42, verbose = 1)

# Train
clf.fit(X_train, y_train)

# Predict
y_pred = clf.predict(X_test)

# Score
print "\nScore:"
print classification_report(y_test, y_pred, labels=None, target_names=None)

if opt_grid_search:
    # Directly from scikit:
    # Use a grid search to find the best parameters

    # Utility function to report best scores
    def report(grid_scores, n_top=3):
        top_scores = sorted(grid_scores, key=itemgetter(1), reverse=True)[:n_top]
        for i, score in enumerate(top_scores):
            print("Model with rank: {0}".format(i + 1))
            print("Mean validation score: {0:.3f} (std: {1:.3f})".format(
                  score.mean_validation_score,
                  np.std(score.cv_validation_scores)))
            print("Parameters: {0}".format(score.parameters))
            print("")


    # specify parameters and distributions to sample from
    param_dist = {"max_depth": [3, None],
                  "max_features": sp_randint(1, 11),
                  "min_samples_split": sp_randint(1, 11),
                  "min_samples_leaf": sp_randint(1, 11),
                  "bootstrap": [True, False],
                  "criterion": ["gini", "entropy"]}

    # run randomized search
    n_iter_search = 20
    random_search = RandomizedSearchCV(clf, param_distributions=param_dist,
                                       n_iter=n_iter_search)

    start = time()
    random_search.fit(X, y)
    print("RandomizedSearchCV took %.2f seconds for %d candidates"
          " parameter settings." % ((time() - start), n_iter_search))
    report(random_search.grid_scores_)

    # use a full grid over all parameters
    param_grid = {"max_depth": [3, None],
                  "max_features": [1, 3, 10],
                  "min_samples_split": [1, 3, 10],
                  "min_samples_leaf": [1, 3, 10],
                  "bootstrap": [True, False],
                  "criterion": ["gini", "entropy"]}

    # run grid search
    grid_search = GridSearchCV(clf, param_grid=param_grid)
    start = time()
    grid_search.fit(X, y)

    print("GridSearchCV took %.2f seconds for %d candidate parameter settings."
          % (time() - start, len(grid_search.grid_scores_)))
    report(grid_search.grid_scores_)
