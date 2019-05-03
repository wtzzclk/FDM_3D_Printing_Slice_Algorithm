%%% read ascii stl file
function [numTriangles,triangles] = read_ascii_stl_file(filename, header_lines_num)
    % header_lines_num��ʾ�ļ���ͷռ�õ�������
    % һ���׼��ascii�ļ���ͷ�ĵ�һ�����ļ���������Ϣ��
    % �ڶ��м������в���������Ƭ����ϸ��������ͷ�����
    %���¾���ascii STL�ļ������ݽṹ
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
        % triangles(i,10:12)��������Ƭ�ķ�ʸ������
        triangles(i,10:12) = str2double(normals(end-2:end));
        tline = fgetl(fid);
        tline = fgetl(fid);
        vertex1 = strsplit(tline, ' ');
        % triangles(i,1:3)��������Ƭ�ĵ�һ��������
        triangles(i,1:3) = str2double(vertex1(end-2:end));
        tline = fgetl(fid);
        vertex2 = strsplit(tline, ' ');
        % triangles(i,4:6)��������Ƭ�ڶ���������
        triangles(i,4:6) = str2double(vertex2(end-2:end));
        tline = fgetl(fid);
        vertex3 = strsplit(tline, ' ');
        % triangles(i,7:9)��������Ƭ�ĵ�����������
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
