#!/bin/sh

# Create the db and WP Volumes
mkdir db
mkdir wordpress

# Docker
docker-compose up -d

echo "\r"
echo '********************************'
echo 'Installing ACME Sports site.....'
echo '********************************'
sleep 5;

docker-compose run --rm wordpress-cli core download --version=latest --force --quiet
# docker-compose run --rm wordpress-cli core download --version=5.0 --force --quiet
docker-compose run --rm wordpress-cli core install --path="/var/www/html" --url="http://localhost:8000" --title="ACME Sports" --admin_user=admin --admin_password=secret --admin_email=foo@acmesports.com
docker-compose run --rm wordpress-cli wp rewrite structure "/%postname%/"
docker-compose run --rm wordpress-cli site empty --yes
docker-compose run --rm wordpress-cli theme delete twentyseventeen twentynineteen
docker-compose run --rm wordpress-cli widget delete search-2 recent-posts-2 recent-comments-2 archives-2 categories-2 meta-2
docker-compose run --rm wordpress-cli option update blogdescription 'Your Sports Site!' 

echo "\r"
echo '*******************************'
echo 'Installing Resulta plugins.....'
echo '*******************************'
cd wordpress/wp-content/plugins
git clone git@github.com:CesarReyes/resulta-nfl-teams.git 
docker-compose run --rm wordpress-cli plugin activate resulta-nfl-teams

echo "\r"
echo '***********************'
echo 'Creating test page.....'
echo '***********************'
docker-compose run --rm wordpress-cli post create --post_type=page --post_title='NFL Teams' --post_status=publish --post_content='<!-- wp:resulta/block-resulta-nfl-teams /-->'

echo "\r"
echo '*******************'
echo 'Installation done!'
echo 'To see the working solution go to: http://localhost:8000/nfl-teams'
echo 'WP admin side go to: http://localhost:8000/wp-admin'
echo 'User/Pwd: admin/secret'
echo '*******************'
