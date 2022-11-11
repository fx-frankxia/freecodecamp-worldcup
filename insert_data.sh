#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER_TEAM_NAME OPPONENT_TEAM_NAME WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # insert team name in teams
    INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER_TEAM_NAME') ON CONFLICT(name) DO NOTHING")
    INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT_TEAM_NAME') ON CONFLICT(name) DO NOTHING")

    # load the WINNER_TEAM_ID and OPPONENT_TEAM_ID in teams table
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER_TEAM_NAME'")
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT_TEAM_NAME'")

    # insert other data to games table
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi 
done