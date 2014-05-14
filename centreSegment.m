function [BWcentre] = centreSegment(BW)
%
%Function uses morphological opening and closing to segment centre line
%of the turtle and returns an image with only the centre line component
%
%INPUTS: BW - Binary template image where turtle is centred in image
%
%OUTPUTS: BWcentre - Binary image containing one component: the centre
%                    line of the turtle
    se = strel('disk', 2);
    BW = imerode(BW, se);
    [M N] = size(BW);
    L = bwlabel(BW);
    
    %set BW equal to the component at or closest to the centre of image BW
    dist = bwdist(BW, 'cityblock');
    d = dist(M/2, N/2);
    if d == 0
        i = L(M/2, N/2);
    else
        temp = L(M/2-d:M/2+d,N/2-d:N/2+d);
        i = max(max(temp));
    end     
    BW = (L==i);

    %opening to detach centre component from other components
    se = strel('line', 10, 0);
    BW = imopen(BW, se);
    %closing to combine components of centre segment
    se = strel('line', 20, 0);
    BW = imclose(BW, se);
    
    %set BW equal to the component at or closest to the centre of image BW
    L = bwlabel(BW);
    dist = bwdist(BW, 'cityblock');
    d = dist(M/2, N/2);
    if d == 0
        i = L(M/2, N/2);
    else
        temp = L(M/2-d:M/2+d,N/2-d:N/2+d);
        i = max(max(temp));
    end
    BWcentre = (L==i);
end

