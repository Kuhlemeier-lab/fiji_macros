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

This is useful if you have a serie of pictures to crop all the same and add a scale bar (the scale has to be identical for all images). You need to have the coordinates of the rectangular area you want to crop, and you need the scale in pixel to your reference scale bar. These can be set by changing the text in the macro. See the section [crop leaves](##-crop-leaves) for further details.

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

[PIDIQ_edited.ijm](scripts/PIDIQ_edited.ijm)

We wanted to measure "how yellow" leaves were, so we took advantage of a Fiji macro published by [Laflamme and colleagues in 2016](https://doi.org/10.1094/MPMI-07-16-0129-TA), and [available on github](https://gist.github.com/DSGlab/1b3a226a7af884efd9356ea2d6a02bd4). We used the structure of their function (credited to Peggy Muddles in their code) to develop a macro that would fit our needs. We are grateful for their publishing of the code.

The macro takes a picture with a dark background and measures the yellow and green areas (in our case leaves with signs of necrosis on a black photography cloth). The macro processes folders of input images and outputs a table containing yellow, green and total areas measured in pixels, and a new folder containing the same pictures, but painted where the areas where considered as greeen (painted green) and yellow (painted purple). Like this:

<img src="https://user-images.githubusercontent.com/25846389/138834435-6f00b73c-b4de-4473-843d-df8807104420.png" width=50% height=50%>

When using this macro, **it is essential to maintain constant and even light conditions** throughout the whole photo shooting and across the surface that is photographed (no dark or extremely bright corners). And it is essential to have a colour reference card in each picture taken (note that you can combine this macro with the [crop leaves](##crop-leaves) one, so you don't have to take 1 picture for 1 subject necessarily). The measurement of the yellow and green on the colour cards throughout the experiment tells us if the light conditions have been constant (e.g. if the yellow area of the colour cards changes significantly between the first and last picture taken, then we cannot trust the results). For this reason I consider that only pictures taken in the same session can be compared. I thus suggest to always have a control condition in your session to compare to. You should also check how much of the total subject area is covered by the sum of yellow and green area. If this is too low then something is wrong (your subject has a colour that is not measured or the thresholds are not set correctly).

How the macro decides to consider an area as yellow or green depends on the hue thresholds. The brightness and saturation are used to define the object area (as is done in [Measure area based on colour thresholds](#measure-area-based-on-colour-thresholds) ). Then the hue is used to define what is yellow and what is green. These parameters are set in the beginning of the macro:

```
// thresholds for hue, saturation and brightness
// Brightness, defines leaf area
var brightMin = 40;
var brightMax = 255;
// Saturation
var satMin = 65;
var satMax = 255;
// Hue, green
var hueGMin = 66;
var hueGMax = 150;
// Hue, yellow
var hueYMin = 12;
var hueYMax = 62;
```

Note that you will have to adjust the thresholds for your own picture settings. I suggest that you open a few images in Fiji and try the thresholds interactively as explained for [Measure area based on colour thresholds](#measure-area-based-on-colour-thresholds).

The macro also applies a minimum size threshold for the area considered (this is useful if you have debris in the background such as small pieces of leaves that remained but should not be counted). The size threshold is set here:

```
// area minimum threshold in pixel
var areaMin = 470;
```
[user-content-crop-leaves](user-content-crop-leaves)
[crop-leaves](#crop-leaves)
