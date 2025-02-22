#!/bin/bash -eu
set -o pipefail
# Include pretty printing for logs
# This library provides error, log, and success functions
. $(cd $(dirname "$0"); pwd)/lib-logging.sh
trap "error 'DATABASE SETUP FAILED'" 0

USER=webdiplomacy
ADMIN_PASS=Admin2015
USER_PASS=$USER

log "Starting MySql"

/etc/init.d/mysql start
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
service mysql start

log "Creating database"
mysql -u root --password="$ADMIN_PASS" -h localhost <<-EOSQL
  CREATE DATABASE webdiplomacy;
  GRANT ALL ON webdiplomacy.* TO '$USER' IDENTIFIED BY '$USER_PASS'
EOSQL

log "Run Full Install"
# cat /db_install/FullInstall/fullInstall.sql
# cat /db_install/FullInstall/fullInstall.sql > mysql webdiplomacy
cat /db_install/FullInstall/fullInstall.sql | mysql webdiplomacy


# # This should sort the database update scripts and run them in turn
# find /db_install -name update.sql -print0 | sort -zn | while IFS= read -r -d $'\0' f; do
# log "Updating $(basename $(dirname "$f"))"
#   cat $f | mysql -u "$USER" --password="$USER_PASS" webdiplomacy
# done

trap - 0

success "Database install complete"
