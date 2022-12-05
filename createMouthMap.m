function [mouthMap, centroid] = createMouthMap(im)
%CREATE_MOUTH_MAP takes in a RGB image (croped and rotated), returns x and
%y position of the mouth

originalImage = im;

%Excract columns and rows
[columns, rows] = size(im);

%Convert to YCbCr color space
    im_2 = rgb2ycbcr(im);
    Cb = im_2(:,:,2);
    Cr = im_2(:,:,3);
    
    Cr_2 = power(Cr,2);
    Cr_Cb = Cr./Cb;
    
    num = (sum(sum(Cr_2)))/(columns*rows);
    den = (sum(sum(Cr_Cb)))/(columns*rows);
    n = 0.95*(num/den);
    
    a = power(Cr_2-n*Cr_Cb,2);
    mouthMap = Cr_2.*a;
    
    mouthMap = mouthMap/(abs(max(mouthMap(:))));
    %imshow(mouthMap);
    se = strel('disk', 15);
    se2 = strel('rectangle', [10 60]);
    se3 = strel('rectangle', [2 10]);
    se4 = strel('diamond', 5);
    
    
    mouthMap = imdilate(mouthMap, se);
    mouthMap =  (mouthMap > 0.5) & (mouthMap < 0.9);
   
   
    mouthMap = imerode(mouthMap, se3);
    mouthMap = imdilate(mouthMap, se);
    mouthMap = imfill(mouthMap, 'holes');
    mouthMap = imerode(mouthMap, se2);
    
    blobs = regionprops(mouthMap,'Area','Centroid');
    
    if isempty(blobs)
        centroid = [0,0];
        disp('No mouth was found')
    else
        [~,ind] = max(cat(1,blobs.Area));
        centroid = blobs(ind).Centroid;
    end
   
    
 
end