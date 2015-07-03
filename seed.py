#!/anaconda/bin/ipython
"""
Adding some code to play with the Atom editor
"""

import pandas as pd
import matplotlib.pylab as plt

# Make a test dataframe
df = pd.DataFrame({"first":range(50),"second":range(50)})

print "Plotting results"

for x in range(200):
    print x

# Plot the results
plt.scatter(df["first"], df["second"])
plt.show()
plt.close()
