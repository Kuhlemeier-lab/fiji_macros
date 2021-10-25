////    crop_addscale function
// Written for cropping a defined area and adding the scale
//  to each picture in a folder.
// Marta Binaghi
// Created 12th November 2019
// Last modified 12th November 2019
// Licensed under MIT license

// The function
function crop_addscale(in_folder, out_folder, filename) {
	print("Processing file " + filename);
	open(in_folder + filename);
	run("Specify...", "width=1323 height=2169 x=1050 y=3");
	run("Crop");
	run("Set Scale...", "distance=37.292 known=1 unit=cm");
	run("Scale Bar...", "width=5 height=8 font=42 color=White background=None location=[Lower Right] overlay");
	saveAs("Jpeg", out_folder + filename);
	close();
}

// Choose a directory for the input
in_folder = getDirectory("Choose the input directory");
print("Input folder is " + in_folder); 


// Choose a directory for the output
out_folder = getDirectory("Choose the output directory");
print("");
print("Output folder is " + out_folder);


// Loop through the files and crop them

setBatchMode(true);  // seems to prevent imageJ from messing up windows

// make list of files in input directory (includes subfolders)
list = getFileList(in_folder);

// crop every file in the folder
for (i = 0; i < list.length; i++) {
	currentFile = list[i];
	lastChar = substring(currentFile, lengthOf(currentFile)-1, lengthOf(currentFile));
	// skip subfolders
	if ( lastChar != "/" ) {
		crop_addscale(in_folder, out_folder, list[i]);
	}
}
setBatchMode(false);

print("");
print("Done.");
