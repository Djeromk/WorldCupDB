#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")
echo -e "\nInserting into teams table:\n"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS;
do

if [[ $WINNER != winner ]]
  then
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $TEAM_ID ]] 
    then
    # insert team name
    INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
      echo  "Inserted winner, $WINNER"
      fi
  fi
fi

if [[ $OPPONENT != opponent ]]
then
TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
if [[ -z $TEAM_ID2 ]]
then
INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
  then
  echo  "~Inserted opponent, $OPPONENT"
  fi 
  fi
  fi

WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
LOS_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

if [[ -n WIN_ID || -n LOS_ID ]]
then
  if [[ $YEAR != year ]]
  then
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $LOS_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
  then
  echo  "~~Inserted games, $ROUND, $WIN_ID"
  fi 
  fi
fi
done
