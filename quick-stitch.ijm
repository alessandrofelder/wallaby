  dir = getDirectory("Choose a Directory ");
  stitchInAllSubDirs(dir); 

  function stitchInAllSubDirs(dir) {
     list = getFileList(dir);
     for (i=0; i<list.length; i++) {
        if (endsWith(list[i], "/"))
           subDir=dir+list[i];
           name = getFileList(subDir);
           if(name.length >1) {
           		run("Grid/Collection stitching", "type=[Unknown position] order=[All files in directory] directory=["+subDir+"] output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.95 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 ignore_z_stage subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)]image_output=[Fuse and display]");
     	   		//run("Grid/Collection stitching", "type=[Sequential Images] order=[All files in directory] directory=["+subDir+"] output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.85 max/avg_displacement_threshold=1.5 absolute_displacement_threshold=3.50 ignore_z_stage subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
     	   		print(name[3]+"");
     	   		saveAs("tiff", dir+name[3]+"");
  		   		close();
           }
     }	   
  }

