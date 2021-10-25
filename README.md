# Fiji (IMageJ) macros

A collection of macros and scripts to be used with [Fiji (ImageJ)](https://imagej.net/software/fiji/).

Except where differently stated, the code in this repo is licensed under [MIT license](LICENSE.txt). Note that certain macros are developed from macros already existing and with unknown license.

## Crop leaves

A macro to crop areas from a picture based on a grid of rectangles. The macro takes a folder of images as input and creates a new folder with the cropped images numbered from 1 to the total number of areas cut from each picture (you can in fact set any string to distinguish the cut images). 

We use it to crop leaves into single pictures like this:

<img src="https://user-images.githubusercontent.com/25846389/138696182-6a8d5759-17bc-4913-9eaf-59999112d557.png" width=50% height=50%>

[crop_leaves.ijm](scripts/crop_leaves.ijm)


### Define area to crop

The areas to crop are defined by two coordinates, height and width, expressed in pixels. To know the coordinates of your areas to crop you can draw a rectangle in Fiji and without moving the mouse further, you can read the x,y and width and height in the main window of imagej.

To set your newly established coordinates in the macro, just open the macro with a text editor and change these sections accordingly:

```
// leaf 1
	run("Specify...", "width=492 height=566 x=244 y=170");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 1 + ".JPG");
	close();
```

Note that you can also set a different suffix for your cropped image to be saved (in the `saveAs` function).



## Crop and add scale bar

This is useful if you have a serie of pictures to crop all the same and add a scale bar (the scale has to be identical for all images). You need to have the coordinates of the rectangular area you want to crop, and you need the scale in pixel to your reference scale bar. These can be set by changing the text in the macro. See the section [crop leaves](##crop-leaves) for further details.

For example we use it as such:

<img src="https://user-images.githubusercontent.com/25846389/138700243-d984ff31-5e0c-4ce4-a6e4-0e3619d85891.png" width=50% height=50%>

[crop_addscale.ijm](scripts/crop_addscale.ijm)
