function mask = maskFromMatrix(matrix, im)

%Excract columns and rows
[columns, rows, channel] = size(im);

mask = zeros(columns, rows);    %Create a black image, same size as the input image
matrixSize = length(matrix);    %Calculate the length of the input matrix

%Get row and column information in matrix and use it to fill the mask with
%white pixels
for i=1:1:matrixSize
    col = matrix(i,1);
    row = matrix(i,2);
    mask(row,col) = 1;
end
end