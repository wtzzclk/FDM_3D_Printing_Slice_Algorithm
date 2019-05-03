%%% read ascii stl file
function [numTriangles,triangles] = read_ascii_stl_file(filename, header_lines_num)
    % header_lines_num表示文件开头占用的行数，
    % 一般标准的ascii文件开头的第一行是文件的属性信息，
    % 第二行及以下行才是三角面片的详细顶点坐标和法向量
    %以下举例ascii STL文件的数据结构
    %*******************************************************
    % solid D638_TypeI_ascii
    % facet normal 2.111806e-016 0.000000e+000 1.000000e+000
    %   outer loop
    %      vertex 3.285763e+001 3.200000e+000 1.900000e+001
    %      vertex 0.000000e+000 3.200000e+000 1.900000e+001
    %      vertex 3.285763e+001 0.000000e+000 1.900000e+001
    %   endloop
    % endfacet
    % ......
    % endsolid
    %*********************************************************
    fid = fopen(filename);
    for i = 1: header_lines_num
    tline = fgetl(fid);
    end
    i = 1;
    tline = fgetl(fid);
    z1 = {'proceed'};
    while ~strcmp(z1{1}, 'endsolid')
        normals = strsplit(tline,' ');
        % triangles(i,10:12)是三角面片的法矢量坐标
        triangles(i,10:12) = str2double(normals(end-2:end));
        tline = fgetl(fid);
        tline = fgetl(fid);
        vertex1 = strsplit(tline, ' ');
        % triangles(i,1:3)是三角面片的第一顶点坐标
        triangles(i,1:3) = str2double(vertex1(end-2:end));
        tline = fgetl(fid);
        vertex2 = strsplit(tline, ' ');
        % triangles(i,4:6)是三角面片第二顶点坐标
        triangles(i,4:6) = str2double(vertex2(end-2:end));
        tline = fgetl(fid);
        vertex3 = strsplit(tline, ' ');
        % triangles(i,7:9)是三角面片的第三顶点坐标
        triangles(i,7:9) = str2double(vertex3(end-2:end));
        tline = fgetl(fid);
        tline = fgetl(fid);
        i = i + 1;
        tline = fgetl(fid);
        z1 = strsplit(tline, ' ');        
    end
    numTriangles = size(triangles,1);
    fclose(fid);
end
%fclose(fid)
