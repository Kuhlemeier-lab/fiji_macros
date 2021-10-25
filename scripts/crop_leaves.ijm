////    crop_leaves function
// Written for cropping several defined areas from each picture in a 
//  folder.
// Marta Binaghi
// Created 12th November 2019
// Last modified 12th November 2019
// Licensed under MIT License

// The cropping function
function crop_leaves(in_folder, out_folder, filename) {
	print("Cropping file " + filename);
	// get image name
	img_name = substring(filename, 0, lengthOf(filename)-4);
	open(in_folder + filename);
	// leaf 1
	run("Specify...", "width=492 height=566 x=244 y=170");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 1 + ".JPG");
	close();
	// leaf 2
	run("Specify...", "width=618 height=575 x=784 y=192");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 2 + ".JPG");
	close();
	// leaf 3
	run("Specify...", "width=562 height=592 x=1454 y=166");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 3 + ".JPG");
	close();
	// leaf 4
	run("Specify...", "width=551 height=600 x=2062 y=196");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 4 + ".JPG");
	close();
	// leaf 5
	run("Specify...", "width=568 height=617 x=2668 y=216");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 5 + ".JPG");
	close();
	// leaf 6
	run("Specify...", "width=554 height=564 x=164 y=789");	//run("Specify...", "width=554 height=550 x=164 y=803");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 6 + ".JPG");
	close();
	// leaf 7
	run("Specify...", "width=603 height=594 x=777 y=768");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 7 + ".JPG");
	close();
	// leaf 8
	run("Specify...", "width=555 height=579 x=1458 y=792");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 8 + ".JPG");
	close();
	// leaf 9
	run("Specify...", "width=555 height=582 x=2058 y=819");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 9 + ".JPG");
	close();
	// leaf 10
	run("Specify...", "width=411 height=606 x=2673 y=855");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 10 + ".JPG");
	close();
	// leaf 11
	run("Specify...", "width=544 height=582 x=146 y=1464");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 11 + ".JPG");
	close();
	// leaf 12
	run("Specify...", "width=549 height=597 x=750 y=1464");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 12 + ".JPG");
	close();
	// leaf 13
	run("Specify...", "width=558 height=660 x=1365 y=1464");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 13 + ".JPG");
	close();
	// leaf 14
	run("Specify...", "width=563 height=654 x=1983 y=1484");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 14 + ".JPG");
	close();
	// leaf 15
	run("Specify...", "width=546 height=613 x=2578 y=1527");
	run("Duplicate...", " ");
	saveAs("Jpeg", out_folder + img_name + "_" + 15 + ".JPG");
	close();
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
		crop_leaves(in_folder, out_folder, list[i]);
	}
}
setBatchMode(false);

print("");
print("Done.");
