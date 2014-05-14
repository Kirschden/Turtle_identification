function [BW, imgFG] = snake(imgName)
%
%Function performs preprocessing for images
%Function initializes contour to iterate through active contouring
%Uses the function iterate by Ritwik Kumar, Harvard University 2010
%   to perform active contouring
%
%INPUTS: imgName - name of image file to apply active contouring to
%
%OUTPUTS: BW - binary image of input image
%         imgFG - foreground image after active contouring
%
    
    image = imread(imgName);
    image = imresize(image, 0.2); %resize image to one fifth the size
    image = image(:,:,1); %get red component of image
    image = adapthisteq(image); %perform contrast enhancement
    [M N] = size(image);
    level = graythresh(image); %get global threshold level using Otsu's method
    BW = im2bw(image,level); %get binary image
    
    %pad the outside of the red component image and the BW image to assure
    %that the active contour algorithm doesn't go outside of the image bounds
    image = padarray(image, [round(M/8), round(N/8)], 'replicate');
    BW = padarray(BW, [round(M/8), round(N/8)], 0);

    %perform gaussian smoothing on red component image
    smask = fspecial('gaussian', ceil(15), 5);
    smth = filter2(smask, image, 'same');

    [xs ys] = makeElipse(image, M, N);
    %Do active contouring and return x and y components of active contour outline
    [xs, ys] = iterate(smth, xs, ys, 1, 2, .2, .22, .5, .5, .5, 150);
  
    %create image to extract foreground (ie. turtle) of BW image
    imgFG = zeros(size(image));
    %set pixles at x y  components of active contour to 1
    for i = 1:size(xs)
        imgFG(round(ys(i)), round(xs(i))) = 1;
    end

    %use dilation, filling, and erosion to create foreground image mask
    se = strel('disk', 12);
    imgFG = imdilate(imgFG, se);
    imgFG = imfill(imgFG, 'holes');
    se = strel('disk', 14);
    imgFG = imerode(imgFG, se);
    %remove background of BW turtle image
    imgFG = BW.*imgFG;
end

    