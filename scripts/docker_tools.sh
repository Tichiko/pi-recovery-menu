#!/bin/bash
HEIGHT=20
WIDTH=60
CHOICE_HEIGHT=10
BACKTITLE="Docker Management"
TITLE="Docker Menu"
MENU="Choose a task:"

OPTIONS=(
  1 "Start Docker"
  2 "Stop Docker"
  3 "Restart Docker"
  4 "List Running Containers"
  5 "List All Containers"
  6 "View Logs of a Container"
  7 "Prune Unused Docker Data"
  8 "Pull a Docker Image"
  9 "Install or Update Portainer"
  10 "Return to Main Menu"
)

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
  1)
    sudo systemctl start docker
    dialog --msgbox "Docker started." 10 40
    ;;
  2)
    sudo systemctl stop docker
    dialog --msgbox "Docker stopped." 10 40
    ;;
  3)
    sudo systemctl restart docker
    dialog --msgbox "Docker restarted." 10 40
    ;;
  4)
    sudo docker ps | less
    ;;
  5)
    sudo docker ps -a | less
    ;;
  6)
    CONTAINER_ID=$(dialog --inputbox "Enter Container ID or Name:" 8 40 2>&1 >/dev/tty)
    clear
    if [ -n "$CONTAINER_ID" ]; then
      docker logs --tail 100 "$CONTAINER_ID" | tee /tmp/docker_logs.log
      dialog --textbox /tmp/docker_logs.log 20 70
    else
      dialog --msgbox "No container specified." 6 40
    fi
    ;;
  7)
    docker system prune -a --volumes -f
    dialog --msgbox "Docker system pruned (containers, images, volumes)." 10 50
    ;;
  8)
    IMAGE_NAME=$(dialog --inputbox "Enter image name (e.g., nginx:latest):" 8 50 2>&1 >/dev/tty)
    clear
    if [ -n "$IMAGE_NAME" ]; then
      docker pull "$IMAGE_NAME" | tee /tmp/docker_pull.log
      dialog --textbox /tmp/docker_pull.log 20 70
    else
      dialog --msgbox "No image name entered." 6 40
    fi
    ;;
  9)
    docker volume create portainer_data
    docker stop portainer 2>/dev/null
    docker rm portainer 2>/dev/null
    docker run -d -p 9000:9000 --name portainer --restart=always \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v portainer_data:/data \
      portainer/portainer-ce
    dialog --msgbox "Portainer is running at http://<your-pi-ip>:9000" 10 50
    ;;
  10)
    ;;
esac
