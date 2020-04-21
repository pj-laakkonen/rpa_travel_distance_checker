# tasks.robot
# Author Petri Laakkonen
# petri@laakkonen.io

*** Keywords ***
Check Travel Distances
#Initialize System
    ${file_path}=    Set Variable    ${WORK_FOLDER_PATH}${EXCEL_PATH}
    ${output_path}=    Set Variable    ${WORK_FOLDER_PATH}${OUTPUT_PATH}
    Open Excel Document  filename=${file_path}  doc_id=doc1

#Get Excel User Data
    ${rows}=    Read Excel Cell  row_num=2  col_num=2
    #${rows}=    Set Variable  2
    log to console  \n
    log to console  Number of Distances: ${rows}

    @{TravelListStart}=    Create List
    : For    ${i}     IN RANGE  ${rows}
    \    ${row_id}=     Evaluate    ${i} + ${START_ROW}
    \    ${start_street}=  Read Excel Cell  row_num=${row_id}   col_num=1
    \    ${start_number}=  Read Excel Cell  row_num=${row_id}   col_num=2
    \    ${start_city}=  Read Excel Cell  row_num=${row_id}     col_num=3
    \    ${start_postalcode}=  Read Excel Cell  row_num=${row_id}  col_num=4
    \    ${travel} =    Set Variable    ${start_street}, ${start_number}, ${start_postalcode} ${start_city}
    \    Append To List    ${TravelListStart}    ${travel}

    @{TravelListEnd}=    Create List
    : For    ${i}     IN RANGE  ${rows}
    \    ${row_id}=     Evaluate    ${i} + ${START_ROW}
    \    ${end_street}=  Read Excel Cell  row_num=${row_id}     col_num=5
    \    ${end_number}=  Read Excel Cell  row_num=${row_id}     col_num=6
    \    ${end_city}=  Read Excel Cell  row_num=${row_id}       col_num=7
    \    ${end_postalcode}=  Read Excel Cell  row_num=${row_id}    col_num=8
    \    ${travel} =    Set Variable    ${end_street}, ${end_number}, ${end_postalcode} ${end_city}
    \    Append To List    ${TravelListEnd}    ${travel}

#Get Google Maps Distances and Write to Excel File
    Open Browser    ${BASE URL}    ${BROWSER}
    Wait Until Element Is Enabled   sb_ifc50
    Click Element    //*[contains(@data-travel_mode, "0")]

    log to console  Get Google Maps Distances and Write to Excel File

    : For    ${i}     IN RANGE  ${rows}
    \    ${current_id}=     Evaluate    ${i} + 1
    \    log to console    Distance: ${current_id}/${rows}
    \    Press Keys	sb_ifc50	@{TravelListStart}[${i}]
    \    Press Keys	sb_ifc51	${TravelListEnd}[${i}]
    \    Press Keys	sb_ifc51  RETURN

    \    Wait Until Element Is Enabled   section-directions-trip-0
    \    Click Element   section-directions-trip-0

    \    Wait Until Element Is Enabled   class=section-trip-summary-subtitle
    \    ${trip}    GET Text    class=section-trip-summary-subtitle
    \    log to console    ${trip}
    \    Click Element   class=section-trip-header-back
    \    Write Excel Cell  1  1   Checked Travel Distances  Data
    \    ${row_id}=     Evaluate    ${i} + ${START_ROW}
    \    ${dist}=   string2float  ${trip}
    \    Write Excel Cell  ${row_id}  10   ${dist}  Data

#Save and Close
    Save Excel Document  filename=${output_path}
    Close Current Excel Document
