# wallaby
a collection of imagej macros I used to (a) stitch and (b) accelerate opening, closing and saving of files for a semi-automated analysis of 2d images of bone histology

### what it does

`quick-stitch.ijm` 
iterates through all folders in a directory and uses the grid/collection plugin
(S. Preibisch, S. Saalfeld, P. Tomancak (2009) "Globally optimal stitching of tiled 3D microscopic image acquisitions", Bioinformatics, 25(11):1463-1465) to try and stitch together all tiff images within each folder.

`basic-analysis.ijm` 
lets the user specify 
   * an input folder which contains the tiff images to analyse
   * an (optional) input folder with contains previously stored ROIs 
   * an output folder
   * an input ROI suffix (only zip files whose name ends in this will be used)
   * an output ROI suffix
and saves 
   * the manually drawn rois as zip files ending in output ROI suffix
   * the created binary images as tiffs ending in output ROI suffix
   * the results of the imageJ analyze Particles function (https://imagej.nih.gov/ij/docs/menus/analyze.html#ap) as csv files
The scale is hard-coded into the macro, as all my images were taken at the same magnification.
Empty selections are ignored, the code just continues to execute.
Particles touching the image boundary are not counted.

`subtract-two-images-and-analyse-difference.ijm` 
iterates through user-specified "Minuend" and "Subtrahend" directories and subtracts images in "Subtrahend" from corresponding images in "Minuend" and writes the difference image into a user-specified "Difference" directory. I
mages need to match user-specified suffixes. 
Afterwards, the imageJ analyse Particles function (https://imagej.nih.gov/ij/docs/menus/analyze.html#ap) is run on the difference images and the results are stored as a csv file. Particles touching the image boundary are not counted.

### name
The name is chosen because when I measure secondary osteons on lots of images, I sometime feel like a stoned wallaby making crop circles in a poppy field (http://news.bbc.co.uk/1/hi/world/asia-pacific/8118257.stm).
