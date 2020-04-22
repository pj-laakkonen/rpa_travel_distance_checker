# keywords.robot
# Author Petri Laakkonen
# petri@laakkonen.io

*** Variables ***
${BASE URL}             https://www.google.fi/maps/dir/
${BROWSER}              Chrome

${WORK_FOLDER_PATH}     /Users/petri/Dropbox/TravelDistances/
${EXCEL_PATH}           Travel_Distances.xlsx
${OUTPUT_PATH}          Travel_Distances_Output.xlsx
${START_ROW}            7
${ROWS}                 Actual value is set in "Initialize System" keyword

*** Keywords ***
Initialize System
    Open Excel Document     filename=${WORK_FOLDER_PATH}${EXCEL_PATH}  doc_id=doc1
    ${ROWS}=                Read Excel Cell  row_num=2  col_num=2
    #${ROWS}=                Set Variable  2
    Set Suite Variable      ${ROWS}
    log to console          \nNumber of Distances: ${ROWS}\n

Get Distances From Excel
    @{TRAVEL_LIST_START}=   Create List
    @{TRAVEL_LIST_END}=     Create List
    Set Suite Variable      ${TRAVEL_LIST_START}
    Set Suite Variable      ${TRAVEL_LIST_END}

    : For   ${i}    IN RANGE    ${ROWS}
    \    ${row_id}=             Evaluate    ${i} + ${START_ROW}
    \    ${start_street}=       Read Excel Cell  row_num=${row_id}   col_num=1
    \    ${start_number}=       Read Excel Cell  row_num=${row_id}   col_num=2
    \    ${start_city}=         Read Excel Cell  row_num=${row_id}     col_num=3
    \    ${start_postalcode}=   Read Excel Cell  row_num=${row_id}  col_num=4
    \    Append To List         ${TRAVEL_LIST_START}    ${start_street}, ${start_number}, ${start_postalcode} ${start_city}
    \    ${row_id}=             Evaluate    ${i} + ${START_ROW}
    \    ${end_street}=         Read Excel Cell  row_num=${row_id}     col_num=5
    \    ${end_number}=         Read Excel Cell  row_num=${row_id}     col_num=6
    \    ${end_city}=           Read Excel Cell  row_num=${row_id}       col_num=7
    \    ${end_postalcode}=     Read Excel Cell  row_num=${row_id}    col_num=8
    \    Append To List         ${TravelListEnd}    ${end_street}, ${end_number}, ${end_postalcode} ${end_city}

Get Google Maps Distances And Write To Excel File
    Open Browser    ${BASE URL}    ${BROWSER}
    Wait Until Element Is Enabled   sb_ifc50
    Click Element                   //*[contains(@data-travel_mode, "0")]
    log to console  \n
    : For   ${i}    IN RANGE    ${ROWS}
    \    ${current_id}=         Evaluate    ${i} + 1
    \    log to console         Distance: ${current_id}/${ROWS}
    \    Press Keys	sb_ifc50	@{TRAVEL_LIST_START}[${i}]
    \    Press Keys	sb_ifc51	@{TRAVEL_LIST_END}[${i}]
    \    Press Keys	sb_ifc51    RETURN

    \    Wait Until Element is Visible      section-directions-trip-0
    \    Click Element                      section-directions-trip-0

    \    Wait Until Element is Visible      class=section-trip-summary-subtitle
    \    ${trip}    GET Text                class=section-trip-summary-subtitle
    \    log to console                     ${trip}
    \    Click Element                      class=section-trip-header-back
    \    Write Excel Cell  1  1   Checked Travel Distances  Data
    \    ${row_id}=     Evaluate    ${i} + ${START_ROW}
    \    ${dist}=       string2float  ${trip}
    \    Write Excel Cell  ${row_id}  10   ${dist}  Data

Save and Close Excel
    Save Excel Document         filename=${WORK_FOLDER_PATH}${OUTPUT_PATH}
    Close Current Excel Document
