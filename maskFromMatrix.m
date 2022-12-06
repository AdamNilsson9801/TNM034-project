function mask = maskFromMatrix(matrix, im)
    
    [columns, rows, channel] = size(im);
    mask = zeros(columns, rows);
    matrixSize = length(matrix);

    for i=1:1:matrixSize
        col = matrix(i,1);
        row = matrix(i,2);
        mask(row,col) = 1;
 
    end
end