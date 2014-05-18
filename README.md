Turtle_identification
=====================

Template creation and matching of Western Painted Turtles
Code written by Kirsten Dohmeier for CENG 421 (Computer Vision) at the Univerity of Victoria, BC, Canada in March 2012. 
Rerpot by Michel van Eekelen and Kirsten Dohmeier

This project makes use of an active contouring method by Ritwik Kumar, Harvard University (interate.m)
http://www.mathworks.com/matlabcentral/fileexchange/28109-snakes--active-contour-models

A database of 62 images of 21 different western painted turtles was used

To run:

place database images to be analysed in turtles subfolder
ensure the orientation of turtles is consistent and the line of symmetry approximately horizontal

run iterTemplate >>iterTemplate
	this will create template images of the selected turtles in the templates subdirectory

run iterCompare >>iterCompare
	this will compare each image in the templates directory with all others in that directory
	and create an image in the Output subdirectory. The ouput shows the image to be matched 
	and the three images with the highest correlation coefficients to the one in question

**********************

TEMPLATES: Contains the templates generated from running iterTemplate for all database images

OUPUTS: Contains the output for comparing each of the database images with all other database images
	ie. the three images with the highest correlation coefficients
