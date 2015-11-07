# close any open ports
killall node app &> /dev/null
kill -9 $(lsof -i:3000 -t) &> /dev/null
kill -9 $(lsof -i:5222 -t) &> /dev/null
kill -9 $(lsof -i:5223 -t) &> /dev/null
kill -9 $(lsof -i:9090 -t) &> /dev/null
kill -9 $(lsof -i:9091 -t) &> /dev/null
kill -9 $(lsof -i:6060 -t) &> /dev/null
kill -9 $(lsof -i:6061 -t) &> /dev/null
kill -9 $(lsof -i:5220 -t) &> /dev/null
kill -9 $(lsof -i:5221 -t) &> /dev/null

# drop db
mysql -uroot -e "drop database if exists magnetmessagedb";