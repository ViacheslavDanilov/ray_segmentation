clc;
clear;

%% Setting  parameters
points=[];
dTetta=pi/2;
dFi=pi/32;

data = load('C:\Users\ram8\Dropbox\squareSegmentation\BrainTumor\66.mat');
img = imnorm(data.cjdata.image, 'norm255');
mask = data.cjdata.tumorMask;
imshow(img/255);
[x y] = ginput(1);
startPoint = [y x];


%% Ray generation and processing
image3D = zeros(size(img, 1), size(img, 2), 2);
image3D(:,:,1) = img;
points = [];
startPoint(1,3) = 1;
points=EmitRays(double(image3D),points,startPoint,dTetta,dFi);
pointsForSpline = points(:,1:2); % only for xy coords
pointsForSpline(end+1,:) = pointsForSpline(1,:);
spline = cscvn(pointsForSpline');
sqMask = Spline2Mask(spline,size(img));
figure;
imshow(sqMask);