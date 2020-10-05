### Global variables
$LeftPath = ""
$RightPath = ""
$LeftDB = ""
$RightDB = ""
$Recursive = $True
$TryCounter = 0

### Global functions
Function Get-FolderPath($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}
Function Get-FilePath($initialDirectory="")
{
    $openFileDialog = New-Object windows.forms.openfiledialog   
    $openFileDialog.initialDirectory = $initialDirectory
    $openFileDialog.title = "Select path"   
    $openFileDialog.filter = "All files (*.*)| *.*"
    $openFileDialog.ShowHelp = $True
    $result = $openFileDialog.ShowDialog()
    $result 
    return $OpenFileDialog.filename
}
function Reset-TryCounter(){$TryCounter = 0}


### Runtime
while ([string]::IsNullOrEmpty($LeftPath))
{
    $LeftPath = Get-FolderPath
    $TryCounter++
    if ($TryCounter -gt 3){exit}
}
Reset-TryCounter
while ([string]::IsNullOrEmpty($RightPath))
{
    $RightPath = Get-FolderPath
    $TryCounter++
    if ($TryCounter -gt 3){exit}
}
Reset-TryCounter

# LeftEval
$LeftEval = @{
    'Path' = $LeftPath
    'Force' = $True
}
 
If ($Recursive) {
    $LeftEval['Recurse'] = $True
}

Get-ChildItem @LeftEval | select @{Name="LeftPath";Expression={$LeftPath}}, Name, Length, Directory, FullName, PSIsContainer | Export-Clixml -Path db1.xml

# RightEval
$RightEval = @{
    'Path' = $RightPath
    'Force' = $True
}
 
If ($Recursive) {
    $RightEval['Recurse'] = $True
}

Get-ChildItem @RightEval | select @{Name="RightPath";Expression={$RightPath}}, Name, Length, Directory, FullName, PSIsContainer | Export-Clixml -Path db1.xml