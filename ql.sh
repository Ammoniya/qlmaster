#!/bin/bash
# Assign the first argument to a variable
command="$1"
argument="$2"
EXPHOME=$(pwd)
# Check the value of the first argument and execute different commands accordingly
case "$command" in
"create")
  codeql database create "$EXPHOME/JS_QL_DB" \
    --source-root="$EXPHOME/nutshell" \
    --language=$argument \
    --overwrite
  ;;
"analyze")
  codeql database analyze "$EXPHOME/JS_QL_DB" \
    --format=csv \
    --output="$EXPHOME/results/nutshell.analyze.js.csv"
  ;;
"run")
  codeql query run "$EXPHOME/queries/$argument.ql" \
    --database="$EXPHOME/JS_QL_DB" \
    --output="$EXPHOME/results/$argument.bqrs"

  ;;
"cast")
  codeql bqrs decode "$EXPHOME/results/$argument.bqrs" \
    --output="$EXPHOME/results/$argument.csv" \
    --format=csv
  ;;
*)
  echo "Invalid command: $command"
  exit 1
  ;;
esac
