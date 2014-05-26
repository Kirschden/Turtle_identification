function [img] = centreImage(img, imgCentre)
%
%Function crops img to centre the turtle
%The 'centre' is the centroid of the single component centre line image
%imgCentre
%
%INPUTS: img - image to be cropped and centred
%        imgCentre - image containing a single component which represents
%                    the centre line of the turtle
%
%OUTPUTS: img - cropped and centred image coresponsding to centroid of
%               imgCentre
    [M N] = size(imgCentre);
    L = bwlabel(imgCentre);
    s = regionprops(L, 'Orientation', 'Centroid');

    xbar = round(s(1).Centroid(1));
    ybar = round(s(1).Centroid(2));
    theta = s(1).Orientation;

    if xbar < N/2
        img = img(:,1:2*xbar);
    elseif xbar > N/2
        img = img(:,-N+2*xbar:N);
    end    

    if ybar < M/2
        img = img(1:2*ybar,:);
    elseif ybar > M/2
        img = img(1-M+2*ybar:M,:);
    end

    img = imrotate(img, -theta);
end

