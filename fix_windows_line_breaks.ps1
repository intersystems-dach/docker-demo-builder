$file="./setup.sh"
((Get-Content $file) -join "`n") + "`n" | Set-Content -NoNewline $file

$file="./resources/install_projects.sh"
((Get-Content $file) -join "`n") + "`n" | Set-Content -NoNewline $file