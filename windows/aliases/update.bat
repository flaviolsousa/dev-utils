# @echo off

echo.
winget upgrade --all --accept-package-agreements --accept-source-agreements --include-unknown

wsl --update

wuauclt /detectnow
