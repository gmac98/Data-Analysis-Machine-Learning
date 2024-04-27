# set working directory
setwd("D:\\hult coursework\\MBAN\\Spring 2024_1\\Visualizing & Analyzing Data with R\\A2 Moneyball")
#setwd("Add path here")
getwd()

# read batting file
df.batting <- read.csv('Batting.csv')
head(df.batting,5)
str(df.batting)
nrow(df.batting)

# read salaries file
df.salaries <- read.csv('Salaries.csv')
head(df.salaries,5)
str(df.salaries)
nrow(df.salaries)

# check summary of both data frames
summary(df.batting)
summary(df.salaries)

# To identify and recruit players overlooked by the market, we need to merge salary data with batting data.
# However, the min yearID in salaries is 1985 while the min yearID in batting is 1871, 
# so we remove all data prior to 1985.
df.batting <- subset(df.batting, df.batting$yearID >= 1985)
summary(df.batting)

# Feature Engineering
# We add 3 more statistics that were used in Moneyball to batting data : Batting Average (BA), 
# On Base Percentage (OBP), and Slugging Percentage (SLG).
df.batting$BA <- df.batting$H / df.batting$AB

df.batting$OBP <- (df.batting$H + df.batting$BB + df.batting$HBP) / (df.batting$AB + df.batting$BB + df.batting$HBP + df.batting$SF)

df.batting$X1B <- df.batting$H - df.batting$X2B - df.batting$X3B - df.batting$HR #first base value not present in data frame
df.batting$SLG <- ((1 * df.batting$X1B) + (2 * df.batting$X2B) + (3 * df.batting$X3B) + (4 * df.batting$HR)) / df.batting$AB
str(df.batting)

# Merging the batting data with the salary data.
# We need to merge on both playerID and yearID because we have players playing numerous years, 
# which means we'll have playerID repetitions for several years.
df.merged <- merge(df.batting, df.salaries, by=c('playerID', 'yearID'))
nrow(df.merged)
summary(df.merged)

# Oakland Athletics lost 3 players during 2001-02 off season to bigger market teams. 
# They were: first baseman 2000 AL MVP Jason Giambi (giambja01) to the New York Yankees, 
# outfielder Johnny Damon (damonjo01) to the Boston Red Sox and 
# infielder Rainer Gustavo "Ray" Olmedo (saenzol01).

# install.packages('dplyr')
library(dplyr)       #data manipulation library

# Since these players were lost during 2001 off season, we look at their data from 2000 & 2001
lost.players <- subset(x = df.merged, subset = ((yearID == 2000 | yearID == 2001) & playerID %in% c('giambja01', 'damonjo01', 'saenzol01')))
lost.players <- lost_players[,c('playerID','yearID','G_batting', 'AB', 'H', 'X2B', 'X3B', 'HR', 'BA', 'OBP', 'SLG', 'salary')]
lost.players

# Total salary of lost players in 2001
sum(lost.players[lost.players$yearID == 2001,]$salary) # Total = $11493333 i.e. ~11.5 million
# calculate mean OBP of lost players for 2000 & 2001
mean(lost.players$OBP, na.rm = TRUE)                   # Mean OBP = 0.3917185
# calculate mean SLG of lost players for 2000 & 2001
mean(lost.players$SLG, na.rm = TRUE)                   # Mean SLG = 0.510385
# calculate mean AB of lost players for 2000 & 2001
mean(lost.players$AB, na.rm = TRUE)                    # Mean AB = 474


# Now, we decide the strategy for player replacement
# 1. Salary Constraint: Total Salary <= $12 million
#      Due to financial limitations, the three new athletes' combined salary must not be more than $12 million.
# 2. On-Base Percentage (OBP) Constraint: OBP >= Lost Players' Mean OBP for 2000-01
#      This considers both hits and walks, giving a better picture of a player's ability to reach base. As OA team 
#      is focused on scoring runs, OBP is valuable as it leads to more scoring opportunities.
# 3. Slugging Percentage (SLG): SLG >= Lost Players' Mean SLG for 2000-01
#      This measures a player's extra-base hitting ability. While important, it shouldn't overshadow OBP. 
#      We will focus on high OBP to get on base early, followed by SLG for run production.
# 4. At Bats (AB) Constraint: AB >= Lost Players' At Bats for 2000-01
#      At-bats represent opportunities to contribute, so ensuring the replacements had at least as many 
#      combined at-bats aimed to maintain offensive output.


# filter available batting players in 2001 for replacement selection
avail.players <- filter(df.merged, yearID == 2001)
head(avail.players)
nrow(avail.players)       # Count = 915
colSums((is.na(avail.players)))

# scatter plot to determine cut-off salary vs OBP
#install.packages('ggplot2')
library(ggplot2)          # creating graphics library
salary_OBP <- ggplot(avail.players, aes(x=OBP,y=salary)) + geom_point(color = "maroon", alpha = 0.7) +
  geom_vline(xintercept = mean(avail.players$OBP, na.rm = TRUE), color = "blue", linetype = "longdash", lwd = 1) +
  geom_vline(xintercept = median(avail.players$OBP, na.rm = TRUE), color = "sienna2", linetype = "longdash", lwd = 1) +
  labs(title = "Scatter Plot of Salary vs OBP with Mean (blue line) and Median (red line)", 
       x = "On-Base Percentage (OBP)", y = "Salary")
print(salary_OBP)

salary_SLG <- ggplot(avail.players, aes(x=SLG,y=salary)) + geom_point(color = "plum3") +
  geom_vline(xintercept = mean(avail.players$SLG, na.rm = TRUE), color = "blue", linetype = "longdash", lwd = 1) +
  geom_vline(xintercept = median(avail.players$SLG, na.rm = TRUE), color = "sienna2", linetype = "longdash", lwd = 1) +
  labs(title = "Scatter Plot of Salary vs SLG with Mean (blue line) and Median (red line)", 
       x = "Slugging Percentage (SLG)", y = "Salary")
print(salary_SLG)

# The scatter plots suggests that a cut-off salary of $7.5million would be reasonable against OBP and SLG.

# We only want players with OBP >= mean OBP of lost players for 2000 & 2001 (0.3917185), hence we should filter out other players.
# Also, to manage the budget, there is no point in investing more than $7.5 million on any one player, so we filter them out.
# Since we are looking for new recruits for the team, we are looking for players who are not in Oakland Athletics
avail.players <- filter(avail.players, OBP >= 0.3917185, salary<7500000, teamID.x != 'OAK')
nrow(avail.players)       # Count = 43

# We only want players with SLG >= mean SLG of lost players for 2000 & 2001 (0.510385), hence we should filter out other players.
avail.players <- filter(avail.players, SLG >= 0.510385)
nrow(avail.players)       # Count = 23

# We only want players with AB >= mean AB of lost players for 2000 & 2001 (474), hence we should filter out other players.
avail.players <- filter(avail.players, AB >= 474)
nrow(avail.players)       # Count = 9

# arrange potential recruits by prioritizing OBP, but considering SLG as a tiebreaker for players with similar OBP
arrange(avail.players[,c('playerID','OBP','SLG', 'AB', 'BA','salary')], desc(OBP), desc(SLG))

# Top 3 potential recruits
top3recruits <- head(arrange(avail.players[,c('playerID','OBP','SLG', 'AB', 'BA','salary')], desc(OBP), desc(SLG)),3)
sum(top3recruits$salary)      # Total salary = 10088333 i.e. ~$10.1 million

# Top 3 Replacement Recruits that satisfy all replacement strategy constraints
top3recruits

# TOP 3 REPLACEMENT RECRUITS
#   playerID       OBP       SLG  AB        BA  salary
# 1 heltoto01 0.4316547 0.6848382 587 0.3356048 4950000
# 2 berkmla01 0.4302326 0.6204506 577 0.3310225  305000
# 3 gonzalu01 0.4285714 0.6880131 609 0.3251232 4833333
