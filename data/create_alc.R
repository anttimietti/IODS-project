#Name: Antti Miettinen
#Date: 12/11/2011
#or like this: date()
#File description: R script for the data wrangling part of Exercise 3
#Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

##### Data wrangling

#Read both student-mat.csv and student-por.csv into R (from the data folder) 
#and explore the structure and dimensions of the data.

setwd("~/IODS-project/data")

math <- read.csv("student-mat.csv", sep=";", header=TRUE)

por <- read.csv("student-por.csv", sep=";", header=TRUE)

str(math)
str(por)
#Both dataframes above have the same variables (rows)
#Some of the variables are factors, such as school, sex or famsize. 
#Some are integers such as age and absences.

dim(math)
#There are 395 observations and 33 rows

dim(por)
#There are 649 observations and 33 rows


#Join the two data sets using the variables "school", "sex", "age", "address", 
#"famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery", "internet" 
#as (student) identifiers. Keep only the students present in both data sets. 
#Explore the structure and dimensions of the joined data.

library(dplyr)

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob",
             "reason","nursery","internet")

math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

# glimpse at the data
glimpse(math_por)

#There are now 382 observations and 53 columns. Some variables are still factors and the others integers.


#Using the solution from the DataCamp exercise to combine the 'duplicated' answers in the joined data. 

#Creating a new data frame 'alc' with only the joined columns
alc <- select(math_por, one_of(join_by))

#These are the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

#Printing out the columns not used for joining
notjoined_columns

#Below is the for loop for combining the duplicated answers in the joined data:

#For every column name not used for joining...
for(column_name in notjoined_columns) {
  #Select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  #Select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  #If that first column vector is numeric...
  if(is.numeric(first_column)) {
    #Take a rounded average of each row of the two columns and
    #Add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { #Else if it's not numeric...
    #Add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

#Glimpse at the new combined data
glimpse(alc)
#There are now 382 observations and 33 variables. 
#In other words, there are no duplicated variables anymore.


#Take the average of the answers related to weekday and weekend alcohol consumption 
#to create a new column 'alc_use' to the joined data. 

#Defining a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#Use 'alc_use' to create a new logical column 'high_use' which is TRUE for students 
#for which 'alc_use' is greater than 2 (and FALSE otherwise).

#Defining a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)


#Glimpse at the joined and modified data to make sure everything is in order. 
#The joined data should now have 382 observations of 35 variables. 

glimpse(alc)
#Yes, it now has 382 observations and 35 variables.

#Save the joined and modified data set to the ‘data’ folder, 
#using for example write.csv() or write.table() functions.

write.table(alc, file="~/IODS-project/data/alc.txt", quote=FALSE, sep="\t", col.names=TRUE)


#Testing that it's still readable
alc_test <- read.table("~/IODS-project/data/alc.txt", sep="\t")

glimpse(alc_test)
str(alc_test)
#Looks good to me.