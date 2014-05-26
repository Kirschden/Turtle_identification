function [] = iterCompare()
%
%Function iterates through all images in the templates folder 
%and calles the compare function to find the correlation between images
%
    close all
    listing = dir('templates');
    [M N] = size(listing);
    for i = 3:M-1
        compare(listing(i).name);
    end
end