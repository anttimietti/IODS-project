#Name: Antti Miettinen

#Date: 26/11/2011
#or like this: date()

#File description: R script for the data wrangling part of Exercise 5. The data was originally wrangled
#in file "create_human.R".

#Data source: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
#and http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv

##### Data wrangling

#Load the 'human' data into R. 

human <- read.table("~/IODS-project/data/human.txt")

glimpse(human)

#Explore the structure and the dimensions of the data
#and describe the dataset briefly.

str(human)
dim(human)
#The data consist of 195 observations (rows) and 19 variables (columns).
#The dataset consists of 

...

#Mutate the data: transform the Gross National Income (GNI) variable to numeric.

#First, access the stringr package
library(stringr)

human$GNI <- as.numeric(human$GNI)
str(human)

#Remove the commas from GNI and print out a numeric version of it
#str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric()


#Exclude unneeded variables: keep only the columns matching the following variable names: 
#"Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"

#Columns to keep (names here as I have named them in my dataset)
keep <- c("Country", "edu_sexratio", "lab_sexratio", "LifeExp", "EduExp", 
          "GNI", "MatMort", "AdolBirth", "ParlRep")

#Select the 'keep' columns
human <- select(human, one_of(keep))

#Check that only the mentioned columns are kept:
str(human)

#Remove all rows with missing values

#First, print out a completeness indicator of the 'human' data
complete.cases(human)

#Print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

#Filter out all rows with NA values
human_noNA <- filter(human, complete.cases(human) == TRUE)

#Check that there are no columns with missing values:
complete.cases(human_noNA)

#Remove the observations which relate to regions instead of countries.

#First, look at the last 10 observations of human_noNA
tail(human_noNA, n = 10)

#Then, define the last indice we want to keep
last <- nrow(human_noNA) - 7

#Choose everything until the last 7 observations
human_ <- human_noNA[1:last, ]

str(human_)

#Define the row names of the data by the country names and remove the country name column from the data. 
#The data should now have 155 observations and 8 variables. 

rownames(human_) <- human_$Country

human_ <- select(human_, -Country)

str(human_)
#Yep, 155 observations and 8 variables.

#Save the human data, including the row names, in the data folder. 
#Overwriting the old 'human' data.

write.table(human_, file="~/IODS-project/data/human.txt", sep="\t", col.names=TRUE)

#Testing that it's still readable
human_test <- read.table("~/IODS-project/data/human.txt", sep="\t")

glimpse(human_test)
#Looks good.