////    Macro to measure area of leaves
// On each pic in a folder, it sets a colour threshold and 
//   measures the area.
// Marta Binaghi
// Created 13th November 2019
// Last modified 13th November 2019
// Licensed under MIT license

function get_area(myfile) {
	selectWindow(myfile);

	// Color Thresholder 1.51i
	min=newArray(3);
	max=newArray(3);
	filter=newArray(3);
	a=getTitle();
	run("HSB Stack");
	run("Convert Stack to Images");
	selectWindow("Hue");
	rename("0");
	selectWindow("Saturation");
	rename("1");
	selectWindow("Brightness");
	rename("2");
    // hue thresholds
	min[0]=0;
	max[0]=255;
	filter[0]="pass";
    // saturation thresholds
	min[1]=0;
	max[1]=255;
	filter[1]="pass";
    // brightness thresholds
	min[2]=70;
	max[2]=255;
	filter[2]="pass";
	for (i=0;i<3;i++){
	  selectWindow(""+i);
	  setThreshold(min[i], max[i]);
	  run("Convert to Mask");
	  if (filter[i]=="stop")  run("Invert");
	}
	imageCalculator("AND create", "0","1");
	imageCalculator("AND create", "Result of 0","2");
	for (i=0;i<3;i++){
	  selectWindow(""+i);
	  close();
	}
	selectWindow("Result of 0");
	close();
	selectWindow("Result of Result of 0");
	rename(a);
	// Colour Thresholding-------------
	
	// measure area of particles
	run("Analyze Particles...", "size=101-Infinity show=Outlines display include");

	// save outline
	selectWindow("Drawing of " + myfile);
	index = lastIndexOf(myfile, "."); 
	if (index!=-1) img_name = substring(myfile, 0, index); 
	saveAs("Jpeg", out_folder + img_name + "_outline.jpg");
	close(img_name + "_outline.jpg");
}


// Choose a directory for the input
in_folder = getDirectory("Choose the input directory");
print("Input folder is " + in_folder); 

// Choose a directory for the output (outline images and measurements)
out_folder = getDirectory("Choose the output directory");
print("Output folder is " + out_folder);

setBatchMode(true);  // seems to prevent imageJ from messing up windows

// make list of files in input directory (includes subfolders)
list = getFileList(in_folder);

// clear possibly pre-existing results
run("Clear Results");
run("Set Measurements...", "area display redirect=None decimal=3");

// process every file in the folder
for (i = 0; i < list.length; i++) {
	currentFile = list[i];
	lastChar = substring(currentFile, lengthOf(currentFile)-1, lengthOf(currentFile));
	// skip subfolders
	if ( lastChar != "/" ) {
		open(in_folder + list[i]);
		get_area(list[i]);
		close(list[i]);
	}
}

// save area measure
saveAs("Measurements", out_folder + "area_measurements.csv");

setBatchMode(false);

print("");
print("Done.");
