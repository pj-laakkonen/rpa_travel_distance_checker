# travel.robot
# Author Petri Laakkonen
# petri@laakkonen.io

*** Settings ***
Documentation   Travel Distance Checker v. 0.1
...
...             Check distances from Google maps with Robot Framework and Selenium
...

Library     Selenium2Library
Library     ExcelLibrary
Library     Collections
Library     CustomCode.py

Resource    tasks.robot
Resource    resource.txt

#Suite Setup
#Suite Teardown

*** Tasks ***
Run automated tasks
    Check Travel Distances
    [Teardown]    Close Browser


