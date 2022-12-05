function [eye1, eye2] = eyedetectionV2(im)
% EYEDETECTIONV1 takes image input and returns two 1x2 vectors, one for each eyes x,y position.

% konvertera bilden till NTSC format för att enklare hitta eye dot genom chromasitet 
% använd endast chromasity kanalen
YIQim = rgb2ntsc(im);
imChrom = YIQim(:,:,1);

% bilddimensioner, används för att normalisera distanser för bilderna
im_height = length(imChrom(:,1)); im_width = length(imChrom(1,:));
im_area = im_height*im_width;
im_dist = round(sqrt(im_area));

% morfologi, dilation följt av erosion med 9x9 element och tar differensen
se1 = strel('disk', 9);
imOp = imopen(imChrom,se1);
imCl = imclose(imChrom,se1);
imDiff = imCl - imOp;

% Adaptiv tröskla genom bilden tills 6 blobbar med min area eller 2 med max area
thresh = 0.8; step = 0.05;
blob_minarea = round(im_area/10000); blobs_maxarea = round(im_area/1000);
counter_minarea = 0; counter_maxarea = 0;
imThresh = imDiff(:,:) > thresh;
blobs = regionprops(imThresh);
blobs_amount = length(blobs(:)); % det här värdet används alltid

while counter_minarea < 7 && counter_maxarea < 2 && thresh > 0.35
    counter_minarea = 0; counter_maxarea = 0;
    thresh = thresh - step;
    imThresh = imDiff(:,:) > thresh;
    blobs = regionprops(imThresh);
    blobs_amount = length(blobs(:));
    for i = 1:1:blobs_amount
        if blobs(i).Area > blob_minarea
            counter_minarea = counter_minarea + 1;
            if blobs(i).Area > blobs_maxarea
                counter_maxarea = counter_maxarea + 1;
            end
        end
    end
end

% Gör ögon tydligare, ta bort noise genom morfologisk stängning
se2 = strel('disk',3);
imThresh = imopen(imThresh,se2);
imThresh = imclose(imThresh,se2);

% ta bort blobbar från kanten som är 1/4 över under, är för långa
% Omringar området som tas bort med en låda vilket kan överlappa ögats blob
maxLength = im_dist/6;
h_remove = round(im_height/4);
blobs = regionprops(imThresh);
blobs_amount = length(blobs(:));
if blobs_amount > 2
    for i = 1:1:blobs_amount
        box = blobs(i).BoundingBox;
        if blobs(i).Centroid(2) < h_remove || blobs(i).Centroid(2) > im_height - h_remove || box(3) > maxLength || box(4) > maxLength
            imThresh(round(box(2)):round(box(4) + box(2)-1), round(box(1)):round(box(3) + box(1)-1)) = 0;
        end
    end
end

% Testar varje blobb mot varandra. Om längre än 1/3.5 av bild +- samt +-15 grader, ta bort
optDist = round(im_dist/3.5); tol = round(optDist/5);
blobs = regionprops(imThresh);
blobs_amount = length(blobs(:));
blob_current = 1;
while blob_current < blobs_amount + 1 && blobs_amount > 2
    blob_candidate = false;
    for i = 1:blobs_amount
        % sqrt((x1-x2)^2+(y1-y2)^2)
        % asin(motstående katet/hypotenusa) = vinkel i radianer
        hypotenuse = sqrt((blobs(blob_current).Centroid(1) - blobs(i).Centroid(1))^2 + (blobs(blob_current).Centroid(2) - blobs(i).Centroid(2))^2);
        perpendicular = abs(blobs(blob_current).Centroid(2) - blobs(i).Centroid(2));
        angle = asin(perpendicular/hypotenuse);
        if i ~= blob_current && abs(optDist - hypotenuse) < tol && angle < 0.26 % är detta rätt?
            blob_candidate = true;
        end
    end
    if blob_candidate == false
        box = blobs(blob_current).BoundingBox;
        imThresh(round(box(2)):round(box(4) + box(2)-1), round(box(1)):round(box(3) + box(1)-1)) = 0;
    end
    blob_current = blob_current + 1;
end

% DEBUG: Se resultat av algoritmen. Det borde endast finnas 2 vita blobbar som är ögonen 
% figure; imshow(imThresh);

% Få ögats position med regionprops, returnera värden
eyeStruct = regionprops(imThresh);
eyes_amount = length(eyeStruct(:));
if eyes_amount == 2
    eye1 = eyeStruct(1).Centroid;
    eye2 = eyeStruct(2).Centroid;
else
    eye1 = zeros(1,2);
    eye2 = zeros(1,2);
    disp("ERROR: Could not find the eyes");
    imshow(imThresh);
end
end