
## Use sql (.bak) database from external drive - SQL Server:



To restore a database from a `.bak` file located on an external drive and use it from that drive without moving the files to the default directory on your C drive, you can use the following steps:

1. **Attach the External Drive**: Ensure your external drive is connected and accessible from your computer.

2. **Restore the Database**: Use SQL Server Management Studio (SSMS) or Transact-SQL (T-SQL) to restore the database from the `.bak` file on the external drive. You can use a T-SQL script like the following:

   ```sql
   USE master;
   GO
   RESTORE DATABASE YourDatabaseName
   FROM DISK = 'E:\Path\To\Your\BackupFile.bak'
   WITH REPLACE, 
   MOVE 'LogicalDataFileName' TO 'E:\Path\To\DataFile.mdf',
   MOVE 'LogicalLogFileName' TO 'E:\Path\To\LogFile.ldf';
   GO
   ```

   Replace `YourDatabaseName` with the desired name for the database, `'E:\Path\To\Your\BackupFile.bak'` with the path to your `.bak` file on the external drive, `'LogicalDataFileName'` with the logical name of the data file in the backup (you can find this using 
   ```
    RESTORE FILELISTONLY FROM DISK = 'E:\Path\To\Your\BackupFile.bak';
    ```
    `RESTORE FILELISTONLY FROM DISK = 'E:\Path\To\Your\BackupFile.bak';`), `'E:\Path\To\DataFile.mdf'` with the path on the external drive where you want to store the data file (`.mdf`), and `'E:\Path\To\LogFile.ldf'` with the path on the external drive where you want to store the log file (`.ldf`).

3. **Verify the Restore**: After running the restore command, verify that the database has been successfully restored and is accessible from the external drive.

4. **Use the Database**: You can now use the database from the external drive without needing to move the files to your C drive.

Remember to ensure that the SQL Server service account has the necessary permissions to access the `.bak` file and write to the specified locations on the external drive.


## Recover bulk of (.bak) dabases in SQL Server:

 - **SqlServer:** Your sql server name.
 - **RestoreDir:** Folder containing the sql backups.
 - **Run as Administrator:** Save the file as `.bat` and run it as `admin` .

```bat
    @echo off
    SETLOCAL ENABLEDELAYEDEXPANSION

    REM Set the variables
    SET SqlServer=DESKTOP-8BL3MIG
    SET RestoreDir="C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup"

    REM Loop through each .bak file in the directory
    FOR %%F IN (%RestoreDir%\*.bak) DO (
        REM Extract the database name from the .bak filename
        SET "DbName=%%~nF"
        
        REM Run the restore command
        SqlCmd -S !SqlServer! -E -Q "RESTORE DATABASE [!DbName!] FROM DISK='%%F' WITH REPLACE, STATS=10"
        
        REM Check for errors
        IF !ERRORLEVEL! NEQ 0 (
            echo Error restoring !DbName!
        ) ELSE (
            echo Database !DbName! restored successfully.
        )
    )
    REM Prompt user to press any key to exit
    pause
    ENDLOCAL

```