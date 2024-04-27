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
