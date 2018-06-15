%**********************************************************
% �ýű����������е�ǰ�ļ����µ��ӳ���
% �ó����� Matlab 2017a �汾�ϱ���ɹ�
% �ó��������Matlab 2015b �����ϰ汾������
% �����õ�ģ����Test_Models�ļ����£������G������Show_Result
%**********************************************************
%������б������ݡ�������������С��ر����л�ͼ����
clc; clearvars; close all;
%% ���ƶ����ƻ���ASCII��ʽ��stlģ��ԭʼͼ��
% read_binary_or_ascii_stl�������Զ�ȡASCII���߶����Ƶ�STLģ���ļ���
% �����ذ��������ֶεĽṹ����fv,�ú�����MATLAB�Ŷӱ�д
% fv������һ���ֶ��淨ʸ��faces�͵ڶ����ֶζ�������vertices����ֵ
fv = read_binary_or_ascii_stl('Test_Models\femur_half_bone_like.stl');
% ���ģ��ͨ��PATCHͼ����������ɫ�������һЩ��̬��Դ
% ���ҵ����˲��������Ըı�ģ�͵Ĺ���
figure('Name','STLԭʼģ������Ƭ','NumberTitle','off');
subplot(121)
pause(10)
title('STLԭʼģ��');
xlabel('X');ylabel('Y');zlabel('Z');
patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);
rotate3d on 
% ���������Դ�����ҵ�������ǿ��
camlight('headlight'); 
material('dull'); 
% �趨�鿴�Ƕ� ʹͼ���ʺϴ��ڴ�С��ʾ
axis('image');
view([-135 40]);
%% �鿴��תģ��
i = 1;
t = 0:1:30;  
for i = 2:length(t)  
    view(-135-t(i),40);  
    pause(0.1) %�趨��ת��̬��ʱʱ��
end  
%% ��ȡASCII��ʽ��STL�ļ�
% ����Ҫ��ȡASCII��ʽ��STL�ļ�ʱ������read_ascii_stl_file������ȡstl�ļ���
% [triangles] = read_ascii_stl_file('femur_O.stl',1)
% �ڶ��������header_lines_num��ʾstl�ļ���ͷռ�õ�������
% ��׼��ASCII��ʽ��stl�ļ���ͷռһ��

%% ��ȡ������binary��stl�ļ�
% ����ֵtriangles�Ǿ���12�еľ���ÿһ�б�ʾһ��������Ƭ��
% ǰ9�б�ʾ�������������ֵ�����3�б�ʾ��Ƭ�ķ���������
% ���Ա���Ϊ (x1, y1, z1),(x2, y2, z2),(x3, y3, z3),(n1, n2, n3)
% ����ֵnumTriangles��ʾ������Ƭ���ܸ���
[numTriangles,triangles] = read_binary_stl_file...
    ('Test_Models\femur_half_bone_like.stl');

%% ����ģ�͵���Ƭ�������� slice_stl_create_path
%������Ƭ��� slice_height
slice_height = 0.2;
%��ʱ��
tic; 
% ��������ֵ Crossing_Point_of_All_SlicesԪ�����󣬰���������ƽ����������Ƭ�Ľ��������ֵ
% ��������ֵ z_slices ��ʾ������ƽ���Z������ֵ����ƽ���������������ֵ��������λ�þ�����������Ƭ�Ķ���
% ��������ֵ triangles_new ��һ��14�о��󣬺����а���������Ƭ����Ͷ���(��13��)����߶���(��14��)
[Crossing_Point_of_All_Slices,z_slices,model_height,triangles_new] = ...
    slice_stl_create_path(triangles, slice_height);
%��ȡtic��ʱ�������ݣ�����ʾ������������������Ч��
toc; 

%% ���Ʒֲ�������� 
subplot(122)
title('ģ�ͷֲ���������ȡ')

xlabel('X');ylabel('Y');zlabel('Z');
view(-135,40);
axis([-Inf Inf -Inf Inf z_slices(1) z_slices(end)])
%% �켣�������Ʒֲ����������
plot_slices_3D(Crossing_Point_of_All_Slices,z_slices,0.0);
rotate3d on
% �趨��Ҫ��ʾ����Ƭ��ı��
Number_of_Slice = 50;
figure('Name','��ά��Ƭ��ͼ','NumberTitle','off');
title('��״��׽ṹ�������Ƭ');
axis([0 40 0 55]);
plot_slices_2D(Crossing_Point_of_All_Slices,Number_of_Slice,0.005);

%% �鿴��תģ��
t = 0:1:30;  
for j = 2:length(t)  
    view(-135-t(j),40);  
    pause(0.1)  
end  

%% ��ָ����������
% ������Ƭ��ı��number
% z_slices��1X39ά�ȵľ���ÿһ�б�ʾ��ƽ�����ڵ�Z������ֵ
% ����Crossing_Point_of_All_SlicesԪ�������Ԫ��������z_slices������С1��
% ����Ҫ��ȥ1

% �趨��Ҫ��ʾ����Ƭ��ı��
Number_of_Slice = 50;
figure('Name','������Ƭ���','NumberTitle','off');
% ��Ƭ���ֻ������һ��Χ�� Number_of_Slice = 1:1:size(z_slices,2)-1;
[Crossing_Point_of_each_Slice] = infill_outline...
    (Crossing_Point_of_All_Slices,Number_of_Slice);
title(['���Ƶ�',num2str(Number_of_Slice),'���������'])

%% G��������
Extrude_Speed = 0.01485; %�����������ٶ� ��λmm/s
Move_Speed_G1 = 1800; %������XY�����ƶ��ٶ� ��λmm/s
% slice_height = 0.4; %��Ƭ�߶��Ѿ����Ϸ������
Move_Speed_G0 = 3600; %���������ٶ�λ�ƶ��ٶ� ��λmm/s
% �趨��ʼ���0.3,֮��Ĳ�߾���0.4
z_slices(1)=0.3;
% G�������ɺ���
generate_gcode(Crossing_Point_of_All_Slices,z_slices,...
    Extrude_Speed,Move_Speed_G0,Move_Speed_G1,slice_height);







