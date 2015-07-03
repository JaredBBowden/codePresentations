#!/anaconda/bin/ipython
"""
Adding some code to play with the Atom editor.
Also testing the abilities of pycharm
"""

import pandas as pd
import matplotlib.pylab as plt

# Make a test dataframe
df = pd.DataFrame({"first":range(50),"second":range(50)})

print "Plotting results"

# Plot the results
plt.scatter(df["first"], df["second"])
plt.title("First and second")
plt.show()
plt.close()
