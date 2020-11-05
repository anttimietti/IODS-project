#Name: Antti Miettinen
#Date: 
date()
#File description: ... (one sentence) 
#Data source: ...

##### Data wrangling

# 1) Create a folder named ‘data’ in your IODS-project folder.
# Done.

# 2) Read the full learning2014 data into R
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                header=TRUE, sep="\t")

# Explore the structure of the data
str(learning2014)
# Describe the output: This is a data frame of 183 observations and 60 variables.
# All other variables (columns) are integers, 
# but the last one (gender) is a factor with 2 levels.

# Explore the dimensions of the data
dim(learning2014)
# Describe the output: There are 183 rows and 60 columns in the data.
# The output looks like this:
# [1] 183  60

# 3) Create an analysis dataset with the variables 

# gender, age, attitude, deep, stra, surf and points 

# by combining questions in the learning2014 data, as defined in the datacamp exercises 
# and also on the bottom part of the following page
# http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt. 
 

# Accessing the dplyr library for this
library(dplyr)

# Combining questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# Scale all combination variables to the original scales (by taking the mean). 

learning2014$Attitude <- learning2014$Attitude / 10
#This is done because the column Attitude is a sum of 10 questions related to students 
#attitude towards statistics, each measured on the Likert scale (1-5). 
#Scaling the combination variable back to the 1-5 scale.

# Selecting the columns related to deep learning and creating column 'deep' by averaging
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

# Selecting the columns related to surface learning and creating column 'surf' by averaging
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

# Selecting the columns related to strategic learning and creating column 'stra' by averaging
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)


str(learning2014)

# Selecting only these 7 columns:
# gender, age, attitude, deep, stra, surf, points 

keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# Select the 'keep_columns' to create a new dataset 
# Calling the new dataset "learning2014_chosen"
learning2014_chosen <- select(learning2014, one_of(keep_columns))


# print out the column names of the data
colnames(learning2014_chosen)

# change the name of the second column
colnames(learning2014_chosen)[2] <- "age"

colnames(learning2014_chosen)[3] <- "attitude"

# change the name of "Points" to "points"
colnames(learning2014_chosen)[7] <- "points"

# print out the new column names of the data
colnames(learning2014_chosen)



###################head(learning2014$Attitude)




# Exclude observations where the exam points variable is zero. 

# Selecting rows where points is greater than zero
learning2014_chosen <- filter(learning2014_chosen, points > 0)

# (The data should then have 166 observations and 7 variables) (1 point)
# It does.



# 4) Set the working directory of your R session the iods project folder. 
# Save the analysis dataset to the ‘data’ folder, using for example write.csv() 
# or write.table() functions. You can name the data set for example as 
# learning2014(.txt or .csv). See ?write.csv for help or search the web for 
# pointers and examples. Demonstrate that you can also read the data again 
# by using read.table() or read.csv(). 
# (Use `str()` and `head()` to make sure that the structure of the data is correct). (3 points)

setwd("~/IODS-project")

?write.csv



learningdata <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/learning2014.txt", header=TRUE, sep=",")
