"""
Adding some code to play with the Atom editor.
Also testing the abilities of pycharm.
"""

import pandas as pd
import matplotlib.pylab as plt

# Make a test dataframe
df = pd.DataFrame({"first":range(50), "second":range(50)})

# Plot the results
print "Plotting results"

plt.scatter(df["first"], df["second"])
plt.title("First and second")
plt.xlabel("First")
plt.ylabel("Second")

plt.show()
plt.close()

