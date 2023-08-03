#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install whiptail -y

CHOICES=$(whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "SELECT PACKAGES TO INSTALL"  --checklist "Choose options" 22 82 15 \
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
  "HomeAssistant" "HomeAssistant in a Container " OFF \
  "RaspberryMatic" "Homematic CCU in a Container " OFF \
  "CodeServer" "VS Code through the browser " OFF \
  "Prometheus" "Monitoring a linux host " OFF \
  "node-exporter" "Data Export used to show host stats in Grafana" OFF  3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
  whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --msgbox "No option was selected (user hit Cancel or ESC)" 8 82
  else
  if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "CONFIRMATION" --yesno "You are about to install: $CHOICES" 8 82; then 
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
        if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --yesno "openHAB is running on port http://yourIP:8080\nWould you like to restore your old openHAB config?" 14 82; then
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
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/mosquitto-broker/main/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/mosquitto/config && cd $HOME/docker-compose-data/mosquitto/config
        sudo wget -nc https://raw.github.com/BangerTech/mosquitto-broker/main/mosquitto.conf
        cd ..
        sudo docker-compose up -d
      ;;
      '"Zigbee2MQTT"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/zigbee2mqtt && cd $HOME/docker-compose-data/zigbee2mqtt
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/zigbee2mqtt/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Zigbee2MQTT" --msgbox "Check your Zigbee Network here http://yourIP:7000" 8 82
      ;;
      '"Homebridge"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/homebridge && cd $HOME/docker-compose-data/homebridge
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/homebridge/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Homebridge" --msgbox "Setup the HomeKit Bridge here http://yourIP:8581" 8 82
      ;;
      '"Grafana"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/grafana && cd $HOME/docker-compose-data/grafana
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/grafana/main/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/grafana/data && cd $HOME/docker-compose-data/grafana/data
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/grafana/main/env.grafana
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Grafana" --msgbox "The Dashboard´s are located here http://yourIP:3000" 8 82
      ;;
      '"influxDB"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/influxdb && cd $HOME/docker-compose-data/influxdb
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/influxdb-x86/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "influxDB" --msgbox "You´ll find the WebUI on port http://yourIP:8086" 8 82
      ;;
      '"Portainer"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/portainer && cd $HOME/docker-compose-data/portainer
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/portainer/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Portainer" --msgbox "You´ll find the WebUI on port http://yourIP:8999" 8 82
      ;;
      '"Filestash"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/filestash && cd $HOME/docker-compose-data/filestash
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/filestash-before/main/docker-compose.yml
        sudo docker-compose up -d
        if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --yesno "Please go to http://yourIP:8334 and create a unique password. Done?" 8 82; then
        sudo docker cp filestash:/app/data/state $HOME/docker-compose-data/filestash/data
        sudo docker-compose down
        sudo rm -R docker-compose.yml
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/filestash/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Filestash" --msgbox "browse through files on port http://yourIP:8334" 8 82
        else 
          whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --msgbox "Please redo the installation" 8 82
        fi
      ;;
      '"Heimdall"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/heimdall && cd $HOME/docker-compose-data/heimdall
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/heimdall/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Heimdall" --msgbox "You´ll find the Dashboard on port http://yourIP:8500" 8 82
      ;;
      '"HomeAssistant"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/homeassistant && cd $HOME/docker-compose-data/homeassistant
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/homeassistant/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "HomeAssistant" --msgbox "Your HomeAssistant is located here http://yourIP:8123" 8 82
      ;;
      '"RaspberryMatic"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/raspberrymatic && cd $HOME/docker-compose-data/raspberrymatic
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/raspberrymatic/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "RaspberryMatic" --msgbox "Your RaspberryMatic is located here http://yourIP:8083" 8 82
      ;;
      '"CodeServer"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/codeserver && cd $HOME/docker-compose-data/codeserver
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/codeserver/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "CodeServer" --msgbox "Your CodeServer is located here http://yourIP:8440\nPassword is: admin\nYou may change it here $HOME/docker-compose-data/codeserver/docker-compose.yml" 14 82
      ;;
      '"Prometheus"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/prometheus && cd $HOME/docker-compose-data/prometheus
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/prometheus/main/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/prometheus/prometheus && cd $HOME/docker-compose-data/prometheus/prometheus
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/prometheus/main/prometheus.yml
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/prometheus/main/alert.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Prometheus" --msgbox "Your Prometheus Monitoring runs at http://yourIP:9090" 8 82
      ;;
      '"node-exporter"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/node_exporter && cd $HOME/docker-compose-data/node_exporter
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/nodeexporter/main/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "node-exporter" --msgbox "Scrape your Data from http://yourIP:9100" 8 82
      ;;
      *)
        echo "Unsupported item $CHOICE!" >&2
      exit 1
      ;;
      esac
      sudo apt autoremove -y
    done
      if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --yesno "PACKAGES: $CHOICES installed successfully.\nWould you like to reboot?" 14 82; then
        sudo reboot
      fi
  else
    whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --msgbox "Cancelling Process since user pressed <NO>." 8 82
  fi
fi