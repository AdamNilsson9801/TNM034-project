function outImg = rgb2ycgcr(inImg)
%Converts from rgb to YCgCr colorspace 

%Seperate RGB channels
R = inImg(:,:,1);
G = inImg(:,:,2);
B = inImg(:,:,3);

%Linear transform from RGB to YCgCr
Y = 16 + 65.481.*R + 128.553.*G + 24.966.*B;
Cg = 128 - 81.085.*R + 112.*G - 30.0915.*B;
Cr = 128 + 122.*R - 93.768.*G - 18.214.*B;

%Combine channels into one image
outImg = zeros(size(inImg));
outImg(:,:,1) = Y;
outImg(:,:,2) = Cg;
outImg(:,:,3) = Cr;
outImg = outImg./255;
end

