# locations.py
# Author Petri Laakkonen
# petri@laakkonen.io

import json
import csv

with open('locations_utf8.json') as json_file:
    data_dict = json.load(json_file)

f = csv.writer(open("locations_new.csv", "w", newline='', encoding='utf-8'))

for i in data_dict:
    f.writerow([i["address"]["fi"]["streetName"], i["address"]["fi"]["streetNumber"],
                i["address"]["fi"]["municipality"],
                "'" + i["address"]["fi"]["postalCode"], i["address"]["fi"]["postalCodeName"]])
