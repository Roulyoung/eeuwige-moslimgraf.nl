@echo off
setlocal enabledelayedexpansion

REM ==================================================
REM AUTO-DETECT matching .txt file (same base name)
REM ==================================================
set "BAT_NAME=%~n0"
set "PROMPTS_TXT=%BAT_NAME%.txt"
set "LOG_FILE=%BAT_NAME%_run.log"

echo =============================== > "%LOG_FILE%"
echo %DATE% %TIME% >> "%LOG_FILE%"
echo Running %~nx0 >> "%LOG_FILE%"
echo Prompt file: %PROMPTS_TXT% >> "%LOG_FILE%"
echo =============================== >> "%LOG_FILE%"

echo.
echo [INFO] Logging to: %LOG_FILE%
echo.

REM ==================================================
REM CURRENT + PARENT DIR
REM ==================================================
set "CURRENT_DIR=%CD%"
for %%I in ("%CD%\..") do set "PARENT_DIR=%%~fI"

echo [INFO] Current dir: %CURRENT_DIR%
echo [INFO] Parent dir : %PARENT_DIR%
echo Current dir: %CURRENT_DIR% >> "%LOG_FILE%"
echo Parent dir : %PARENT_DIR% >> "%LOG_FILE%"

REM ==================================================
REM FIND SCRAPED DIR in parent: scraped_site_* OR scraped_website_*
REM ==================================================
set "SCRAPED_DIR="

for /d %%D in ("%PARENT_DIR%\scraped_site_*") do (
  if defined SCRAPED_DIR (
    echo [ERROR] Multiple scraped_site_* directories found in parent.
    echo [ERROR] Multiple scraped_site_* found >> "%LOG_FILE%"
    goto :end
  )
  set "SCRAPED_DIR=%%~fD"
)

if not defined SCRAPED_DIR (
  for /d %%D in ("%PARENT_DIR%\scraped_website_*") do (
    if defined SCRAPED_DIR (
      echo [ERROR] Multiple scraped_website_* directories found in parent.
      echo [ERROR] Multiple scraped_website_* found >> "%LOG_FILE%"
      goto :end
    )
    set "SCRAPED_DIR=%%~fD"
  )
)

if not defined SCRAPED_DIR (
  echo [ERROR] No scraped_site_* or scraped_website_* directory found in parent.
  echo [ERROR] No scraped dir found >> "%LOG_FILE%"
  goto :end
)

echo [OK] Using scraped dir: %SCRAPED_DIR%
echo Using scraped dir: %SCRAPED_DIR% >> "%LOG_FILE%"

REM ==================================================
REM CONFIG
REM ==================================================
set "OUTPUT_DIR=%CURRENT_DIR%"
set "PROMPTS_DIR=_codex_prompts_split"
set "CODEX_FLAGS=--full-auto --skip-git-repo-check"

REM ==================================================
REM PRECHECKS
REM ==================================================
if not exist "%PROMPTS_TXT%" (
  echo [ERROR] Missing prompt file: %PROMPTS_TXT%
  echo [ERROR] Missing prompt file >> "%LOG_FILE%"
  goto :end
)

where codex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] "codex" command not found in PATH.
  echo [ERROR] codex not found >> "%LOG_FILE%"
  goto :end
)
echo [OK] codex found.
echo codex found >> "%LOG_FILE%"

REM ==================================================
REM SPLIT PROMPTS (NO Set-Content; hard fail on errors)
REM ==================================================
if exist "%PROMPTS_DIR%" rmdir /s /q "%PROMPTS_DIR%"
mkdir "%PROMPTS_DIR%"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$raw = Get-Content -Raw '%PROMPTS_TXT%';" ^
  "$blocks = $raw -split '### PROMPT:\s*';" ^
  "$blocks = $blocks | Where-Object { $_.Trim() -ne '' };" ^
  "if($blocks.Count -eq 0){ throw 'No prompts found. Use lines like: ### PROMPT: name' }" ^
  "$utf8 = New-Object System.Text.UTF8Encoding($false);" ^
  "$i = 1;" ^
  "foreach ($b in $blocks) {" ^
  "  $lines = $b -split \"`r?`n\";" ^
  "  $name = $lines[0].Trim();" ^
  "  $body = ($lines | Select-Object -Skip 1) -join \"`n\";" ^
  "  $body = $body.Replace('{{SCRAPED_DIR}}','%SCRAPED_DIR%').Replace('{{OUTPUT_DIR}}','%OUTPUT_DIR%');" ^
  "  $safe = ($name -replace '[^a-zA-Z0-9_\-]', '_');" ^
  "  $file = ('{0:d2}_{1}.txt' -f $i, $safe);" ^
  "  $outPath = Join-Path '%PROMPTS_DIR%' $file;" ^
  "  [System.IO.File]::WriteAllText($outPath, $body, $utf8);" ^
  "  $i++;" ^
  "}"

if errorlevel 1 (
  echo [ERROR] Failed splitting prompts (PowerShell error).
  echo [ERROR] Split failed >> "%LOG_FILE%"
  goto :end
)

echo [OK] Prompts prepared in %PROMPTS_DIR%
echo Prompts prepared >> "%LOG_FILE%"

REM ==================================================
REM RUN PROMPTS SEQUENTIALLY
REM ==================================================
for %%F in ("%PROMPTS_DIR%\*.txt") do (
  echo.
  echo ==================================================
  echo Running prompt: %%~nxF
  echo ==================================================
  echo Running: %%~nxF >> "%LOG_FILE%"

  type "%%F" | codex exec %CODEX_FLAGS% - >> "%LOG_FILE%" 2>&1
  if errorlevel 1 (
    echo [ERROR] Codex failed on %%~nxF
    echo [ERROR] Codex failed on %%~nxF >> "%LOG_FILE%"
    goto :end
  )
)

echo.
echo [SUCCESS] All prompts executed successfully.
echo [SUCCESS] All prompts executed >> "%LOG_FILE%"

:end
echo.
echo [DONE] Press any key to close...
pause >nul
exit /b
