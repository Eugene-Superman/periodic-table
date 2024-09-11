#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
COLUMNS_TO_SELECT="elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius"
QUERY_BASE="SELECT $COLUMNS_TO_SELECT FROM elements LEFT JOIN properties ON elements.atomic_number = properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id"

PRINT_RESULT() {
  if [[ -z $1 ]]; then
    echo "I could not find that element in the database."
  else
    IFS='|' read -r atomic_number name symbol type atomic_mass melting_point_celsius boiling_point_celsius <<< "$1"
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi
}

if [[ -z  $1 ]]; then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^-?[0-9]+$ ]]; then
    QUERY_RESULT=$($PSQL "$QUERY_BASE WHERE elements.atomic_number = '$1';")
  else
    QUERY_RESULT=$($PSQL "$QUERY_BASE WHERE symbol = '$1' OR name = '$1';")
  fi
  PRINT_RESULT $QUERY_RESULT 
fi
