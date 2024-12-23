CREATE DATABASE number_guess;

CREATE TABLE usernames(user_id SERIAL PRIMARY KEY, username VARCHAR(22), games_played INT DEFAULT(0), best_game INT DEFAULT(1000));