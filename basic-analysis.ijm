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

input_image_dir = getDirectory("Choose an input image directory")
input_roi_dir = getDirectory("Choose an input roi directory")
output_roi_dir = getDirectory("Choose an output directory")
input_image_suffix = "";//getString("Please enter input image suffix", "");
input_roi_suffix = getString("Please enter input roi suffix", "");
output_roi_suffix = getString("Please enter output roi suffix", "");
files = getFileList(input_image_dir);

newImage("dummyImageToSetGlobalScale", "16-bit black", 1, 1, 1);
run("Set Scale...", "distance=429.0105 known=0.7 pixel=1 unit=mm global");//4x	
run("Close");

for(i=0; i<files.length; i++) {
	if(!endsWith(files[i], input_image_suffix+".tif")) {
		continue;
	}

	roiManager("reset");
	setOption("Show All", true);

	open(input_image_dir+files[i]);
	originalName = files[i];
	
	previousRoiFile=replace(files[i],".tif","_")+input_roi_suffix+".zip";
	if(File.exists(input_roi_dir+previousRoiFile))
	{
		roiManager("open", input_roi_dir+previousRoiFile);
		roiManager("select", roiManager("count")-1);	
	}
	else
	{
		print("Warning: no previous roi");	
	}		
	//let user select area of interest, save and measure roi, save results
	selectWindow(originalName);
		
	if(getBoolean("Would you like to modify the current image?"))
	{
 		previousROIisOK = (input_roi_suffix!=output_roi_suffix && output_roi_dir!=input_roi_dir);

		if(previousROIisOK) 
		{				
			if(roiManager("count")>0)//get rid of the rest for better visual focus
			{
				eraseNonROIPixels();
				print("erasing non-ROI pixels for "+originalName);
			}
			else
			{
				run("Select All");
				roiManager("Add");	
			}		
		}

		waitForUser("Please select area of interest and then click OK");

		if(selectionType()==-1)
		{
			//empty selections should be handled as any selection that is touching the image border, as they are not counted in Analyse particles --- this is a bit of a hack!
			 makeRectangle(0,0,1,1);
			 print("empty selection");	
		}

		roiManager("Add");
		if(previousROIisOK)
		{
			print("using previous ROI for "+originalName);
			lastTwoSelections = newArray(1,0);
			roiManager("select", lastTwoSelections);
			roiManager("AND");
			if(selectionType()==-1)
			{
				//empty selections should be handled as any selection that is touching the image border, as they are not counted in Analyse particles --- this is a bit of a hack!
				 makeRectangle(0,0,1,1);
				 print("selection outside ROI or empty selection");	
			}
			roiManager("Add");
			roiManager("select", lastTwoSelections);
			roiManager("Delete");

		}
		
		roiManager("select", roiManager("count")-1);
		roiManager("Rename",replace(files[i],".tif","")+output_roi_suffix);
		roiManager("deselect");
		roiManager("save",output_roi_dir+replace(files[i],".tif","_")+output_roi_suffix+".zip");

		//convert to mask
		run("8-bit");
		setForegroundColor(255, 255, 255);
		fill();
		setForegroundColor(0, 0, 0);
		run("Make Inverse");
		fill();		
		setForegroundColor(255, 255, 255);
		
		setAutoThreshold("Default");
		run("Convert to Mask");
		run("Invert");
		save(output_roi_dir+replace(files[i],".tif","_")+output_roi_suffix+"-binary.tif");

		//analyse and save
		run("Analyze Particles...", "size=0.0001-Infinity circularity=0.5-1.00 show=Nothing display exclude clear summarize");
		close();
		if(isOpen("Results")) selectWindow("Results");
		saveAs("Results", output_roi_dir+replace(files[i],".tif","_")+output_roi_suffix+".csv");
	}
	else{
		close();
	}
}

//if(isOpen("Summary")) selectWindow("Summary");
//saveAs("Results", output_roi_dir+"Summary_"+output_roi_suffix+".csv");


function eraseNonROIPixels()
{
		run("Make Inverse");
		setForegroundColor(255, 255, 255);
		fill();
		run("Make Inverse");
		roiManager("deselect");
		roiManager("Delete");
		roiManager("Add");	
}