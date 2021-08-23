# Workshop: randomForest in R

![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

José R. Ferrer-Paris (@jrfep) for UNSW codeRs.

## Abstract

"Random Forests" are used everywhere, and for good reason! Random Forest is a powerful and versatile _machine learning_ algorithm that grows and combines multiple decision trees to create a "forest". It sounds very complex, but learning to use them is very intuitive, specially if you got a **USNW codeRs workshop** to help you. JR will give a beginner friendly introduction to Random Forests applied to classification problems.

We will start our workshop using decision trees to describe rules for classifying data, and discuss how multiple, randomized trees can get us to more accurate classifications. We will use guide you through the code needed to fit classification trees and Random Forests using popular R packages. Before you know it, you will be talking about 'bagging', 'variable randomization' and 'ensembles prediction' like a pro.

Come with the latest version of R loaded on your laptop, or come a few minutes early so we can help you load it!

## Bio

José Rafael Ferrer-Paris (a.k.a. JR) is currently Research Fellow at the Center for Ecosystem Science at UNSW, and a member of the International Union for the Conservation of Nature (IUCN) Thematic Group on Red List of Ecosystems. JR has studied and worked in Venezuela, Germany and South Africa with biodiversity data, spatial and temporal ecological data and geographical information systems. He is currently working with Prof. David Keith on global risk assessment of ecosystems. He has been using R since version 1.0.0, and also likes working with other command, scripting and programming languages like PHP, Bash, Python, JS, Java or Perl and all kinds of databases (SQL, XML, GDB).


## Material based on:

- Davis David **Random Forest Classifier Tutorial: How to Use Tree-Based Algorithms for Machine Learning** https://www.freecodecamp.org/news/how-to-use-the-tree-based-algorithm-for-machine-learning/
- Evan Muzzall and Chris Kennedy **Introduction to Machine Learning in R**: https://dlab-berkeley.github.io/Machine-Learning-in-R/slides.html | https://github.com/dlab-berkeley/Machine-Learning-in-R | https://github.com/dlab-berkeley/Machine-Learning-with-tidymodels
- Dave Tang **Building a classification tree in R** https://davetang.org/muse/2013/03/12/building-a-classification-tree-in-r/
- Zach @ Statology **How to Fit Classification and Regression Trees in R** https://www.statology.org/classification-and-regression-trees-in-r/
- Ben Gorman **Decision Trees in R using rpart** https://www.gormanalysis.com/blog/decision-trees-in-r-using-rpart/
- Victor Zhou **Random Forests for Complete Beginners** at https://victorzhou.com/blog/intro-to-random-forests/
- Bradley Boehmke & Brandon Greenwell **Hands-On Machine Learning with R** https://bradleyboehmke.github.io/HOML/random-forest.html
- Julia Kho **Why Random Forest is My Favorite Machine Learning Model** https://towardsdatascience.com/why-random-forest-is-my-favorite-machine-learning-model-b97651fa3706
- JanBask Training **A Practical guide to implementing Random Forest in R with example** https://www.janbasktraining.com/blog/random-forest-in-r/

## R-markdown

To generate or update the R-scripts from R-markdown documents use:

```{r}
knitr::purl("01-hands-on-classification-tree.Rmd",documentation=2)
knitr::purl("02-hands-on-random-forest.Rmd",documentation=2)
```
