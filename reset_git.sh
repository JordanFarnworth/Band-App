echo "disgaurding changes"
git reset --hard
echo "Switching to master.."
git checkout master
echo "Pulling.."
git pull origin master
echo "Bundling.."
bundle install
echo "checking postgress"
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
echo "Raking.."
rake db:migrate
echo "Starting Delayed Jobs"
bin/delayed_job start
echo "Starting server.."
rails s -p 4000
