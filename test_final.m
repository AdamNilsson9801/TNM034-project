inImage = imread(['images\DB1\db1_06.jpg']);
inImage = im2double(inImage);
originalImage = inImage;
subplot(1,2,1);
imshow(originalImage);
inImage = AWB_max(inImage);
id = tnm034(inImage);
disp(id);

[eye_l,eye_r] = eyedetectionV2(inImage);
eye_x = [eye_l(1),eye_r(1)];
eye_y = [eye_l(2),eye_r(2)];

im = normalizeFace(inImage,eye_x,eye_y);
subplot(1,2,2);
imshow(im);

%%

% filepath = "images/DB2";
% [Fisher_faces,class_weights] = generateFisherFaces(filepath,16)