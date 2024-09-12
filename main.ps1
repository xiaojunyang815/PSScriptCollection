[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$CandidateName,

    [Parameter(Mandatory, ParameterSetName='Wicresoft')]
    [switch]$Wicresoft,

    [Parameter(Mandatory, ParameterSetName='Chinasoft')]
    [switch]$Chinasoft,

    [Parameter(Mandatory, ParameterSetName='Isoftstone')]
    [switch]$Isoftstone,

    [Parameter(Mandatory, ParameterSetName='Pegatron')]
    [switch]$Pegatron
)

function Invoke-Executable {
    # Runs the specified executable and captures its exit code, stdout
    # and stderr.
    # see: https://stackoverflow.com/questions/24370814/how-to-capture-process-output-asynchronously-in-powershell
    # Returns: custom object.
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$sExeFile,
        [Parameter(Mandatory = $false)]
        [String[]]$cArgs,
        [Switch]$AllowError
    )

    Write-Host($sExeFile, $cArgs)

    # Setting process invocation parameters.
    $oPsi = New-Object -TypeName System.Diagnostics.ProcessStartInfo
    $oPsi.CreateNoWindow = $true
    $oPsi.UseShellExecute = $false
    $oPsi.RedirectStandardOutput = $true
    $oPsi.RedirectStandardError = $true
    $oPsi.FileName = $sExeFile
    if (! [String]::IsNullOrEmpty($cArgs)) {
        $oPsi.Arguments = $cArgs
    }

    # Creating process object.
    $oProcess = New-Object -TypeName System.Diagnostics.Process
    $oProcess.StartInfo = $oPsi

    # Creating string builders to store stdout and stderr.
    $oStdOutBuilder = New-Object -TypeName System.Text.StringBuilder
    $oStdErrBuilder = New-Object -TypeName System.Text.StringBuilder

    # Adding event handers for stdout and stderr.
    $sScripBlock = {
        if (! [String]::IsNullOrEmpty($EventArgs.Data)) {
            $Event.MessageData.AppendLine($EventArgs.Data)
        }
    }
    $oStdOutEvent = Register-ObjectEvent -InputObject $oProcess `
        -Action $sScripBlock -EventName 'OutputDataReceived' `
        -MessageData $oStdOutBuilder
    $oStdErrEvent = Register-ObjectEvent -InputObject $oProcess `
        -Action $sScripBlock -EventName 'ErrorDataReceived' `
        -MessageData $oStdErrBuilder

    # Starting process.
    [Void]$oProcess.Start()
    $oProcess.BeginOutputReadLine()
    $oProcess.BeginErrorReadLine()
    [Void]$oProcess.WaitForExit(2000)

    # Unregistering events to retrieve process output.
    Unregister-Event -SourceIdentifier $oStdOutEvent.Name
    Unregister-Event -SourceIdentifier $oStdErrEvent.Name

    $oResult = New-Object -TypeName PSObject -Property ([Ordered]@{
            "ExeFile"  = $sExeFile;
            "Args"     = $cArgs -join " ";
            "ExitCode" = $oProcess.ExitCode;
            "StdOut"   = $oStdOutBuilder.ToString().Trim();
            "StdErr"   = $oStdErrBuilder.ToString().Trim()
        })

    if ($oResult.ExitCode -ne 0 -and -not $AllowError) {

        Write-Host($oResult.StdOut, $oResult.StdErr)
        Throw "Command failed: $oResult"
    }

    #For debug - uncomment this line to dump command results to console.
    #Write-Host $oResult
    return $oResult
}

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

# $targetDriverName : surfacehotplug.inf
function uninstallSpecificDriver {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$targetDriverName
    )
    $driverList = dism /online /get-drivers

    # transfer specific driver name to "oemxxx.inf"
    $pubName = $driverList | Select-String -Context 1 'Original File Name : $targetDriverName' |
                ForEach-Object { ($_.Context.PreContext[0] -split ' : +')[1] }

    if ($null -ne $pubName) {
        Write-Host "successed to get inf name" -BackgroundColor Green
        }
    else {
        Write-Host "Failed to get inf name!" -BackgroundColor Red
        exit 0
    }

    pnputil.exe /delete-driver $pubName /uninstall

    Write-Host "Success uninstalled driver" -BackgroundColor Green
}

WriteHelloWorld1

PauseThenExit -ExitCode 9999