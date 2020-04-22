# main.robot
# Author Petri Laakkonen
# petri@laakkonen.io

*** Settings ***
Documentation   Travel Distance Checker v. 0.1.1
...
...             Check distances from Google maps with Robot Framework and Selenium
...

Library     SeleniumLibrary
Library     ExcelLibrary
Library     Collections
Library     ../libraries/CustomCode.py

Resource    ../resources/keywords.robot

Suite Setup     Initialize System
Suite Teardown  Close Browser

*** Tasks ***
Get distances from Excel file
    Get Distances From Excel
Get Google Maps distances and write to Excel file
    Get Google Maps Distances And Write To Excel File
Save and close
    Save and Close Excel


