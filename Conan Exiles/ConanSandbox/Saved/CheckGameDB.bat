@echo off
for %%a in (*.db) do (
echo "%%a"
sqlite3.exe %%a "pragma integrity_check"
)
pause