%%%%%%%%%%%%%%%%%%%%%%%%%%
function id = tnm034(im)
%
% im: Image of unknown face, RGB-image in uint8 format in the
% range [0,255]
%
% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,…,‘16’ for the persons belonging to ‘db1’
% and ‘0’ for all other faces.
%
% Your program code.
%%%%%%%%%%%%%%%%%%%%%%%%%%

im = im2double(im);

%Get the position of the eyes
[eye_l,eye_r] = eyedetectionV2(im);
eye_x = [eye_l(1),eye_r(1)];
eye_y = [eye_l(2),eye_r(2)];

%Normalize the face and reshape to vector 
im = normalizeFace(im,eye_x,eye_y);
im = reshape(im,400*300,1);


%Load in the fisher face and class_weights 
load("FisherFace_weights.mat", "Fisher_faces", "weight_class");

%Get the image weights 
weight_image = Fisher_faces'*im;
N_classes = 16;

euclidian_distance_fish_class = zeros(N_classes,1);
for class_index = 1:N_classes
    euclidian_distance_fish_class(class_index) = norm(weight_image - weight_class(:,class_index));
end
[minDist,id] = min(euclidian_distance_fish_class);

distance_threshold = 9.0;

if minDist > distance_threshold
    id = 0;
end


end

