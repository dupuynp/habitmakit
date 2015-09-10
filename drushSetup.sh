#!/bin/bash
#ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# This is a bash script that can install the drupal site on fresh machines
# You may need to alter the db info below
dbname="drupal_habitmakit"
dbuser="root"
dbpass="root"
adminpass="pass"
sitename="Habit Makit"

read -p "Warning! This will drop an existing database named $dbname. Are you sure you want to continue? (y/n) " -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then

	db_drop="DROP DATABASE IF EXISTS $dbname;"
	mysql --host=localhost -u$dbuser -p$dbpass -e "$db_drop"

	db_create="CREATE DATABASE $dbname;"
	mysql --host=localhost -u$dbuser -p$dbpass -e "$db_create"

	drush make drupal.make
	drush site-install standard --db-url=mysql://$dbuser:$dbpass@localhost/$dbname --site-name=$sitename --account-name=admin --account-pass=$adminpass
	
	# Drush install will wipe out our gitignore, so we check in a copy
	cp my.gitignore .gitignore

	# Uncomment this if you have a database to pre-load
	#drush en -y backup_migrate
	#drush vset file_private_path DB
	#cd DB/backup_migrate/manual/
	#latestfile=$(ls -t1 | head -n1)
	#drush bam-restore db manual "$latestfile"

	echo "Completed. Drupal login is admin / $adminpass"
else
	echo "Aborted"
fi
