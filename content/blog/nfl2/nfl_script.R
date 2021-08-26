# have to save script in "C:/Users/jfslo/OneDrive/Main Documents/Documents/R/win-library/4.1/taskscheduleR/extdata"

library(mysportsfeedsR)
library(tidyverse)
library(janitor)
library(httr)
library(jsonlite)
library(RCurl)
library(kableExtra)
library(gmailr)
library(glue)
library(taskscheduleR)

# set parameters
season = "pre" # "pre" or "regular"
n_week = 2 # week number

close_game_points = 7
close_game_points_total = 35
high_score_points = 40

# GET request 
source("login_creds.R")

res = GET(glue('https://api.mysportsfeeds.com/v2.0/pull/nfl/2021-{season}/week/{n_week}/games.json'), add_headers(Authorization = paste("Basic", auth)))
res

api_response <- content(res, as="text")
api_response <- jsonlite::fromJSON(api_response, flatten=TRUE) # flatten=TRUE automatically flattens nested data into a single non-nested data frame

games_raw <- api_response$games # selecting the data I want

# clean data
games_clean <- games_raw %>%
  as_tibble() %>%
  clean_names() %>%
  select(schedule_week, schedule_away_team_abbreviation, schedule_home_team_abbreviation, score_away_score_total, score_home_score_total, score_quarters) %>%
  rename(away_team = schedule_away_team_abbreviation,
         home_team = schedule_home_team_abbreviation,
         away_score_final = score_away_score_total,
         home_score_final = score_home_score_total) %>%
  unnest(score_quarters)


# what games to watch?
games <- games_clean %>%
  mutate(final_score_diff = abs(away_score_final-home_score_final), 
         total_score_combine = away_score_final+home_score_final)

ravens_chiefs <- games %>%
  filter(away_team %in% c("BAL", "KC") | home_team %in% c("BAL", "KC"))

close_games <- games %>%
  filter(final_score_diff <= close_game_points & total_score_combine > close_game_points_total)

high_games <- games %>%
  filter(total_score_combine >= high_score_points)

lead_change <- games %>%
  select(away_team, home_team, quarterNumber, awayScore, homeScore) %>%
  group_by(away_team, home_team) %>%
  mutate(cum_away_score = cumsum(awayScore),
         cum_home_score = cumsum(homeScore)) %>%
  mutate(q_score_diff = cum_away_score - cum_home_score, # negative means away team in the lead
         q_score_diff_sign = sign(q_score_diff)) %>% # just makes it easier to read either + or - 1
  summarise(sign_diff_sum = sum(diff(sign(q_score_diff_sign)) != 0)) %>% # how many sign changes are there with each game
  filter(sign_diff_sum >= 2)

# combine mini datasets together
common_cols <- intersect(colnames(ravens_chiefs), colnames(lead_change)) # only want the common columns (team names)

final_games <- rbind(
  subset(ravens_chiefs, select = common_cols), 
  subset(close_games, select = common_cols),
  subset(high_games, select = common_cols), 
  subset(lead_change, select = common_cols)
) %>%
  distinct(away_team, home_team)

# make a table
games_table <- final_games %>%
  kable() # gt package doesn't work because i

final_games %>%
  kable()

# gmailR
gm_auth_configure(key = key, secret = secret)

email_msg <- glue("Here are your top NFL games to watch this week!! <br> {games_table} <br> <b>GO RAVENS</b>")

my_html_msg <- gm_mime() %>%
  gm_to(c("jfsloane92@gmail.com")) %>%
  gm_from("jsloane1992@gmail.com") %>%
  gm_subject("NFL Games!") %>%
  gm_html_body(email_msg)

gm_send_message(my_html_msg)
