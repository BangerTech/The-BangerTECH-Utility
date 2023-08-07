#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo bash -c 'sudo apt install whiptail -y >/dev/null 2>&1 & disown'
sudo bash -c 'sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/scripts/logo.txt >/dev/null 2>&1 & disown'
#sudo bash -c 'sudo apt update && sudo apt upgrade -y >/dev/null 2>&1 & disown'

sleep 2
sudo cat logo.txt

echo "Website:   https://bangertech.de"
echo "Donations: https://www.paypal.com/donate/?hosted_button_id=FD26FHKRWS3US"


sleep 5

CHOICES=$(whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "SELECT PACKAGES TO INSTALL"  --checklist "Choose options" 27 85 19 \
  "openHAB" "install openHABian on top of your running System " ON \
  "Docker" "install just the Docker Engine" OFF \
  "Docker+Docker-Compose" "install Docker & Docker-Compose" OFF \
  "MosquittoBroker" "Mosquitto MQTT Broker" OFF \
  "Zigbee2MQTT" "Zigbee to MQTT Bridge" OFF \
  "Homebridge" "Homebridge/HomeKit Server" OFF \
  "Grafana" "Grafana Dashboard in a Docker Container" OFF \
  "influxDB" "influxDB Database in a Docker Container" OFF \
  "Portainer" "Docker Management Platform" OFF \
  "Filebrowser" "Self hosted File Managemnet in a Docker Container" OFF \
  "Heimdall" "Self hosted Dashboard" OFF \
  "HomeAssistant" "HomeAssistant in a Docker Container " OFF \
  "RaspberryMatic" "Homematic CCU in a Docker Container " OFF \
  "CodeServer" "VS Code through a browser " OFF \
  "Prometheus" "Monitoring System " OFF \
  "node-exporter" "Data Export used to show host stats in Grafana " OFF \
  "Whats-Up-Docker" "updating Docker Containers made easy " OFF \
  "WatchYourLAN" "Lightweight network IP scanner" OFF \
  "shut-wake" "shuts down & wakes up your Server fully automatic " OFF  3>&1 1>&2 2>&3)

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
        ipaddr=$(hostname -I | awk '{print $1}')
        if whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --yesno "openHAB is running on port http://$ipaddr:8080\nWould you like to restore your old openHAB config?" 14 82; then
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
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/mosquitto-broker/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/mosquitto/config && cd $HOME/docker-compose-data/mosquitto/config
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/mosquitto-broker/mosquitto.conf
        cd ..
        sudo docker-compose up -d
      ;;
      '"Zigbee2MQTT"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/zigbee2mqtt && cd $HOME/docker-compose-data/zigbee2mqtt
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/zigbee2mqtt/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Zigbee2MQTT" --msgbox "Check your Zigbee Network here http://$ipaddr:7000" 8 82
      ;;
      '"Homebridge"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/homebridge && cd $HOME/docker-compose-data/homebridge
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/homebridge/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Homebridge" --msgbox "Setup the HomeKit Bridge here http://$ipaddr:8581" 8 82
      ;;
      '"Grafana"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/grafana && cd $HOME/docker-compose-data/grafana
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/grafana/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/grafana/data && cd $HOME/docker-compose-data/grafana/data
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/grafana/env.grafana
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Grafana" --msgbox "The Dashboard´s are located here http://$ipaddr:3000" 8 82
      ;;
      '"influxDB"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/influxdb && cd $HOME/docker-compose-data/influxdb
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/influxdb-arm/docker-compose.yml
        sudo docker-compose up -d
        if whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --yesno "Would you like to create a DATABASE database1 with USER user1 PASSWD pwd12345 ?" 8 82; then
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/scripts/influxdb/influxdbdatabase.sh
        sudo sh influxdatabase.sh
        else 
          whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --msgbox "You need to create your own DATABASE & USER " 8 82
        fi
      ;;
      '"Portainer"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/portainer && cd $HOME/docker-compose-data/portainer
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/portainer/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Portainer" --msgbox "You´ll find the WebUI on port http://$ipaddr:8999" 8 82
      ;;
      '"Filebrowser"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/filebrowser && cd $HOME/docker-compose-data/filebrowser
        sudo mkdir -p $HOME/docker-compose-data/filebrowser/database && cd $HOME/docker-compose-data/filebrowser/database
        sudo touch filebrowser.db
        cd $HOME/docker-compose-data/filebrowser
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/filebrowser/settings.json
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/filebrowser/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Filebrowser" --msgbox "You´ll find your self hosted Filebrowser on port http://$ipaddr:8998\nUser=admin Password=admin " 8 82
      ;;
      '"Heimdall"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/heimdall && cd $HOME/docker-compose-data/heimdall
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/heimdall/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Heimdall" --msgbox "You´ll find the Dashboard on port http://$ipaddr:8500" 8 82
      ;;
      '"HomeAssistant"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/homeassistant && cd $HOME/docker-compose-data/homeassistant
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/homeassistant/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "HomeAssistant" --msgbox "Your HomeAssistant is located here http://$ipaddr:8123" 8 82
      ;;
      '"RaspberryMatic"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/raspberrymatic && cd $HOME/docker-compose-data/raspberrymatic
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/raspberrymatic/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "RaspberryMatic" --msgbox "Your RaspberryMatic is located here http://$ipaddr:8083" 8 82
      ;;
      '"CodeServer"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/codeserver && cd $HOME/docker-compose-data/codeserver
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/codeserver/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "CodeServer" --msgbox "Your CodeServer is located here http://$ipaddr:8440\nPassword is: admin\nYou may change it here $HOME/docker-compose-data/codeserver/docker-compose.yml" 14 82
      ;;
      '"Prometheus"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/prometheus && cd $HOME/docker-compose-data/prometheus
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/prometheus/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/prometheus/prometheus && cd $HOME/docker-compose-data/prometheus/prometheus
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/prometheus/prometheus.yml
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/prometheus/alert.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Prometheus" --msgbox "Your Prometheus Monitoring runs at http://$ipaddr:9090" 8 82
      ;;
      '"node-exporter"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/node_exporter && cd $HOME/docker-compose-data/node_exporter
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/nodeexporter/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "node-exporter" --msgbox "Scrape your Data from http://$ipaddr:9100" 8 82
      ;;
      '"Whats-Up-Docker"')
        ipaddr=$(hostname -I | awk '{print $1}')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/whatsupdocker && cd $HOME/docker-compose-data/whatsupdocker
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/whatsupdocker/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "Whats up Docker" --msgbox "Update your Containers here http://$ipaddr:3004" 8 82
      ;;
      '"WatchYourLAN"')
        ipaddr=$(hostname -I | awk '{print $1}')
        lanaddr1=$(ls /sys/class/net/)
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/watchyourlan && cd $HOME/docker-compose-data/watchyourlan
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/watchyourlanarm/docker-compose.yml
        lanaddr=$(whiptail --backtitle "The BangerTECH Utility X86 VERSION" --inputbox "which network interface do you want to use to scan?\n\n$lanaddr1 " 17 85 3>&1 1>&2 2>&3)
        if ! grep -q 'IFACE: "'"$lanaddr"'"' "$HOME/docker-compose-data/watchyourlan/docker-compose.yml"; then
        sudo sed -i '19i\      IFACE: "'"$lanaddr"'"' "$HOME/docker-compose-data/watchyourlan/docker-compose.yml"
        fi
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "WatchYourLAN" --msgbox "scan your Network here http://$ipaddr:8840" 8 82
      ;;
      '"shut-wake"')
        timeshutdown=$(whiptail --backtitle "The BangerTECH Utility ARM VERSION" --inputbox " when do you want to shutdown your server? (hh:mm) " 15 85 3>&1 1>&2 2>&3)
        timewakeup=$(whiptail --backtitle "The BangerTECH Utility ARM VERSION" --inputbox " when do you want to wakeup your server? (hh:mm) " 15 85 3>&1 1>&2 2>&3)
        whiptail --backtitle "The BangerTECH Utility ARM VERSION" --ok-button Done --msgbox " Ok the server will be shutdown between $timeshutdown and $timewakeup ." 15 85
        hour=$(date -d "$timeshutdown" '+%-H')
        minute=$(date -d "$timeshutdown" '+%-M')
        wakeuphour=$(date -d "$timewakeup" '+%-H')
        wakeupminute=$(date -d "$timewakeup" '+%-M')
        sh=$(($hour*3600))
        sm=$(($minute*60))
        shutseconds=$(($sh + $sm))
        wh=$(($wakeuphour*3600))
        wm=$(($wakeupminute*60))
        wakeupseconds=$(($wh  + $wm))
        downtime=$(($shutseconds - $wakeupseconds))
        downtimeseconds=${downtime#-}
        sudo echo -e "#!/bin/bash\nsudo rtcwake -m no -s $downtimeseconds\nsudo /sbin/shutdown -h now" | sudo tee /usr/local/bin/shutwake.sh
        sudo chmod +x /usr/local/bin/shutwake.sh
        (crontab -l; echo "$minute $hour * * * /usr/local/bin/shutwake.sh")|awk '!x[$0]++'|crontab -
      ;;
      *)
        echo "Unsupported item $CHOICE!" >&2
      exit 1
      ;;
      esac
      sudo bash -c 'sudo apt autoremove -y >/dev/null 2>&1 & disown'
      #sudo apt autoremove -y
    done
      if whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --yesno "PACKAGES: $CHOICES installed successfully.\nWould you like to reboot?" 14 82; then
        sudo reboot
      fi
  else
    whiptail --backtitle "The BangerTECH Utility ARM VERSION" --title "MESSAGE" --msgbox "Cancelling Process since user pressed <NO>." 8 82
  fi
fi
