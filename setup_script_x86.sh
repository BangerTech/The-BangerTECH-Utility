#!/bin/bash


CHOICES=$(whiptail --backtitle "BangerTECH INSTALLATION SCRIPT X86 VERSION" --title "SELECT PACKAGES TO INSTALL"  --checklist "Choose options" 22 82 10 \
  "openHAB" "install openHABian on top of your running System " ON \
  "Docker" "install just the Docker Engine" OFF \
  "Docker+Docker-Compose" "install Docker & Docker-Compose" OFF \
  "MosquittoBroker" "Mosquitto Broker in a Docker Container" OFF \
  "Zigbee2MQTT" "Zigbee2MQTT in a Docker Container" OFF \
  "Homebridge" "Homebridge/HomeKit Server in a Docker Container" OFF \
  "Grafana" "Grafana Dashboard in a Docker Container" OFF \
  "influxDB" "influxDB Database in a Docker Container" OFF \
  "Portainer" "Docker Management Platform in a Docker Container" OFF \
  "Filestash" "FTP File Browser in a Docker Container" OFF \
  "Heimdall" "Self hosted Dashboard" OFF \
  "node-exporter" "Data Export used to show host stats in Grafana" OFF  3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
  whiptail --title "MESSAGE" --msgbox "No option was selected (user hit Cancel or ESC)" 8 82
  else
  if whiptail --title "CONFIRMATION" --yesno "You are about to install: $CHOICES" 8 82; then 
    for CHOICE in $CHOICES; do
    case "$CHOICE" in
      '"openHAB"')
        sudo apt update && sudo apt upgrade -y
        sudo apt-get install -y git
        sudo apt install curl -y
        sudo git clone -b openHAB https://github.com/openhab/openhabian.git /opt/openhabian
        sudo ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config
        sudo cp /opt/openhabian/build-image/openhabian.conf /etc/openhabian.conf
        sudo openhabian-config unattended
        if whiptail --title "MESSAGE" --yesno "Would you like to restore your old openHAB config?" 8 82; then
        sudo openhab-cli restore /var/lib/openhab/backups/openhab-backup.zip
        else 
          whiptail --title "MESSAGE" --msgbox "OK enjoy using openHAB" 8 82
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
        sudo mkdir $HOME/docker-compose-data
      ;;
      '"MosquittoBroker"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/mosquitto && cd ~/docker-compose-data/mosquitto
        sudo wget https://raw.github.com/BangerTech/mosquitto-broker/main/docker-compose.yml
        mkdir ~/docker-compose-data/mosquitto/config && cd ~/docker-compose-data/mosquitto/config
        sudo wget https://raw.github.com/BangerTech/mosquitto-broker/main/mosquitto.conf
        cd ..
        sudo docker-compose up -d
      ;;
      '"Zigbee2MQTT"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/zigbee2mqtt && cd ~/docker-compose-data/zigbee2mqtt
        sudo wget https://raw.github.com/BangerTech/zigbee2mqtt/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --title "Zigbee2MQTT" --msgbox "Check your Zigbee Network here http://yourip:7000" 8 82
      ;;
      '"Homebridge"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/homebridge && cd ~/docker-compose-data/homebridge
        sudo wget https://raw.github.com/BangerTech/homebridge/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --title "Homebridge" --msgbox "Setup the HomeKit Bridge here http://yourip:8321" 8 82
      ;;
      '"Grafana"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/grafana && cd ~/docker-compose-data/grafana
        sudo wget https://raw.github.com/BangerTech/grafana/main/docker-compose.yml
        mkdir ~/docker-compose-data/grafana/data && cd ~/docker-compose-data/grafana/data
        sudo wget https://raw.github.com/BangerTech/grafana/main/env.grafana
        sudo docker-compose up -d
        whiptail --title "Grafana" --msgbox "The Dashboard´s are located here http://yourip:3000" 8 82
      ;;
      '"influxDB"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/influxdb && cd ~/docker-compose-data/influxdb
        sudo wget https://raw.github.com/BangerTech/influxdb-x86/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --title "influxDB" --msgbox "You´ll find the WebUI on port http://yourip:8086" 8 82
      ;;
      '"Portainer"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/portainer && cd ~/docker-compose-data/portainer
        sudo wget https://raw.github.com/BangerTech/portainer/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --title "Portainer" --msgbox "You´ll find the WebUI on port http://yourip:8999" 8 82
      ;;
      '"Filestash"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/filestash && cd ~/docker-compose-data/filestash
        sudo wget https://raw.github.com/BangerTech/filestash-before/main/docker-compose.yml
        sudo docker-compose up -d
        if whiptail --title "MESSAGE" --yesno "Please go to http://yourip:8334 and create a unique password. Done?" 8 120; then
        sudo docker cp filestash:/app/data/state $HOME/docker-compose-data/filestash/data
        sudo docker-compose down
        sudo rm -R docker-compose.yml
        sudo wget https://raw.github.com/BangerTech/filestash/main/docker-compose.yml
        sudo docker-compose up -d
        else 
          whiptail --title "MESSAGE" --msgbox "Please redo the installation" 8 120
        fi
      ;;
      '"Heimdall"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/heimdall && cd ~/docker-compose-data/heimdall
        sudo wget https://raw.github.com/BangerTech/heimdall/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --title "Heimdall" --msgbox "You´ll find the Dashboard on port http://yourip:8500" 8 120
      ;;
      '"node-exporter"')
        mkdir ~/docker-compose-data && cd ~/docker-compose-data
        mkdir ~/docker-compose-data/node_exporter && cd ~/docker-compose-data/node_exporter
        sudo wget https://raw.github.com/BangerTech/nodeexporter/main/docker-compose.yml
        sudo docker-compose up -d
      ;;
      *)
        echo "Unsupported item $CHOICE!" >&2
      exit 1
      ;;
      esac
    done
      if whiptail --title "MESSAGE" --yesno "PACKAGES: $CHOICES installed successfully.\nWould you like to reboot?" 8 82; then
        sudo reboot
      else 
        whiptail --title "MESSAGE" --msgbox "All Done!" 8 82
      fi
  else
    whiptail --title "MESSAGE" --msgbox "Cancelling Process since user pressed <NO>." 8 82
  fi
fi
