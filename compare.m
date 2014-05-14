function [] = compare(imgName)
%
%Function finds correlation between image imgName in templates directory
%and all other images in that directory
%
%INPUTS: imgName - name of image to be matched
%
    img = imread(strcat('templates/', imgName));
    imgCentre = centreSegment(img);
    [M N] = size(imgCentre);
    img = padarray(img, [round(M/2), round(N/2)], 0);
    imgCentre = padarray(imgCentre, [round(M/2), round(N/2)], 0);
    
    imgCentred = centreImage(img, imgCentre);
    imgCentred = cropImage(imgCentred, imgCentre);

    %create listing of all files in the templates directory
    listing = dir('templates');
    [M N] = size(listing);
    R = [-1 -2 -3];
    imgMatch = cell(3);
    %iterate through files
    for i = 3:M-1
        imgTempName = listing(i).name;
        imgTemplate = imread(strcat('templates/', imgTempName));
        imgTempCentre = centreSegment(imgTemplate);
        [M N] = size(imgTempCentre);
        imgTemplate = padarray(imgTemplate, [round(M/2), round(N/2)], 0);
        imgTempCentre = padarray(imgTempCentre, [round(M/2), round(N/2)], 0);
        
        imgTemplate = centreImage(imgTemplate, imgTempCentre);
        imgTemplate = cropImage(imgTemplate, imgTempCentre);
        
        correlation = corr2(imgCentred,imgTemplate);
        
        figure(1)
        subplot(2,2,2)
        imshow(imgTemplate)
        subplot(2,2,1)
        imshow(imgCentred)
        subplot(2,2,3)
        imshow(imread(strcat('turtles/', imgName)))
        title(imgName)
        subplot(2,2,4)
        imshow(imread(strcat('turtles/', imgTempName)))
        title(strcat(imgTempName, ' Correlation: ', num2str(correlation)))
        
        %create array containing top three correlation coefficients
        %create cell containing the name of images with the top three
        %correlation coefficients
        if correlation > min(min(R)) && correlation ~= 1
            index = find(R==min(min(R)));
            R(index) = correlation;
            imgMatch{index,1} = imgTempName;
        end
    end
   
    %determine indexes of the images with the top three correlation
    %coefficient which are iMax, iMid, and iMin in descending order of
    %correlation
    iMax = find(R==max(max(R)));
    iMin = find(R==min(min(R)));
    if iMax + iMin == 3 
        iMid = 3; 
    end
    if iMax + iMin == 4 
        iMid = 2; 
    end
    if iMax + iMin == 5 
        iMid = 1;
    end
    
    figure(2)
    subplot(2,2,1)
    imshow(imread(strcat('turtles/', imgName)))
    title(imgName)
    subplot(2,2,2)
    imshow(imread(strcat('turtles/', imgMatch{iMax,1})))
    title(strcat('Best match: ',imgMatch{iMax,1}, ' with Correlation: ', num2str(R(iMax))))
    subplot(2,2,3)
    imshow(imread(strcat('turtles/', imgMatch{iMid,1})))
    title(strcat('Second match: ',imgMatch{iMid,1}, ' with Correlation: ', num2str(R(iMid))))
    subplot(2,2,4)
    imshow(imread(strcat('turtles/', imgMatch{iMin,1})))
    title(strcat('Third match: ',imgMatch{iMin,1}, ' with Correlation: ', num2str(R(iMin))))
    eval(['print -djpeg ',strcat('Output/', imgName)])
end