#----------------------------------------------
# Generated Form Function
#----------------------------------------------
function Show-MainForm_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$MainForm = New-Object 'System.Windows.Forms.Form'
	$groupbox3 = New-Object 'System.Windows.Forms.GroupBox'
	$radiobuttonSyncbestEffort = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonRightToLeft = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonLeftToRight = New-Object 'System.Windows.Forms.RadioButton'
	$tabcontrol1 = New-Object 'System.Windows.Forms.TabControl'
	$tabpage1 = New-Object 'System.Windows.Forms.TabPage'
	$groupbox2 = New-Object 'System.Windows.Forms.GroupBox'
	$buttonScan = New-Object 'System.Windows.Forms.Button'
	$tabpage2 = New-Object 'System.Windows.Forms.TabPage'
	$groupboxOptions = New-Object 'System.Windows.Forms.GroupBox'
	$checkboxKeepACLs = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxForce = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxRecursive = New-Object 'System.Windows.Forms.CheckBox'
	$buttonStartCopy = New-Object 'System.Windows.Forms.Button'
	$tabpage3 = New-Object 'System.Windows.Forms.TabPage'
	$groupbox1 = New-Object 'System.Windows.Forms.GroupBox'
	$tabpage4 = New-Object 'System.Windows.Forms.TabPage'
	$checkboxSaveScanResults = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxSaveCopyProgress = New-Object 'System.Windows.Forms.CheckBox'
	$labelOutputFolder = New-Object 'System.Windows.Forms.Label'
	$textboxOutputFolder = New-Object 'System.Windows.Forms.TextBox'
	$buttonOpenFolderOutput = New-Object 'System.Windows.Forms.Button'
	$labelRightFolder = New-Object 'System.Windows.Forms.Label'
	$textboxRightFolderPath = New-Object 'System.Windows.Forms.TextBox'
	$buttonOpenFolderRight = New-Object 'System.Windows.Forms.Button'
	$labelLeftFolder = New-Object 'System.Windows.Forms.Label'
	$textboxLeftFolderPath = New-Object 'System.Windows.Forms.TextBox'
	$statusbar1 = New-Object 'System.Windows.Forms.StatusBar'
	$buttonOpenFolderLeft = New-Object 'System.Windows.Forms.Button'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$MainForm.SuspendLayout()
	$groupboxOptions.SuspendLayout()
	$tabcontrol1.SuspendLayout()
	$tabpage1.SuspendLayout()
	$tabpage2.SuspendLayout()
	$tabpage3.SuspendLayout()
	$tabpage4.SuspendLayout()
	$groupbox3.SuspendLayout()
	#
	# MainForm
	#
	$MainForm.Controls.Add($groupbox3)
	$MainForm.Controls.Add($tabcontrol1)
	$MainForm.Controls.Add($labelOutputFolder)
	$MainForm.Controls.Add($textboxOutputFolder)
	$MainForm.Controls.Add($buttonOpenFolderOutput)
	$MainForm.Controls.Add($labelRightFolder)
	$MainForm.Controls.Add($textboxRightFolderPath)
	$MainForm.Controls.Add($buttonOpenFolderRight)
	$MainForm.Controls.Add($labelLeftFolder)
	$MainForm.Controls.Add($textboxLeftFolderPath)
	$MainForm.Controls.Add($statusbar1)
	$MainForm.Controls.Add($buttonOpenFolderLeft)
	$MainForm.AutoScaleDimensions = '6, 13'
	$MainForm.AutoScaleMode = 'Font'
	$MainForm.ClientSize = '578, 471'
	$MainForm.FormBorderStyle = 'SizableToolWindow'
	$MainForm.Margin = '4, 4, 4, 4'
	$MainForm.MaximumSize = '594, 2000'
	$MainForm.MinimumSize = '594, 510'
	$MainForm.Name = 'MainForm'
	$MainForm.StartPosition = 'CenterScreen'
	$MainForm.Text = 'AdvFileUtility'
	$MainForm.add_Load($MainForm_Load)
	#
	# groupbox3
	#
	$groupbox3.Controls.Add($radiobuttonSyncbestEffort)
	$groupbox3.Controls.Add($radiobuttonRightToLeft)
	$groupbox3.Controls.Add($radiobuttonLeftToRight)
	$groupbox3.Location = '12, 91'
	$groupbox3.Name = 'groupbox3'
	$groupbox3.Size = '418, 53'
	$groupbox3.TabIndex = 14
	$groupbox3.TabStop = $False
	$groupbox3.Text = 'Direction'
	$groupbox3.UseCompatibleTextRendering = $True
	#
	# radiobuttonSyncbestEffort
	#
	$radiobuttonSyncbestEffort.Location = '226, 19'
	$radiobuttonSyncbestEffort.Name = 'radiobuttonSyncbestEffort'
	$radiobuttonSyncbestEffort.Size = '116, 24'
	$radiobuttonSyncbestEffort.TabIndex = 2
	$radiobuttonSyncbestEffort.TabStop = $True
	$radiobuttonSyncbestEffort.Text = 'Sync (best effort)'
	$radiobuttonSyncbestEffort.UseCompatibleTextRendering = $True
	$radiobuttonSyncbestEffort.UseVisualStyleBackColor = $True
	#
	# radiobuttonRightToLeft
	#
	$radiobuttonRightToLeft.Location = '116, 19'
	$radiobuttonRightToLeft.Name = 'radiobuttonRightToLeft'
	$radiobuttonRightToLeft.Size = '104, 24'
	$radiobuttonRightToLeft.TabIndex = 1
	$radiobuttonRightToLeft.TabStop = $True
	$radiobuttonRightToLeft.Text = 'Right to Left'
	$radiobuttonRightToLeft.UseCompatibleTextRendering = $True
	$radiobuttonRightToLeft.UseVisualStyleBackColor = $True
	#
	# radiobuttonLeftToRight
	#
	$radiobuttonLeftToRight.Location = '6, 19'
	$radiobuttonLeftToRight.Name = 'radiobuttonLeftToRight'
	$radiobuttonLeftToRight.Size = '104, 24'
	$radiobuttonLeftToRight.TabIndex = 0
	$radiobuttonLeftToRight.TabStop = $True
	$radiobuttonLeftToRight.Text = 'Left to Right'
	$radiobuttonLeftToRight.UseCompatibleTextRendering = $True
	$radiobuttonLeftToRight.UseVisualStyleBackColor = $True
	#
	# tabcontrol1
	#
	$tabcontrol1.Controls.Add($tabpage1)
	$tabcontrol1.Controls.Add($tabpage2)
	$tabcontrol1.Controls.Add($tabpage3)
	$tabcontrol1.Controls.Add($tabpage4)
	$tabcontrol1.Location = '12, 150'
	$tabcontrol1.Name = 'tabcontrol1'
	$tabcontrol1.SelectedIndex = 0
	$tabcontrol1.Size = '555, 295'
	$tabcontrol1.TabIndex = 15
	#
	# tabpage1
	#
	$tabpage1.Controls.Add($groupbox2)
	$tabpage1.Controls.Add($buttonScan)
	$tabpage1.Location = '4, 22'
	$tabpage1.Name = 'tabpage1'
	$tabpage1.Padding = '3, 3, 3, 3'
	$tabpage1.Size = '547, 269'
	$tabpage1.TabIndex = 0
	$tabpage1.Text = '1. Scan'
	$tabpage1.UseVisualStyleBackColor = $True
	#
	# groupbox2
	#
	$groupbox2.Location = '6, 6'
	$groupbox2.Name = 'groupbox2'
	$groupbox2.Size = '368, 100'
	$groupbox2.TabIndex = 14
	$groupbox2.TabStop = $False
	$groupbox2.Text = 'Scan options'
	$groupbox2.UseCompatibleTextRendering = $True
	#
	# buttonScan
	#
	$buttonScan.Location = '6, 112'
	$buttonScan.Name = 'buttonScan'
	$buttonScan.Size = '368, 23'
	$buttonScan.TabIndex = 12
	$buttonScan.Text = 'Scan'
	$buttonScan.UseCompatibleTextRendering = $True
	$buttonScan.UseVisualStyleBackColor = $True
	#
	# tabpage2
	#
	$tabpage2.Controls.Add($groupboxOptions)
	$tabpage2.Controls.Add($buttonStartCopy)
	$tabpage2.Location = '4, 22'
	$tabpage2.Name = 'tabpage2'
	$tabpage2.Padding = '3, 3, 3, 3'
	$tabpage2.Size = '547, 269'
	$tabpage2.TabIndex = 1
	$tabpage2.Text = '2. Copy'
	$tabpage2.UseVisualStyleBackColor = $True
	#
	# groupboxOptions
	#
	$groupboxOptions.Controls.Add($checkboxKeepACLs)
	$groupboxOptions.Controls.Add($checkboxForce)
	$groupboxOptions.Controls.Add($checkboxRecursive)
	$groupboxOptions.Location = '6, 6'
	$groupboxOptions.Name = 'groupboxOptions'
	$groupboxOptions.Size = '368, 100'
	$groupboxOptions.TabIndex = 11
	$groupboxOptions.TabStop = $False
	$groupboxOptions.Text = 'Copy options'
	$groupboxOptions.UseCompatibleTextRendering = $True
	#
	# checkboxKeepACLs
	#
	$checkboxKeepACLs.Location = '116, 19'
	$checkboxKeepACLs.Name = 'checkboxKeepACLs'
	$checkboxKeepACLs.Size = '104, 24'
	$checkboxKeepACLs.TabIndex = 2
	$checkboxKeepACLs.Text = 'Keep ACLs'
	$checkboxKeepACLs.UseCompatibleTextRendering = $True
	$checkboxKeepACLs.UseVisualStyleBackColor = $True
	#
	# checkboxForce
	#
	$checkboxForce.Location = '6, 49'
	$checkboxForce.Name = 'checkboxForce'
	$checkboxForce.Size = '104, 24'
	$checkboxForce.TabIndex = 1
	$checkboxForce.Text = 'Force'
	$checkboxForce.UseCompatibleTextRendering = $True
	$checkboxForce.UseVisualStyleBackColor = $True
	#
	# checkboxRecursive
	#
	$checkboxRecursive.Location = '6, 19'
	$checkboxRecursive.Name = 'checkboxRecursive'
	$checkboxRecursive.Size = '104, 24'
	$checkboxRecursive.TabIndex = 0
	$checkboxRecursive.Text = 'Recursive'
	$checkboxRecursive.UseCompatibleTextRendering = $True
	$checkboxRecursive.UseVisualStyleBackColor = $True
	#
	# buttonStartCopy
	#
	$buttonStartCopy.Location = '6, 112'
	$buttonStartCopy.Name = 'buttonStartCopy'
	$buttonStartCopy.Size = '368, 23'
	$buttonStartCopy.TabIndex = 13
	$buttonStartCopy.Text = 'Start copy'
	$buttonStartCopy.UseCompatibleTextRendering = $True
	$buttonStartCopy.UseVisualStyleBackColor = $True
	#
	# tabpage3
	#
	$tabpage3.Controls.Add($groupbox1)
	$tabpage3.Location = '4, 22'
	$tabpage3.Name = 'tabpage3'
	$tabpage3.Padding = '3, 3, 3, 3'
	$tabpage3.Size = '547, 383'
	$tabpage3.TabIndex = 2
	$tabpage3.Text = '3. Resume/Sync'
	$tabpage3.UseVisualStyleBackColor = $True
	#
	# groupbox1
	#
	$groupbox1.Location = '6, 6'
	$groupbox1.Name = 'groupbox1'
	$groupbox1.Size = '294, 185'
	$groupbox1.TabIndex = 7
	$groupbox1.TabStop = $False
	$groupbox1.Text = 'Resume progress'
	$groupbox1.UseCompatibleTextRendering = $True
	#
	# tabpage4
	#
	$tabpage4.Controls.Add($checkboxSaveScanResults)
	$tabpage4.Controls.Add($checkboxSaveCopyProgress)
	$tabpage4.Location = '4, 22'
	$tabpage4.Name = 'tabpage4'
	$tabpage4.Padding = '3, 3, 3, 3'
	$tabpage4.Size = '547, 269'
	$tabpage4.TabIndex = 3
	$tabpage4.Text = 'Options'
	$tabpage4.UseVisualStyleBackColor = $True
	#
	# checkboxSaveScanResults
	#
	$checkboxSaveScanResults.Checked = $True
	$checkboxSaveScanResults.CheckState = 'Checked'
	$checkboxSaveScanResults.Location = '6, 36'
	$checkboxSaveScanResults.Name = 'checkboxSaveScanResults'
	$checkboxSaveScanResults.Size = '120, 24'
	$checkboxSaveScanResults.TabIndex = 1
	$checkboxSaveScanResults.Text = 'Save scan results'
	$checkboxSaveScanResults.UseCompatibleTextRendering = $True
	$checkboxSaveScanResults.UseVisualStyleBackColor = $True
	#
	# checkboxSaveCopyProgress
	#
	$checkboxSaveCopyProgress.Checked = $True
	$checkboxSaveCopyProgress.CheckState = 'Checked'
	$checkboxSaveCopyProgress.Location = '6, 6'
	$checkboxSaveCopyProgress.Name = 'checkboxSaveCopyProgress'
	$checkboxSaveCopyProgress.Size = '127, 24'
	$checkboxSaveCopyProgress.TabIndex = 0
	$checkboxSaveCopyProgress.Text = 'Save copy progress'
	$checkboxSaveCopyProgress.UseCompatibleTextRendering = $True
	$checkboxSaveCopyProgress.UseVisualStyleBackColor = $True
	#
	# labelOutputFolder
	#
	$labelOutputFolder.AutoSize = $True
	$labelOutputFolder.Location = '12, 67'
	$labelOutputFolder.Name = 'labelOutputFolder'
	$labelOutputFolder.Size = '70, 17'
	$labelOutputFolder.TabIndex = 10
	$labelOutputFolder.Text = 'Output folder'
	$labelOutputFolder.UseCompatibleTextRendering = $True
	#
	# textboxOutputFolder
	#
	$textboxOutputFolder.Location = '87, 64'
	$textboxOutputFolder.Name = 'textboxOutputFolder'
	$textboxOutputFolder.Size = '374, 20'
	$textboxOutputFolder.TabIndex = 9
	#
	# buttonOpenFolderOutput
	#
	$buttonOpenFolderOutput.Location = '468, 62'
	$buttonOpenFolderOutput.Name = 'buttonOpenFolderOutput'
	$buttonOpenFolderOutput.Size = '98, 23'
	$buttonOpenFolderOutput.TabIndex = 8
	$buttonOpenFolderOutput.Text = 'Open folder'
	$buttonOpenFolderOutput.UseCompatibleTextRendering = $True
	$buttonOpenFolderOutput.UseVisualStyleBackColor = $True
	$buttonOpenFolderOutput.add_Click($buttonOpenFolderOutput_Click)
	#
	# labelRightFolder
	#
	$labelRightFolder.AutoSize = $True
	$labelRightFolder.Location = '19, 41'
	$labelRightFolder.Name = 'labelRightFolder'
	$labelRightFolder.Size = '62, 17'
	$labelRightFolder.TabIndex = 6
	$labelRightFolder.Text = 'Right folder'
	$labelRightFolder.UseCompatibleTextRendering = $True
	#
	# textboxRightFolderPath
	#
	$textboxRightFolderPath.Location = '87, 38'
	$textboxRightFolderPath.Name = 'textboxRightFolderPath'
	$textboxRightFolderPath.Size = '374, 20'
	$textboxRightFolderPath.TabIndex = 5
	#
	# buttonOpenFolderRight
	#
	$buttonOpenFolderRight.Location = '468, 36'
	$buttonOpenFolderRight.Name = 'buttonOpenFolderRight'
	$buttonOpenFolderRight.Size = '98, 23'
	$buttonOpenFolderRight.TabIndex = 4
	$buttonOpenFolderRight.Text = 'Open folder'
	$buttonOpenFolderRight.UseCompatibleTextRendering = $True
	$buttonOpenFolderRight.UseVisualStyleBackColor = $True
	$buttonOpenFolderRight.add_Click($buttonOpenFolderRight_Click)
	#
	# labelLeftFolder
	#
	$labelLeftFolder.AutoSize = $True
	$labelLeftFolder.Location = '27, 15'
	$labelLeftFolder.Name = 'labelLeftFolder'
	$labelLeftFolder.Size = '54, 17'
	$labelLeftFolder.TabIndex = 3
	$labelLeftFolder.Text = 'Left folder'
	$labelLeftFolder.UseCompatibleTextRendering = $True
	#
	# textboxLeftFolderPath
	#
	$textboxLeftFolderPath.Location = '87, 12'
	$textboxLeftFolderPath.Name = 'textboxLeftFolderPath'
	$textboxLeftFolderPath.Size = '374, 20'
	$textboxLeftFolderPath.TabIndex = 2
	#
	# statusbar1
	#
	$statusbar1.Location = '0, 449'
	$statusbar1.Name = 'statusbar1'
	$statusbar1.Size = '578, 22'
	$statusbar1.TabIndex = 1
	$statusbar1.Text = 'Ready'
	#
	# buttonOpenFolderLeft
	#
	$buttonOpenFolderLeft.Location = '468, 10'
	$buttonOpenFolderLeft.Name = 'buttonOpenFolderLeft'
	$buttonOpenFolderLeft.Size = '98, 23'
	$buttonOpenFolderLeft.TabIndex = 0
	$buttonOpenFolderLeft.Text = 'Open folder'
	$buttonOpenFolderLeft.UseCompatibleTextRendering = $True
	$buttonOpenFolderLeft.UseVisualStyleBackColor = $True
	$buttonOpenFolderLeft.add_Click($buttonOpenFolderLeft_Click)
	$groupbox3.ResumeLayout()
	$tabpage4.ResumeLayout()
	$tabpage3.ResumeLayout()
	$tabpage2.ResumeLayout()
	$tabpage1.ResumeLayout()
	$tabcontrol1.ResumeLayout()
	$groupboxOptions.ResumeLayout()
	$MainForm.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $MainForm.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$MainForm.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$MainForm.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $MainForm.ShowDialog()

} #End Function

#Call the form
Show-MainForm_psf | Out-Null
