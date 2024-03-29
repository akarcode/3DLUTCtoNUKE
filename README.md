# 3D LUT Creator to NUKE

![3dlutc2nuke_104](https://user-images.githubusercontent.com/59408512/230012911-5c486ce7-4faf-4db2-af27-ab13dbef6cdd.png)

This utility can be used to quickly copy RGB Curves and Color Matrix from 3D LUT Creator to The Foundry Nuke.

Matrix values can be copied by doubleclicking on the Red, Green and Blue values text on the channels tab within 3D LUT Creator. When pasted into the input fields they are automatically converted. Once all three fields are filled in the Nuke Matrix node is automatically copied to the clipboard and can be pasted in your Nuke nodetree.

The Master, Red, Green and Blue Curves from the Curves tab can be copied by 'Save Curves...' from the dropdown menu and saving them as a Lightroom template. The file can then be loaded, the curves are directly copied to the clipboard and can be pasted in Nuke.

You'll have to add a Colorspace node to convert to the correct colorspace and then back in Nuke to match the colors from 3D LUT Creator.

#### Notes

The Binary included in the release is compiled from C# and is not the packed PowerShell Script. The code is basically the same and will generate the same output.
It requires .NET 7 libraries to run it.


#### Changelog

1.0.4
- Small code simplification

1.0.3
- Removed unnecessary loops.
- Reduced need for array in colormatrix.
- Minor code adjustments.

1.0.2
- Added drag and drop functionality to the curves textbox.
- Minor code adjustments.
- Shifted things around a bit.
- Fixed always on top at launch.

1.0.1
- Added topmost checkbox.
- Added master curve (luminance).
- Changed GUI to only one status line.
- Changed disabled second and third matrix input.

v1.0 (Initial release)
