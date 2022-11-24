#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


$($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR -ne 'year' ]]
  then
    QUERY_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    QUERY_LOOSER=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $QUERY_WINNER ]]
    then
      INSERT_QUERY=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $INSERT_QUERY == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $WINNER
          QUERY_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        fi
    fi
    if [[ -z $QUERY_LOOSER ]]
    then
      INSERT_QUERY=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $INSERT_QUERY == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $OPPONENT
          QUERY_LOOSER=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        fi
    fi
    INSERT_QUERY=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $QUERY_WINNER, $QUERY_LOOSER, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
