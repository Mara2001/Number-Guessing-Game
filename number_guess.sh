#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

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

  if [[ $GUESS -lt $NUMBER ]]
  than
    echo "It's higher than that, guess again:"
    NUMBER_GUESS
  elif [[ $GUESS -gt $NUMBER ]]
  than
    echo "It's lower than that, guess again:"
    NUMBER_GUESS
  else
    echo "You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!"    
  fi
}

NUMBER=$(( $RANDOM % 1000 ))
echo $NUMBER

USER_LOGIN
NUMBER_GUESS