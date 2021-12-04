#! /bin/bash --

source ./env_vars.sh

VERB=${1:-install}

helm "${VERB}"\
 --create-namespace\
 -n "${WP_NAMESPACE}"\
 "${WP_DEPLOYMENT}"\
 --set externalDatabase.host="${DB_DEPLOYMENT}-0.${DB_DEPLOYMENT}.${DB_NAMESPACE}"\
 --set externalDatabase.user="${DB_USER}"\
 --set externalDatabase.password="${DB_PASS}"\
 --set externalDatabase.database="${DB_NAME}"\
 --set wordpressUsername="${WP_USER}"\
 --set wordpressPassword="${WP_PASS}"\
 -f ./wordpress.yaml\
 --wait\
 bitnami/wordpress
