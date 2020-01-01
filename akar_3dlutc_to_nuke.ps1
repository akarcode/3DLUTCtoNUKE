#Requires -Version 5.0

#
# Akar // 3D LUT Creator to NUKE v1.0.1
# ----------------------------------
# http://www.akar.id
# ----------------------------------
# by Nick Zimmermann
# ----------------------------------
#
# v1.0.1
# added topmost checkbox
# added master curve (luminance)
# changed GUI to only one status line
# changed disabled second and third matrix input
#
# v1.0 (initial release)
#
#
# TODO:
# nothing at this point
#
# to consider:
# - checkboxes of what curves to actually copy
#   This would bloat the script. just delete the curve points in nuke
#


Clear-Host

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Size = New-Object System.Drawing.Size(650,225)
    FormBorderStyle = 'FixedDialog'
    Text = 'Akar \\ 3D LUT Creator to NUKE v1.0.1'
    Toplevel = $true
    TopMost = $true
    MaximizeBox = $false
    MinimizeBox = $true
    StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
}

$GroupBoxSeparator00 = New-Object System.Windows.Forms.GroupBox -Property @{
    Location = New-Object System.Drawing.Point(15,47)
    Size = New-Object System.Drawing.Size(614,2)
    FlatStyle = 'Flat'
}
$Form.Controls.Add($GroupBoxSeparator00)

$GroupBoxSeparator01 = New-Object System.Windows.Forms.GroupBox -Property @{
    Location = New-Object System.Drawing.Point(15,143)
    Size = New-Object System.Drawing.Size(614,2)
    FlatStyle = 'Flat'
}
$Form.Controls.Add($GroupBoxSeparator01)

$CheckBoxTopMost = New-Object System.Windows.Forms.CheckBox -Property @{
    Location = New-Object System.Drawing.Point(510,159)
    Size = New-Object System.Drawing.Size(120,20)
    Text = 'Always on top'
    Checked = $true
    RightToLeft = 'Yes'
}
$Form.Controls.Add($CheckBoxTopMost)

$TextBoxLabelCurves = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(12,18)
    Size = New-Object System.Drawing.Size(50,22)
    Text = "Curves:"
}
$Form.Controls.Add($TextBoxLabelCurves)

$TextBoxLabelMatrix = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(12,64)
    Size = New-Object System.Drawing.Size(50,22)
    Text = "Matrix:"
}
$Form.Controls.Add($TextBoxLabelMatrix)

$TextBoxLabelStatus = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(12,160)
    Size = New-Object System.Drawing.Size(50,22)
    Text = 'Status:'
}
$Form.Controls.Add($TextBoxLabelStatus)

$TextBoxLabelInfo = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(68,160)
    Size = New-Object System.Drawing.Size(250,22)
    Text = ''
}
$Form.Controls.Add($TextBoxLabelInfo)


$TextBoxLightroom = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,15)
    Size = New-Object System.Drawing.Size(487,22)
    Text = ''
    TabIndex = 1
}
$Form.Controls.Add($TextBoxLightroom)

$TextBoxMatrixRed0 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,61)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 3
}
$Form.Controls.Add($TextBoxMatrixRed0)

$TextBoxMatrixRed1 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(128,61)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    Enabled = $False
    TabIndex = 4
}
$Form.Controls.Add($TextBoxMatrixRed1)

$TextBoxMatrixRed2 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(188,61)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    Enabled = $False
    TabIndex = 5
}
$Form.Controls.Add($TextBoxMatrixRed2)

$TextBoxMatrixGreen0 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,86)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 3
}
$Form.Controls.Add($TextBoxMatrixGreen0)

$TextBoxMatrixGreen1 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(128,86)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    Enabled = $False
    TabIndex = 4
}
$Form.Controls.Add($TextBoxMatrixGreen1)

$TextBoxMatrixGreen2 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(188,86)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    Enabled = $False
    TabIndex = 5
}
$Form.Controls.Add($TextBoxMatrixGreen2)

$TextBoxMatrixBlue0 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,111)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 3
}
$Form.Controls.Add($TextBoxMatrixBlue0)

$TextBoxMatrixBlue1 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(128,111)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    Enabled = $False
    TabIndex = 4
}
$Form.Controls.Add($TextBoxMatrixBlue1)

$TextBoxMatrixBlue2 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(188,111)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    Enabled = $False
    TabIndex = 5
}
$Form.Controls.Add($TextBoxMatrixBlue2)

$ButtonFile = New-Object System.Windows.Forms.Button -Property @{
    Location = New-Object System.Drawing.Point(570,14)
    Size = New-Object System.Drawing.Size(60,22)
    Text = "Select"
    TabIndex = 2
}
$Form.Controls.Add($ButtonFile)

# functions
Function Get-Lightroom($initialDirectory)
{
    Add-Type -AssemblyName System.Windows.Forms | Out-Null
    $select = New-Object System.Windows.Forms.OpenFileDialog
    $select.initialDirectory = $initialDirectory
    $select.filter = "Lightroom|*.lrtemplate"
    $select.ShowDialog() | Out-Null
    $select.filename
}

# even test function by /\/\o\/\/
Function Test-Even {

    Param(

        [Parameter(Mandatory=$true)]
        $Number

    )

    [bool]!($Number % 2)
    
}

Function Format-Curves {

    if ($TextBoxLightroom.Text -ne ''){
    
        if ($TextBoxLightroom.Text -match '^(\w:\\)([a-z0-9_\-\\ ]*)(.lrtemplate$)'){

            $InputPath = $TextBoxLightroom.Text
            $LightroomTemplate = (Get-Content $InputPath -Raw)


            # collect all rgb values
            #
            # Luminance has no clear name inside the lrtemplate!
            # The valuename PV2012 (Process Version 2012 Lightroom 4) is used directly for convenience.
            
            $Curve = @{PV2012 = @();Blue = @();Green = @();Red = @()}
            $RGB = @('PV2012','Blue','Green','Red')
            $RGBValues = 0

            for ($i = 0; $i -lt 4; $i++){

                $Regex = [Regex]::new('(?smi)' + $RGB[$i] + ' = {(.*?)}')

                $Match = $Regex.Match($LightroomTemplate).Groups[1]

                if ($Match.Success){

                    $Curve.($RGB[$i]) = $Match.Value.Replace("`t",'').Replace("`n",'').Split(',').Where({ $_ -ne '' }) | Select-Object -SkipLast 1
                    $RGBValues += $Curve.($RGB[$i]).Count

                }
            }


            # format all rgb values

            if ($RGBValues -ne 0){

                for ($i = 0; $i -lt 4; $i++){
                    for ($j = 0; $j -lt $Curve.($RGB[$i]).Count; $j++){
                    
                        if (Test-Even -Number $j){
                            $X = 'x'
                        } else {
                            $X = ''
                        }

                        $Curve.($RGB[$i])[$j] = $X + [math]::Round((([int]$Curve.($RGB[$i])[$j] - 0) / (255 - 0)),6)

                    }
                }

                $Cancel = $False

            } else {

                $TextBoxLabelInfoCurves.Text = 'Cannot find the RGB values in the Lightroom Template.'
                $Cancel = $True

            }


            # create nuke output

            if (!$Cancel){

                $NukeNode = "ColorLookup {`n" + `
                    "lut {master {}`n" + `
                    "master {curve " + ($Curve.PV2012 -Join ' ') + "}`n" + `
                    "red {curve " + ($Curve.Red -Join ' ') + "}`n" + `
                    "green {curve " + ($Curve.Green -Join ' ') + "}`n" + `
                    "blue {curve " + ($Curve.Blue -Join ' ') + "}`n" + `
                    "alpha {}}`n" + `
                    "name ColorLookup3DLUTCreator`n" + `
                    "xpos 0`n" + `
                    "ypos 0`n" + `
                    "}"

                Set-Clipboard -Value $NukeNode
            
                $TextBoxLabelInfo.Text = 'Nuke Curves successfully copied to Clipboard.'

            }

        } else {

            $TextBoxLabelInfo.Text = 'Input is not valid.'

        }
    }
}

Function Format-Matrix {

    Param(

        [Parameter(Mandatory=$true)]
        $Color,
        [Parameter(Mandatory=$true)]
        $TextInput

    )


    if ($TextInput -ne ''){
    
        if ($TextInput -match '^(R:)'){

            # collect all rgb values
            $MatrixColors = $TextInput.Split().Replace('%','').Replace('R:','').Replace('G:','').Replace('B:','').Where({ $_ -ne '' })


            # format all rgb values
            for ($i = 0; $i -lt 3; $i++){

                $MatrixColors[$i] = ($MatrixColors[$i] / 100)
            
            }


            # write values back into input fields
            for ($i = 0; $i -lt 3; $i++){

                $((Get-Variable -Name ('TextBoxMatrix' + $Color + $i)).value).Text = $MatrixColors[$i]
            
            }


            # collect values from grid
            $Matrix = @{Blue = @();Green = @();Red = @()}
            $RGB = @('Blue','Green','Red')

            for ($i = 0; $i -lt 3; $i++){
                for ($j = 0; $j -lt 3; $j++){

                    if (($((Get-Variable -Name ('TextBoxMatrix' + $RGB[$i] + $j)).value).Text) -eq ''){
                        
                        $Incomplete += $True
                    
                    } else {

                        $Matrix.($RGB[$i]) += ($((Get-Variable -Name ('TextBoxMatrix' + $RGB[$i] + $j)).value).Text)
                        $Incomplete += $False
                    
                    }
                }
            }


            # create nuke output
            if (!$Incomplete){

                $NukeNode = "ColorMatrix {`n" + `
                    "inputs 0`n" + `
                    "matrix {`n" + `
                    "{" + ($Matrix.Red -Join ' ') + "}`n" + `
                    "{" + ($Matrix.Green -Join ' ') + "}`n" + `
                    "{" + ($Matrix.Blue -Join ' ') + "}`n" + `
                    "}`n" + `
                    "name ColorMatrix3DLUTCreator`n" + `
                    "selected true`n" + `
                    "xpos 0`n" + `
                    "ypos 0`n" + `
                    "}"

                Set-Clipboard -Value $NukeNode
            
                $TextBoxLabelInfo.Text = 'Nuke Matrix successfully copied to Clipboard.'

            }
        } 
    }
}


$ButtonFile.Add_Click({

    $TextBoxLightroom.Text = Get-Lightroom "*\"

    Format-Curves

})


$TextBoxLightroom.Add_TextChanged({

    Format-Curves

})


$CheckBoxTopMost.Add_CheckStateChanged({

    $Form.TopMost = $CheckBoxTopMost.Checked

})


$TextBoxMatrixRed0.Add_TextChanged({

    Format-Matrix -Color Red -TextInput $TextBoxMatrixRed0.Text

})
$TextBoxMatrixGreen0.Add_TextChanged({

    Format-Matrix -Color Green -TextInput $TextBoxMatrixGreen0.Text

})
$TextBoxMatrixBlue0.Add_TextChanged({

    Format-Matrix -Color Blue -TextInput $TextBoxMatrixBlue0.Text

})


$Form.ShowDialog() | Out-Null
