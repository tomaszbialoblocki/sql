-- Informacje o wersji i edycji SQL Server:
SELECT 
    SERVERPROPERTY('ProductVersion') AS [Product Version],
    SERVERPROPERTY('ProductLevel') AS [Product Level],
    SERVERPROPERTY('Edition') AS [Edition],
    SERVERPROPERTY('EngineEdition') AS [Engine Edition],
    SERVERPROPERTY('LicenseType') AS [License Type],
    SERVERPROPERTY('NumLicenses') AS [Number of Licenses];

-- Opis Engine Edition:
SELECT
    CASE SERVERPROPERTY('EngineEdition')
        WHEN 1 THEN 'Personal or Desktop Engine (Not available in SQL Server 2005 and later versions)'
        WHEN 2 THEN 'Standard'
        WHEN 3 THEN 'Enterprise'
        WHEN 4 THEN 'Express'
        WHEN 5 THEN 'SQL Database'
        WHEN 6 THEN 'SQL Data Warehouse'
        ELSE 'Unknown'
    END AS [Engine Edition Description];

-- Informacje o liczbie procesorów i rdzeni:
SELECT 
    cpu_count AS [Logical CPUs],
    hyperthread_ratio AS [Hyperthread Ratio],
    physical_memory_kb / 1024 AS [Physical Memory (MB)],
    sqlserver_start_time AS [SQL Server Start Time],
    sqlserver_start_time AS [SQL Server Start Time],
    scheduler_count AS [Schedulers],
    cpu_count / hyperthread_ratio AS [Physical CPU Count],
    cpu_count - (cpu_count / hyperthread_ratio) AS [Hyperthreaded CPUs]
FROM 
    sys.dm_os_sys_info;

-- Informacje o aktywnych instancjach SQL Server:
SELECT 
    @@SERVICENAME AS [Service Name],
    SERVERPROPERTY('MachineName') AS [Machine Name],
    SERVERPROPERTY('IsClustered') AS [Is Clustered],
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS [NetBIOS Name];

-- Informacje o aktywacji i kluczu licencyjnym:
EXEC xp_msver 'ProductVersion';
EXEC xp_msver 'ProductLevel';
EXEC xp_msver 'Edition';
EXEC xp_msver 'Platform';
EXEC xp_msver 'ServicePackLevel';