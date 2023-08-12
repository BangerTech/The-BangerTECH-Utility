#!/bin/bash

sudo bash -c 'sudo apt install whiptail -y >/dev/null 2>&1 & disown'
sudo bash -c 'sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/scripts/logo.txt >/dev/null 2>&1 & disown'
sudo bash -c 'sudo apt update && sudo apt upgrade -y >/dev/null 2>&1 & disown'

sleep 2
sudo cat $HOME/logo.txt

echo "Website:   https://bangertech.de"
echo "Donations: https://www.paypal.com/donate/?hosted_button_id=FD26FHKRWS3US"


sleep 5

CHOICES=$(whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "SELECT PACKAGES TO INSTALL"  --checklist "Choose options" 28 85 20 \
  "openHAB" "install openHABian on top of your running System " ON \
  "MosquittoBroker" "Mosquitto MQTT Broker" OFF \
  "Zigbee2MQTT" "Zigbee to MQTT Bridge" OFF \
  "Homebridge" "Homebridge/HomeKit Server" OFF \
  "Grafana" "Grafana Dashboard in a Docker Container" OFF \
  "influxDB" "influxDB Database in a Docker Container" OFF \
  "Portainer" "Docker Management Platform" OFF \
  "Filestash" "FTP File Browser in a Docker Container" OFF \
  "Heimdall" "Self hosted Dashboard" OFF \
  "HomeAssistant" "HomeAssistant in a Docker Container " OFF \
  "RaspberryMatic" "Homematic CCU in a Docker Container " OFF \
  "CodeServer" "VS Code through a Browser " OFF \
  "Prometheus" "Monitoring System " OFF \
  "node-exporter" "Data Export used to show host stats in Grafana " OFF \
  "Whats-Up-Docker" "updating Docker Containers made easy " OFF \
  "WatchYourLAN" "Lightweight network IP scanner" OFF \
  "Backup" "clone your system to an external device " OFF \
  "shut-wake" "shuts down & wakes up your Server fully automatic " OFF  3>&1 1>&2 2>&3)

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
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --yesno "openHAB is running on port http://$ipaddr:8080\nWould you like to restore your old openHAB config?" 14 82; then
        sudo openhab-cli restore /var/lib/openhab/backups/openhab-backup.zip
        fi
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
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/zigbee2mqtt && cd $HOME/docker-compose-data/zigbee2mqtt
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/zigbee2mqtt/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Zigbee2MQTT" --msgbox "Check your Zigbee Network here http://$ipaddr:7000" 8 82
      ;;
      '"Homebridge"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/homebridge && cd $HOME/docker-compose-data/homebridge
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/homebridge/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Homebridge" --msgbox "Setup the HomeKit Bridge here http://$ipaddr:8581" 8 82
      ;;
      '"Grafana"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/grafana && cd $HOME/docker-compose-data/grafana
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/grafana/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/grafana/data && cd $HOME/docker-compose-data/grafana/data
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/grafana/env.grafana
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Grafana" --msgbox "The Dashboard´s are located here http://$ipaddr:3000" 8 82
      ;;
      '"influxDB"')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/influxdb && cd $HOME/docker-compose-data/influxdb
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/influxdb-x86/docker-compose1.8.10.yml
        sudo docker-compose -f docker-compose1.8.10.yml up -d
        if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --yesno "Would you like to create a DATABASE database1 with USER user1 PASSWD pwd12345 ?" 8 88; then
        sudo wget -nc https://raw.github.com/BangerTech/The-BangerTECH-Utility/development/scripts/influxdb/influxdbdatabase.sh
        sudo sh influxdatabase.sh
        else 
          whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --msgbox "You need to create your own DATABASE & USER " 8 82
        fi
      ;;
      '"Portainer"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/portainer && cd $HOME/docker-compose-data/portainer
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/portainer/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Portainer" --msgbox "You´ll find the WebUI on port http://$ipaddr:8999" 8 82
      ;;
      '"Filestash"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/filestash && cd $HOME/docker-compose-data/filestash
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/filestash/docker-compose-before.yml
        sudo docker-compose -f docker-compose-before.yml up -d
        if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --yesno "Please go to http://$ipaddr:8334 and create a unique password. Done?" 8 82; then
        sudo docker cp filestash:/app/data/state $HOME/docker-compose-data/filestash/data
        sudo docker-compose -f docker-compose-before.yml down
        sudo rm -R docker-compose-before.yml
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/filestash/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Filestash" --msgbox "browse through files on port http://$ipaddr:8334" 8 82
        else 
          whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --msgbox "Please redo the installation" 8 82
        fi
      ;;
      '"Heimdall"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/heimdall && cd $HOME/docker-compose-data/heimdall
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/heimdall/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Heimdall" --msgbox "You´ll find the Dashboard on port http://$ipaddr:8500" 8 82
      ;;
      '"HomeAssistant"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/homeassistant && cd $HOME/docker-compose-data/homeassistant
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/homeassistant/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "HomeAssistant" --msgbox "Your HomeAssistant is located here http://$ipaddr:8123" 8 82
      ;;
      '"RaspberryMatic"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/raspberrymatic && cd $HOME/docker-compose-data/raspberrymatic
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/raspberrymatic/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "RaspberryMatic" --msgbox "Your RaspberryMatic is located here http://$ipaddr:8083" 8 82
      ;;
      '"CodeServer"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/codeserver && cd $HOME/docker-compose-data/codeserver
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/codeserver/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "CodeServer" --msgbox "Your CodeServer is located here http://$ipaddr:8440\nPassword is: admin\nYou may change it here $HOME/docker-compose-data/codeserver/docker-compose.yml" 14 82
      ;;
      '"Prometheus"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/prometheus && cd $HOME/docker-compose-data/prometheus
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/prometheus/docker-compose.yml
        sudo mkdir -p $HOME/docker-compose-data/prometheus/prometheus && cd $HOME/docker-compose-data/prometheus/prometheus
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/prometheus/prometheus.yml
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/prometheus/alert.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Prometheus" --msgbox "Your Prometheus Monitoring runs at http://$ipaddr:9090" 8 82
      ;;
      '"node-exporter"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/node_exporter && cd $HOME/docker-compose-data/node_exporter
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/nodeexporter/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "node-exporter" --msgbox "Scrape your Data from http://$ipaddr:9100" 8 82
      ;;
      '"Whats-Up-Docker"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/whatsupdocker && cd $HOME/docker-compose-data/whatsupdocker
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/whatsupdocker/docker-compose.yml
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "Whats up Docker" --msgbox "Update your Containers here http://$ipaddr:3004" 8 82
      ;;
      '"WatchYourLAN"')
        ipaddr=$(/mnt/c/Windows/System32/ipconfig.exe | grep 192.168. | grep -m1 IPv4 | awk '{print $13}' | tr -d '\r')
        lanaddr1=$(ls /sys/class/net/)
        sudo mkdir -p $HOME/docker-compose-data && cd $HOME/docker-compose-data
        sudo mkdir -p $HOME/docker-compose-data/watchyourlan && cd $HOME/docker-compose-data/watchyourlan
        sudo wget -nc https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/docker-compose-files/watchyourlan/docker-compose.yml
        lanaddr=$(whiptail --backtitle "The BangerTECH Utility X86 VERSION" --inputbox "which network interface do you want to use to scan?\n\n$lanaddr1 " 17 85 3>&1 1>&2 2>&3)
        if ! grep -q 'command: "'"-n http://'"$ipaddr"':8850"'"' "$HOME/docker-compose-data/watchyourlan/docker-compose.yml"; then
        sudo sed -i '12i\    command: "'"-n http://'"$ipaddr"':8850"'"' "$HOME/docker-compose-data/watchyourlan/docker-compose.yml"
        fi
        if ! grep -q 'IFACE: "'"$lanaddr"'"' "$HOME/docker-compose-data/watchyourlan/docker-compose.yml"; then
        sudo sed -i '19i\      IFACE: "'"$lanaddr"'"' "$HOME/docker-compose-data/watchyourlan/docker-compose.yml"
        fi
        if ! grep -q 'GUIIP: "'"$lanaddr"'"' "$HOME/docker-compose-data/watchyourlan/docker-compose.yml"; then
        sudo sed -i '21i\      GUIIP: "'"$ipaddr"'"' "$HOME/docker-compose-data/watchyourlan/docker-compose.yml"
        fi
        sudo docker-compose up -d
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "WatchYourLAN" --msgbox "scan your Network here http://$ipaddr:8840" 8 82
      ;;
      '"Backup"')
        disk=$(lsblk)
        diskint=$(whiptail --backtitle "The BangerTECH Utility X86 VERSION" --inputbox "which disk do you want to clone?\n\n$disk " 17 85 3>&1 1>&2 2>&3)
        diskext=$(whiptail --backtitle "The BangerTECH Utility X86 VERSION" --inputbox "on which disk do you want to store your clone?\n\n$disk " 17 85 3>&1 1>&2 2>&3)
        if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --yesno "Would you like to clone $diskint to $diskext now?" 8 82; then
        sudo dd if=/dev/$diskint of=/dev/$diskext bs=64K conv=noerror,sync status=progress
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "WatchYourLAN" --msgbox "You´re save. Cloning complete." 8 82
        else 
          whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --msgbox "Please redo the installation" 8 82
        fi
      ;;
      '"shut-wake"')
        timeshutdown=$(whiptail --backtitle "The BangerTECH Utility X86 VERSION" --inputbox " when do you want to shutdown your server? (hh:mm) " 15 85 3>&1 1>&2 2>&3)
        timewakeup=$(whiptail --backtitle "The BangerTECH Utility X86 VERSION" --inputbox " when do you want to wakeup your server? (hh:mm) " 15 85 3>&1 1>&2 2>&3)
        whiptail --backtitle "The BangerTECH Utility X86 VERSION" --ok-button Done --msgbox " Ok the server will be shutdown between $timeshutdown and $timewakeup ." 15 85
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
    done
      if whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --yesno "PACKAGES: $CHOICES installed successfully.\nWould you like to reboot?" 14 82; then
        sudo reboot
      fi
  else
    whiptail --backtitle "The BangerTECH Utility X86 VERSION" --title "MESSAGE" --msgbox "Cancelling Process since user pressed <NO>." 8 82
  fi
fi