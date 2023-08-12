# The BangerTECH Utility

<img width="1338" alt="Screenshot 2023-08-03 at 12 12 52" src="https://github.com/BangerTech/The-BangerTECH-Utility/assets/73241309/a4d8ccc9-6e75-458b-9d06-37c95b1353c8">


# 1. Table of content
- [1. Table of content](#1-table-of-content)
- [2. What is this Tool?](#2-what-is-this-plugin)
- [3. Setup & Requirements](#3-setup)
- [4. How to use it?](#5-how-to-use-it)
- [5. Support / Feedback](#4-support--feedback)
- [6. How to contribute?](#6-how-to-contribute)
- [7. Sponsor me!](#7-how-to-sponsor)

# 2. What is this Tool?
This Tool is usefull to install Programs & Software on your Debian based Server, Desktop, Mini-PC...  
After you´ve choosen a Program the Tool will install and setup everything for you.   
There are two versions, one for ARM based Systems like a Raspberry Pi and one for X86 Systems like a Server, Desktop...  

1. openHABian
2. Docker + Docker-Compose
3. Mosquitto Broker
4. Zigbee2MQTT
5. Homebridge
6. Grafana
7. influxDB
8. Portainer
9. Filestash / Filebrowser
10. Heimdall
11. HomeAssistant
12. RaspberryMatic
13. CodeServer
14. Prometheus
15. node-exporter
16. Whats up Docker
17. WatchYourLAN
18. Backup
19. shut-wake Script


# 3. Setup & Requirements
- _sudo_ should be installed
- **$USER** needs to be a Member of Group _sudo_
- ad **%sudo  ALL=(ALL) NOPASSWD:ALL** with _visudo_
- Docker + Docker-Compose is **required** for all Container based Programs

# 4. How to use it?

For X86 Systems:
1. cd $HOME
2. sudo wget https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/bangertech_utility_x86.sh
3. sudo chmod +x bangertech_utility_x86.sh
4. sh bangertech_utility_x86.sh
5. pick your Program and follow the Steps presented by the Tool

For ARM Systems:
1. cd $HOME
2. sudo wget https://raw.githubusercontent.com/BangerTech/The-BangerTECH-Utility/development/bangertech_utility_arm.sh
3. sudo chmod +x bangertech_utility_arm.sh
4. sh bangertech_utility_arm.sh
5. pick your Program and follow the Steps presented by the Tool

check out the development Branch here: https://github.com/BangerTech/The-BangerTECH-Utility/tree/development

written Article how to use it: https://bangertech.de/the-bangertech-utility-smarthome-server-schnell-einfach-installiert/

# 5. Support / Feedback
Any bugs? Feature request? Message me [here](https://github.com/bangertech) or click on the "Issues" tab here on the GitHub repository!

# 6. How to contribute?

Fork the repository and create PR's.

# 7 How to sponsor?


<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FD26FHKRWS3US" target="_blank"><img src="https://pics.paypal.com/00/s/N2EwMzk4NzUtOTQ4Yy00Yjc4LWIwYmUtMTA3MWExNWIzYzMz/file.PNG" alt="SUPPORT" height="51"></a>
