#Requires -Version 5.0

#
# akar // 3D LUT Creator to NUKE v1.0.3
# ----------------------------------
# http://www.akar.id
# ----------------------------------
# by Nick Zimmermann
# ----------------------------------
#

Clear-Host

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Size = New-Object System.Drawing.Size(650,225)
    FormBorderStyle = 'FixedDialog'
    Text = 'akar \\ 3D LUT Creator to NUKE v1.0.3'
    MaximizeBox = $False
    MinimizeBox = $True
    StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    Add_Load = ({

      $Form.TopMost = $True

    })
}

$Divider0 = New-Object System.Windows.Forms.Panel -Property @{
    Location = New-Object System.Drawing.Point(15,47)
    Size = New-Object System.Drawing.Size(614,1)
    BackColor = '217, 217, 217'
    BorderStyle = 'None'
}
$Form.Controls.Add($Divider0)

$Divider1 = New-Object System.Windows.Forms.Panel -Property @{
    Location = New-Object System.Drawing.Point(15,143)
    Size = New-Object System.Drawing.Size(614,1)
    BackColor = '217, 217, 217'
    BorderStyle = 'None'
}
$Form.Controls.Add($Divider1)

$CheckBoxTopMost = New-Object System.Windows.Forms.CheckBox -Property @{
    Location = New-Object System.Drawing.Point(510,159)
    Size = New-Object System.Drawing.Size(120,20)
    Text = 'Always on top'
    Checked = $True
    RightToLeft = 'Yes'

    Add_CheckStateChanged = ({

        $Form.TopMost = $CheckBoxTopMost.Checked

    })
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
    AllowDrop = $True

    Add_DragOver = ({

    	if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)[0]) {

	        $_.Effect = 'Copy'

	    } else {

	        $_.Effect = 'None'

	    }
    })

    Add_DragDrop = ({

        $TextBoxLightroom.Text = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)[0]

    })

    Add_TextChanged = ({

        Format-Curves

    })
}
$Form.Controls.Add($TextBoxLightroom)

$TextBoxMatrixRed0 = New-Object System.Windows.Forms.TextBox -Property @{
    Location = New-Object System.Drawing.Point(68,61)
    Size = New-Object System.Drawing.Size(50,22)
    Text = ''
    TabIndex = 3

    Add_TextChanged = ({

        Format-Matrix -Color Red -TextInput $TextBoxMatrixRed0.Text

    })
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

    Add_TextChanged = ({

        Format-Matrix -Color Green -TextInput $TextBoxMatrixGreen0.Text

    })
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

    Add_TextChanged = ({

        Format-Matrix -Color Blue -TextInput $TextBoxMatrixBlue0.Text

    })
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

    Add_Click = ({

        $TextBoxLightroom.Text = Get-Lightroom "*\"

        Format-Curves

    })
}
$Form.Controls.Add($ButtonFile)

# functions
Function Get-Lightroom($InitialDirectory){

    $Select = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        InitialDirectory = $InitialDirectory
        Filter = "Lightroom|*.lrtemplate"
    }

    $Select.ShowDialog() | Out-Null

    $Select.Filename
}

Function Format-Curves {
    
    if (![string]::IsNullOrWhiteSpace($TextBoxLightroom.Text) -and 
        [System.IO.File]::Exists($TextBoxLightroom.Text) -and 
        [System.IO.Path]::HasExtension('.lrtemplate')){

        $LightroomTemplate = (Get-Content $TextBoxLightroom.Text -Raw) -replace '\s+'

        # Collect all RGB values.
        # PV2012 (Process Version 2012 Lightroom 4) is used for the Master curve.
        $RGB = 'PV2012','Blue','Green','Red'
        $Curve = @{}

        for ($i = 0; $i -lt 4; $i++){

            $Regex = [Regex]::New('(?s)' + $RGB[$i] + '={0,(.*?),}')

            $Match = $Regex.Match($LightroomTemplate).Groups[1]

            if ($Match.Success){

                $Curve.($RGB[$i]) = $Match.Value.Split(',')

            }
        }

        # format all rgb values
        if ([bool](Compare-Object ([string[]]$Curve.Keys) $RGB -IncludeEqual -ExcludeDifferent)){

            for ($i = 0; $i -lt 4; $i++){
                for ($j = 0; $j -lt $Curve.($RGB[$i]).Count; $j++){
                    
                    $X = ''
                    if ([bool]($j % 2)){ # even test!
                        $X = 'x'
                    }

                    $Curve.($RGB[$i])[$j] = $X + [math]::Round([int]$Curve.($RGB[$i])[$j] / 255, 6)

                }
            }

            # create nuke output
            $NukeNode = "ColorLookup {`n" +
            "lut {master {}`n" +
            "master {curve " + ($Curve.PV2012 -Join ' ') + "}`n" +
            "red {curve " + ($Curve.Red -Join ' ') + "}`n" +
            "green {curve " + ($Curve.Green -Join ' ') + "}`n" +
            "blue {curve " + ($Curve.Blue -Join ' ') + "}`n" +
            "alpha {}}`n" +
            "name ColorLookup3DLUTCreator`n" +
            "xpos 0`n" +
            "ypos 0`n" +
            "}"

            Set-Clipboard -Value $NukeNode
            
            $TextBoxLabelInfo.Text = 'Status: Nuke Curves successfully copied to Clipboard.'

        } else {

            $TextBoxLabelInfo.Text = 'Status: Cannot find the RGB values in the Lightroom Template.'
            $Cancel = $True

        }
    } else {

        $TextBoxLabelInfo.Text = 'Status: Input is not valid.'

    }

}

Function Format-Matrix {

    Param(

        [Parameter(Mandatory=$True)]
        $Color,
        [Parameter(Mandatory=$True)]
        $TextInput

    )
    
    if (![string]::IsNullOrWhiteSpace($TextInput) -and $TextInput -match '^(R:)'){

        # collect all rgb values
        $MatrixColors = $TextInput.split(' %RGB:').Where({ $_.Trim() })

        # format all rgb values
        for ($i = 0; $i -lt 3; $i++){

            $MatrixColors[$i] /= 100
            
            # write values back into input fields
            $((Get-Variable -Name ('TextBoxMatrix' + $Color + $i)).value).Text = $MatrixColors[$i]
            
        }

        # collect values from grid
        $Matrix = @{}
        $RGB = 'Blue','Green','Red'

        for ($i = 0; $i -lt 3; $i++){
            for ($j = 0; $j -lt 3; $j++){

                if ([string]::IsNullOrWhiteSpace($((Get-Variable -Name ('TextBoxMatrix' + $RGB[$i] + $j)).value).Text)){
                        
                    $Incomplete = $True
                    $i = $j = 3
                    
                } else {

                    $Matrix.($RGB[$i]) += $((Get-Variable -Name ('TextBoxMatrix' + $RGB[$i] + $j)).value).Text + ' '
                    $Incomplete = $False
                    
                }
            }
        }

        # create nuke output
        if (!$Incomplete){

            $NukeNode = "ColorMatrix {`n" +
                        "inputs 0`n" +
                        "matrix {`n" +
                        "{" + $Matrix.Red.Trim() + "}`n" +
                        "{" + $Matrix.Green.Trim() + "}`n" +
                        "{" + $Matrix.Blue.Trim() + "}`n" +
                        "}`n" +
                        "name ColorMatrix3DLUTCreator`n" +
                        "selected true`n" +
                        "xpos 0`n" +
                        "ypos 0`n" +
                        "}"

            Set-Clipboard -Value $NukeNode
            
            $TextBoxLabelInfo.Text = 'Status: Nuke Matrix successfully copied to Clipboard.'

        }
    } 
}

$Form.ShowDialog() | Out-Null
