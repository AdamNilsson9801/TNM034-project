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


%%
%Train the system
train_path = "images\DB4\";
eye_finding_metod = 'hybrid';   %'auto' , 'manual' or 'hybrid'
[Fisher_faces,weight_class] = generateFisherFaces(train_path,16,eye_finding_metod);


%save("FisherFace_weights_backup.mat", "Fisher_faces", "weight_class");
save("FisherFace_weights.mat", "Fisher_faces", "weight_class");

%%
% Test the system 

test_path = "images\DB4\";

file_path = append(test_path,'*.jpg');
imagefiles = dir(file_path); 
N_images = length(imagefiles);

class_prediction = zeros(N_images,1);
class_ground_truth = zeros(N_images,1);
classes_right = 0;
image_dist = zeros(N_images,1);

for im_index = 1:N_images
    split_fileName = split(imagefiles(im_index).name,["_","."]);
    im_class = str2double(split_fileName(2));
    im_current = imread(append(test_path,imagefiles(im_index).name));
        
    [class_prediction(im_index),image_dist(im_index)] = tnm034(im_current); 
    class_ground_truth(im_index) = im_class;
    
    if class_prediction(im_index) == class_ground_truth(im_index)
        classes_right = classes_right + 1;
    end
end

disp(['Accuracy: ',num2str(classes_right/N_images)]);
reults = cat(2,class_ground_truth,class_prediction);
