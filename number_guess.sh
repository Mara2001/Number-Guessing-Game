#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

DATABASE_TRUNCATE() {
  RESULT=$($PSQL "TRUNCATE TABLE guesses;")
  RESULT=$($PSQL "ALTER SEQUENCE guesses_guess_id_seq RESTART WITH 1;")
}

NUMBER_TOSS() {
  NUMBER=$(( $RANDOM % 1000 ))
}

USER_LOGIN() {
  # LOGIN THE USER
  #================
  # prompt the users name
  echo "Enter your username:"
  read USERNAME

  # search username in usernames table
  USERNAME_RESULT=$($PSQL "SELECT username FROM usernames WHERE username='$USERNAME'")
  if [[ -z $USERNAME_RESULT ]]
  then
    # username not found, insert to usernames table
    INSERT_RESULT=$($PSQL "INSERT INTO usernames(username) VALUES('$USERNAME');")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    # username found
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM usernames WHERE username='$USERNAME';")
    BEST_GAME=$($PSQL "SELECT best_game FROM usernames WHERE username='$USERNAME';")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
}

NUMBER_GUESS() {
  # GUESSING THE SECRET NUMBER
  #============================
  # prompt the users guess and save it
  echo "Guess the secret number between 1 and 1000:"
  read GUESS

  # check if guess is a number
  if [[ ! $GUESS =~ [0-9]+ ]]
  then
    # guess is not a number
    echo "That is not an integer, guess again:"
    NUMBER_GUESS
  else
    # guess is a number
    INSERT_RESULT=$($PSQL "INSERT INTO guesses(guess) VALUES($GUESS);")

    if [[ $GUESS -lt $NUMBER ]]
    then    
      echo "It's higher than that, guess again:"
      NUMBER_GUESS
    elif [[ $GUESS -gt $NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      NUMBER_GUESS
    else
      GUESS_NUMBER=$($PSQL "SELECT MAX(guess_id) FROM guesses;")
      echo "You guessed it in $GUESS_NUMBER tries. The secret number was $NUMBER. Nice job!"            
      INSERT_RESULT=$($PSQL "UPDATE usernames SET games_played=$(( $GAMES_PLAYED + 1 )) WHERE username='$USERNAME';")      
      if [[ $BEST_GAME -gt $GUESS_NUMBER ]]
      then
        INSERT_RESULT=$($PSQL "UPDATE usernames SET best_game=$GUESS_NUMBER WHERE username='$USERNAME';")
      fi
    fi
  fi
}

DATABASE_TRUNCATE

NUMBER_TOSS

USER_LOGIN

NUMBER_GUESS