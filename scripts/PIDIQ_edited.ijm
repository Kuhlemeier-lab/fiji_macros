//////////////////////////////////////////////////////////
// Published in:
// https://apsjournals.apsnet.org/doi/pdf/10.1094/MPMI-07-16-0129-TA
// https://gist.github.com/DSGlab
//
// Peggy Muddles
// 
// March 15, 2016
// Revised March 28, 2017 with thanks to Brandon Hurr
//
// October 15, 2020 Edited by Marta Binaghi:
//  - adapted hue thresholds for petunia leaves
//  - added an analyse particles step to consider only
//    bright areas bigger than a defined pixel area 
//    (to exclude debris that might be present in the 
//    background)
//  - added a text file that saves the thresholds for HSB
//    used in the analysis.
//
// Fully automatic macro that assesses yellowing in arabidopsis
// Input
//	- Folder of plant tray images 
//	- background is soil
// Output
//	- False color image showing isolated plants and yellowed area
//	- Results table of plant and yellowed area measurements
//
// Release v0.0.1
//
//	v0.0.1 Initial Recorded Release (borrowed codebase from Brandon Hurr cucumber macro)
//
// Needs
//	- ?
//////////////////////////////////////////////////////////


////////////////////////////////
// global variables

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

// area minimum threshold in pixel
var areaMin = 470;

var orig = 0; 			//stores name of picture

// for getTimeString() function
var TimeString = 0;				//Date and Time for macro run

// for createTable() function
var title1 = 0;			//Name of Results Table
var f=0;					//Result Table

// for getDateTime() function
var DateTime = 0;				//Date and Time from Exif info

//for folderChoice() function
var savedir = 0;		// Directory where files will be saved
var falsecolordir = ""; // Directory to store main image with fruit highlighted
var midlinedir = "";	// Directory to store midline/skeleton images of isoloated fruit

var filecount = 0;		// how many files are there?
var jpgcount = 0;		// how many jpgs in the folder?
var folderstoprocess = newArray(1000000);	//folder names to process
var filestoprocess = newArray(1000000);		//file names to process


// begin macro code
resetImageJ(); // clean up in case there are open windows or ROIs in manager
var count = 0; 
createTable(); // creates the results table
getTimeString(); // makes the timestring


// control structure of macro to allow in-determinate number of images to be processed.

folderChoice(); // select folder(s) for processing

do {
	choice = getBoolean("Do you want to process another folder?");
	if (choice==0) {
		start = getTime();
		folderstoprocess = Array.trim(folderstoprocess, filecount);
		filestoprocess = Array.trim(filestoprocess, filecount);
		
		setBatchMode(true);
		
		for (z=0; z<filestoprocess.length; z++) {
			
			roiManager("reset");
			run("Clear Results");
			
			showProgress(z/filestoprocess.length);
			
			open(folderstoprocess[z]+filestoprocess[z]);
			
			clearScale(); // clear any scale that is present all results will be in pixels

			orig = getTitle();

			selectWindow(orig);
			
			run("Duplicate...", "title=Painted");

			selectWindow(orig);
			
			// find green area
			run("Duplicate...", "title=Green");
			
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
			min[0]=hueGMin;
			max[0]=hueGMax;
			filter[0]="pass";
			min[1]=satMin;
			max[1]=satMax;
			filter[1]="pass";
			min[2]=brightMin;
			max[2]=brightMax;
			filter[2]="pass";
			for (i=0;i<3;i++){
			  selectWindow(""+i);
			  setThreshold(min[i], max[i]);
			  run("Convert to Mask");
			  if (filter[i]=="stop")  run("Invert");
			}
			// create a mask from analyse paticles to keep only
                        // areas bigger than a size threshold
                        roiManager("reset");
			selectWindow("2");
                        run("Analyze Particles...", "size=areaMin-Infinity include add");
                        // if 0 ROIs then go to next image
                        // if more than one ROI then combine them
                        nROIs = roiManager("count");
                        //print(nROIs);
                        if ( nROIs == 0 ) {
                                //print("Continue");
				roiManager("reset");
				// close unnecessary image windows
			        run("Close All"); 
                        	continue;
			} else if ( nROIs > 1 ) {
                        	roiManager("Deselect");
                        	roiManager("Combine");
                        } else {
                        	roiManager("Select", 0);
                        }
			// measure total leaf area and save as variable
			run("Clear Results");
			run("Measure");
			leafArea = getResult("Area", 0);
                        // make a mask of the leaf area
			selectWindow("2");
			run("Create Mask");
                        imageCalculator("AND create", "0","1");
			imageCalculator("AND create", "Result of 0","Mask");
			for (i=0;i<3;i++){
			  selectWindow(""+i);
			  close();
			}
			selectWindow("Result of 0");
			close();
			selectWindow("Result of Result of 0");
			rename("Green");

			// correct the f'n LUT

			invertedLUT = is("Inverting LUT");
			if (invertedLUT == 1) {
				run("Invert LUT");
				run("Invert");
			}

			
			run("Clear Results");
			run("Measure");
			how_white = getResult("Mean", 0);

			if (how_white == 255) { // get mean brightness from results table
				greenArea = 0; // nothing is green, the end is nigh
			} else {
				// something's green!
				run("Create Selection");
				run("Clear Results");
				run("Measure");	
				greenArea = getResult("Area", 0); // get area from results table
				
				// paint it
				selectWindow("Painted");
				run("Restore Selection");
				setForegroundColor(0, 136, 55); 
				run("Line Width...", "line=5"); 
				run("Fill", "slice"); 
			}
			
			selectWindow("Green");
			run("Close");
			
			selectWindow(orig);
			
			// find yellow area
			run("Duplicate...", "title=Yellow");
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
			min[0]=hueYMin;
			max[0]=hueYMax;
			filter[0]="pass";
			min[1]=satMin;
			max[1]=satMax;
			filter[1]="pass";
			min[2]=brightMin;
			max[2]=brightMax;
			filter[2]="pass";
			for (i=0;i<3;i++){
			  selectWindow(""+i);
			  setThreshold(min[i], max[i]);
			  run("Convert to Mask");
			  if (filter[i]=="stop")  run("Invert");
			}
			// create a mask from analyse paticles to keep only
                        // areas bigger than a size threshold
                        roiManager("reset");
			selectWindow("2");
                        run("Analyze Particles...", "size=areaMin-Infinity include add");
			// if more than one ROI then combine them
                        nROIs = roiManager("count");
                        if ( nROIs > 1 ) {
                        	roiManager("Deselect");
                        	roiManager("Combine");
                        } else {
                        	roiManager("Select", 0);
                        }
                        run("Create Mask");
                        imageCalculator("AND create", "0","1");
			imageCalculator("AND create", "Result of 0","Mask");
			for (i=0;i<3;i++){
			  selectWindow(""+i);
			  close();
			}
			selectWindow("Result of 0");
			close();
			selectWindow("Result of Result of 0");
			rename("Yellow");

			// correct the f'n LUT

			invertedLUT = is("Inverting LUT");
			if (invertedLUT == 1) {
				run("Invert LUT");
				run("Invert");
			}
			
			run("Clear Results");
			run("Measure");
			how_white = getResult("Mean", 0);
			if (how_white == 255) { // get mean brightness from results table
				yellowArea = 0; // nothing is yellow, the world is great
			} else {
				// something's yellow!
				run("Create Selection");
				run("Clear Results");
				run("Measure");
				yellowArea = getResult("Area", 0); // get area from results table
				
				// paint it
				selectWindow("Painted");
				run("Restore Selection");
				setForegroundColor(123, 50, 148);
				run("Fill", "slice");
			}
			
			selectWindow("Yellow");
			run("Close");

			selectWindow("Painted");
			//save with false color
			saveAs("jpg", savedir + orig + "_Painted");
			close();

			//Print results for each leaf
			print(f, orig + "\t" + greenArea + "\t" + yellowArea + "\t" + leafArea);
			
			//reset ROIs for netting/stripes/shell diagnostics
			roiManager("reset");
								
			// close unnecessary image windows
			run("Close All"); 
			
			run("Clear Results");

			selectWindow("Results Table (results in px)");
			saveAs("Text", savedir + "Results.temp");
			
		} // end of image loop	
			
	} // end of if statement when choice ==0
	if (choice==1) {	
	folderChoice();
	}
} while (choice==1);

// print thresholds to file
infoFile = savedir+TimeString+"_thresholds.txt";
info = File.open(infoFile);
print(info, "Brightness "+brightMin+" - "+brightMax);
print(info, "Saturation "+satMin+" - "+satMax);
print(info, "Hue yellow "+hueYMin+" - "+hueYMax);
print(info, "Hue green "+hueGMin+" - "+hueGMax);
File.close(info);


exit("Finished!");	



///////////////////////////////////////////////////////////////////////////////////////////////////
//These are the functions called by the macro
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////
function resetImageJ() {
	requires("1.48d");
	// Only if needed uncomment these lines
	//run("Proxy Settings...", "proxy=webproxy-chbs.eame.syngenta.org port=8080");
	//run("Memory & Threads...", "maximum=1500 parallel=4 run");

	run("Options...", "iterations=1 count=1 edm=Overwrite");
	run("Line Width...", "line=1");
	run("Colors...", "foreground=black background=white selection=yellow");
	run("Clear Results");
	run("Close All");
	print("\\Clear");
	run("ROI Manager...");
	run("Input/Output...", "jpeg=75 gif=-1 file=.csv use_file copy_row save_column save_row");
	run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
}
///////////////////////////////////////

///////////////////////////////////////////////////////
function folderChoice() {

	path = getDirectory("Choose a folder of images to analyze"); 

	// saves a folder for the processed images at your path with the following name
  	savedir = path+TimeString+File.separator;
 	File.makeDirectory(savedir);

	filelist = getFileList(path);
	for (z=0; z<filelist.length; z++) {
		 if (endsWith(filelist[z],"JPG")) {
			folderstoprocess[filecount] = path;
			filestoprocess[filecount] = filelist[z];
			jpgcount++;
			filecount++;
		}
		if (endsWith(filelist[z],"jpg")) {
			folderstoprocess[filecount] = path;
			filestoprocess[filecount] = filelist[z];
			jpgcount++;
			filecount++;
		}
		 if (endsWith(filelist[z],"tif")) {
			folderstoprocess[filecount] = path;
			filestoprocess[filecount] = filelist[z];
			jpgcount++;
			filecount++;
		}
		if (endsWith(filelist[z],"tiff")) {
			folderstoprocess[filecount] = path;
			filestoprocess[filecount] = filelist[z];
			jpgcount++;
			filecount++;
		}
	}
var count = (count+1);

}// end of Folderchoice Function
///////////////////////////////////////////////////////

////////////////////////////////////////
function createTable() {

// creates a custom results table or clears the current open if open
  title1 = "Results Table (results in px)";
  title2 = "["+title1+"]";
  f = title2;
  if (isOpen(title1))
     print(f, "\\Clear");
  else
     run("Table...", "name="+title2+" width=800 height=200");
print(f, "\\Headings:File\tGreenArea\tYellowedArea\tLeafArea");
} // end of function Createtable()
//////////////////////////////////////////

//////////////////////////////////////////
function getTimeString() {

// time string for folder name

MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
     DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     TimeString = DayNames[dayOfWeek]+"_";
     if (dayOfMonth<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+dayOfMonth+"_"+MonthNames[month]+"_"+year+"_";
     if (hour<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+hour+"";
     if (minute<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+minute+"_";
     if (second<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+second;

} // end of getTimeString()
//////////////////////////////////////////

///////////////////////////////////////
function clearScale() {

run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");

} // end of ClearScale () function {
///////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
function correctLUT() {
	invertedLUT = is("Inverting LUT");
	if (invertedLUT == 1) {
		run("Invert LUT");
		run("Invert");
	}
}
/////////////////////////////////////////////////////////////////////////
