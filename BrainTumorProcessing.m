clc;
clear;
% import square segmentation library
addpath('C:\Users\ram8\Dropbox\squareSegmentation\BrainTumor'); % path to samples

nFiles = 200;
currAlgo = 'ray'; % square or RG

dTetta=pi/2;

K = 32;
dFi=pi/K;

% SqSeg options

distRG = 22.9; % RG params

timeCoef = 2.2; % time coeff

isVisualize=false; % vizualize images & masks
isSaveImages = true;
isSaveResults = true; 

results=[];
errorCount = 0;
failCount=0;

for i= 1:nFiles
        % reading and setting start point
        sample = load([num2str(i) '.mat']);
        img = sample.cjdata.image;
        img = imnorm(img, 'norm255');
        mask=sample.cjdata.tumorMask;
        startPoint = GetStartPointByMask(mask); 
        
        %testing...
        tic();
        error = 0;
        if (strcmp(currAlgo, 'ray')) % square seg testing
            image3D = zeros(size(img, 1), size(img, 2), 2);
            image3D(:,:,1) = img';
            points = [];
            startPoint(1,3) = 1;
            points=EmitRays(double(image3D),points,startPoint,dTetta,dFi);
            pointsForSpline = points(:,1:2); % only for xy coords
            pointsForSpline(end+1,:) = pointsForSpline(1,:);
            spline = cscvn(pointsForSpline');
            sqMask = Spline2Mask(spline,size(img));
        else
           % RG testing
           sqMask = regiongrowing(img, startPoint(1), startPoint(2), distRG);
        end
        
        %morphology
        %se = strel('disk', 9);
        %sqMask = imclose(sqMask, se); 
        time = toc() / timeCoef;
    
        % accuracy calculating 
        currAccuracy=CompareMasks(sqMask,mask);
        if (currAccuracy.dice > 0.5)   
            results(end+1,:)=[i, time, currAccuracy.dice];
        else
            failCount=failCount+1;
        end
        
        % additional blocks vizualization and save
        if(isVisualize)
            close all;
            %figure('units','normalized','outerposition',[0 0 1 1])
            subplot(2,2,1);
            imshow(img/255);
            title('Image');
            
            subplot(2,2,2);
            imshow(mask);
            title('Original Mask');
            
            subplot(2,2,3);
            imshow(sqMask);
            title([currAlgo ' Mask']);
            pause(0.5);
        end
        
        if (isSaveImages)
            folderPath = ['images\' num2str(i)];
            if (exist(folderPath, 'dir') ~= 7)
                mkdir(folderPath);
            end
            imwrite(img / 255, [folderPath '\img.tiff']);
            imwrite(mask, [folderPath '\orig.tiff']);
            if (strcmp(currAlgo, 'ray'))
               fileName = ['ray_' num2str(K) '.tiff']; 
            else
              fileName = ['RG.tiff'];  
            end
            imwrite(sqMask, [folderPath '\' fileName]);
        end
end
total=sum(results(:,3));
totalCount=size(results,1);
total=total/totalCount;
total

failCount
errorCount
imhist(results(:,3));

% last string: nImages, 1square fail, acc < 0.5
results(end+1, :) = [total, 0, 0];
results(end+1, :) = [nFiles, errorCount, failCount];
%%
if (isSaveResults)
    %path = '';
    if (strcmp(currAlgo, 'ray'))
        fileName = ['ray_' num2str(K) '.mat']; 
    else
        fileName = ['RG.mat'];  
    end
    save([ fileName], 'results');
end
