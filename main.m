%**********************************************************
% 该脚本调用了所有当前文件夹下的子程序
% 该程序在 Matlab 2017a 版本上编译成功
% 该程序必须在Matlab 2015b 及以上版本上运行
% 测试用的模型在Test_Models文件夹下，输出的G代码在Show_Result
%**********************************************************
%清除所有变量数据、清楚所有命令行、关闭所有绘图窗口
clc; clearvars; close all;
%% 绘制二进制或者ASCII格式的stl模型原始图像
% read_binary_or_ascii_stl函数可以读取ASCII或者二进制的STL模型文件，
% 并返回包含两个字段的结构矩阵fv,该函数由MATLAB团队编写
% fv包含第一个字段面法矢量faces和第二个字段顶点坐标vertices坐标值
fv = read_binary_or_ascii_stl('Test_Models\femur_half_bone_like.stl');
% 这个模型通过PATCH图像函数进行润色，添加了一些动态光源
% 并且调整了材料属性以改变模型的光泽
figure('Name','STL原始模型与切片','NumberTitle','off');
subplot(121)
pause(10)
title('STL原始模型');
xlabel('X');ylabel('Y');zlabel('Z');
patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);
rotate3d on 
% 增加相机光源，并且调整反光强度
camlight('headlight'); 
material('dull'); 
% 设定查看角度 使图形适合窗口大小显示
axis('image');
view([-135 40]);
%% 查看旋转模型
i = 1;
t = 0:1:30;  
for i = 2:length(t)  
    view(-135-t(i),40);  
    pause(0.1) %设定旋转动态延时时间
end  
%% 读取ASCII格式的STL文件
% 当需要读取ASCII格式的STL文件时，请用read_ascii_stl_file函数读取stl文件，
% [triangles] = read_ascii_stl_file('femur_O.stl',1)
% 第二输入参数header_lines_num表示stl文件开头占用的行数，
% 标准的ASCII格式的stl文件开头占一行

%% 读取二进制binary的stl文件
% 返回值triangles是具有12列的矩阵，每一行表示一个三角面片，
% 前9列表示三个顶点的坐标值，最后3列表示面片的法向量坐标
% 可以表述为 (x1, y1, z1),(x2, y2, z2),(x3, y3, z3),(n1, n2, n3)
% 返回值numTriangles表示三角面片的总个数
[numTriangles,triangles] = read_binary_stl_file...
    ('Test_Models\femur_half_bone_like.stl');

%% 创建模型的切片轮廓曲线 slice_stl_create_path
%设置切片厚度 slice_height
slice_height = 0.2;
%计时器
tic; 
% 函数返回值 Crossing_Point_of_All_Slices元胞矩阵，包含所有切平面与三角面片的交点的坐标值
% 函数返回值 z_slices 表示所有切平面的Z轴坐标值，切平面坐标的两个极端值，最高最低位置均穿过三角面片的顶点
% 函数返回值 triangles_new 是一个14列矩阵，后两列包含三角面片的最低顶点(第13列)和最高顶点(第14列)
[Crossing_Point_of_All_Slices,z_slices,model_height,triangles_new] = ...
    slice_stl_create_path(triangles, slice_height);
%读取tic计时器的数据，并显示，用于评估程序计算的效率
toc; 

%% 绘制分层截面轮廓 
subplot(122)
title('模型分层与轮廓提取')

xlabel('X');ylabel('Y');zlabel('Z');
view(-135,40);
axis([-Inf Inf -Inf Inf z_slices(1) z_slices(end)])
%% 轨迹动画绘制分层与截面轮廓
plot_slices_3D(Crossing_Point_of_All_Slices,z_slices,0.0);
rotate3d on
% 设定需要显示的切片层的编号
Number_of_Slice = 50;
figure('Name','二维切片绘图','NumberTitle','off');
title('骨状多孔结构填充与切片');
axis([0 40 0 55]);
plot_slices_2D(Crossing_Point_of_All_Slices,Number_of_Slice,0.005);

%% 查看旋转模型
t = 0:1:30;  
for j = 2:length(t)  
    view(-135-t(j),40);  
    pause(0.1)  
end  

%% 对指定层进行填充
% 定义切片层的编号number
% z_slices是1X39维度的矩阵，每一列表示切平面所在的Z轴坐标值
% 但是Crossing_Point_of_All_Slices元胞矩阵的元胞个数比z_slices的列数小1，
% 故需要减去1

% 设定需要显示的切片层的编号
Number_of_Slice = 50;
figure('Name','绘制切片填充','NumberTitle','off');
% 切片编号只能在这一范围内 Number_of_Slice = 1:1:size(z_slices,2)-1;
[Crossing_Point_of_each_Slice] = infill_outline...
    (Crossing_Point_of_All_Slices,Number_of_Slice);
title(['绘制第',num2str(Number_of_Slice),'层截面轮廓'])

%% G代码的输出
Extrude_Speed = 0.01485; %挤出机挤出速度 单位mm/s
Move_Speed_G1 = 1800; %挤出机XY方向移动速度 单位mm/s
% slice_height = 0.4; %切片高度已经在上方定义过
Move_Speed_G0 = 3600; %挤出机快速定位移动速度 单位mm/s
% 设定初始层高0.3,之后的层高均是0.4
z_slices(1)=0.3;
% G代码生成函数
generate_gcode(Crossing_Point_of_All_Slices,z_slices,...
    Extrude_Speed,Move_Speed_G0,Move_Speed_G1,slice_height);







