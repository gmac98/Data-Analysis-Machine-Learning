####################################################
# ANALYSIS OF AIRBNB LISTING'S DESCRIPTION CONTENT #
####################################################

#installing and loading the mongolite library to download the Airbnb data
library(mongolite)

library(dplyr)
library(stringr)
library(wordcloud)
library(cld2)          # language identification
library(ggplot2)
library(wordcloud)
library(ggraph)
library(tm)
library(tidytext)
library(tidyverse)
library(tidygraph)
library(topicmodels)
library(writexl)      # export data to excel file
library(remotes)
library(textstem)
library(gridExtra)

# Establish connection to mongoDB to extract Airbnb dataset
connection_string <- 'mongodb+srv://username:password@cluster0.jy2txrs.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0'
airbnb_collection <- mongo(collection="listingsAndReviews", db="sample_airbnb", url=connection_string)

# Convert the airbnb collection into a dataframe
airbnb_all <- airbnb_collection$find()

# Exploratory Data Analysis
class(airbnb_all$description)
colnames(airbnb_all)

# Checking the number of missing values in description and listing_url
sum(is.na(airbnb_all$description))
sum(is.na(airbnb_all$listing_url))

# Extract listing ID using string manipulation
airbnb_all$listing_id <- str_extract(airbnb_all$listing_url, "\\/(\\d+)")
# Remove "/" from listing_id values
airbnb_all$listing_id <- str_remove(airbnb_all$listing_id, "/")
sum(is.na(airbnb_all$listing_id))     # primary key

# Create new dataframe to extract selected data for text analysis on description
airbnb_desc_df <- select(airbnb_all, c('listing_id','description'))

# Extracting character length of each listing description
airbnb_desc_df$desc_length_chars <- nchar(airbnb_desc_df$description)

# Check min, max, mean and quantile statistics to understand description lengths
max(airbnb_desc_df$desc_length_chars)                    # 1000
min(airbnb_desc_df$desc_length_chars)                    # 0
mean(airbnb_desc_df$desc_length_chars)                   # 741
quantile(airbnb_desc_df$desc_length_chars)               # description length is capped at 1000
# 0%  25%  50%  75% 100% 
# 0  449 1000 1000 1000 

# Plot a histogram to show distribution of description lengths
airbnb_desc_df %>%
  ggplot(aes(x=desc_length_chars)) +
  geom_histogram(fill="deepskyblue1",col="black",bins=10) +
  ggtitle("Distribution of description length for listings") +
  geom_vline(xintercept = 100,linetype="dashed",color="red") +
  xlab("Description character length") +
  ylab("Number of listings")

# Limit the listings by removing too short descriptions
airbnb_desc_df <- airbnb_desc_df %>% 
  filter(between(desc_length_chars, 100, 1000))

# Export data to excel file
export_data <- select(airbnb_desc_df, c('listing_id','desc_length_chars'))
write_xlsx(export_data, "descriptionlength.xlsx")

# detect the description text's language by cld2
lang_group_cld2 <- detect_language(airbnb_desc_df$description)
lang_desc <- data.frame(language = lang_group_cld2)
airbnb_desc_df <- cbind(airbnb_desc_df, lang_desc)

# List the main languages in listings
airbnb_desc_df %>% count(language) %>% 
  mutate(percentage = round(n/sum(n)*100, 1)) %>% 
  filter(percentage > 0) %>% 
  arrange(desc(n))
# English is the main language of these descriptions with 80% of the total filtered listings 

# Export data to excel file
export_data <- airbnb_desc_df %>% count(language) %>% 
  mutate(percentage = round(n/sum(n)*100, 1)) %>% 
  filter(percentage > 0) %>% 
  arrange(desc(n))
write_xlsx(export_data, "descriptionlanguage.xlsx")

# Since English is the major language, further analysis will only be on English descriptions
# Drop descriptions of other languages
airbnb_desc_df <- airbnb_desc_df %>% filter(language == 'en')
dim(airbnb_desc_df)                               # 4073 observations

#####################################
# TOKENIZATION AND STOPWORD REMOVAL #
#####################################
# Remove stopwords and custom stopwords according to the features of the description

# All custom stop words transformed into lower case and combined into one object
tokens_all_desc <- data.frame()
property_name <- strsplit(unique(tolower(airbnb_all$property_type))," ")
property_name <- sapply(property_name, toString)
room_name <- as.character(unique(tolower(airbnb_all$room_type)))
market_name <- as.character(unique(tolower(airbnb_all$address$market)))
suburb_name <-  as.character(unique(tolower(airbnb_all$address$suburb)))
host_name <- as.character(unique(tolower(airbnb_all$host$host_name)))
custom_stopwords <- c("airbnb",property_name,room_name,market_name,suburb_name,host_name)

# Tokenize the description sentences
all_description <- airbnb_desc_df %>% 
  unnest_tokens(sentence, description,token = "sentences")%>%
  unique(.)

# Remove digits and punctuations in sentences
all_description$sentence <- gsub('[[:digit:]]+',' ', all_description$sentence)
all_description$sentence <- gsub('[[:punct:]]+',' ', all_description$sentence)

# Lowercase all words within each sentence
all_description$sentence <- tolower(all_description$sentence)

# Remove extra whitespace between words
all_description$sentence <- gsub('\\s+',' ', all_description$sentence)

# Tokenize sentences and remove stopwords
split_size <- 10000
tokens_list <- split(all_description, rep(1:ceiling(nrow(all_description)/split_size), 
                         each=split_size, length.out=nrow(all_description)))

tokens_all_description <- data.frame()
for(i in 1:length(tokens_list)){
  tokens_h <- tokens_list[[i]] %>% 
    unnest_tokens(word,sentence)
  
  tokens_h$word <- tolower(tokens_h$word)
  
  tokens_h<- tokens_h %>%
    count(word,listing_id) %>%
    anti_join(stop_words)%>%
    filter(!(word %in% custom_stopwords))
  
  tokens_all_description <- bind_rows(tokens_all_description,tokens_h)
}

# Lemmatization of token words 
tokens_all_description$word   <- lemmatize_words(tokens_all_description$word,
                                                 dictionary = lexicon::hash_lemmas)

# Calculate token length and remove too short, too long ones
tokens_all_description$token_length <- nchar(tokens_all_description$word)
tokens_all_description %>%
  group_by(token_length) %>% 
  summarise(total = n())

tokens_all_description <- tokens_all_description %>%
                            filter(between(token_length,3,15))

# Remove custom stopwords from tokens
tokens_all_description <- tokens_all_description %>%
                            filter(!(word %in% custom_stopwords))

# Find the 20 most relevant words in the airbnb dataset
top_20 <- tokens_all_description %>% 
  group_by(word) %>% 
  summarise(total =n()) %>% 
  arrange(desc(total)) %>% 
  top_n(20)

# Find the 100 most relevant words in the airbnb dataset
top_100 <- tokens_all_description %>% 
  group_by(word) %>% 
  summarise(total =n()) %>% 
  arrange(desc(total)) %>% 
  top_n(100)

# Export data to excel file
write_xlsx(top_100, "top100frequentwords.xlsx")

# Visualize the top 20 most relevant words by count
top_20 %>%
  mutate(word = reorder(word,total)) %>%  # reorder word by total count
  ggplot() +
  geom_bar(mapping = aes(x=word,y=total),
           stat="identity", fill = "deepskyblue1") +
  labs(title="Top 20 words appearing in listings by frequency",
       y="Word count", x="Most Common Words") +
  coord_flip() +
  theme_bw()

# WordCloud showing 100 most important words
layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=0.5, "Wordcloud of 100 most frequent words in description")
wordcloud(tokens_all_description$word, min.freq=10,max.words=100, random.order=FALSE, 
          colors=RColorBrewer::brewer.pal(8, "Dark2"), scale = c(2, 0.4))

#############################
# TF-IDF FOR TERM FREQUENCY #
#############################
# Bind the term frequency and inverse document frequency with word as term and listing_id as document
tokens_all_description_tf_idf <- tokens_all_description %>% 
  bind_tf_idf(word,listing_id,n)

# Determine cutoff values
tf_idf_cutoff <- boxplot.stats(tokens_all_description_tf_idf$tf_idf)$stats

# Use stats low and high cutoff values to filter out tokens
tokens_all_description_tf_idf <- tokens_all_description_tf_idf %>% 
                                  filter(tf_idf >= tf_idf_cutoff[1] & tf_idf <= tf_idf_cutoff[5]) %>%
                                  arrange(desc(tf_idf))

# Distribution of tf_idf values
tokens_all_description_tf_idf %>% 
  ggplot(aes(tf_idf))+
  ggtitle("Distribution of TF-IDF values") +
  geom_histogram(fill = "deepskyblue1", col = "black", bins = 50)

# Cast tokens to a Document-Term Matrix
description_dtm <- tokens_all_description %>% 
  cast_dtm(listing_id,word,n)

# Top 5 countries by number of listings 
# Attributes for 68% of total listings
top_5_country <- airbnb_all %>% 
  unnest(address) %>%
  select(listing_id, country) %>%
  unique(.) %>% 
  group_by(country) %>% 
  summarise(total =n()) %>% 
  arrange(desc(total)) %>% 
  top_n(5)

# Identify listings in top 5 countries
top_5_country_listing <- airbnb_all %>% 
  unnest(address) %>%
  select(listing_id, country) %>%
  filter(country %in% top_5_country$country) %>% 
  unique(.)

# Filter tokens to select from top 5 countries
tokens_all_description_tf_idf$listing_id <- as.character(tokens_all_description_tf_idf$listing_id)
country_tokens_description <- tokens_all_description_tf_idf %>% 
  right_join(top_5_country_listing) %>%  
  group_by(country,word) %>% 
  summarise(total=sum(n)) %>% 
  arrange(desc(total))

# Get the top 10 tokens in description for each country
all_country_words = data.frame()
for(cvar in 1:nrow(top_5_country)){
  country_words <- country_tokens_description %>% 
    ungroup() %>% 
    filter(country == top_5_country$country[cvar]) %>% 
    top_n(10,total)  %>% 
    mutate(rank = row_number())
  all_country_words <- rbind(all_country_words, country_words)
}

# Visualize the top 10 tokens in description for each country
country_plots <- list()
i <- 1
for (cname in top_5_country$country) {
  # Filter data for current country
  h <- all_country_words %>%
    filter(country == cname)
  
  # Create ggplot object and assign dynamic name
  nm <- paste0("plot_b", i)
  country_plots[[i]] <- ggplot(h, aes(x = reorder(word, total), y = total, fill = total)) +
    geom_bar(stat = "identity") + xlab("Word Count") + coord_flip()
  
  i <- i + 1
}

# Arrange country plots in a grid
grid.arrange(
  country_plots[[1]] + ylab("United States"),
  country_plots[[2]] + ylab("Turkey"),
  country_plots[[3]] + ylab("Canada"),
  country_plots[[4]] + ylab("Spain"),
  country_plots[[5]] + ylab("Australia"),
  nrow = 2, ncol = 3, top="Top 10 tokens in description by TF-IDF"
)

# Export data to excel file
write_xlsx(all_country_words, "top10tokenstfidf.xlsx")

###################################
# BIGRAMS FOR SHOWING CONNECTIONS #
###################################
# The bigram network illustrates the relationships between words

# Extract bigrams from descriptions
description_bigrams <- airbnb_desc_df %>% 
  unnest_tokens(bigram, description, token = "ngrams", n = 2)

# Separate bigrams into individual words
description_tokens_separated <- description_bigrams %>% 
  separate(bigram, into = c("word1", "word2"), sep = " ")

# Remove stop words from bigrams
description_tokens_separated <- description_tokens_separated %>% 
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# Reconstruct bigrams after removing stop words
description_bigrams <- description_tokens_separated %>% 
  unite(bigram, c(word1, word2), sep = " ")

# Visualize 20 most common bigrams
description_bigrams %>%
  count(bigram, sort = TRUE) %>% 
  head(20) %>% 
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n, fill = -n)) +
  geom_col() +
  coord_flip() +
  theme(legend.position = "none") +
  labs(y = "Count", title = "Top 20 most common bigrams in Airbnb listings description")

# Counting Bigram Occurrences
description_bigram_counts <- description_tokens_separated %>% 
  count(word1, word2, sort = TRUE)

# Filtering Frequent Bigrams with occurence greater than 100
description_bigram_graph <- description_bigram_counts %>% 
  filter(n >= 100) %>%
  tidygraph::as_tbl_graph()

# Export data to excel file
write_xlsx(description_bigram_graph, "networkgraph.xlsx")

# Creating the Bigram Network Graph
arrow <- grid::arrow(type = "closed", length = unit(.1, "inches"))
ggraph(description_bigram_graph, layout = "fr") + 
  geom_edge_link(aes(alpha = n), show.legend = F, arrow = arrow, start_cap = circle(3, 'mm'),
                 end_cap = circle(3, 'mm')) + 
  geom_node_point(color = "Light Green", size = 5) + 
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  labs(title = "Network of bigrams in Airbnb listings description")

# Extract trigrams from descriptions
description_trigrams <- airbnb_desc_df %>% 
  unnest_tokens(trigram, description, token = "ngrams", n = 3)

# Separate trigrams into individual words
description_tokens_separated3 <- description_trigrams %>% 
  separate(trigram, into = c("word1", "word2", "word3"), sep = " ")

# Remove stop words from trigrams
description_tokens_separated3 <- description_tokens_separated3 %>% 
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  filter(!word3 %in% stop_words$word)

# Reconstruct trigrams after removing stop words
description_trigrams <- description_tokens_separated3 %>% 
  unite(trigram, c(word1, word2, word3), sep = " ")

# Select 20 most common bigrams
export_data <- description_bigrams %>%
  count(bigram, sort = TRUE) %>%
  head(20) %>%
  mutate(type = "bigram") %>%
  rename(ngram = bigram)

# Select 20 most common trigrams
export_data2 <- description_trigrams %>%
  count(trigram, sort = TRUE) %>% 
  head(20) %>% 
  mutate(type = "trigram") %>%
  rename(ngram = trigram)

# Export data to excel file
export_data <- rbind(export_data, export_data2)
write_xlsx(export_data, "top20ngram.xlsx")

###########################
# TOPIC MODELING WITH LDA #
###########################
# Topic Modeling using Latent Dirichlet Allocation (LDA) to discover topics inherent in 
# the description corpus

# Calling the Latent Dirichlet Allocation algorithm
description_lda <- LDA(description_dtm, k = 3, control = list(seed = 123))

# Convert to tidy dataframe
description_topics <- tidy(description_lda, matrix = "beta")

# Define a named vector for mapping topic values to names
topic_names <- c(
  `1` = "Amenities and Atmosphere",
  `2` = "Location and Convenience",
  `3` = "Essentials and Accessibility"
)

# Rename values in topic column using replace
description_topics <- description_topics %>%
  mutate(topic = factor(topic, levels = 1:3, labels = topic_names))

# Plot the term frequencies by description topic
description_topics %>%
  group_by(topic) %>%
  top_n(20, beta) %>%
  arrange(desc(beta), .by_group = TRUE) %>%
  ggplot(., aes(x = reorder_within(term, beta, topic), y = beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_x_reordered() +
  coord_flip() +
  labs(title = "Top 20 Most Important Words in Each Topic with LDA",
       y = "Importance (beta)", x = "Word") +
  theme_bw()

# Export data to excel file
export_data <- description_topics %>%
  group_by(topic) %>%
  top_n(20, beta) %>%
  arrange(desc(beta), .by_group = TRUE) %>%
  mutate(rank = dplyr::row_number(desc(beta)))
write_xlsx(export_data, "top20wordswLDA.xlsx")
