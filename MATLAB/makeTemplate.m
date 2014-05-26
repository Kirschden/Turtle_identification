function [imTemplate] = makeTemplate(BW, imgFG, imgName)
%
%Function finds the centre line of the turtle
%Function centres turtle and rotates image so that centre line of
%turtle is horizontal (based off centroid and orientation of best fit
%elipsoid)
%
%INPUTS: BW - binary image
%        imgFG - foreground of BW image
%        imgName - name of image to be processed
%
%OUTPUTS: imTemplate - centred and rotated version of BW image
%
    [M N] = size(BW);
    %pad foreground image and BW image to ensure resizing is within bounds
    imgFG = padarray(imgFG, [round(M/2), round(N/2)], 0);
    BW = padarray(BW, [round(M/2), round(N/2)], 0);
    [M N] = size(BW);

    %erode foreground image
    se = strel('rectangle', [2 20]);
    imgCentre = imerode(imgFG, se);
    se = strel('disk', 1);
    imgCentre = imerode(imgCentre, se);
  
    %remove vertical components with |orientation| > 20 degrees
    removeVertical(imgCentre, 20);
   
    se = strel('line', 30, 0);
    imgCentre = imdilate(imgCentre, se);
      
    imgCentre = remove(imgCentre);
     
    se = strel('line', 30, 0);
    imgCentre = imdilate(imgCentre, se);
    se = strel('line', 2, 90);
    imgCentre = imdilate(imgCentre, se);      

    L = bwlabel(imgCentre);
    mja = regionprops(L, 'majoraxislength');
    mna = regionprops(L, 'minoraxislength');

    %find label of centre line components
    [m n] = size(mja);
    mj = cell2mat(struct2cell(mja));
    mn = cell2mat(struct2cell(mna));
    x = -1;
    %find label of component with max MajorAxisLength/MinorAxiLength
    for i = 1:m
        if mj(i)/mn(i) > x
            x = mj(i)/mn(i);
            label = i;
        end
    end
       
    %remove all other components
    imgCentre = (L == label);
        
    L = bwlabel(imgCentre);
    s = regionprops(L, 'Orientation', 'Centroid');
        
    xbar = round(s(1).Centroid(1));
    ybar = round(s(1).Centroid(2));
    theta = s(1).Orientation;
    
    BW = imgCrop(BW, xbar, ybar); 
    BW = imrotate(BW, -theta);
    
    [M N] = size(BW);
        
    L = bwlabel(imgCentre);
    s = regionprops(L, 'MajorAxisLength');
    
    a = s(1).MajorAxisLength/1.6;
    b = s(1).MajorAxisLength/2.6;
    
    %crop image so that centroid of centre line component is at centre of
    %image
    BW = BW(round(M/2-1.5*b):round(M/2+1.5*b),round(N/2-1.5*a):round(N/2+1.5*a));

    %resize image based on major axis length of centre component
   	imTemplate = imresize(BW, [300, 300*a/b]);
    
    %write template image to templates folder
    imwrite(imTemplate, strcat('templates/',imgName), 'JPEG')
end


