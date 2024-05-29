-- Informacje o użytkownikach serwera i ich uprawnieniach
SELECT
    sp.name AS [Login Name],
    sp.type_desc AS [Login Type],
    sp.is_disabled AS [Is Disabled],
    sp.create_date AS [Creation Date],
    sp.modify_date AS [Last Modified Date],
    sp.default_database_name AS [Default Database],
    sp.default_language_name AS [Default Language],
    perms.permission_name AS [Server Permission],
    perms.state_desc AS [Permission State]
FROM
    sys.server_principals sp
LEFT JOIN
    sys.server_permissions perms ON sp.principal_id = perms.grantee_principal_id
WHERE
    sp.type IN ('S', 'U', 'G') -- S = SQL user, U = Windows user, G = Windows group
ORDER BY
    sp.name;

-- Informacje o użytkownikach bazy danych i ich uprawnieniach w każdej bazie danych
DECLARE @database_name nvarchar(128);
DECLARE @sql nvarchar(max);

-- Cursor do iteracji przez wszystkie bazy danych
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE'
AND name NOT IN ('master', 'tempdb', 'model', 'msdb');

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @database_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
    USE ' + QUOTENAME(@database_name) + ';
    SELECT
        ''' + @database_name + ''' AS [Database Name],
        dp.name AS [User Name],
        dp.type_desc AS [User Type],
        dp.create_date AS [Creation Date],
        dp.modify_date AS [Last Modified Date],
        perms.permission_name AS [Database Permission],
        perms.state_desc AS [Permission State],
        dp.default_schema_name AS [Default Schema]
    FROM
        sys.database_principals dp
    LEFT JOIN
        sys.database_permissions perms ON dp.principal_id = perms.grantee_principal_id
    WHERE
        dp.type IN (''S'', ''U'', ''G'', ''A'') -- S = SQL user, U = Windows user, G = Windows group, A = Application role
    ORDER BY
        dp.name;
    ';
    EXEC sp_executesql @sql;

    FETCH NEXT FROM db_cursor INTO @database_name;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;
