function [img] = removeVertical(img, theta)
%
%Function removes connected components with orientation > theta
%and orientation < -theta
%
%INPUTS: img - binary image
%        theta - orientation in degrees at which component is considered
%                vertical and will be removed with 0 being the positive
%                x-axis with range from -90 to 90.
    L = bwlabel(img,4);
    orient = regionprops(L, 'Orientation');
    [H W] = size(orient);
    m = cell2mat(struct2cell(orient));
    for i = 1:H
        if abs(m(i)) > theta
            img(L==i) = 0;
        end
    end
end

