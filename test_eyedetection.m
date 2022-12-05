clear
im = imread("DB1/db1_01.jpg");
im = im2double(im); % måste konvertera den till double innan vi skickar till facemask, för eyedetect gör det ingen skillnad
% facemask = skinDetection(im);
% im = im.*facemask;
imshow(im);
[eye1, eye2] = eyedetectionV2(im);
disp(eye1);
disp(eye2);

