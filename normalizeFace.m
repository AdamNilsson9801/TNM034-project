function im_norm = normalizeFace(im,eye_x,eye_y)

% Make image grayscale  
im = rgb2gray(im);

eyeDiffVec = [eye_x(2)-eye_x(1) eye_y(2)-eye_y(1)];

%rotate the image 
ang_rad = pi/2 - acos(eyeDiffVec(2)/norm(eyeDiffVec));
ang_deg = ang_rad*180/pi;
rot_im = imrotate(im,ang_deg,'bilinear','crop');

% New eye positions
im_center = size(im)./2;
im_center = [im_center(2) im_center(1)]; % switch x and y 
rot_mat = [cos(-ang_rad) -sin(-ang_rad);sin(-ang_rad) cos(-ang_rad)];
cen2left = [eye_x(1) eye_y(1)] - im_center;
cen2right = [eye_x(2) eye_y(2)] - im_center;

cen2left = rot_mat*cen2left';
cen2right = rot_mat*cen2right';
eye_left = im_center + cen2left';
eye_right = im_center + cen2right';

% Crop the image with the new eye position
eye_diff = eye_right(1) - eye_left(1);
eye_side_ratio = 0.65;
eye_top_ratio = 1.35;
eye_bot_ratio = 1.91;

R_TL = eye_left + [-eye_diff*eye_side_ratio -eye_diff*eye_top_ratio];
R_BR = eye_right + [eye_diff*eye_side_ratio eye_diff*eye_bot_ratio];

cropRect = [R_TL R_BR-R_TL];
crop_im = imcrop(rot_im,cropRect);

% Make the resulution the same for every image:
im_norm = imresize(crop_im,[400,300]);
end

