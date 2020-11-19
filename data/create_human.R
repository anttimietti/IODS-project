#Name: Antti Miettinen
#Date: 19/11/2011
#or like this: date()
#File description: R script for the data wrangling part of Exercise 4
#Data source: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
#and http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv


##### Data wrangling

#Data wrangling for next week’s data

#Create a new R script called create_human.R
#Read the “Human development” and “Gender inequality” datas into R. Here are the links to the datasets:
  
setwd("~/IODS-project/data")

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Meta files for the datasets: http://hdr.undp.org/en/content/human-development-index-hdi
#And http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

# Explore the datasets: 
# See the structure and dimensions of the data. Create summaries of the variables.

str(hd)
dim(hd)
#195 observations and 8 variables in the hd dataset

str(gii)
dim(gii)
#195 observations and 10 variables in the gii dataset

summary(hd)
summary(gii)

#Look at the meta files (http://hdr.undp.org/en/content/human-development-index-hdi) 
#and rename the variables with (shorter) descriptive names. (1 point)

hd <- hd %>% rename(HDI = Human.Development.Index..HDI., 
                    LifeExp = Life.Expectancy.at.Birth, 
                    EduExp = Expected.Years.of.Education,
                    EduYrs = Mean.Years.of.Education,
                    GNI = Gross.National.Income..GNI..per.Capita,
                    GNIHDI = GNI.per.Capita.Rank.Minus.HDI.Rank)

gii <- gii %>% rename(GII = Gender.Inequality.Index..GII., 
                      MatMort = Maternal.Mortality.Ratio,
                      AdolBirth = Adolescent.Birth.Rate,
                      ParlRep = Percent.Representation.in.Parliament,
                      EduFem = Population.with.Secondary.Education..Female.,
                      EduMale = Population.with.Secondary.Education..Male.,
                      LabFem = Labour.Force.Participation.Rate..Female.,
                      LabMale = Labour.Force.Participation.Rate..Male.)

#Checking that the variable names are changed.
glimpse(hd)
glimpse(gii)
#Looks good.

#Mutate the “Gender inequality” data and create two new variables. 

#The first one should be the ratio of Female and Male populations 
#with secondary education in each country.

library(dplyr)

gii <- mutate(gii, edu_sexratio = EduFem / EduMale)

#The second new variable should be the ratio of labour force participation of females and males 
#in each country.

gii <- mutate(gii, lab_sexratio = LabFem / LabMale)

#Checking that new variables are there:
glimpse(gii)
#Looks good.

#Join together the two datasets using the variable Country as the identifier. 
#Keep only the countries in both data sets.

join_by <- c("Country")

hd_gii <- inner_join(hd, gii, by = join_by, suffix = c(".hd", ".gii"))

#The joined data should have 195 observations and 19 variables. 

glimpse(hd_gii)
#It does.

#Call the new joined data "human" and save it in your data folder.

human <- hd_gii

write.table(human, file="~/IODS-project/data/human.txt", sep="\t", col.names=TRUE)

#Testing that it's still readable
human_test <- read.table("~/IODS-project/data/human.txt", sep="\t")

glimpse(human_test)
#Looks good.