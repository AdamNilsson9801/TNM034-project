clear
num_success = 0;
num_error = 0;

% Test DB1
disp(" ");
disp("DB1")
for n=1:16
    im{n} = imread(sprintf('images/DB1/db1_%02d.jpg',n));
    im{n} = im2double(im{n}); % måste konvertera den till double innan vi skickar 
    [eye1, eye2] = eyedetectionV2(im{n});
    pos = [eye1; eye2];
    showim = insertMarker(im{n}, pos, 'star','color','red','size',10);
    imshow(showim);
    if eye1(1) > 0 && eye2(1) > 0
        disp("image db1_" + n + ": SUCCESS");
        num_success = num_success + 1;
    else
        disp("image db1_" + n + ": ERROR");
        num_error = num_error + 1;
    end
end

disp(" ");
disp("DB2");
for n=[1,2,4,5,6,7,10,13,14]
    im{n} = imread(sprintf('images/DB2/bl_%02d.jpg',n));
    im{n} = im2double(im{n}); 
    [eye1, eye2] = eyedetectionV2(im{n});
    pos = [eye1; eye2];
    showim = insertMarker(im{n}, pos, 'star','color','red','size',10);
    imshow(showim);
    if eye1(1) > 0 && eye2(1) > 0
        disp("image bl_" + n + ": SUCCESS");
        num_success = num_success + 1;
    else
        disp("image bl_" + n + ": ERROR");
        num_error = num_error + 1;
    end
end

disp(" ");
for n= 1:16
    im{n} = imread(sprintf('images/DB2/cl_%02d.jpg',n));
    im{n} = im2double(im{n}); 
    [eye1, eye2] = eyedetectionV2(im{n});
    pos = [eye1; eye2];
    showim = insertMarker(im{n}, pos, 'star','color','red','size',10);
    imshow(showim);
    if eye1(1) > 0 && eye2(1) > 0
        disp("image cl_" + n + ": SUCCESS");
        num_success = num_success + 1;
    else
        disp("image cl_" + n + ": ERROR");
        num_error = num_error + 1;
    end
end

disp(" ");
for n= [1,3,4,7,9,11,12]
    im{n} = imread(sprintf('images/DB2/ex_%02d.jpg',n));
    im{n} = im2double(im{n}); 
    [eye1, eye2] = eyedetectionV2(im{n});
    pos = [eye1; eye2];
    showim = insertMarker(im{n}, pos, 'star','color','red','size',10);
    imshow(showim);
    if eye1(1) > 0 && eye2(1) > 0
        disp("image ex_" + n + ": SUCCESS");
        num_success = num_success + 1;
    else
        disp("image ex_" + n + ": ERROR");
        num_error = num_error + 1;
    end
end

disp(" ");
for n= [1,7,8,9,12,16]
    im{n} = imread(sprintf('images/DB2/il_%02d.jpg',n));
    im{n} = im2double(im{n}); 
    [eye1, eye2] = eyedetectionV2(im{n});
    pos = [eye1; eye2];
    showim = insertMarker(im{n}, pos, 'star','color','red','size',10);
    imshow(showim);
    if eye1(1) > 0 && eye2(1) > 0
        disp("image il_" + n + ": SUCCESS");
        num_success = num_success + 1;
    else
        disp("image il_" + n + ": ERROR");
        num_error = num_error + 1;
    end
end

disp(" ");
disp("DB3")
for n=1:16
    im{n} = imread(sprintf('images/DB3/db1_%02d.jpg',n));
    im{n} = im2double(im{n});
    [eye1, eye2] = eyedetectionV2(im{n});
    pos = [eye1; eye2];
    showim = insertMarker(im{n}, pos, 'star','color','red','size',10);
    imshow(showim);
    if eye1(1) > 0 && eye2(1) > 0
        disp("image db1_" + n + ": SUCCESS");
        num_success = num_success + 1;
    else
        disp("image db1_" + n + ": ERROR");
        num_error = num_error + 1;
    end
end

disp(" ");
disp(" Successes: " + num_success);
disp(" Errors: " + num_error);
