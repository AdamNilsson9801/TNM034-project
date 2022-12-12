inImage = imread(['images\DB0\db0_4.jpg']);
inImage = im2double(inImage);
originalImage = inImage;
subplot(1,2,1);
imshow(originalImage);
inImage = AWB_max(inImage);
id = tnm034(inImage);
disp(id);

faceMask = skinDetection(inImage);
imFace = inImage.*faceMask;
[eye_l,eye_r] = eyedetectionV2(inImage);
eye_x = [eye_l(1),eye_r(1)];
eye_y = [eye_l(2),eye_r(2)];

%Normalize the face and reshape to vector 
im = reshape(im,400*300,1);
subplot(1,2,2);
imshow(im);

%%

% filepath = "images/DB2";
% [Fisher_faces,class_weights] = generateFisherFaces(filepath,16)