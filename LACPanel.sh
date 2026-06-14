#!/bin/bash

# ========== Functions ==========

# Clear screen
clear_screen() { echo -e "\033[2J\033[H"; }

# Check for package manager
pkgmgmt()
{
if command -v apt &> /dev/null; then
    echo "Package manager: APT (Debian/Ubuntu)"
elif command -v dnf &> /dev/null; then
    echo "Package manager: DNF (Fedora/RHEL)"
elif command -v yum &> /dev/null; then
    echo "Package manager: YUM (Older RHEL/CentOS)"
elif command -v pacman &> /dev/null; then
    echo "Package manager: Pacman (Arch)"
elif command -v zypper &> /dev/null; then
    echo "Package manager: Zypper (openSUSE)"
elif command -v apk &> /dev/null; then
    echo "Package manager: APK (Alpine)"
else
    echo "Package manager not detected"
fi


}


# Check if Apache is installed
is_installed() {
    if dpkg -l | grep -q "^ii.*apache2"; then
    #command -v apache2 >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Install Apache
installApache() {
    sudo apt update && sudo apt install -y apache2
}

# Display Apache status
show_status() {
    local status
    status=$(systemctl is-active apache2 2>/dev/null)
    if [[ $status == "active" ]]; then
        echo -e "\e[32mApache2 is RUNNING\e[0m"
    else
        echo -e "\e[31mApache2 is STOPPED\e[0m"
    fi
}

# Main control panel
main_menu() {
    while true; do
        echo ""
        show_status
        echo ""
        echo "Type A and enter for Status"
        echo "Type B and enter to Start"
        echo "Type C and enter to Restart"
        echo "Type D and enter to Stop"
        echo "Type E and enter to Exit"
        echo ""
        read -p "Enter your choice: " choice

        case $choice in
            "A"|"a") clear_screen; systemctl status apache2; echo; read -p "Press Enter to continue..." ;;
            "B"|"b") clear_screen; systemctl start apache2; echo "Apache started."; sleep 2 ;;
            "C"|"c") clear_screen; systemctl restart apache2; echo "Apache restarted."; sleep 2 ;;
            "D"|"d") clear_screen; systemctl stop apache2; echo "Apache stopped."; sleep 2 ;;
            "E"|"e") clear_screen; echo "Goodbye!"; break ;;
            *) clear_screen; printf "\nInvalid choice. Please try again.\n"; sleep 2 ;;
        esac

        clear_screen
    done
}

# Install prompt
install_prompt() {
    while true; do
        echo -e "\e[31mApache is not installed on this computer.\e[0m"
        echo "Do you wish to install the latest version? (Y/N)"
        read -p "Your choice: " install_choice

        case $install_choice in
            "Y"|"y"|"Yes"|"YES"|"yes")
                clear_screen
                echo "Installing Apache..."
                installApache
                echo "Installation complete!"
                sleep 2
                exec "$0" # Restart the script
                ;;
            "N"|"n"|"No"|"NO"|"no")
                clear_screen
                echo "Apache will not be installed. Exiting..."
                sleep 2
                exit 0
                ;;
            *) clear_screen; printf "\nInvalid choice. Please try again.\n"; sleep 2 ;;
        esac
    done
}

# ========== Main Execution ==========

clear_screen
echo "**********************************************"
echo "* Welcome to the Simple Apache2 Control Panel *"
echo "**********************************************"

if is_installed; then
    echo ""
    echo -e "\e[32mApache is Installed!\e[0m"
    main_menu
else
    install_prompt
fi
