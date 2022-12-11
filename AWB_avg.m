function imOut = AWB_avg(im)
%Takes in a non-color corrected image and returns an image that is white
%balanced (gray world assumption)

%Seperate channels
R = im(:,:,1);
G = im(:,:,2);
B = im(:,:,3);

%Calculate the average
[columns, rows, channels] = size(im);
R_avg = sum(R(:))/(columns*rows);
G_avg = sum(G(:))/(columns*rows);
B_avg = sum(B(:))/(columns*rows);

%Compute the gain
alphaRed = G_avg/R_avg;
betaBlue = G_avg/B_avg;

%Compute color corrected image
R = R*alphaRed;
B = B*betaBlue;

%Combined image
imOut = cat(channels,R,G,B);
end