#! /bin/bash --

source ./env_vars.sh

VERB=${1:-install}

helm "${VERB}"\
 --create-namespace\
 -n "${DB_NAMESPACE}"\
 "${DB_DEPLOYMENT}"\
 --set init_db.user="${DB_USER}"\
 --set init_db.pass="${DB_PASS}"\
 --set init_db.name="${DB_NAME}"\
 --wait\
 ./mysql-chart
