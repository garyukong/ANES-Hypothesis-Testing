## title: Lab 1 Part 2- Data Wrangling
## author: "Gary Kong, Yeshwanth Somu, Maiya Caldwell, and Clara Zhu"

## Reading in file and getting baseline

## Reading in file
anes_timeseries_2020_csv_20220210 = read.csv("C:/Users/Yeshwanth Somu/Documents/UC Berkeley/W203/lab-1-caldwell_kong_somu_zhu/anes_timeseries_2020_csv_20220210.csv")

# Remove unnecessary columns 
ANES = subset(anes_timeseries_2020_csv_20220210, 
              select = c(V200003, V201025x, V201231x, V202051, V200004, V202052, V202065x, V202066, V202119))

nrow(ANES) ## 8280 rows to begin with across all survey methods



# 2. Subsetting for 2020 cohort only

# Keep records for 2020 only
ANES = ANES[!ANES$V200003 == 2,]; nrow(ANES) ## 5441 rows

 

# 3. Both Pre & Post election data available

ANES = ANES[ANES$V200004 == 3,]; nrow(ANES)




# Separate data by survey method
Web_Only = ANES[(ANES$V200003==3 | ANES$V200003==4),] 
nrow(Web_Only)
Web_Phone = ANES[ANES$V200003==5,]
nrow(Web_Phone)
Web_Phone_Video = ANES[ANES$V200003==6,]
nrow(Web_Phone_Video)


## Data Wrangling- Initial Data Cleaning and Filtering for Survey Type

#4. Voter logic- filter for voters only

voting_logic <- function(df){
  df$Voter = ( (df$V201025x== 3) | 
                 (df$V201025x == 4) |
                 (df$V202052 == 1) | 
                 (df$V202051 == 1) | (df$V202051 == 2) |
                 (df$V202066 == 4) )
  df = df[df$Voter == TRUE,]
  return (df)
}

ANES = voting_logic(ANES); nrow(ANES) ## 4507 rows



# 5. Democrat vs Republican- filter for these parties
library(dplyr)
party_logic <- function(df){
  
  df$Party = ifelse(df$V202065x==1, "Democrat", 
                   ifelse(df$V202065x==2, "Republican", 
                          ifelse((df$V201231x == 1) | (df$V201231x == 2) | (df$V201231x == 3), "Democrat", 
                                 ifelse((df$V201231x == 5) | (df$V201231x == 6) | (df$V201231x == 7), "Republican", "Other"))))
  
  df = filter(df, Party == "Democrat" | Party == "Republican") ## removing non-Democrats or Republicans
  
  
  return (df)
}

ANES = party_logic(ANES); nrow(ANES)


# Valid response to 7-point scale
# Include those who provided difficulty factor(column V202119)
ANES = ANES[ANES$V202119 > 0,]; nrow(ANES) ## 3772 rows

## changing column name of difficulty voting
colnames(ANES)[colnames(ANES) == "V202119"] ="Voting_Difficulty_Level"

# Here is a breakdown of the three different survey types and percentage of each Party in each.

# Separate data by survey method
ANES = ANES[(ANES$V200003==3 | ANES$V200003==4 | ANES$V200003==5 | ANES$V200003==6),]
ANES$Survey = ifelse((ANES$V200003==3 | ANES$V200003==4), "Web Only", 
       ifelse(ANES$V200003==5, "Web Phone Only",
              ifelse(ANES$V200003==6, "Web Phone Video", "Other")))

source("http://pcwww.liv.ac.uk/~william/R/crosstab.r")
crosstab(ANES, row.vars = "Survey", col.vars = "Party", type="c") 


# Splitting into three groups and stratifying

Web_Only = ANES[(ANES$V200003==3 | ANES$V200003==4),] 
print(c("Web-only:", nrow(Web_Only)))

Web_Phone = ANES[ANES$V200003==5,]
print(c("Phone/Web:", nrow(Web_Phone)))

Web_Phone_Video = ANES[ANES$V200003==6,]
print(c("Video/Phone/Web:", nrow(Web_Phone_Video)))



## Crosstabs section
# 1. Web only

# Get crosstab data as a dataframe
c_web = as.data.frame.matrix(crosstab(Web_Only, row.vars="Voting_Difficulty_Level", col.vars = "Party", type="c")$crosstab)
# Add a new column as difficulty level
c_web = cbind(Difficulty=c(1:5, "Sum"), c_web)
# Classify difficulty level into "Not Difficult" and "Difficult"
c_web[nrow(c_web)+1,] = 
  c("Not Difficult(1-2)", round(c_web$Democrat[1]+c_web$Democrat[2], digits = 2), round(c_web$Republican[1]+c_web$Republican[2], digits = 2))
# Transform values to numeric
c_web$Democrat = sapply(c_web$Democrat, as.numeric)
c_web$Republican = sapply(c_web$Republican, as.numeric)
c_web[nrow(c_web)+1,] =
  c("Difficult(3-5)", round(c_web$Democrat[3]+c_web$Democrat[4]+c_web$Democrat[5], digits = 2), round(c_web$Republican[3]+c_web$Republican[4]+c_web$Republican[5], digits = 2))
c_web$Delta = sapply(c_web$Democrat, as.numeric) - sapply(c_web$Republican, as.numeric)
tail(c_web,2)


# 2.Web_Phone

# Get crosstab data as a dataframe
c_web_phone = as.data.frame.matrix(crosstab(Web_Phone, row.vars="Voting_Difficulty_Level", col.vars = "Party", type="c")$crosstab)
# Add a new column as difficulty level
c_web_phone = cbind(Difficulty=c(1:5, "Sum"), c_web_phone)
# Classify difficulty level into "Not Difficult" and "Difficult"
c_web_phone[nrow(c_web_phone)+1,] = 
  c("Not Difficult(1-2)", round(c_web_phone$Democrat[1]+c_web_phone$Democrat[2], digits = 2), round(c_web_phone$Republican[1]+c_web_phone$Republican[2], digits = 2))
# Transform values to numeric
c_web_phone$Democrat = sapply(c_web_phone$Democrat, as.numeric)
c_web_phone$Republican = sapply(c_web_phone$Republican, as.numeric)
c_web_phone[nrow(c_web_phone)+1,] =
  c("Difficult(3-5)", round(c_web_phone$Democrat[3]+c_web_phone$Democrat[4]+c_web_phone$Democrat[5], digits = 2), round(c_web_phone$Republican[3]+c_web_phone$Republican[4]+c_web_phone$Republican[5], digits = 2))
c_web_phone$Delta = sapply(c_web_phone$Democrat, as.numeric) - sapply(c_web_phone$Republican, as.numeric)
tail(c_web_phone,2)


# 3.Web_Phone_Video

# Get crosstab data as a dataframe
c_web_phone_video = as.data.frame.matrix(crosstab(Web_Phone_Video, row.vars="Voting_Difficulty_Level", col.vars = "Party", type="c")$crosstab)
# Add a new column as difficulty level
c_web_phone_video = cbind(Difficulty=c(1:5, "Sum"), c_web_phone_video)
# Classify difficulty level into "Not Difficult" and "Difficult"
c_web_phone_video[nrow(c_web_phone_video)+1,] = 
  c("Not Difficult(1-2)", round(c_web_phone_video$Democrat[1]+c_web_phone_video$Democrat[2], digits = 2), round(c_web_phone_video$Republican[1]+c_web_phone_video$Republican[2], digits = 2))
# Transform values to numeric
c_web_phone_video$Democrat = sapply(c_web_phone_video$Democrat, as.numeric)
c_web_phone_video$Republican = sapply(c_web_phone_video$Republican, as.numeric)
c_web_phone_video[nrow(c_web_phone_video)+1,] =
  c("Difficult(3-5)", round(c_web_phone_video$Democrat[3]+c_web_phone_video$Democrat[4]+c_web_phone_video$Democrat[5], digits = 2), round(c_web_phone_video$Republican[3]+c_web_phone_video$Republican[4]+c_web_phone_video$Republican[5], digits = 2))
c_web_phone_video$Delta = sapply(c_web_phone_video$Democrat, as.numeric) - sapply(c_web_phone_video$Republican, as.numeric)
tail(c_web_phone_video,2)




## Plots- Party Distribution across survey methods
library(reshape2)
library(ggplot2)
# Get crosstab data as a dataframe
web_df =  as.data.frame.matrix(crosstab(Web_Only, row.vars="Voting_Difficulty_Level", col.vars = "Party", type="c")$crosstab)
# Add a new column as difficulty level
web_df = cbind(Difficulty=c(1:5, "Sum"), web_df)
web_df = web_df[web_df$Difficulty!="Sum",]

web_df = melt(web_df, id = "Difficulty", value.name = "Percentage_of_Party", names_to = c("Party"))
colnames(web_df)[colnames(web_df) == "variable"] = "Party"
web_df$Percentage_of_Party = round(web_df$Percentage_of_Party, 1)


# Get crosstab data as a dataframe
web_phone_df =  as.data.frame.matrix(crosstab(Web_Phone, row.vars="Voting_Difficulty_Level", col.vars = "Party", type="c")$crosstab)
# Add a new column as difficulty level
web_phone_df = cbind(Difficulty=c(1:5, "Sum"), web_phone_df)
web_phone_df = web_phone_df[web_phone_df$Difficulty!="Sum",]

web_phone_df = melt(web_phone_df, id = "Difficulty", value.name = "Percentage_of_Party", names_to = c("Party"))
colnames(web_phone_df)[colnames(web_phone_df) == "variable"] = "Party"
web_phone_df$Percentage_of_Party = round(web_phone_df$Percentage_of_Party, 1)



# Get crosstab data as a dataframe
web_phone_video_df =  as.data.frame.matrix(crosstab(Web_Phone_Video, row.vars="Voting_Difficulty_Level", col.vars = "Party", type="c")$crosstab)
# Add a new column as difficulty level
web_phone_video_df = cbind(Difficulty=c(1:5, "Sum"), web_phone_video_df)
web_phone_video_df = web_phone_video_df[web_phone_video_df$Difficulty!="Sum",]

web_phone_video_df = melt(web_phone_video_df, id = "Difficulty", value.name = "Percentage_of_Party", names_to = c("Party"))
colnames(web_phone_video_df)[colnames(web_phone_video_df) == "variable"] = "Party"
web_phone_video_df$Percentage_of_Party = round(web_phone_video_df$Percentage_of_Party, 1)


colors = c("dodgerblue1", "brown2")

plot1 = ggplot(web_df, aes(Difficulty, y=Percentage_of_Party, fill = Party)) + 
      geom_bar(position='dodge', stat="identity") + 
      facet_grid(Party ~ .) + scale_fill_manual(values= colors) + labs(
  title = "Web-only",
  y = "Percentage of Party", x = "Difficulty Level") + theme(legend.position = "none") +
  geom_text(aes(label=Percentage_of_Party), vjust=-.5, size=2.5) + ylim(0, 102)

plot2 = ggplot(web_phone_df, aes(Difficulty, y=Percentage_of_Party, fill = Party)) + 
      geom_bar(position='dodge', stat="identity") + 
      facet_grid(Party ~ .) + scale_fill_manual(values= colors) + labs(
  title = "Phone/Web",
  y = "Percentage of Party", x = "Difficulty Level") + theme(legend.position = "none")+
  geom_text(aes(label=Percentage_of_Party), vjust=-.5, size=2.5) + ylim(0, 102)

plot3 = ggplot(web_phone_video_df, aes(Difficulty, y=Percentage_of_Party, fill = Party)) + 
      geom_bar(position='dodge', stat="identity") + 
      facet_grid(Party ~ .) + scale_fill_manual(values= colors) + labs(
  title = "Video/Phone/Web",
  y = "Percentage of Party", x = "Difficulty Level") + theme(legend.position = "none") +
  geom_text(aes(label=Percentage_of_Party), vjust=-.5, size=2.5) + ylim(0, 102) 

require(gridExtra)

grid.arrange(plot1, plot2, plot3, ncol=3)




## Doing Wilcoxon Rank Sum Hypothesis Test

# Conducting test on just the Web Only survey respondents

Dem_diff_web = as.numeric(unlist(subset(Web_Only[Web_Only$Party == "Democrat",], select=Voting_Difficulty_Level)))
Rep_diff_web = as.numeric(unlist(subset(Web_Only[Web_Only$Party == "Republican",], select=Voting_Difficulty_Level)))
print("Web-only")
wilcox.test(x = Dem_diff_web,
            y = Rep_diff_web,
            alternative = "two.sided", correct=FALSE)

# Conducting test on just the Web & Phone Only survey respondents

Dem_diff_web_phone = as.numeric(unlist(subset(Web_Phone[Web_Phone$Party == "Democrat",], select=Voting_Difficulty_Level)))
Rep_diff_web_phone = as.numeric(unlist(subset(Web_Phone[Web_Phone$Party == "Republican",], select=Voting_Difficulty_Level)))
print("Phone/Web")
wilcox.test(x = Dem_diff_web_phone,
            y = Rep_diff_web_phone,
            alternative = "two.sided", correct = FALSE)

# Conducting test on just the Web, Phone, & Video survey respondents

Dem_diff_web_phone_video = as.numeric(unlist(subset(Web_Phone_Video[Web_Phone_Video$Party == "Democrat",], select=Voting_Difficulty_Level)))
Rep_diff_web_phone_video = as.numeric(unlist(subset(Web_Phone_Video[Web_Phone_Video$Party == "Republican",], select=Voting_Difficulty_Level)))
print("Video/Phone/WebS")
wilcox.test(x = Dem_diff_web_phone_video,
            y = Rep_diff_web_phone_video,
            alternative = "two.sided", correct = FALSE)
























