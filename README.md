# Fiji (ImageJ) macros

A collection of macros and scripts to be used with [Fiji (ImageJ)](https://imagej.net/software/fiji/).

Except where differently stated, the code in this repo is licensed under [MIT license](LICENSE.txt). Note that certain macros are developed from macros already existing and with unknown license.

## How to run the macros

Open Fiji, do Plugins > Macros > Run and select the macro file.


## Crop leaves

[crop_leaves.ijm](scripts/crop_leaves.ijm)

A macro to crop areas from a picture based on a grid of rectangles. The macro takes a folder of images as input and creates a new folder with the cropped images numbered from 1 to the total number of areas cut from each picture (you can in fact set any string to distinguish the cut images). 

We use it to crop leaves into single pictures like this:

<img src="https://user-images.githubusercontent.com/25846389/138696182-6a8d5759-17bc-4913-9eaf-59999112d557.png" width=50% height=50%>




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

[crop_addscale.ijm](scripts/crop_addscale.ijm)

This is useful if you have a serie of pictures to crop all the same and add a scale bar (the scale has to be identical for all images). You need to have the coordinates of the rectangular area you want to crop, and you need the scale in pixel to your reference scale bar. These can be set by changing the text in the macro. See the section [crop leaves](##crop-leaves) for further details.

For example we use it as such:

<img src="https://user-images.githubusercontent.com/25846389/138700243-d984ff31-5e0c-4ce4-a6e4-0e3619d85891.png" width=50% height=50%>





## Measure area based on colour thresholds

[leaves_area.ijm](scripts/leaves_area.ijm)

This is used to apply colour thresholds to an image (based on brightness, hue and saturation) and use those to define an area to measure.
You should first define what your thresholds are by using fiji interactively. Open your image in fiji, then Image > Adjust > Color thresholds. You will see the areas that pass the thresholds highlighted in red. Find the optimal threshold for your images (ideally, you have taken all the pictures under the same light conditions, so you will have to do this only once) and add them in the macro, in the part of code:

```
    \\ hue thresholds
	min[0]=0;
	max[0]=255;
	filter[0]="pass";
    \\ saturation thresholds
	min[1]=0;
	max[1]=255;
	filter[1]="pass";
    \\ brightness thresholds
	min[2]=70;
	max[2]=255;
```

<img src="https://user-images.githubusercontent.com/25846389/138705325-fd30ed99-fa63-49e9-9789-48f5546a0205.png" width=50% height=50%>


The area measurement is based on the `Analyze Particles` function. A particle is a fiji term to mean “continuous portion of surface”. You can set a minimum size (pixels) for the particle to be measured in the line:

```
run("Analyze Particles...", "size=101-Infinity show=Outlines display include");
```

The macro takes a folder of images as input and creates a new folder that includes one outline image (represents the outline of what was measured) per each image in the input folder, and one csv file with the area measured.

We use it as:

<img src="https://user-images.githubusercontent.com/25846389/138707109-8b1eca18-79e9-482b-9094-cf37b1e91b8f.png" width=50% height=50%>


## Measure yellow and green areas

We wanted to measure "how yellow" leaves were, so we took advantage of a Fiji macro published by [Laflamme and colleagues in 2016](https://doi.org/10.1094/MPMI-07-16-0129-TA), [available on github](https://gist.github.com/DSGlab/1b3a226a7af884efd9356ea2d6a02bd4). We used the structure of their function (credited to Peggy Muddles in their code) to develop a macro that would fit our needs. We are grateful for their publishing of the code.

