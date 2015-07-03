## Dimensional reduction with SVD and PCA
## Jared Bowden

## This code is based on:
## Exploratory Data Analysis
## by Roger D. Peng, PhD, Jeff Leek, PhD, Brian Caffo, PhD

## Let's make a dataset to work with
set.seed(12345)
par(mar = rep(4, 4))
dataMatrix <- matrix(rnorm(400), nrow = 40)

## Have a quick look at the matrix we've created
dataMatrix

## Easier to see trends if we display graphically. We should just see lots of
## random-ish noise.
image(1:10, 1:40, t(dataMatrix) [, nrow(dataMatrix):1])

## Let's add a trend, so we have something to hunt for
set.seed(678910)
for (i in 1:40) {
    # flip a coin
    coinFlip <- rbinom(1, size = 1, prob = 0.5)
    # if coin is heads add a common pattern to that row
    if (coinFlip) {
        dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0, 3), each = 5)
    }
}

# Review the updated matrix. Can you seen the trend? It's Not so easy to see 
## if you're not a computer.
dataMatrix

## Us 
par(mar = rep(4, 4))
image(1:10, 1:40, t(dataMatrix) [, nrow(dataMatrix):1])

## Basically, we have higher values on the right hand columns of the matrix

## Let's pretend we are seeing this matrix for the first time, and hunt for
## patterns: http://giphy.com/gifs/374pcIBVEGb6g

## The heatmap function is always a good start
par(mar = rep(4, 4))
heatmap(dataMatrix)

## What is headmap() doing? Basically, we are using a euclidean distance
## matrix to identify values that are more-or-less close (read: "different") 
## from one another... Maybe we should break that down a little.
dist(dataMatrix)

## Think of this like plotting all of these values in 2 dimensional space, and 
## measuring the euclidean distance between each point.

## Honestly, this is a mess. It's nice to have all this information, but we 
## need to impose some sort of order if we are going to do anything useful 
## with it. As a first step, it might be nice to know what rows are MOST 
## distant from one another... (cough). 

## Let's rank all of these distance in order. We can do this with the
## hclust function
hh <- hclust(dist(dataMatrix))

## We can now use this distance ranking information to order our data frame.
## If we plot this, we should now see more of a pattern to our high and low 
## values (basically, we're making differences more obvious). These differences
## are now easy to SEE, but we want to extract values algorithmically. Let's
## see what happens if we "scan" through our ordered matrix, looking at row
## and column means
dataMatrixOrdered <- dataMatrix[hh$order, ]
par(mfrow = c(1, 3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(rowMeans(dataMatrixOrdered), 40:1, , xlab = "Row Mean", ylab = "Row", 
     pch = 19)
plot(colMeans(dataMatrixOrdered), xlab = "Column", ylab = "Column Mean", 
     pch = 19)

## Alright, we're getting some pretty good contrast here. Next question:
## what dimensions are providing the MOST contrast?

## "Some of our variables are going to be related to one another (think height
## and weight). We want to reduce the number of variables to the point that we
## are accurately depicting the variability of the data, with the minimum 
## number of variables" 

## We want to find a smaller subset "uncorrelated" variables that explains
## a maximum variability.

## This is what we call dimensional reduction

## Method one: singular value decomposition
## Where x is a matrix:
## X = UDV ^ T

## Working with the data we already made (with the embedded pattern). Let's
## start by running the SVD.
svd1 <- svd(scale(dataMatrixOrdered))

## We can pull these variables of the formula apart. Neat. But what do they
## Mean?
print(svd1)

## Setup our plot
par(mfrow = c(1,3))

## The first left singular vector is going to "scan" across rows (var = u), the
## first right singular vector is going to "scan" across columns (var = v).
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(svd1$u[, 1], 40:1, , xlab = "Row", ylab = "First left singular vector", 
     pch = 19)
plot(svd1$v[, 1], xlab = "Column", ylab = "First right singular vector",
     pch = 19)

## Cool. So this was faster. We can see some trends here, but what do we DO 
## with this. Well, there was another variable mentioned: D

## The D variable the diagonal matrix; the "variance explained". Think of this
## as the percent of the total variation that is explained by that particular 
## component. The function should order these so that the first component 
## explains the most of the variability, and so on.
par(mfrow = c(1, 2))
plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", 
     ylab = "Prop. of variance explained", pch = 19)

## So, what does this all mean for principle components? What happens if we 
## plot the first principle component against the right singular vector?
svd1 <- svd(scale(dataMatrixOrdered))
pca1 <- prcomp(dataMatrixOrdered, scale = TRUE)
plot(pca1$rotation[, 1], svd1$v[, 1], pch = 19, xlab = "Principal Component 1", 
     ylab = "Right Singular Vector 1")
abline(0, 1)
       
## So the principle components are equal to the right singular values, if we
## subtract by the mean, and divide by the standard deviation. 

## Missing values are going to be a problem.

## Let's make a matrix with some missing values. Let's start with what we
## already had
dataMatrix2 <- dataMatrixOrdered

## and then throw in some NA values.
dataMatrix2[sample(1:100, size = 40, replace = FALSE)] <- NA

## What happens when we try to run a SVD? Answer: an error. 
svd1 <- svd(scale(dataMatrix2))

## This is going to happen when you are working with real data. 
## How do we clean this up?

## The impute package provides us with a good way to deal with missing values
## This is provided from bioconductor, so we have to use a different
## install procedure
source("http://bioconductor.org/biocLite.R")
biocLite()

## Now that we have this set, we should be able to install the "impute" 
## package
biocLite("impute")

## And then we can load it up
library(impute)

## The function we are interested in using in this package is the knn function.
## This is going to find missing data files in rows, and replace them with
## the surrounding data

## So, let's run through this again: make a matrix with some missing values
dataMatrix2 <- dataMatrixOrdered
dataMatrix2[sample(1:100,size=40,replace=FALSE)] <- NA

## Use impute.knn to remove these missing values.

dataMatrix2 <- impute.knn(dataMatrix2)$data

## Now we can conduct our svd, and plot
svd1 <- svd(scale(dataMatrixOrdered)); svd2 <- svd(scale(dataMatrix2))
par(mfrow=c(1,2)); plot(svd1$v[,1],pch=19); plot(svd2$v[,1],pch=19)


