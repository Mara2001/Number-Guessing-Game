#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

DATABASE_TRUNCATE() {
  $($PSQL "TRUNCATE TABLE guesses;")
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
    echo "Welcome back, $USERNAME! You have played <games_played> games, and your best game took <best_game> guesses."
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
    fi
  fi
}

DATABASE_TRUNCATE

NUMBER=$(( $RANDOM % 1000 ))
echo $NUMBER

USER_LOGIN
NUMBER_GUESS