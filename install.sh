#!/bin/sh

# Create the db Volume
mkdir db
mkdir wordpress

# Docker
docker-compose up -d

echo 'Installing ACME Sports site.....'
sleep 5;

docker-compose run --rm wordpress-cli core download --version=latest --force --quiet
docker-compose run --rm wordpress-cli core install --path="/var/www/html" --url="http://localhost:8000" --title="ACME Sports" --admin_user=admin --admin_password=secret --admin_email=foo@acmesports.com
docker-compose run --rm wordpress-cli wp rewrite structure "/%postname%/"
docker-compose run --rm wordpress-cli site empty --yes
docker-compose run --rm wordpress-cli theme delete twentyseventeen twentynineteen
docker-compose run --rm wordpress-cli widget delete search-2 recent-posts-2 recent-comments-2 archives-2 categories-2 meta-2

echo 'Installing Resulta plugins.....'
cd wordpress/wp-content/plugins
git clone git@github.com:CesarReyes/resulta-nfl-teams.git 
docker-compose run --rm wordpress-cli plugin activate resulta-nfl-teams
