% This code is seperated into sections, run each section seperately. 

% On row 219 manual eyedectection can be skiped by loading the from file.  


%%



%filepath = "Bilder\DB0\DB0\db0_3.jpg";
%filepath = "Bilder\DB1\DB1\db1_04.jpg";
%im = imread(filepath);
%imshow(im)
%figure, imshow(im(:,:,1));

%im = AWB_max(im);

%%----------------Normalize the image---------------------------
% imshow(im);
% im = rgb2gray(im);
% [eye_x,eye_y] = ginput(2); % first left, then right
% eyeDiffVec = [eye_x(2)-eye_x(1) eye_y(2)-eye_y(1)];
% hold on 
% %plot(eye_x,eye_y,'ro');
% 
% %rotate the image 
% ang_rad = pi/2 - acos(eyeDiffVec(2)/norm(eyeDiffVec));
% ang_deg = ang_rad*180/pi;
% 
% rot_im = imrotate(im,ang_deg,'bilinear','crop');
% %figure, imshow(rot_im);
% %hold on 
% 
% % New eye positions  (can be improved) 
% %im_center = size(im(:,:,1))./2; % For color image 
% im_center = size(im)./2; % For grayscale image 
% rot_mat = [cos(-ang_rad) -sin(-ang_rad);sin(-ang_rad) cos(-ang_rad)];
% cen2left = [eye_x(1) eye_y(1)] - im_center;
% cen2right = [eye_x(2) eye_y(2)] - im_center;
% 
% cen2left = rot_mat*cen2left';
% cen2right = rot_mat*cen2right';
% eye_left = im_center + cen2left';
% eye_right = im_center + cen2right';
% 
% %plot(eye_left(1),eye_left(2),'bo');
% %plot(eye_right(1),eye_right(2),'go');
% %plot(eye_x,eye_y,'ro');
% 
% 
% % Crop the image with the new eye position
% eye_diff = eye_right(1) - eye_left(1);
% eye_side_ratio = 0.65;
% eye_top_ratio = 1.35;
% eye_bot_ratio = 1.91;
% R_TL = eye_left + [-eye_diff*eye_side_ratio -eye_diff*eye_top_ratio];
% R_BR = eye_right + [eye_diff*eye_side_ratio eye_diff*eye_bot_ratio];
% cropRect = [R_TL R_BR-R_TL];
% 
% crop_im = imcrop(rot_im,cropRect);
% %figure, imshow(crop_im);
% 
% % Make the resulution the same for every image:
% im_norm = imresize(crop_im,[400,300]);
% figure, imshow(im_norm);

%%----------------Eigenfaces using PCA-------------------------

% Get the filenames of the images in the folder of dirpath 
%dirpath =  "Bilder\DB0\DB0\";
%dirpath =  "Bilder\DB1\DB1\";
% filepath = append(dirpath,'*.jpg');
% imagefiles = dir(filepath);
% im_count = length(imagefiles);
% 
% % Matrix containing all of the images as vectors 
% im_matrix = zeros(400*300,im_count);
% % Vector that is the mean of all the image vectors.
% mean_face = zeros(1,400*300);
% 
% 
% for im_index = 1:im_count 
%     % Read the image 
%     currentImage = imread(append(dirpath,imagefiles(im_index).name));
%     currentImage = im2double(currentImage);
%     figure, imshow(currentImage);
%     [eye_x,eye_y] = ginput(2); % first left, then right
%     
%     % Normalize the image using normalizedFace function
%     currentImage_norm = normalizeFace(currentImage,eye_x,eye_y);
%     
%     % make the image a vector and place it in a matrix
%     im_matrix(:,im_index) = reshape(currentImage_norm,1,400*300);
%     
%     % mean vecor: 
%     mean_face = mean_face + im_matrix(:,im_index)';
%     
%     %figure,imshow(currentImage_norm);
%     close(1) 
% end
% mean_face = mean_face./im_count;
% %figure,imshow(reshape(mean_face,400,300));
% 
% % Calculate the differece between the mean face and each face 
% A = zeros(400*300,im_count);
% for face_index = 1:im_count
%     A(:,face_index) =  im_matrix(:,face_index) - mean_face';
% end 
% C = A'*A;
% [V,D] = eig(C);
% 
% % Sort the eigenvalues and eigenvectors 
% [d,ind] = sort(diag(D));
% D_sort = D(ind,ind);
% V_sort = V(:,ind);
% 
% % Create the eigenfaces 
% U = A*V_sort;
% 
% %The values in the matrix D_sort will determine the importance of the
% % eigenface, this can be used for choosing the eigenfaces to use. 
% Num_eigenFaces = 2;
% eigenFaces = zeros(400*300,Num_eigenFaces);
% for i = 0:Num_eigenFaces-1
%     figure, imshow(reshape(U(:,im_count-i),400,300));
%     eigenFaces(:,i+1) = U(:,im_count-i);
% end

%%
%--------------------Face detection using eigenfaces------------

train_path = "images\DB1\DB1\";
n_ef = 7;
%test_path = "images\DB1\DB1\db1_16.jpg";
test_path = "images\DB0\DB0\db0_4.jpg";

%[ef,mf,cw] = generateEigenfaces(train_path,n_ef);




test_image = imread(test_path);
test_image = im2double(test_image);
figure(123), imshow(test_image);
[eye_x,eye_y] = ginput(2); % first left, then right
close(123);
norm_test_image = normalizeFace(test_image,eye_x,eye_y);
%figure, imshow(norm_test_image);
test_face = reshape(norm_test_image,1,400*300);

%project the test image to the face space 
test_weights = ef'*(test_face - mf)'; 

% compare what face in the training set is closest
n_classes = size(cw); n_classes = n_classes(2);
classDist = zeros(n_classes,1); 
for class = 1:n_classes
    % Euclidean distance
    classDist(class) = norm(test_weights-cw(:,class));
end

[minDist,classIndex] = min(classDist);

if minDist < 500
    disp(classIndex);
    disp(minDist);
else
    disp(0);
    disp(minDist);
end

figure,imshow(rescale(reshape(mf' + ef*test_weights,400,300)));

%%
%---------------------Face detection using Fisher faces-------------

train_path = "images\DB2\";
file_path = append(train_path,'*.jpg');
imagefiles = dir(file_path);
N_classes = 16; 
N_images = length(imagefiles);



% Section 1: Read faces,mean face and Class mean-face
vec_images = zeros(400*300,N_images);
vec_images_class_tracker = zeros(N_images,1);
mean_face = zeros(400*300,1);
N_images_in_class = zeros(N_classes,1);
class_mean_face = zeros(400*300,N_classes);
for im_index = 1:N_images 
    %Read the image
    im_current = imread(append(train_path,imagefiles(im_index).name));
    im_current = im2double(im_current);
    
    %normalize the face, (TODO replace with eyefinding function)
    figure(444), imshow(im_current);
    [eye_x,eye_y] = ginput(2); % first left, then right
    im_current = normalizeFace(im_current,eye_x,eye_y);
    close(444);
    
    %Find what class the image belongs to 
    split_fileName = split(imagefiles(im_index).name,["_","."]);
    im_class = str2double(split_fileName(2));
    
    % Assign image 
    vec_images(:,im_index) = reshape(im_current,400*300,1);
    vec_images_class_tracker(im_index) = im_class; 
    mean_face = mean_face + reshape(im_current,400*300,1);
    N_images_in_class(im_class) = N_images_in_class(im_class) + 1;
    class_mean_face(:,im_class) = class_mean_face(:,im_class) + reshape(im_current,400*300,1); 
end
class_mean_face = class_mean_face(:,:)./N_images_in_class';
mean_face = mean_face./N_images;

%%
%save("db3images.mat",'vec_images','vec_images_class_tracker','mean_face','N_images_in_class','class_mean_face');

% Uncomment this to skip manual eyedetection
%     load("db3images.mat");
%     N_classes = 16;
%     N_images = 54;

%%
% Section 2: Make eigenfaces and project the images
% Calculate the differece between the mean face and each face 
A_im_diff = zeros(400*300,N_images);
for im_index = 1:N_images
    A_im_diff(:,im_index) =  vec_images(:,im_index) - mean_face;
end

% Compute MxM matrix L with eigenvector matix V 
L = A_im_diff'*A_im_diff;
[V_eigen_vector_matrix,eigen_values_diag] = eig(L);

% Make eigenfaces
U = A_im_diff*V_eigen_vector_matrix;

% Sort the eigenfaces
[eigen_values,ind] = sort(diag(eigen_values_diag),'descend');
U_sorted_ef = U(:,ind);

% Normalize the eigenfaces (maybe not needed)
U_norm = zeros(400*300,N_images);
for i = 1:N_images
    %U_norm(:,i) = U_sorted_ef(:,i)./norm(U_sorted_ef(:,i));
end

% Select the N-c most inprotant eigenFaces(N = N_images , c = N_classes)
eigen_faces = U_sorted_ef(:,1:(N_images-N_classes));
%eigen_faces = U_norm(:,1:(N_images-N_classes));


% Project the images and to the eigenfaces subspace
%A(300*400,N), e_f(300*400,N-c), -> im_efs(N-c,N)
im_eigenfacespace = eigen_faces'*vec_images;


mean_face_eigenfacespace = eigen_faces'*mean_face;
%mean_face_eigenfacespace = mean()

class_mean_face_eigenfacespace = eigen_faces'*class_mean_face;



% Section 3: Scatter matricies 

% Calculate the Between-class scatter matrix 
Scatter_between_class = zeros(N_images-N_classes);
for class_index = 1:N_classes
    mean_face_class_diff = class_mean_face_eigenfacespace(:,class_index) - mean_face_eigenfacespace;
    Scatter_between_class = Scatter_between_class + (mean_face_class_diff*mean_face_class_diff').*N_images_in_class(class_index);
end

% Calculate the Within-class scatter matrix
Scatter_within_class = zeros(N_images-N_classes);
for class_index = 1:N_classes
    current_class_faces = zeros(N_images-N_classes,N_images_in_class(class_index));
    image_class_index = 1;
    for image_index = 1:N_images  
        % Only use the images in the current class
        if vec_images_class_tracker(image_index) == class_index
            current_class_faces(:,image_class_index) = im_eigenfacespace(:,image_index) - class_mean_face_eigenfacespace(:,class_index);
            image_class_index = image_class_index + 1;
        end
    end
    Scatter_within_class = Scatter_within_class + current_class_faces*current_class_faces';
end
    


% Section 4: Making the fisher faces

% Make eigenvectors and sort them
[U_unsorted, eig_values] = eig(Scatter_between_class,Scatter_within_class);
[d,ind] = sort(diag(eig_values),'descend');
U_sorted = U_unsorted(:,ind);
% Extract the c-1 first vectors
U_sorted = U_sorted(:,1:N_classes-1);
% Get the fisher faces
Fisher_faces = eigen_faces*U_sorted;

% Normalize the fisher_faces 
for i = 1:N_classes-1
    %Fisher_faces(:,i) = Fisher_faces(:,i)./norm(Fisher_faces(:,i));
end



%imshow(rescale(reshape(Fisher_faces(:,1),400,300)))

%%
% Fisher Faces test image 


%[Fisher_faces,mean_face,class_weight]=generateFisherfaces("Bilder\DB3\", N_classes);

%imshow(rescale(reshape(Fisher_faces(:,1),400,300)))
%imshow(reshape(mean_face,400,300));

test_path = "images\DB0\db0_4.jpg";
%test_path = "images\DB2\il_16.jpg";
im_test = imread(test_path);
im_test = im2double(im_test);
figure(556),imshow(im_test);
[eye_x,eye_y] = ginput(2);
im_test = normalizeFace(im_test,eye_x,eye_y);
im_test = reshape(im_test,400*300,1);
close(556);

weight_test_image_fish = Fisher_faces'*im_test;

weight_class_fish = Fisher_faces'*class_mean_face;
weight_im_fish = Fisher_faces'*vec_images;

euclidian_distance_fish_class = zeros(N_classes,1);
for class_index = 1:N_classes
    euclidian_distance_fish_class(class_index) = norm(weight_test_image_fish - weight_class_fish(:,class_index));
end
[minDist,minClass] = min(euclidian_distance_fish_class);
clc;
disp('Class Distance');
disp(['Min distance: ',num2str(minDist)]);
disp(['Beloning to class ',num2str(minClass)]);

%imshow(reshape(im_test,400,300));
%figure, imshow(reshape(im_diff,400,300));

%ew = eigen_faces'*(im_test-mean_face');
%imshow(rescale(reshape(mean_face' + eigen_faces*ew,400,300)));

%ew = eigen_faces'*(im_test-mean_face);
%figure,imshow(rescale(reshape(mean_face + eigen_faces*ew,400,300)));
%imshow(rescale(reshape(eigen_faces*class_mean_face_eigenfacespace(:,5),400,300)));

%%
% Save the fisherfaces and the class weights 
weight_class = weight_class_fish;
save("FisherFace_weights.mat",'Fisher_faces','weight_class');


%%
%norm test 

normImg = imread("images\DB3\db1_01.jpg");
figure(555),imshow(normImg)
[ex,ey] = ginput(2);
close(555);
normImg = normalizeFace(normImg,ex,ey);
imshow(normImg);

%%
% current_im = 3;
% figure,imshow(reshape(vec_images(:,current_im),400,300))
% temp = zeros(400*300,N_images);
% for i = 1:N_images-N_classes
%     temp(:,i) = U_sorted_ef(:,i)./norm(U_sorted_ef(:,i));
% end
% weights = temp'*(vec_images - mean_face);
% 
% figure,imshow((reshape((mean_face + temp*weights(:,current_im)),400,300)));
% %figure,imshow(rescale(reshape(eigen_faces(:,1).*-1,400,300)));



