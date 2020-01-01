#Requires -Version 5.0

#
# Akar // 3D LUT Creator to NUKE v1.0.0
# ----------------------------------
# http://www.akar.id
# ----------------------------------
# by Nick Zimmermann
# ----------------------------------
#
#
# v1.0.0 (initial release)
#

cls

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Size = New-Object System.Drawing.Size(650,250)
    FormBorderStyle = 'FixedDialog'
    Text = 'Akar \\ 3D LUT Creator to NUKE v1.0.0'
    Toplevel = $true
    TopMost = $false
    MaximizeBox = $false
    MinimizeBox = $true
    StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
}

$GroupBoxSeparator = New-Object System.Windows.Forms.GroupBox -Property @{
    Location = New-Object System.Drawing.Point(15,70)
    Size = New-Object System.Drawing.Size(614,2)
    FlatStyle = 'Flat'
}
$Form.Controls.Add($GroupBoxSeparator)

$TextBoxLabelCurves = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(12,18)
    Size = New-Object System.Drawing.Size(50,22)
    Text = "Curves:"
}
$Form.Controls.Add($TextBoxLabelCurves)

$TextBoxLabelStatusCurves = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(12,43)
    Size = New-Object System.Drawing.Size(50,22)
    Text = 'Status:'
}
$Form.Controls.Add($TextBoxLabelStatusCurves)

$TextBoxLabelInfoCurves = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(68,43)
    Size = New-Object System.Drawing.Size(250,22)
    Text = ''
}
$Form.Controls.Add($TextBoxLabelInfoCurves)

$TextBoxLabelMatrix = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(12,88)
    Size = New-Object System.Drawing.Size(50,22)
    Text = "Matrix:"
}
$Form.Controls.Add($TextBoxLabelMatrix)

$TextBoxLabelStatusMatrix = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(12,163)
    Size = New-Object System.Drawing.Size(50,22)
    Text = 'Status:'
}
$Form.Controls.Add($TextBoxLabelStatusMatrix)

$TextBoxLabelInfoMatrix = New-Object System.Windows.Forms.Label -Property @{
    Location = New-Object System.Drawing.Point(68,163)
    Size = New-Object System.Drawing.Size(250,22)
    Text = ''
}
$Form.Controls.Add($TextBoxLabelInfoMatrix)


$TextBoxLightroom = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,15)
    Size = New-Object System.Drawing.Size(487,22)
    Text = ''
    TabIndex = 1
}
$Form.Controls.Add($TextBoxLightroom)

$TextBoxMatrixRed0 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,85)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 3
}
$Form.Controls.Add($TextBoxMatrixRed0)

$TextBoxMatrixRed1 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(128,85)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 4
}
$Form.Controls.Add($TextBoxMatrixRed1)

$TextBoxMatrixRed2 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(188,85)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 5
}
$Form.Controls.Add($TextBoxMatrixRed2)

$TextBoxMatrixGreen0 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,110)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 3
}
$Form.Controls.Add($TextBoxMatrixGreen0)

$TextBoxMatrixGreen1 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(128,110)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 4
}
$Form.Controls.Add($TextBoxMatrixGreen1)

$TextBoxMatrixGreen2 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(188,110)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 5
}
$Form.Controls.Add($TextBoxMatrixGreen2)

$TextBoxMatrixBlue0 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,135)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 3
}
$Form.Controls.Add($TextBoxMatrixBlue0)

$TextBoxMatrixBlue1 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(128,135)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 4
}
$Form.Controls.Add($TextBoxMatrixBlue1)

$TextBoxMatrixBlue2 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(188,135)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
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

# even check function by /\/\o\/\/
Function Check-Even {

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
            $Curve = @{Blue = @();Green = @();Red = @()}
            $RGB = @('Blue','Green','Red')
            $RGBValues = 0

            for ($i = 0; $i -lt 3; $i++){

                $Regex = [Regex]::new('(?smi)' + $RGB[$i] + ' = {(.*?)}')

                $Match = $Regex.Match($LightroomTemplate).Groups[1]

                if ($Match.Success){

                    $Curve.($RGB[$i]) = $Match.Value.Replace("`t",'').Replace("`n",'').Split(',').Where({ $_ -ne '' }) | Select-Object -SkipLast 1
                    $RGBValues += $Curve.($RGB[$i]).Count

                }
            }


            # format all rgb values
            if ($RGBValues -eq 48){

                for ($i = 0; $i -lt 3; $i++){
                    for ($j = 0; $j -lt 16; $j++){
                    
                        if (Check-Even -Number $j){
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
                    "red {curve " + ($Curve.Red -Join ' ') + "}`n" + `
                    "green {curve " + ($Curve.Green -Join ' ') + "}`n" + `
                    "blue {curve " + ($Curve.Blue -Join ' ') + "}`n" + `
                    "alpha {}}`n" + `
                    "name ColorLookup3DLUTCreator`n" + `
                    "xpos 0`n" + `
                    "ypos 0`n" + `
                    "}"

                Set-Clipboard -Value $NukeNode
            
                $TextBoxLabelInfoCurves.Text = 'Nuke Node successfully copied to Clipboard.'

            }

        } else {

            $TextBoxLabelInfoCurves.Text = 'Input is not valid.'

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
            
                $TextBoxLabelInfoMatrix.Text = 'Nuke Node successfully copied to Clipboard.'

            }
        } 
    }
}


$ButtonFile.Add_Click({

    $TextBoxLightroom.Text = $global:variable = Get-Lightroom "*\"

    Format-Curves

})


$TextBoxLightroom.Add_TextChanged({

    Format-Curves

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
