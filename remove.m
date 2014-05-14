function [BW] = remove(BW)   
%
%Function removes components of BW with major axis length less than half 
%the maximum major axis length of the components in the image
%
%INPUTS: BW - binary image
%
%OUTPUTS: BW - input binary image with components with a major axis length
%              less than half the maximum major axis length of all
%              components removed
    L = bwlabel(BW,4);
    s = regionprops(L, 'MajorAxisLength');
    [M N] = size(s);
    m = cell2mat(struct2cell(s));
    minMjAxisLen = max(m)/2;
    for i = 1:M
        if m(i) < minMjAxisLen
            BW(L==i) = 0;
        end
    end
    L = bwlabel(BW,8);
end
