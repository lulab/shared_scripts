# this file introduces how to do machine learning using random forest in R 
#
# The script is written by 2018 rotation student, Zhuoer Dong <dongzhuoer@mail.nankai.edu.cn>
#
# The script is last edited on 2018/11/07


# Here we use **Random Forest** classifier as an example.


# 1) preparation ---------------

# we need the following packages
#   1. magrittr enable one style of writing R code. For why I use that style,  
#        please refer to https://r4ds.had.co.nz/pipes.html#piping-alternatives
#   2. dplyr: manipulate data frame
#   3. randomForest: build random forest model
#   4. ROCR: ROC analysis
#   5. GGally: plot correlation between features


# specify needed packages
cran_pkg <- c('magrittr', 'dplyr', 'randomForest', 'ROCR', 'GGally')
# install packages which doesn’t exist in your system 
#   (`.packages(T)` will list all existing packages in the system.)
lapply(cran_pkg, function(x) {if (!(x %in% .packages(T))) install.packages(x)})

# To avoid conflict of function name, in the following code, 
#   I prefer `pkg::fun()` instead of `library(pkg)`.
library(magrittr)


# Before we start, let set the random seed to make our results reproducible:

set.seed(0) 

# 2) Generate/Read a data set -------------

# We use one of R’s built-in data set, `iris`, Edgar Anderson’s Iris Data set.

# The original data set contains observations for four features 
#   (sepal length and width, and petal length and width — all in cm) of 
#   150 flowers of three species (each 50).

# To make things simple, here we only choose two species, 
#   `versicolor` and `virginica`.

# The frist line turn iris into a tibble, a modern reimagining of the data.frame.
# The second line select rows whose species is not setosa, 
#   so only versicolor and virginica are left.
# The third line drops factor level of Species variable, 
#   randomForest::randomForest() would complain if you don’t do this. 
#   (This is a little technical, the orignial Species contains three levels, 
#   setosa, versicolor and virginica. Although we remove all setosa values, 
#   the setosa level still exists, and now this level contains no values, 
#   that would cause randomForest::randomForest() to fail. 
#   After we call factor(), Species only contains two levels, 
#   both do have values.)
df <- iris %>% tibble::as_tibble() %>% 
    dplyr::filter(Species != 'setosa') %>%
    dplyr::mutate(Species = factor(Species))


# Let’s have a look at our data (only part of it is shown):
df %>% {dplyr::bind_rows(head(., 3), tail(., 3))}


# 3) Divide the data into training and test sets --------------

# Before we build the model, 
#   we need to divide the data set into training set and testing set. 
#   So we can train our model using data in training set, 
#   and evalute the model using data in testing set.

# Here we randomly assigns 80 percent samples to the training set, 
#   and the left 20 percent to the testing set.


# The following code seems a little complicated, 
#   and it require you to be familiar with the R language. 

# Anyway, I will try to use a simple example to explain the core idea:
#   - Image your data contains only 5 rows, then 80 percent is 5 * 0.8 = 4 
#       (here `nrow_training` is `4`). 
#   - Image you decide to choose the 1st, 2nd, 3rd and 5th rows for training 
#       (here `indexes` is `c(1, 2, 3, 5)`)
#   - Now `training` contains the 1st, 2nd, 3rd and 5th rows of `df` 
#       (`[indexes, ]` means to choose these rows)
#   - And `testing` contains the 4th row of `df` 
#       (`[-indexes, ]` means not to choose these rows, 
#       so only the 4th row is left)

nrow_training <- floor(nrow(df) * 0.8)  # Calculate the size of training sets
indexes <- sample(1:nrow(df), nrow_training)  # these rows will be select for training

training <- df[indexes, ] 
testing <- df[-indexes, ]

# 4) Build the model on training set -----------------

# Then we can build a random forest model.

# The code is fairly easy and straightforward:
#   - `Species` is the reponse variable
#   - `.` tells that all other variables are features
#   - `training` is the data to train the model
rf_classifier = randomForest::randomForest(Species ~ ., training)


# Let’s have a look at our model
rf_classifier


# 5) Evaluate the model on test set --------------------

# After we build the model, we can make prediction on the testing set:

# `predict()` needs two arguments, the model and a `data.frame` of features. 
#   (`-ncol(testing)` means to drop the last column, 
#   so `testing[, -ncol(testing)` only contains features)
predicted_value <- predict(rf_classifier, testing[, -ncol(testing)])

# we use `testing[[ncol(testing)]]` to get the last column, i.e, 
#   the real value of `Species` in the testing set
real_value <- testing[[ncol(testing)]]

# As you can see, `predicted_value` and `real_value` both contains 20 values, 
#   correspond to 20 rows of testing data. 
# Each value tells a row belongs which species, 
#   the former is the model’ precdiction, the latter is the real case.
predicted_value
real_value

# We can reformat the result to make it more clear:
tibble::tibble(predicted_value, real_value) %>% 
    tibble::add_column(correct = predicted_value == real_value) 

# You can summarise the result into a confusion matrix, 
#   and calculate sensitivity, specificity, accuracy, etc.


# 6) ROC ------------------------------

# Finally, let’s draw a ROC curve.


# for each row, 
#   we use the model to predict the probability of it belongs to each species
probability <- predict(rf_classifier, testing[, -ncol(testing)], type = 'prob')

# we flag the first level (`versicolor` here, notice the `[1]`) as `1`, 
#   the second level (`virginica` here) as `0`.
#   (`as.integer()` will convert `T` to `1`, `F` to `0`.)
label <- as.integer(testing[[5]] == colnames(probability)[1])


# we calculate the ROC statistics. 
#   `[ , 1]` chooses the first column, corresponds to the `[1]` above.
prediction <- ROCR::prediction(probability[ , 1], label)

 

# Plot the ROC using false positive rate (`'fpr'`) as x axis, 
#   true positive rate (`'tpr'`) as y axis.
prediction %>% 
    ROCR::performance('tpr', 'fpr') %>% 
    ROCR::plot(main = 'ROC Curve')


# Finally, we can cauculate the AUC


ROCR::performance(prediction, 'auc')@y.values[[1]]
