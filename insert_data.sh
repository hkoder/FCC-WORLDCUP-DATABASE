#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#TEAMS TABLE
#Truncating tables each time the script runs
echo $($PSQL "TRUNCATE teams, games")

#Inserting teams to the teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
then
#Checking if the winner team already exists in the table
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

#if not found
  if [[ -z $WINNER_ID ]]
  then
  INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER_ID == "INSERT 0 1" ]]
    then
        echo Inserted into teams, $WINNER 
    fi
    #fetching
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
#Checking if the opponent team already exists in the table
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

#if not found
  if [[ -z $OPPONENT_ID ]]
  then
  INSERT_OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
   if [[ $INSERT_OPPONENT_ID == "INSER 0 1" ]]
   then 
    echo Inserted into teams, $OPPONENT
    fi
    #fetching
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
  then 
  echo Inserted into games, $WINNER vs $OPPONENT, $YEAR
  fi
fi
done

