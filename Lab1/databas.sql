RESTORE DATABASE everyloop
 FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\everyloop.bak'
 WITH
    MOVE 'everyloop' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\everyloop.mdf',
    MOVE 'everyloop_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\everyloop.ldf',
 REPLACE;
 GO