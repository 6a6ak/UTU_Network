#!/bin/bash

while true; do
    echo -e "\033[0;34m" # Set color to blue

    # Print the options menu
    echo "Select an option:"
    echo "1. Check Wi-Fi Connection"
    echo "2. Check Ethernet Connection"
    echo "3. Check Wi-Fi Signal Strength"
    echo "4. List Available Wi-Fi Networks"
    echo "5. Display IP Address"
    echo "6. Check Network Speed"
    echo "0. Exit"
    read option

    echo "----------------------------------------"

    case $option in
        1)
        echo "Checking Wi-Fi connection..."
        wifi_card=$(sudo lshw -class network | grep -A 12 'Wireless interface' | grep 'logical name' | awk '{print $3}')
        if [ -z "$wifi_card" ]; then
            echo "No Wi-Fi card found."
        else
            wifi_status=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\: -f2)
            if [ -z "$wifi_status" ]; then
                echo "No active Wi-Fi connection found on interface $wifi_card."
            else
                echo "Connected to Wi-Fi network: $wifi_status on interface $wifi_card."
            fi
        fi
        ;;

        2)
        echo "Checking Ethernet connection..."
        eth_card=$(sudo lshw -class network | grep -A 12 'Ethernet interface' | grep 'logical name' | awk '{print $3}')
        if [ -z "$eth_card" ]; then
            echo "No Ethernet card found."
        else
            eth_status=$(nmcli -t -f connected dev show $eth_card | grep 'yes')
            if [ -z "$eth_status" ]; then
                echo "No active Ethernet connection found on interface $eth_card."
            else
                echo "Ethernet connection active on interface $eth_card."
            fi
        fi
        ;;

        3)
        echo "Checking Wi-Fi signal strength..."
        wifi_card=$(sudo lshw -class network | grep -A 12 'Wireless interface' | grep 'logical name' | awk '{print $3}')
        if [ -z "$wifi_card" ]; then
            echo "No Wi-Fi card found."
        else
            nmcli -f IN-USE,SIGNAL dev wifi
        fi
        ;;

        4)
        echo "Listing available Wi-Fi networks..."
        nmcli dev wifi
        ;;

        5)
        echo "Displaying IP addresses..."
        ip addr show | grep inet
        ;;

        6)
        if ! command -v speedtest-cli &> /dev/null
        then
            echo "speedtest-cli could not be found"
            echo "Would you like to install speedtest-cli? (yes/no)"
            read answer
            if [ "$answer" == "yes" ]; then
                echo "Installing speedtest-cli..."
                sudo apt-get install speedtest-cli
            else
                echo "Skipping network speed check..."
                continue
            fi
        fi
        echo "Checking network speed..."
        speedtest-cli
        ;;

        0)
        echo "Exiting..."
        exit 0
        ;;

        *)
        echo "Invalid option. Please select a valid one."
        ;;
    esac

    echo -e "\033[0m" # Reset color
    echo "----------------------------------------"
done
