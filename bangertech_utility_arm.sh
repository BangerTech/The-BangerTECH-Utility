#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install whiptail -y

CHOICES=$(whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "SELECT PACKAGES TO INSTALL"  --checklist "Choose options" 22 82 10 \
  "openHAB" "install openHABian on top of your running System " ON \
  "Docker" "install just the Docker Engine" OFF \
  "Docker+Docker-Compose" "install Docker & Docker-Compose" OFF \
  "MosquittoBroker" "Mosquitto Broker in a Docker Container" OFF \
  "Zigbee2MQTT" "Zigbee2MQTT in a Docker Container" OFF \
  "Homebridge" "Homebridge/HomeKit Server in a Docker Container" OFF \
  "Grafana" "Grafana Dashboard in a Docker Container" OFF \
  "influxDB" "influxDB Database in a Docker Container" OFF \
  "Portainer" "Docker Management Platform in a Docker Container" OFF \
  "Filebrowser" "Self hosted File Managemnet in a Docker Container" OFF \
  "Heimdall" "Self hosted Dashboard" OFF \
  "HomeAssistant" "HomeAssistant in a Container " OFF \
  "CodeServer" "VS Code through the browser " OFF \
  "node-exporter" "Data Export used to show host stats in Grafana" OFF  3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
  whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --msgbox "No option was selected (user hit Cancel or ESC)" 8 82
  else
  if whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "CONFIRMATION" --yesno "You are about to install: $CHOICES" 8 82; then 
    for CHOICE in $CHOICES; do
    case "$CHOICE" in
      '"openHAB"')
        if ! dpkg --list | grep openhab >/dev/null 2>&1
        then
          sudo apt-get install -y git
          sudo git clone -b openHAB https://github.com/openhab/openhabian.git /opt/openhabian
          sudo ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config
          sudo cp /opt/openhabian/build-image/openhabian.conf /etc/openhabian.conf
          sudo openhabian-config unattended
        fi
        if whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --yesno "openHAB is running on port http://yourIP:8080\nWould you like to restore your old openHAB config?" 14 82; then
        sudo openhab-cli restore /var/lib/openhab/backups/openhab-backup.zip
        fi
      ;;
      '"Docker"')
        sudo apt install curl -y
        sudo curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo rm get-docker.sh
        sudo systemctl enable docker
      ;;
      '"Docker+Docker-Compose"')
        sudo apt install curl -y
        sudo curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo rm get-docker.sh
        sudo apt install -y libffi-dev libssl-dev python3-dev python3 python3-pip
        sudo apt install docker-compose -y
        sudo systemctl enable docker
        sudo mkdir -p $HOME/docker-compose-data
      ;;
      '"MosquittoBroker"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/mosquitto && cd $HOME/docker-compose-data/mosquitto
        sudo wget -nc https://raw.github.com/BangerTech/mosquitto-broker/main/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/mosquitto/config && cd $HOME/docker-compose-data/mosquitto/config
        sudo wget -nc https://raw.github.com/BangerTech/mosquitto-broker/main/mosquitto.conf
        cd ..
        sudo docker-compose up -d
      ;;
      '"Zigbee2MQTT"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/zigbee2mqtt && cd $HOME/docker-compose-data/zigbee2mqtt
        sudo wget -nc https://raw.github.com/BangerTech/zigbee2mqtt/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Zigbee2MQTT" --msgbox "Check your Zigbee Network here http://yourIP:7000" 8 82
      ;;
      '"Homebridge"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/homebridge && cd $HOME/docker-compose-data/homebridge
        sudo wget -nc https://raw.github.com/BangerTech/homebridge/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Homebridge" --msgbox "Setup the HomeKit Bridge here http://yourIP:8581" 8 82
      ;;
      '"Grafana"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/grafana && cd $HOME/docker-compose-data/grafana
        sudo wget -nc https://raw.github.com/BangerTech/grafana/main/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/grafana/data && cd $HOME/docker-compose-data/grafana/data
        sudo wget -nc https://raw.github.com/BangerTech/grafana/main/env.grafana
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Grafana" --msgbox "The Dashboard´s are located here http://yourIP:3000" 8 82
      ;;
      '"influxDB"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/influxdb && cd $HOME/docker-compose-data/influxdb
        sudo wget -nc https://raw.github.com/BangerTech/influxdb-arm/main/docker-compose.yml
        sudo docker-compose up -d
        if whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --yesno "Would you like to create a DATABASE openhab with USER openhabuser ?" 8 82; then
        sudo docker exec -it influxdb /usr/bin/influx
        CREATE DATABASE openhab
        USE openhab
        CREATE USER openhabuser with PASSWORD 'openhab' WITH ALL PRIVILEGES
        GRANT ALL PRIVILEGES ON openhab TO openhabuser
        else 
          whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --msgbox "You need to create your own DATABASE & USER " 8 82
        fi
      ;;
      '"Portainer"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/portainer && cd $HOME/docker-compose-data/portainer
        sudo wget -nc https://raw.github.com/BangerTech/portainer/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Portainer" --msgbox "You´ll find the WebUI on port http://yourIP:8999" 8 82
      ;;
      '"Filebrowser"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/filebrowser && cd $HOME/docker-compose-data/filebrowser
        sudo mkdir -p $HOME/docker-compose-data/filebrowser/database && cd $HOME/docker-compose-data/filebrowser/database
        sudo touch filebrowser.db
        cd $HOME/docker-compose-data/filebrowser
        sudo wget -nc https://raw.github.com/BangerTech/filebrowser/main/settings.json
        sudo wget -nc https://raw.github.com/BangerTech/filebrowser/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Filebrowser" --msgbox "You´ll find your self hosted Filebrowser on port http://yourIP:8998" 8 82
      ;;
      '"Heimdall"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/heimdall && cd $HOME/docker-compose-data/heimdall
        sudo wget -nc https://raw.github.com/BangerTech/heimdall/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Heimdall" --msgbox "You´ll find the Dashboard on port http://yourIP:8500" 8 82
      ;;
      '"HomeAssistant"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/homeassistant && cd $HOME/docker-compose-data/homeassistant
        sudo wget -nc https://raw.github.com/BangerTech/homeassistant/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "HomeAssistant" --msgbox "Your HomeAssistant is located here http://yourIP:8123" 8 82
      ;;
      '"CodeServer"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/codeserver && cd $HOME/docker-compose-data/codeserver
        sudo wget -nc https://raw.github.com/BangerTech/codeserver/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "CodeServer" --msgbox "Your CodeServer is located here http://yourIP:8440\nPassword is: admin\nYou may change it here $HOME/docker-compose-data/codeserver/docker-compose.yml" 14 82
      ;;
      '"node-exporter"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/node_exporter && cd $HOME/docker-compose-data/node_exporter
        sudo wget -nc https://raw.github.com/BangerTech/nodeexporter/main/docker-compose.yml
        sudo docker-compose up -d
      ;;
      *)
        echo "Unsupported item $CHOICE!" >&2
      exit 1
      ;;
      esac
      sudo apt autoremove -y
    done
      if whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --yesno "PACKAGES: $CHOICES installed successfully.\nWould you like to reboot?" 14 82; then
        sudo reboot
      fi
  else
    whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --msgbox "Cancelling Process since user pressed <NO>." 8 82
  fi
fi