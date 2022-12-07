function faceMask = skinDetection(im)

[columns, rows, channel] = size(im);

%RGB to HSV, separate
HSV = rgb2hsv(im);
H = HSV(:,:,1);

%RGB to YCgCr, separate channels
YCgCr = rgb2ycgcr(im);
Y = YCgCr(:,:,1);
Cg = YCgCr(:,:,2);
Cr = YCgCr(:,:,3);

%Convert image to binary image
faceMask = im2bw(im);

for i = 1:1:columns
    for j = 1:1:rows
        if ( Y(i,j) > 110/255.0 )
            if ( 90/255.0 < Cg(i,j) ) && ( Cg(i,j) < 125/255.0)
                if ( 135/255.0 < Cr(i,j) ) && ( Cr(i,j) < 175/255.0)
                    %if ( 0.05 < H(i,j) ) && ( H(i,j) < 0.9412)
                        faceMask(i,j, :) = 1;
                    %end
                
                end
            else, faceMask(i,j, :) = 0;
                
            end
        else, faceMask(i,j, :) = 0;
        end
    end
end

%Create 2 structure elements
se = strel('disk',4);
se2 = strel('disk',9);
se3 = strel('disk',31);
se4 = strel('square',25);


% Morphological operations

%imshow(faceMask);
faceMask = imopen(faceMask, se);
faceMask = imclose(faceMask, se2);
faceMask = imopen(faceMask, se2);

faceMask = imdilate(faceMask, se3);
faceMask = imerode(faceMask, se3);
faceMask = imerode(faceMask, se4);
faceMask = imdilate(faceMask, se4);



%imshow(faceMask);
%Check result
%C = imfuse(im,faceMask,'falsecolor','Scaling','independent'); imshow(C)
blobs = regionprops(faceMask,'Area', 'PixelList');
    
    if isempty(blobs)
        centroid = [0,0];
        disp('No face was found')
    else
        [~,ind] = max(cat(1,blobs.Area));
        pixels = blobs(ind).PixelList; 
    end

%Create mask of the largest blob
faceMask = maskFromMatrix(pixels, im);    
    
end

