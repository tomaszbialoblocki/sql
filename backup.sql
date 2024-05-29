USE msdb;
GO

SELECT
    bs.database_name AS [Database Name],
    bs.backup_start_date AS [Backup Start Date],
    bs.backup_finish_date AS [Backup Finish Date],
    bs.type AS [Backup Type],
    CASE 
        WHEN bs.type = 'D' THEN 'Full'
        WHEN bs.type = 'I' THEN 'Differential'
        WHEN bs.type = 'L' THEN 'Transaction Log'
        WHEN bs.type = 'F' THEN 'File or Filegroup'
        WHEN bs.type = 'G' THEN 'Differential File'
        WHEN bs.type = 'P' THEN 'Partial'
        WHEN bs.type = 'Q' THEN 'Differential Partial'
        ELSE 'Unknown'
    END AS [Backup Type Description],
    bs.backup_size AS [Backup Size (Bytes)],
    bs.compressed_backup_size AS [Compressed Backup Size (Bytes)],
    bs.recovery_model AS [Recovery Model],
    bmf.physical_device_name AS [Backup File Location],
    bs.server_name AS [Server Name],
    bs.machine_name AS [Machine Name],
    bs.user_name AS [User Name]
FROM
    backupset bs
JOIN 
    backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
ORDER BY
    bs.database_name, bs.backup_finish_date DESC;
