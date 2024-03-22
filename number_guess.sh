#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"



echo Enter your username:
read username

games_played=$($PSQL "SELECT COUNT(*) FROM games WHERE username='$username'")
secret_number=$((1 + RANDOM % 10))
guesses=0

if (( $games_played == 0))
then
  echo "Welcome, $username! It looks like this is your first time here."
else
  best_game=$($PSQL "SELECT MIN(score) FROM games WHERE username='$username'")
  echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

echo "Guess the secret number between 1 and 1000:"
while true
do

  read guess
  if ! [[ $guess =~ ^[0-9=+$] ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((guesses++))

  if (( $guess == $secret_number ))
  then
    GAME=$($PSQL "INSERT INTO games(username, score) VALUES('$username', $guesses)")
    echo "You guessed it in $guesses tries. The secret number was $secret_number. Nice job!"
    exit
  elif (( $guess < $secret_number ))
  then
    echo "It's higher than that, guess again:"
    continue
  else
    echo "It's lower than that, guess again:"
    continue
  fi
done
