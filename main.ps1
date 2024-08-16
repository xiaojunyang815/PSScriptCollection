function WriteHelloWorld {
    #Write-Host "Hello PowerShell world!" -BackgroundColor Black -ForegroundColor Green -NoNewline
    Write-Host " ('-. .-.    ('-.                                               _ (`-.                 (`\ .-') /`   ('-.    _  .-')     .-')     ('-. .-.    ('-.                                 (`\ .-') /`              _  .-')               _ .-') _   ";
    Write-Host "( OO )  /  _(  OO)                                             ( (OO  )                 `.( OO ),' _(  OO)  ( \( -O )   ( OO ).  ( OO )  /  _(  OO)                                 `.( OO ),'             ( \( -O )             ( (  OO) )  ";
    Write-Host ",--. ,--. (,------.  ,--.       ,--.       .-'),-----.        _.`     \  .-'),-----. ,--./  .--.  (,------.  ,------.  (_)---\_) ,--. ,--. (,------.  ,--.       ,--.            ,--./  .--.   .-'),-----.  ,------.   ,--.       \     .'_  ";
    Write-Host "|  | |  |  |  .---'  |  |.-')   |  |.-')  ( OO'  .-.  '      (__...--'' ( OO'  .-.  '|      |  |   |  .---'  |   /`. ' /    _ |  |  | |  |  |  .---'  |  |.-')   |  |.-')        |      |  |  ( OO'  .-.  ' |   /`. '  |  |.-')   ,`'--..._) ";
    Write-Host "|   .|  |  |  |      |  | OO )  |  | OO ) /   |  | |  |       |  /  | | /   |  | |  ||  |   |  |,  |  |      |  /  | | \  :` `.  |   .|  |  |  |      |  | OO )  |  | OO )       |  |   |  |, /   |  | |  | |  /  | |  |  | OO )  |  |  \  ' ";
    Write-Host "|       | (|  '--.   |  |`-' |  |  |`-' | \_) |  |\|  |       |  |_.' | \_) |  |\|  ||  |.'.|  |_)(|  '--.   |  |_.' |  '..`''.) |       | (|  '--.   |  |`-' |  |  |`-' |       |  |.'.|  |_)\_) |  |\|  | |  |_.' |  |  |`-' |  |  |   ' | ";
    Write-Host "|  .-.  |  |  .--'  (|  '---.' (|  '---.'   \ |  | |  |       |  .___.'   \ |  | |  ||         |   |  .--'   |  .  '.' .-._)   \ |  .-.  |  |  .--'  (|  '---.' (|  '---.'       |         |    \ |  | |  | |  .  '.' (|  '---.'  |  |   / : ";
    Write-Host "|  | |  |  |  `---.  |      |   |      |     `'  '-'  '       |  |         `'  '-'  '|   ,'.   |   |  `---.  |  |\  \  \       / |  | |  |  |  `---.  |      |   |      |        |   ,'.   |     `'  '-'  ' |  |\  \   |      |   |  '--'  / ";
    Write-Host "`--' `--'  `------'  `------'   `------'       `-----'        `--'           `-----' '--'   '--'   `------'  `--' '--'  `-----'  `--' `--'  `------'  `------'   `------'        '--'   '--'       `-----'  `--' '--'  `------'   `-------'  ";
}

# String chart was generate here: https://www.patorjk.com/software/taag/#p=display&v=2&f=Banner3-D&t=Hello%20World
function WriteHelloWorld1 {
    Write-Host "..:::::..::........::........::........:::.......:::::::...::...::::.......:::..:::::..::........::........:::" -ForegroundColor Green
    Write-Host "##::::'##:'########:'##:::::::'##::::::::'#######:::::'##:::::'##::'#######::'########::'##:::::::'########::" -ForegroundColor Green
    Write-Host "##:::: ##: ##.....:: ##::::::: ##:::::::'##.... ##:::: ##:'##: ##:'##.... ##: ##.... ##: ##::::::: ##.... ##:" -ForegroundColor Green
    Write-Host "##:::: ##: ##::::::: ##::::::: ##::::::: ##:::: ##:::: ##: ##: ##: ##:::: ##: ##:::: ##: ##::::::: ##:::: ##:" -ForegroundColor Green
    Write-Host "#########: ######::: ##::::::: ##::::::: ##:::: ##:::: ##: ##: ##: ##:::: ##: ########:: ##::::::: ##:::: ##:" -ForegroundColor Green
    Write-Host "##.... ##: ##...:::: ##::::::: ##::::::: ##:::: ##:::: ##: ##: ##: ##:::: ##: ##.. ##::: ##::::::: ##:::: ##:" -ForegroundColor Green
    Write-Host "##:::: ##: ##::::::: ##::::::: ##::::::: ##:::: ##:::: ##: ##: ##: ##:::: ##: ##::. ##:: ##::::::: ##:::: ##:" -ForegroundColor Green
    Write-Host "##:::: ##: ########: ########: ########:. #######:::::. ###. ###::. #######:: ##:::. ##: ########: ########::" -ForegroundColor Green
    Write-Host "..:::::..::........::........::........:::.......:::::::...::...::::.......:::..:::::..::........::........:::" -ForegroundColor Green
}

# Another function
function PauseThenExit {
    param([int]$ExitCode = 0)

    $AbortEvent = $false
    $toggle = $true
    do {
        if ($toggle) {
            Write-Host -ForegroundColor Red " Hit any key to continue `r" -NoNewline
            $toggle = $false
        }
        else {
            Write-Host -BackgroundColor Red " Hit any key to continue `r" -NoNewline
            $toggle = $true
        }
        Start-Sleep -Seconds 1
        if ([Console]::KeyAvailable) {
            $AbortEvent = $true
        }
    } while (!$AbortEvent)

    Exit $ExitCode
}




WriteHelloWorld1

PauseThenExit -ExitCode 9999