/*************************** Sophos.com/RapidResponse ***************************\
| DESCRIPTION                                                                    |
| Retrieves the Boot Mode value from the System Event Log                        |
|                                                                                |
|                                                                                |
| Query Type: Endpoint                                                           |
| Version: 1.0                                                                   |
| Author: The Rapid Response Team | Lee Kirkpatrick                              |
| github.com/SophosRapidResponse                                                 |
\********************************************************************************/

SELECT
    strftime('%Y-%m-%dT%H:%M:%S', datetime) AS Datetime, 
    eventid AS EventID,
    JSON_EXTRACT(data, '$.EventData.BootMode') AS BootMode,
    CASE JSON_EXTRACT(data, '$.EventData.BootMode')
        WHEN '0' THEN 'Normal'
        WHEN '1' THEN 'Safe Mode'
        ELSE 'Unknown'
    END AS BootModeDescription
FROM
    sophos_windows_events 
WHERE
    source = 'System'
    AND eventid = 12
    AND time > 0
    AND BootMode IS NOT NULL;
