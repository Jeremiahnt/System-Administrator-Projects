from pykeepass import PyKeePass
from datetime import datetime, timedelta, timezone
import json
import os

###### Synopsis ########
# This .py script will read the .kdbx file, and read for the last time an entry was modified and check if that last modified date is 335 days or older. If it is it will add that entry to the .json file attached to this code or one you declare.
# The .json this script interacts with will then be updated by another task or script that will be called on after an API call to SNOW is made to close out the ticket and/or routinely update the .json. TLDR; the .json file is used as an inventory of accounts that will need credentials updated.
########################

# Config Variables
db_path = ''                                                                # .kdbx absolute file path
db_password = ''                                                            # .kdbx password, will change this to .env or smthn else later
output_file = 'KeePass-Automation/expired_accounts.json'                    # .json inventory file
days_threshold = 1                                                          # Number of days you are ok with for the password age
new_entries = 0                                                             # Counter variable for sanity checks

# Load KeePass database
kp = PyKeePass(db_path, password=db_password)

# Threshold date
threshold_date = datetime.now(timezone.utc) - timedelta(days=days_threshold)    # Math operation to find how many days until password expires

# Grabs full path of the account entry. i.e UNIX/Linux/Ubuntu/Desktops
def get_group_path(group):
    path = []
    while group:
        path.insert(0, group.name)
        group = group.parentgroup
    return '/'.join(path)

# Load existing pwd expiry .json inventory file
if os.path.exists(output_file):
    with open(output_file, 'r') as f:
        expired_entries = json.load(f)                                      # Loads the .json file as a json object for the code to work with

for entry in kp.entries:
    ritm = str(entry.get_custom_property('RITM'))                           # Grabs RITM value of the KeePass entry it is currently iterating over
    if ritm.lower().startswith("ritm") == False:                            # Lowers the RITM value's string and does a check if it has a RITM ticket number in it or not, if it doesn't it continues to the next step
        if entry.mtime <= threshold_date:                                   # Checks if the last modified date of the entry is less than or equal to the # of days a password's age can be
                if str(entry.uuid) not in list(expired_entries.keys()):     # If the current entry's UUID is not in the existing .json inventory file, it will write an entry for it. This compares it against the array of UUIDs that gets extracted from the json above
                    expired_entries[str(entry.uuid)] = {
                        'uuid': str(entry.uuid),
                        'title': entry.title,
                        'username': entry.username,
                        'last_mod_time': entry.mtime.strftime('%Y-%m-%d'),
                        'group_path': get_group_path(entry.group),
                        'RITM': ""
                    }
                    new_entries += 1

# Write to JSON
with open(output_file, 'w') as f:                   
    json.dump(expired_entries, f, indent=2)                                 # Writes the updated expired_entries json variable to the existing .json inventory file

print(f"Exported {(new_entries)} expired entries to {output_file}")
