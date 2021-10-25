# fiji_macros

A collection of macros and scripts to be used with [Fiji (ImageJ)](https://imagej.net/software/fiji/).

Except where differently stated, the code in this repo is licensed under [MIT license](LICENSE.txt). Note that certain macros are developed from macros already existing and with unknown license.

## Crop leaves

A macro to crop areas from a picture based on a grid of rectangles. The macro takes a folder of images as input and creates a new folder with the cropped images numbered from 1 to the total number of areas cut from each picture (you can in fact set any string to distinguish the cut images). The areas to crop are defined by four coordinates each, expressed in pixels. To know the coordinates of your areas to crop you can draw a rectangle in Fiji and without moving the mouse further, you can read the x,y and width and height in the main window of imagej.

We use it to crop leaves into single pictures like this:

<img src="https://user-images.githubusercontent.com/25846389/138696182-6a8d5759-17bc-4913-9eaf-59999112d557.png" width=50% height=50%>

[crop_leaves.ijm](scripts/crop_leaves.ijm)

