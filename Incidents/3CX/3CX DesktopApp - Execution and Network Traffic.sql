/*************************** Sophos.com/RapidResponse ***************************\
| DESCRIPTION                                                                    |
| Identify all network traffic generated by the 3CX DesktopApp on Windows        |
| (3CXDesktopApp.exe).                                                           |
|                                                                                |
| VARIABLES                                                                      |
| - start_time (type DATE)                                                       |
| - end_time (type DATE)                                                         |
|                                                                                |
| REFERENCE                                                                      |
| https://news.sophos.com/en-us/2023/03/29/3cx-dll-sideloading-attack/           |
| https://www.3cx.com/blog/news/desktopapp-security-alert/                       |
| Version: 1.0                                                                   |
| Author: The Rapid Response Team                                                |
| github.com/SophosRapidResponse                                                 |
\********************************************************************************/



WITH process_pid AS( 
SELECT
strftime('%Y-%m-%dT%H:%M:%SZ',datetime(time,'unixepoch')) AS date_time,
sophos_pid,
path,
process_name 
FROM sophos_process_journal 
WHERE time > $$start_time$$ 
    AND time < $$end_time$$ 
    AND process_name = '3CXDesktopApp.exe'
)

SELECT DISTINCT
ep.date_time,
ep.sophos_pid,
ep.path,
ep.process_name,
snj.destination,
snj.destination_port,
sophos_process_activity.object,
snj.data_sent,
snj.data_recv,
'3CX DesktopApp - Network Traffic' AS query
FROM process_pid ep 
LEFT JOIN sophos_network_journal snj USING (sophos_pid)
LEFT JOIN sophos_process_activity ON (ep.sophos_pid = sophos_process_activity.sophos_pid AND sophos_process_activity.subject IN ('Dns','Url','Http','ModernWebFlow'))
