function [img] = cropImage(BW, imgCentre)
%
%Function segments foreground of BW with an elipse describing foreground
%The elipse position and size are based on the centroid and majoraxis
%length of component in imgCentre.
%Function also resized image to a standard size for comparison with other
%images
%
%INPUTS: BW - binary image of centred and rotated turtle
%        imgCentre - binary image of the centre line component of the
%                    turtle corresponding to image BW
%
%OUTPUTS: img - foreground segmented and resized image BW
%

    [M N] = size(BW);
        
    L = bwlabel(imgCentre);
    s = regionprops(L,'MajorAxisLength', 'MinorAxisLength');
        
    xbar = round(N/2);
    ybar = round(M/2);
                
    phi = linspace(0,2*pi,1000);
    cosphi = cos(phi);
    sinphi = sin(phi);
    a = s(1).MajorAxisLength/1.6;
    b = s(1).MajorAxisLength/2.6;
    xy = [a*cosphi; b*sinphi];

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;
        
    BG = zeros(M, N);
    for i = 1:1000
        BG(round(y(i)), round(x(i))) = 1;
    end

    BG = imfill(BG);
    se = strel('disk', 6);
    BG = imdilate(BG, se);
    BG = imfill(BG, 'holes');
    se = strel('disk', 7);
    BG = imerode(BG, se);
    BW = im2bw(BW);
    BW = BW.*BG;

    img = BW(round(M/2-b):round(M/2+b),round(N/2-a):round(N/2+a));

    img = imresize(img, [300, 300*a/b]);
end

