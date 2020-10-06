#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory
$TryCounter = 0
function Reset-TryCounter() { $TryCounter = 0 }
Function Get-FolderPath($initialDirectory = "")
{
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	
	$foldername = New-Object System.Windows.Forms.FolderBrowserDialog
	$foldername.Description = "Select a folder"
	$foldername.rootfolder = "MyComputer"
	$foldername.SelectedPath = $initialDirectory
	
	if ($foldername.ShowDialog() -eq "OK")
	{
		$folder += $foldername.SelectedPath
	}
	return $folder
}
Function Get-FilePath($initialDirectory = "")
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

