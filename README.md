# 3dlut2nuke

This utility can be used to quickly copy Curves and Matrix information from 3D LUT Creator to The Foundry Nuke.

Matrix values can be copied by doubleclicking on the Red, Green and Blue values text on the channels tab within 3D Lut creator. When pasted into the input fields they are automatically converted. Once all three fields are filled in the Nuke Matrix node is automatically copied to the clipboard and can be pasted in your Nuke nodetree.

The Master, Red, Green and Blue Curves from the Curves tab can be copied by 'Save Curves...' from the dropdown menu and saving them as a Lightroom template. The file can then be loaded, the curves are directly copied to the clipboard and can be pasted in Nuke.

You'll have to add a Colorspace node to convert to the correct colorspace and then back in Nuke to match the colors from 3D LUT Creator.

#### Changelog

1.0.2
- minor code adjustments
- shifting things around a bit
- fixed always on top at launch

1.0.1
- added topmost checkbox
- added master curve (luminance)
- changed GUI to only one status line
- changed disabled second and third matrix input

v1.0 (initial release)
