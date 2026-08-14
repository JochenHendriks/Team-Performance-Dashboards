@echo off
title Jira Data Fetcher voor DORA Dashboard
echo Jira Data Ophalen voor DORA Dashboard...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update-data.ps1"
echo.
pause
