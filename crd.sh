#!/bin/bash

username="gibhq"
password="gibhq"
sudo useradd -m "$username" > /dev/null 2>&1
sudo adduser "$username" sudo > /dev/null 2>&1
echo "$username:$password" | sudo chpasswd > /dev/null 2>&1
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd > /dev/null 2>&1

CRP=""
Pin=123456

installCRD() {
    echo "Installing Remote Desktop..."
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    echo "installation complete!"
}

installDesktopEnvironment() {
    echo "Installing Desktop Environment..."
    sudo apt install --assume-yes xfce4 xfce4-goodies
    echo "exec xfce4-session" > ~/.chrome-remote-desktop-session
    chmod +x ~/.chrome-remote-desktop-session
    sudo apt remove --assume-yes gnome-terminal
    echo "installation complete!"
}

installBrowser() {
    echo "Installing Google Chrome..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    sudo apt install --assume-yes remmina remmina-plugin-rdp remmina-plugin-vnc remmina-plugin-secret
    sudo apt install --assume-yes python3-pip
    sudo pip install gdown
    echo "installation complete!"
}

getCRP() {
    echo "Check https://remotedesktop.google.com/headless"
    read -p "SSH Code: " CRP
    if [ -z "$CRP" ]; then
        echo "Please enter a valid value."
        getCRP
    fi
}

finish() {
    sudo adduser $username chrome-remote-desktop > /dev/null 2>&1
    command="$CRP --pin=$Pin" > /dev/null 2>&1
    sudo su - $username -c "$command" > /dev/null 2>&1
    sudo systemctl status chrome-remote-desktop@$USER
}

# Main
installCRD
installDesktopEnvironment
installBrowser
getCRP
finish

while true; do sleep 10; done
