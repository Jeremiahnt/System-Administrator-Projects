import os

entries = []
i = int(0)

online_hosts = open("online_hostst.txt", "w")
offline_hosts = open("offline_hosts.txt", "w")
unreachable_hosts = open("unreachable_hosts.txt", "w")

def readFile(file):
    file = open(file, "r")
    array = file.read().splitlines()
    
    #Checks for any spaces in any entries from the .txt file
    for i in array:
        #By default the code will remove any space because of this replace command below
        update = i.replace(' ', '')
        entries.append(update)

hosts = input("Enter in the full directory of the .txt containing the hosts you'd like to check in format such as C:/Users/USER_NAME/Desktop/hosts.txt\n")
readFile(hosts)

for host in entries:
    response = os.popen(f"ping {host}").read()
    
    if "Received = 0" in response:
        print(f"{host} OFFLINE")
        online_hosts.write(response)
        
    if "could not find" in response:
        print(f"{host} NOT FOUND")
        unreachable_hosts.write(response)
    else:
        print(f"{host} online")
        online_hosts.write(response)

