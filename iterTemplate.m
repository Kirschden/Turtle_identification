function [] = iterTemplate()
%
%Function iterates through all files in the turtles directory to create
%temples in the templates directory
%
    close all
    listing = dir('turtles'); %get listing of files in turtles directory
    [M N] = size(listing);
    for i = 3:M %for each image -> starts from 3 to acount for . and .. directories
        [BW, imgFG] = snake(strcat('turtles/', listing(i).name));
        makeTemplate(BW, imgFG, listing(i).name);
    end
end

