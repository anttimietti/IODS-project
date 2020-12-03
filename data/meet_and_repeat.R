#Name: Antti Miettinen
#Date: 3/12/2020

#File description: R script for the data wrangling part of Exercise 6.

#Source of BPRS data set: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
#Source of RATS data set: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

#Note: The data are in wide form now.

### DATA WRANGLING FOR EXERCISE 6

#1) Load the data

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  = "\t", header = T)

#Taking a look at the data sets

library(dplyr)
library(tidyr)

glimpse(BPRS)
str(BPRS)
#BRPS has 40 observations and 11 columns (variables)

glimpse(RATS)
str(RATS)
#RATS has 16 observations and 13 columns (variables)

summary(BPRS)
#To illustrate the significance of the wide form here.

summary(RATS)
#To illustrate the significance of the wide form here.

#2) Convert the categorical variables of both data sets to factors

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

str(BPRS)
str(RATS)

#3) Convert the data sets to long form & add a week variable to BPRS and a Time variable to RATS

#Converting to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group) 

#Adding 'week' variable to BPRS data
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

#Adding 'Time' variable to RATS data
RATSL <- RATSL %>% mutate(Time = as.integer(substr(WD, 3, 4))) 

#4) Take a serious look at the new data sets & compare with wide form versions

glimpse(BPRSL)
glimpse(RATSL)

str(BPRSL)
str(RATSL)

#Now BPRSL has 360 observations of 5 variables
#Now RATSL has 176 observations of 5 variables

summary(BPRSL)
summary(RATSL)
 
#In short, whereas in the wide form each observation (individual subject) in the BPRS data set
#had their data on one row, now they are split to nine rows, according to weeks. 

#In the RATS data each subject (ID) had one row, but now each subject's observations are on 11 rows, 
#according to Time.  

#Saving the wrangled (long form) data

write.table(BPRSL, file="~/IODS-project/data/BPRSL.txt", sep="\t", col.names=TRUE)
write.table(RATSL, file="~/IODS-project/data/RATSL.txt", sep="\t", col.names=TRUE)

#Testing that it's still readable
BPRSL_test <- read.table("~/IODS-project/data/BPRSL.txt", sep="\t")
RATSL_test <- read.table("~/IODS-project/data/RATSL.txt", sep="\t")

glimpse(BPRSL_test)
glimpse(RATSL_test)
#Looks good!