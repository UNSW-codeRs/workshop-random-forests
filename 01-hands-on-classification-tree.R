#' ---
#' title: "Session 1: Decision Trees in R"
#' author: "JR Ferrer-Paris"
#' date: "02/08/2021"
#' tags: [UNSW coders, Workshop]
#' abstract: |
#'   This document will walk you through examples to fit decision trees for classification using the _rpart_ package and two different datasets. This is part of the UNSW codeRs workshop: _Introduction to Classification Trees and Random Forests in R_ at https://github.com/UNSW-codeRs/workshop-random-forests
#' 
#'   UNSW codeRs is a student and staff run community dedicated for ‘R’ users for anyone who wants to further develop their coding skills. It is our goal to create a safe and open space for members to share and gain new experiences relating to R, coding and statistics.
#' 
#'   https://unsw-coders.netlify.app/
#' output:
#'     pdf_document:
#'         template: NULL
#' editor_options:
#'   chunk_output_type: console
#' ---
#' ## Overview
#' 
#' Decision trees are recursive partitioning methods that divide the predictor spaces into simpler regions and can be visualized in a tree-like structure. They attempt to classify data by dividing it into subsets according to a Y output variable and based on some predictors.
#' 
#' ## What data do we need?
#' 
#' - Y: The output or response variable is a categorical variable with two or more classes (in R: factor with two or more levels)
#' - X: A set of predictors or features, might be a mix of continuous and categorical variables, they should not have any missing values
#' 
#' ### Load data
#' 
#' Here we will work with two examples.
#' 
#' First, we will use the _iris_ dataset from base R. This dataset has 150 observations with four measurements (continuous variables) for three species (categorical variable with three categories):
#' 
## ----dataset1-------------------------------------------------------------------
data(iris)
str(iris)

#' 
#' As a second example we will use the Breast Cancer dataset from the _mlbench_ package. This dataset has 699 observations with 9 nominal or ordinal variables describing cell properties and the output or target variable is the class of tumor with two possible values: bening or malignant:
#' 
## ----dataset2-------------------------------------------------------------------
require(mlbench)
data(BreastCancer)
str(BreastCancer)

#' 
#' ## What package to use
#' 
#' Classification trees are implemented in packages:
#' 
#' - _tree_: Classification and Regression Trees
#' - _rpart_: Recursive Partitioning and Regression Trees
#' 
#' ### Load packages
#' 
#' Here we will work with package _rpart_, and we will also load additional packages for creating the plots
#' 
## ----load_packages--------------------------------------------------------------
library(rpart)
# auxiliary packages for plotting:
library(rpart.plot)

#' 
#' 
#' ## Fit a model
#' 
#' ### _iris_ dataset
#' Let's start with a familiar dataset:
#' 
## ----tree_iris------------------------------------------------------------------
set.seed(3)

tree = rpart::rpart(Species ~ ., data = iris,
             method = "class")
print(tree)

#' 
#' This is a very simple tree and we can walk through the output recognising three levels of nodes: (1) is the root node, (2) and (3) are the branches based on Petal Length. Branch (2) has 50 samples all belong to the first class (setosa), branch (3) has 100 samples of two different classes. Branch (3) splits into two further branches (6) and (7) based on petal width, these end-nodes (or leaf-nodes) have 54 and 46 samples respectively.
#' 
#' We can visualise the same information in a fancy _rpart.plot_:
#' 
## ----plot_tree_iris-------------------------------------------------------------
rpart.plot::rpart.plot(tree)

#' 
#' This function use different colors for each category, splits are labelled with the variable and threshold used. Root nodes are on top, and end-nodes are at the bottom, each node is labelled with the modal category and has information on the proportion of observation in each category and the percentage of the total sample size.
#' 
#' When an end node only contains samples from a single class it is considered to be "pure". So the end-node for _I. setosa_ at the bottom left is pure, the other end-nodes have 2 and 9% impurity.
#' 
#' ### _Breast cancer_ dataset
#' 
#' Now let's look at a more challenging dataset.
#' 
#' 
## ----tree_breast_cancer---------------------------------------------------------
set.seed(3)

BC.data <- BreastCancer[,-1]

tree = rpart::rpart(Class ~ ., data = BC.data,
             method = "class")
print(tree)

#' 
#' This is a more complex tree with up to five levels of branching, can you see them?
#' 
#' The plot is a great visual aid, but what do all these values mean?
#' 
## ----plot_tree_breast_cancer----------------------------------------------------
rpart.plot::rpart.plot(tree)

#' 
#' Here the output or response variable has two categories, so the rules are slightly simplified, but is actually all pretty similar as the previos example. Each box is labelled with the modal category on top, the proportion of observations in the second class within each group (in this case 'malignant'), and the percentage of total observation within the group. Compare figure and text to try make sense of this.
#' 
#' 
#' #### Variable importance
#' 
#' We can also look inside of `tree` object to see its components, for example  "variable.importance":
#' 
## ----variable_importance--------------------------------------------------------
names(tree)
data.frame(tree$variable.importance)

#' 
#' #### Complexity parameter
#' 
#' In decision trees the main hyperparameter (configuration setting) is the **complexity parameter** (CP), but the name is a little counterintuitive; a high CP results in a simple decision tree with few splits, whereas a low CP results in a larger decision tree with many splits.
#' 
#' `rpart` uses cross-validation internally to estimate the accuracy at various CP settings. We can review those to see what setting seems best.
#' 
#' Print the results for various CP settings - we want the one with the lowest "xerror".
#' 
## ----print_complex_parameter----------------------------------------------------
printcp(tree)

#' 
#' We can visualise this using this function:
#' 
## ----plot_complex_parameter-----------------------------------------------------
plotcp(tree)

#' 
#' There is an obvious drop between 1 and 2, but afterwards the differences in xerror are pretty small. Considering that a tree with fewer splits might be easier to interpret we can adjust the `cp` value:
#' 
## ----prune_tree-----------------------------------------------------------------
tree_pruned2 = prune(tree, cp = 0.037)

#' 
#' How does it look?
#' 
## -------------------------------------------------------------------------------
rpart.plot(tree_pruned2)

#' 
#' So this tree looks much simpler, but is it good enough? Notice that the end-nodes on the left and right have relative low impurity and together include 96% of the original sample. So with only two variables we can get a good discrimination of most of the samples.
#' 
#' If we want to look at the detailed results, variable importance, and summary of splits we can use:
#' 
## -------------------------------------------------------------------------------
summary(tree_pruned2)

#' 
#' And compare this output with the previous `tree` object.
#' 
#' 
#' That's it for now! Let's move to the next [document](02-hands-on-randmom-forest.Rmd).
#' 
#' ## Post-scriptum
#' 
#' #### Additional resources
#' 
#' - Davis David [**Random Forest Classifier Tutorial: How to Use Tree-Based Algorithms for Machine Learning**](https://www.freecodecamp.org/news/how-to-use-the-tree-based-algorithm-for-machine-learning/)
#' - Evan Muzzall and Chris Kennedy [**Introduction to Machine Learning in R**](https://dlab-berkeley.github.io/Machine-Learning-in-R/slides.html)
#' - Dave Tang [**Building a classification tree in R**](https://davetang.org/muse/2013/03/12/building-a-classification-tree-in-r/)
#' - Zach @ Statology [**How to Fit Classification and Regression Trees in R**](https://www.statology.org/classification-and-regression-trees-in-r/)
#' - Ben Gorman [**Decision Trees in R using rpart**](https://www.gormanalysis.com/blog/decision-trees-in-r-using-rpart/)
#' 
#' 
#' #### Session information:
#' 
## ----sessionInfo----------------------------------------------------------------
sessionInfo()

