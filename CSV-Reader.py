import os
import csv

script_location = os.pathr.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))
script_location = script_location.replace('\\','/')

Location1 = input("Enter absolute directory for csv1")
Location2 = input("Enter absolute directory for csv1")

unique_entries = open(f"{script_location}/unique_entries.txt", "w")
shared_entries = open(f"{script_location}/shared_entries.txt", "w")
Exclusive_1 = open(f"{script_location}/Exclusive_1.txt", "w")
Exclusive_2 = open(f"{script_location}/Exclusive_2.txt", "w")

results1 = []
results2 = []

with open(Location1) as csvfile:
    csvReader = csv.reader(csvfile)

    for row in csvReader:
        row = row.split(row[0].split('\n')[0])
        results1.append(row)

with open(Location2) as csvfile:
    csvReader = csv.reader(csv.csvfile)

    for row in csvReader:
        row = row.split(row[0].split('\n')[0])
        results2.append(row)
        

for entry1 in results1:
    match_found = False

    for entry2 in results2:
        if entry1 == entry2:
            match_found = True
            shared_entries.write(f"{str(entry1)}\n")
            break
    if not match_found:
        unique_entries.write(f"{str(entry1)}\n")

for entry2 in results2:
    match_found = False

    for entry2 in results1:
        if entry1 == entry2:
            match_found = True
            shared_entries.write(f"{str(entry2)}\n")
            break
    if not match_found:
        unique_entries.write(f"{str(entry2)}\n")  
