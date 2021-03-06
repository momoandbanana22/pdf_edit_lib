function set-shortcut {
    param ( [string]$SourceLnk, [string]$DestinationPath, [string]$exeArgs, [string]$WorkingPath )

    try {
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($SourceLnk)
        $Shortcut.TargetPath = """$DestinationPath"""
        $Shortcut.Arguments = $exeArgs
        $Shortcut.WorkingDirectory = $WorkingPath
        $Shortcut.Save()
        return $true
    }catch{
        return $false
    }
}

$folderPath = (Split-Path $PSScriptRoot -Parent)
$scripts = @("pdf_join.ps1","pdf_split.ps1","pdf_unlock.ps1")

$shortcutLinks = @()
$exeArgs = @()
foreach($scriptPath in $scripts){
    $shortcutLinks += $folderPath + "\" + $scriptPath + ".lnk"
    $exeArgs += "-NoProfile -ExecutionPolicy Unrestricted -File $($folderPath)\bin\$($scriptPath)"
}

$exePath = "$($PSHOME)\powershell.exe"

$WorkingPath = $folderPath + "\bin\"

$createCheck = $true
for($i=0; $i -lt $shortcutLinks.Length; $i++){
    if(!(set-shortcut $shortcutLinks[$i] $exePath $exeArgs[0] $WorkingPath)) {
        $createCheck = $false
        break
    }
}


$wsobj = new-object -comobject wscript.shell
if($createCheck) {
    $wsobj.popup("Create Shortcut Icon is complete.") | Out-Null
}else{
    $wsobj.popup("Error occured. Can't Create Shortcut Icon.") | Out-Null
}
