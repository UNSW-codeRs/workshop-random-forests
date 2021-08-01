#' ---
#' title: "Random Forest in R"
#' author: "JR Ferrer-Paris"
#' date: "02/08/2021"
#' tags: [UNSW coders, Workshop]
#' abstract: |
#'   This document will walk you through examples to fit random forest models for classification using the _randomForest_ package and two different datasets. This is part of the UNSW codeRs workshop: _Introduction to Classification Trees and Random Forests in R_ at https://github.com/UNSW-codeRs/workshop-random-forests
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
#' 
#' ## Overview
#' 
#' The random forest algorithm seeks to improve on the performance of a single decision tree by taking the average of many trees. Thus, a random forest can be viewed as an **ensemble** method, or model averaging approach.
#' 
#' Random forests use **bagging** and **variable randomization** to create different conditions for each tree. As a result, the average of these trees tends to be more accurate overall than a single tree.
#' 
#' ## What data do we need?
#' 
#' The same as any regular classification decision tree!
#' 
#' - Y: The output or response variable is a categorical variable with two or more classes (in R: factor with two or more levels)
#' - X: A set of predictors or features, might be a mix of continuous and categorical variables, they should not have any missing values
#' 
#' ### Load data
#' 
#' Here we will work again with two examples.
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
#' 
#' ## What package to use
#' 
#' Random Forests are implemented in several packages:
#' 
#' - _randomForest_: Breiman and Cutler's Random Forests for Classification and Regression
#' - _ranger_: A Fast Implementation of Random Forests
#' - _party_: A Laboratory for Recursive Partytioning
#' - _RandomForestsGLS_: Random Forests for Dependent Data
#' - _randomForestSRC_: Fast Unified Random Forests for Survival, Regression, and Classification (RF-SRC)
#' - _Rborist_: Extensible, Parallelizable Implementation of the Random Forest Algorithm
#' - etc.
#' 
#' Some helper packages are:
#' 
#' - _randomForestExplainer_: Explaining and Visualizing Random Forests in Terms of Variable Importance
#' - _vip_: Variable Importance Plots
#' - _varImp_: Variable Importance Plots
#' - _caret_: Classification and Regression Training
#' - _tidymodels_: tidy model framework (model workflows)
#' 
#' ### Load packages
#' 
#' Here we will work with package _randomForest_.
#' 
## ----load_packages--------------------------------------------------------------
library(randomForest)

#' 
#' 
#' ## Fit a model
#' 
#' ### _iris_ dataset
#' Let's start with a familiar dataset. Fitting the model is very straightforward.
#' 
## ----rf_iris--------------------------------------------------------------------
set.seed(3)
rf_model = randomForest(Species ~ ., data = iris, ntree=30)

#' 
#' The `print` method shows basic information about the fitted model:
## ----rf_iris_print--------------------------------------------------------------
print(rf_model)

#' 
#' We will go through these output in more detail, but first take a look at the  "OOB estimate of error rate", this shows us how accurate our model is. $accuracy = 1 - error\ rate$. OOB stands for "out of bag" - and bag is short for "bootstrap aggregation". So OOB estimates performance by comparing the predicted outcome value to the actual value across all trees using only the observations that were not part of the training data for that tree.
#' 
#' #### Tree complexity 
#' 
#' Ok, now let's look at the top of the output: `Number of trees: 30`. 
#' So a forest is made up of trees, right? Let's see tree number three:
#' 
## ----rf_iris_get_tree-----------------------------------------------------------
getTree(rf_model, 3, labelVar=TRUE)

#' 
#' This is not very user friendly... but normally we would focus on the forest rather than the individual trees.
#' 
#' Key question here is, why are these trees so complex compared to the ones we saw before? We can control the complexity of the trees with `nodesize` and `maxnode` parameters. For example a large node size and small number of nodes will result in simpler/shorter trees, but this could affect OOB error rates:
#' 
## ----rf_tuning1-----------------------------------------------------------------
rf2 = randomForest(Species ~ ., data = iris, ntree=30, nodesize=20, maxnodes=5)
print(rf2)
getTree(rf2, 3, labelVar=TRUE)

#' 
#' #### Variable randomization 
#' 
#' We can also control the complexity by tweaking the`number of variables sampled in each split` with the parameter `mtry`. By default `randomForest` will test one third of the variables in each split and choose the best one. Here we can force it to use four variables each time:
#' 
## ----rf_tuning2-----------------------------------------------------------------
rf3 = randomForest(Species ~ ., data = iris, ntree=30, mtry=4)
print(rf3)

#' 
#' #### Tuning hyper-parameters 
#' 
#' These three hyper-parameters (`maxnode`, `nodesize` and `mtry`) can be tuned to get better results:
#' 
## ----rf_tuning3-----------------------------------------------------------------
for (ns in c(5,25)) {
  for (mn in c(5,15)) {
    for (mt in c(2,4)) {
      rf1 <- randomForest(Species ~ ., data = iris, nodesize=ns, maxnodes=mn, mtry=mt, ntree=30)
      cat(sprintf("nodesize=%02d maxnodes=%02d mtry=%s OOB-error=%0.4f\n", ns, mn,mt, rf1$err.rate[30,"OOB"]))
    }
  }
}

#' 
#' However this is subject to variability due to randomness, and a better fine-tuning requires several replicate runs of each combinations. Some functions  can be used to do this more efficiently, for example `randomForest::tuneRF` or the workflow in packages `caret` or `tidymodels`.
#' 
#' ### _Breast cancer_ dataset
#' 
#' Let's look at the more complex example of breast cancer dataset to look at other aspects of the randomForest object.
#' 
## ----rf_breast_cancer-----------------------------------------------------------
set.seed(83)

BC.data <- subset(BreastCancer[,-1],!is.na(Bare.nuclei))

rf_model = randomForest(Class ~ ., data = BC.data,importance=TRUE)
print(rf_model)

#' 
#' #### Variable importance 
#' 
#' Random Forest estimates variable importance in two different ways: one is by comparing the accuracy of the original prediction with the accuracy of a prediction based on a randomly shuffled (permuted) variable. If a variable is important then the model's accuracy will suffer a large drop when it is randomly shuffled. But if the accuracy is similar, then the variable is not important to the model.
#' 
#' The second measure is the total decrease in node impurities from splitting on the variable, averaged over all trees. For classification, the node impurity is measured by the [Gini index](https://en.wikipedia.org/wiki/Gini_coefficient). It's basically a measure of diversity or dispersion - a higher gini means the model is classifying better.
#' 
## ----rf_variable_importance-----------------------------------------------------
importance(rf_model)

#' 
#' Notice for example that `Bl.cromatin` and `Normal.nucleoli` have similar values of mean decrease in overall accuracy when permuted, but they have different importance for each class.
#' 
#' The `varImpPlot` function can be used to produce a plot, use `type=1` for `MeanDecreaseAccuracy` and `type=2` for `MeanDecreaseGini`.
#' 
## ----rf_plot_importance---------------------------------------------------------
varImpPlot(rf_model,type=1)

#' 
#' #### Confusion matrix and votes
#' 
#' Now let's look at the prediction for each observation. The confusion matrix compares observed with predicted values and shows the classification error for each class.
#' 
## ----rf_confusion_matrix--------------------------------------------------------
rf_model$confusion

#' 
#' The classification error is very low, but we might be interested in exploring those cases of misclassification (we don't want a malign tumor to be misclassified). Each observation has a number of OOB predictions, these are considered "votes" for a class, and the observation is assigned to the class with the majority of votes. Let's look at the _votes_ object for this model:
#' 
## ----rf_votes-------------------------------------------------------------------
head(rf_model$votes)

#' 
#' We can compare the votes for the second class ('malignant') and compare them between the two classes:
#' 
## ----rf_votes_boxplot-----------------------------------------------------------
boxplot(rf_model$votes[,2]~rf_model$y,xlab="",ylab="votes for 'malignant'")
abline(h=0.5,lty=2,col=2)

#' 
#' Using a lower threshold (for example 0.4 or 0.3) to classify a tumor as malignant would reduce the false negative rate, but increase false positive rate. 
#' 
#' There are other machine-learning methods that focus on improving the performance for these hard-to-classify observations, but this would be a subject for another workshop!
#' 
#' ## Post-scriptum
#' 
#' #### Additional resources
#' 
#' - Davis David [**Random Forest Classifier Tutorial: How to Use Tree-Based Algorithms for Machine Learning**](https://www.freecodecamp.org/news/how-to-use-the-tree-based-algorithm-for-machine-learning/)
#' - Evan Muzzall and Chris Kennedy [**Introduction to Machine Learning in R**](https://dlab-berkeley.github.io/Machine-Learning-in-R/slides.html)
#' 
#' - Victor Zhou [**Random Forests for Complete Beginners**](https://victorzhou.com/blog/intro-to-random-forests/)
#' - Bradley Boehmke & Brandon Greenwell [**Hands-On Machine Learning with R**](https://bradleyboehmke.github.io/HOML/random-forest.html)
#' - Julia Kho [**Why Random Forest is My Favorite Machine Learning Model**](https://towardsdatascience.com/why-random-forest-is-my-favorite-machine-learning-model-b97651fa3706)
#' - JanBask Training [**A Practical guide to implementing Random Forest in R with example**](https://www.janbasktraining.com/blog/random-forest-in-r/)
#' 
#' #### Session information:
#' 
## ----sessionInfo----------------------------------------------------------------
sessionInfo()

