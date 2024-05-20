function [s] = buildVectorMatrixStr(vectorMatrix)
%UNTITLED Преобразовать трехмерную матрицу в строку с плоским
%представлениемё

    s = "";

    for i = 1:size(vectorMatrix, 1)      

        for j = 1:size(vectorMatrix, 2)           

             s = strcat(s, sprintf("{%0.3f,%0.3f}\t", string(vectorMatrix(i,j,1)), string(vectorMatrix(i,j,2))));
        end

        s = sprintf("%s\n", s);

    end

end