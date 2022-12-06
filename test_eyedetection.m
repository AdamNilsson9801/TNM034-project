clear
im = imread("images/DB2/cl_04.jpg");
im = im2double(im); % måste konvertera den till double innan vi skickar till facemask, för eyedetect gör det ingen skillnad
imshow(im);
[eye1, eye2] = eyedetectionV2(im);
disp(eye1);
disp(eye2);

