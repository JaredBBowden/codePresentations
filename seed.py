import pandas as pd
import matplotlib.pylab as plt

# Make an empty dataframe
df = DataFrame({"first":range(50),
                "second":range(50)})

plt.scatter(df["frist"], df["second"])
plt.show()
