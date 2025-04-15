# INFO
# C:\Users\<username>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
#
# winget install fzf
# winget winget install Neovim.Neovim
# winget winget install --id=Neovide.Neovide -e

function edit { neovide $PROFILE }
function b { Set-Location .. }
function c { clear }
function exp { explorer . }

#########################################################
# cd history browser
#########################################################
function Set-Location {
    param([string]$Path)

    # Run the real Set-Location
    Microsoft.PowerShell.Management\Set-Location $Path

    # Save to history
    $logfile = "$env:USERPROFILE\.path_history.log"
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) $PWD" | Add-Content $logfile
}

function cd {
    param([string]$Path)
    Set-Location $Path
}

function ph {
    $today = (Get-Date).Date

    $paths = Get-Content "$env:USERPROFILE\.path_history.log" |
        Where-Object { 
            # Parse timestamp from first 19 chars
            $timestamp = $_.Substring(0, 19) -as [datetime]
            $timestamp -ge $today
        } |
        ForEach-Object { $_.Substring(20) } |
        Sort-Object -Unique |
        fzf --height=40% --reverse --border --prompt "cd> "

    if ($paths) {
        Set-Location $paths
    }
}
#########################################################

Import-Module posh-git
