/* 
Author: Alessandro Felder, RVC, London

basic frame work that allows to (re-)analyse all tiff images in one directory with the same input suffix.
if offers the possibility to import a previous ROI

inputs: directory to analyse
		output directory
		input suffix
		input roi suffix
		output roi suffix

idea is to be easily repeatable and modular with respect to various area measurements and counts of interest.

*/


run("Close All");
roiManager("reset");
setOption("Show All", true);

run("Set Measurements...", "area mean standard median area_fraction limit redirect=None decimal=5");

minuend_image_dir = getDirectory("Choose an input minuend image directory");
subtrahend_image_dir = getDirectory("Choose an input subtrahend image directory");
difference_image_dir = getDirectory("Choose an output difference image directory");

minuend_suffix = getString("Choose an input minuend suffix", "");
subtrahend_suffix = getString("Choose an input subtrahend suffix","");
difference_suffix = getString("Choose an output difference suffix", "");

minuend_files = getFileList(minuend_image_dir);
subtrahend_files = getFileList(subtrahend_image_dir);

//check all files are present
if(!(minuend_files.length==subtrahend_files.length)){
	print("length of file lists do not match: "+minuend_files.length+" v "+subtrahend_files.length+". Aborting.");
	return;
	}

	
for(i=0; i<minuend_files.length; i++) {
	if(!endsWith(minuend_files[i], minuend_suffix+"-binary.tif")) {
		continue;
	}
	if(!endsWith(subtrahend_files[i], subtrahend_suffix+"-binary.tif")) {
		continue;
	}

	open(minuend_image_dir+minuend_files[i]);
	open(subtrahend_image_dir+subtrahend_files[i]);
	imageCalculator("Subtract create", minuend_files[i],subtrahend_files[i]);
	
	selectWindow("Result of "+minuend_files[i]);
	difference_name = replace(minuend_files[i],minuend_suffix,difference_suffix);
	saveAs(difference_image_dir+difference_name);

	//analyse and save
	run("Analyze Particles...", "size=0.0001-Infinity show=Nothing display exclude clear summarize");
	close();
	if(isOpen("Results")) selectWindow("Results");
	saveAs("Results", difference_image_dir+replace(difference_name,".tif","")+".csv");
		
	run("Close All");
}
