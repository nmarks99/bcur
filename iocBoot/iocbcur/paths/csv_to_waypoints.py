#!/usr/bin/env python3
import argparse
from epics import caput

CSV_FILE = "AtoB_new.csv"
FIELDS = ("X", "Y", "Z", "Roll", "Pitch", "Yaw", "Speed", "Acceleration", "Blend", "Gripper")

# Read the CSV waypoints file
csv_in = []
with open(CSV_FILE, "r") as file:
    for row in file:
        csv_in.append(list(map(lambda i: float(i), row.strip().split(","))))

# Define the waypoints you want to overwrite here
pv_names = [f"bcur:WaypointL:{i}" for i in range(1,len(csv_in)+1)]

# Set the waypoints to the values in the CSV file
for i in range(len(pv_names)):
    for j in range(len(FIELDS)):
        pv = f"{pv_names[i]}:{FIELDS[j]}"
        print(f"Setting {pv} = {csv_in[i][j]}")
        caput(pv, csv_in[i][j])

