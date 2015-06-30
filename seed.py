import pandas as pd
import matplotlib.pylab as plt

# Make a test dataframe
df = pd.DataFrame({"first":range(50),"second":range(50)})

# Plot the results
plt.scatter(df["first"], df["second"])
plt.show()
plt.close()
