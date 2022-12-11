function centroid = mouthDetection(im)
%MOUTHDETECTION takes in a RGB image and returns x and
%y position of the mouth

%Excract columns and rows
[columns, rows] = size(im);

%Convert to YCbCr color space
im_2 = rgb2ycbcr(im);
Cb = im_2(:,:,2);
Cr = im_2(:,:,3);
    
%Using formulas for mouth map
Cr_2 = power(Cr,2);
Cr_Cb = Cr./Cb;
    
num = (sum(sum(Cr_2)))/(columns*rows);
den = (sum(sum(Cr_Cb)))/(columns*rows);
n = 0.95*(num/den);
    
a = power(Cr_2-n*Cr_Cb,2);
mouthMap = Cr_2.*a;
 
%Normalize image by max value
mouthMap = mouthMap/(abs(max(mouthMap(:))));

%Structure elements
se = strel('disk', 15);
se2 = strel('rectangle', [10 60]);
se3 = strel('rectangle', [2 10]);
se4 = strel('rectangle', [40 2]);
    
%Morphological operations   
mouthMap = imdilate(mouthMap, se);
mouthMap =  (mouthMap > 0.5) & (mouthMap < 0.9);    %Thresholding image
   
   
mouthMap = imerode(mouthMap, se3);
mouthMap = imdilate(mouthMap, se);
mouthMap = imfill(mouthMap, 'holes');
mouthMap = imerode(mouthMap, se2);
mouthMap = imdilate(mouthMap, se4);
mouthMap = imerode(mouthMap, se4);

%Extract area and centroid properties from all blobs
blobs = regionprops(mouthMap,'Area','Centroid');
    
if isempty(blobs)   %If no blobs was found, display error message
    centroid = [0,0];
    disp('No mouth was found')
else
    [~,ind] = max(cat(1,blobs.Area));   %Get index of the largest blob
    centroid = blobs(ind).Centroid;     %Get the centroid of the largest blob
end
   
end