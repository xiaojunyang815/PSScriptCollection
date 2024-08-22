<#
.SYNOPSIS
This script switches the TPM used on the DUT.

.DESCRIPTION
This script switches the TPM used on the DUT.
Includes extra variable setting and FPT commands needed on LunarLake and later platforms.
The script is backwards compatible and won't run those extra commands on older platforms.

.PARAMETER GetCurrentTpmType
Get the current TPM type (dTPM, fTPM, or pTPM).

.PARAMETER SetTpmType
The new TPM to switch to. Valid values are [dTPM, fTPM, pTPM]. dTPM is for
discrete TPM, fTPM is for PTT, and pTPM is for PSE(Partner Security Engin)/Pluton TPM.

.EXAMPLE
Configure-Tpm.ps1 -GetCurrentTpmType

.EXAMPLE
Configure-Tpm.ps1 -SetTpmType dTPM

#>

# Copyright (C) Microsoft Corporation.  All Rights Reserved.
#Requires -RunAsAdministrator
#Requires -Version 7
param(
    [Parameter(Mandatory = $true, ParameterSetName = "Get")]
    [switch]
    $GetCurrentTpmType,

    [Parameter(Mandatory = $true, ParameterSetName = "Set")]
    [ValidateSet('dTPM', 'fTPM', 'pTPM')]
    [string]$SetTpmType

)


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