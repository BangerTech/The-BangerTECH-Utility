#!/bin/bash

# Step 1: Run the InfluxDB command to create a database named 'openhab'
sudo docker exec influxdb /usr/bin/influx -execute 'CREATE DATABASE database1'

# Step 2: Run the InfluxDB command to use the 'openhab' database
sudo docker exec influxdb /usr/bin/influx -execute 'USE database1'

# Step 3: Run the InfluxDB command to create a user named 'openhabuser' with password 'openhab' and grant all privileges
sudo docker exec influxdb /usr/bin/influx -execute "CREATE USER user1 WITH PASSWORD 'pwd12345' WITH ALL PRIVILEGES"

# Step 4: Run the InfluxDB command to grant all privileges on the 'openhab' database to the 'openhabuser'
sudo docker exec influxdb /usr/bin/influx -execute 'GRANT ALL ON database1 TO user1'