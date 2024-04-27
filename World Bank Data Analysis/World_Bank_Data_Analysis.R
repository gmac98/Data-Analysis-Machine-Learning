# Set working directory
setwd("D:\\hult coursework\\MBAN\\Spring 2024_1\\Visualizing & Analyzing Data with R")
# Get the working directory
getwd()                               

data1 <- read.csv('Datset_IA.csv')    #read csv file
head(data1)
str(data1)

# Check for missing values in data
data1[!complete.cases(data1),]

source("RVector_IA.R")                #read r file

# Filter dataframe for 1960 and 2020 separately
df_1960 <- data1[data1$Year == 1960, ]
df_2020 <- data1[data1$Year == 2020, ]

# Add life expectancy column for 1960
df_1960$Life_Expectancy_At_Birth <- Life_Expectancy_At_Birth_1960[match(df_1960$Country.Code, Country_Code)]

# Add life expectancy column for 2020
df_2020$Life_Expectancy_At_Birth <- Life_Expectancy_At_Birth_2020[match(df_2020$Country.Code, Country_Code)]

# Combine the filtered dataframes back together
df_combined <- rbind(df_1960, df_2020)

# View the modified dataframe
df_combined[180:190,]
nrow(df_combined)

# load the ggplot2 package for visualization
#install.packages("ggplot2")
library(ggplot2)


# Scatter plot for 1960
ggplot(df_1960, aes(x = Fertility.Rate, y = Life_Expectancy_At_Birth, color = Region, 
                    size = Fertility.Rate)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~ Year) +
  labs(title = "Life Expectancy vs. Fertility Rate (1960)",
       x = "Fertility Rate",
       y = "Life Expectancy (Years)",
       color = "Region")


# Scatter plot for 2020
ggplot(df_2020, aes(x = Fertility.Rate, y = Life_Expectancy_At_Birth, color = Region, 
                    size = Fertility.Rate)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~ Year) +
  labs(title = "Life Expectancy vs. Fertility Rate (2020)",
       x = "Fertility Rate",
       y = "Life Expectancy (Years)",
       color = "Region")

# Combined scatter plot for 1960 and 2020 using facets
ggplot(df_combined, aes(x = Fertility.Rate, y = Life_Expectancy_At_Birth, color = Region, 
                        size = Fertility.Rate)) +
  geom_point(alpha = 0.7) + facet_grid(Year~.) +
  labs(title = "Life Expectancy vs. Fertility Rate (1960 and 2020)",
       x = "Fertility Rate",
       y = "Life Expectancy (Years)",
       color = "Region")


# Boxplots for life expectancy grouped by region using facets
ggplot(df_combined, aes(x = Region, y = Life_Expectancy_At_Birth, fill = Region)) +
  geom_boxplot() + facet_grid(.~Year) +
  labs(title = "Life Expectancy by Region",
       x = "Region",
       y = "Life Expectancy (Years)")

# Boxplots for fertility rate grouped by region using facets
ggplot(df_combined, aes(x = Region, y = Fertility.Rate, fill = Region)) +
  geom_boxplot() + facet_grid(.~Year) +
  labs(title = "Fertility Rate by Region",
       x = "Region",
       y = "Fertility Rate")


## DATA INSIGHTS BASED ON VISUALIZATIONS
# Global life expectancy has significantly increased between 1960 and 2020. In 1960, the average 
# life expectancy across regions was around 50-60 years, while in 2020, it has jumped to about 70-80 years.

# Fertility rates have generally declined across all regions between 1960 and 2020. The scatter plots 
# highlight a downward trend in fertility rates across all five regions. In 1960, the average fertility 
# rate hovered around 6 children per woman, whereas in 2020, it has almost halved to roughly 3 children 
# per woman.This represents a nearly 50% decline over 60 years.
# While all regions experienced declines in fertility rates, the extent of the decrease varied. 
# For example, the median fertility rate in Africa fell from around 7 children per woman to 4.5 
# children per woman, while the median rate in Europe dropped from around 2.5 children per woman 
# to 1.5 children per woman. Despite the decline, Africa's median fertility rate in 2020 is still 
# above the replacement rate of 2.1 children per woman needed for a population to maintain its size 
# without migration.In contrast, Europe's median fertility rate in 2020 is now below the replacement rate.

# The negative correlation between life expectancy and fertility rate appears to have persisted 
# between 1960 and 2020. Although the data points for both years exhibit some spread, the overall trend 
# suggests that regions with higher fertility rates tend to have lower life expectancy, and vice versa.
# While some regions like Europe and the Americas have witnessed a convergence of their fertility 
# rates and life expectancy towards the upper end of the spectrum, others like Africa and the 
# Middle East continue to diverge, with fertility rates remaining higher and life expectancy lagging behind. 

# Regional variations in life expectancy and fertility rate patterns persist. The graph indicates 
# that even though global trends exist, significant disparities remain between different regions. 
# For instance, in 2020, Africa still bears the burden of the lowest life expectancy and highest 
# fertility rate compared to other regions. While Europe has the highest life expectancy and the 
# lowest fertility rate. This suggests that there are other factors besides fertility rate that are 
# affecting life expectancy in these regions.

# The interquartile range (IQR), which represents the spread of the middle 50% of the data, 
# has also shrunk in most regions. This indicates that the distribution of life expectancy and fertility 
# rates has become less variable over time, with fewer countries now having extremely high or 
# low life expectancy and fertility rates compared to 1960.
# The relationship between life expectancy and fertility rate is not linear. This means that 
# the difference in life expectancy between countries with high and low fertility rates is not constant. 
# For example, the difference in life expectancy between countries with fertility rates of 2 and 4 children 
# per woman appears to be smaller than the difference in life expectancy between countries with fertility 
# rates of 6 and 8 children per woman.
