function im = changeImage(im)

%Get random tone value
toneMin = 0.7;
toneMax = 1.3;
randTone = toneMin + rand*(toneMax - toneMin);
disp('-------------');disp('random tone:');disp(randTone);

%Tone the image
im = im.*randTone;

%Get random scaling value
scaleMin = 0.9;
scaleMax = 1.1;
randScale = scaleMin + rand*(scaleMax - scaleMin);
disp('random scale:');disp(randScale);

%Scale the image
im = im.*randScale;

%Get random rotation
rotationMin = -5;
rotationMax = 5;
randRotation = rotationMin + rand*(rotationMax - rotationMin);
disp('random rotation:');disp(randRotation);disp('-------------');

%Rotate the image
im = imrotate(im, randRotation, 'bilinear'); 
imshow(im);
end