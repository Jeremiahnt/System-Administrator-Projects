import os
import csv

script_location = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))
script_location = script_location.replace('\\','/')

# Location1 = input("Enter absolute directory for csv1")
# Location2 = input("Enter absolute directory for csv1")
Location1 = "C:/Users/trent/OneDrive/Desktop/book1.csv"
Location2 = "C:/Users/trent/OneDrive/Desktop/book2.csv"

unique_entries = open(f"{script_location}/unique_entries.txt", "w")
shared_entries = open(f"{script_location}/shared_entries.txt", "w")
Exclusive_1 = open(f"{script_location}/Exclusive_1.txt", "w")
Exclusive_2 = open(f"{script_location}/Exclusive_2.txt", "w")

results1 = []
results2 = []

# Have to use encoding, to prevent first entry error...
with open(Location1, encoding ='utf-8-sig') as csvfile:
    csvReader = csv.reader(csvfile)

    for row in csvReader:
        row = row[0].split('\n')
        for i in row:
            results1.append(i)

with open(Location2, encoding ='utf-8-sig') as csvfile:
    csvReader = csv.reader(csvfile)

    for row in csvReader:
        row = row[0].split('\n')
        for i in row:
            results2.append(i)

print(results1,"\n") 
print(results2,"\n")       

for entry1 in results1:
    match_found = False

    for entry2 in results2:
        if entry1 in entry2:
            match_found = True
            shared_entries.write(f"{str(entry1)}\n")
            break
        
    if not match_found:
        unique_entries.write(f"{str(entry1)}\n")
        Exclusive_1.write(f"{str(entry1)}\n")
        
for entry2 in results2:
    match_found = False
    for entry1 in results1:
        if entry2 in entry1:
            match_found = True
            break
    
    if not match_found:
        unique_entries.write(f"{str(entry2)}\n")
        Exclusive_2.write(f"{str(entry2)}\n")
