inImage = imread(['images\DB3\db1_16.jpg']);
inImage = im2double(inImage);
originalImage = inImage;
subplot(1,2,1);
imshow(originalImage);
inImage = AWB_max(inImage);
id = tnm034(inImage);
disp(id);

faceMask = skinDetection(inImage);
imFace = inImage.*faceMask;
[eye_x, eye_y] = eyedetectionV2(imFace);
 im = normalizeFace(inImage, [eye_x(1) eye_y(1)],[eye_x(2) eye_y(2)]);
 subplot(1,2,2);
imshow(im);
