function [img] = imgCrop(img, xbar, ybar)
%
%Function crops image such that the centre of the image is at [xbar ybar]
%
%INPUTS: img - image to be cropped
%        [xbar ybar] - coordinates of centre of output image
%
%OUTPUTS: img - cropped version of input image
%
    [M N] = size(img);
    
    if xbar < N/2
        img = img(:,1:2*xbar);
    elseif xbar > N/2
        img = img(:,-N+2*xbar:N);
    end    
        
    if ybar < M/2
        img = img(1:2*ybar,:);
    elseif ybar > M/2
        img = img(-M+2*ybar:M,:);
    end

end

