function [xs ys] =  makeElipse(img, M, N)
%
%Function initilizes points on image to perform active contouring
%
%INPUTS: img- image to be segmented with active contouring
%
    x = 2:N/8:N;
    y = (0.8*M)/2 + (0.5*M)/2.*sqrt(1 - (x - N/2).^2/(N/2).^2);
    x(1) = x(1); 
    x(9) = x(8) + x(2) - x(1); 
    y(1) = y(1);
    y(9) = y(1);
    x = 1.1*[x N-x] + N/14;
    y = [y+M/2, -y+M/1.4];
    
%     figure(1)
%     imshow(img, [])
%     hold on
%     plot(x,y, 'ro')
%     hold off
    
    xy = [x;y];
    xy(:,19) = [xy(1,1);xy(2,1)];
    
    %interpolate points and create spline
    t = 1:19;
    ts = 1: 0.1: 19;
    xys = spline(t,xy,ts);
    size(xys)
    xs = xys(1,:);
    ys = xys(2,:);
end

