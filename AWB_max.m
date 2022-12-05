function imOut = AWB_max(im)

%Seperate channels
R = im(:,:,1);
G = im(:,:,2);
B = im(:,:,3);

%Find max value
[columns, rows, channels] = size(im);
R_max = max(R(:));
G_max = max(G(:));
B_max = max(B(:));

%If G_max is smal, scale it up
if(G_max < 0.8)
    G = G/(max(abs(G(:))));
    G_max = max(G(:));
end

%Compute the gain
alphaRed = G_max/R_max;
betaBlue = G_max/B_max;

%Compute color corrected image
R = R*alphaRed;
B = B*betaBlue;

%Combined image
imOut = cat(channels,R,G,B);
end