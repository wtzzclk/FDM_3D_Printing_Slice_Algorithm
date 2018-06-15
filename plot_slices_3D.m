function []= plot_slices_3D(Crossing_Point_of_All_Slices, z_slices,delay)
% 动态或静态绘制三维截面轮廓
% Crossing_Point_of_All_Slices 元胞矩阵的每一个元胞都含有该层切片的所有节点（XY坐标值）数据
% Crossing_Point_of_All_Slices 的元胞个数等于切片层数 ，Crossing_Point_of_All_Slices是一维行向量
% 该函数用于绘制slice_stl_create_path函数计算所得的所有点通过轨迹线表示出切片层的轮廓
% 设定 delay值 可以通过延时，调整绘图速度
% Crossing_Point_of_All_Slices{i}元胞数组表示所有交点的坐标值
% size(Crossing_Point_of_All_Slices,2)表示元胞矩阵中元胞的个数，即切片层的总个数
% Crossing_Poin_of_each_Slice 表示每个切片层的所有交点坐标值(X,Y)
hold on;
    for i = 1: size(Crossing_Point_of_All_Slices,2)
       
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{i}; % 通过for循环 逐个提取元胞子矩阵 到矩阵Crossing_Poin_of_each_Slice中
        if delay >0     %判断是，进行延时绘图操作
            if ~isempty(Crossing_Point_of_each_Slice)
                for j = 1:size(Crossing_Point_of_each_Slice,1)-1        % size(mlst_all,1)表示元胞子矩阵的行数
                    % plot3(X1,Y1,Z1,LineSpec)在三维空间绘制一个或者多个曲线。
                    % 这些线条穿过坐标为 X1、Y1 和 Z1 的元素的点。X1、Y1 和 Z1 的值可以是数值、日期时间、持续时间或类别值。
                    % LineSpec控制线形和颜色
                    plot3(Crossing_Point_of_each_Slice(j:j+1,1),Crossing_Point_of_each_Slice(j:j+1,2),ones(2,1)*z_slices(i),'k','LineWidth',0.1)
                    % pause()表示绘制延时，函数的输入参数已经进行了定义s
                    pause(delay)
                end
            end   
                    % [Crossing_Poin_of_each_Slice(:,1),Crossing_Poin_of_each_Slice(:,2)]表示相交线的顶点的XY坐标值
                    % plot3()中的第三个变量是Z轴方向切平面的坐标值
        else        %判断否，不进行延时绘图操作，计算完成后一次性将图形全部显示
            if ~isempty(Crossing_Point_of_each_Slice)
                plot3(Crossing_Point_of_each_Slice(:,1),Crossing_Point_of_each_Slice(:,2),ones(size(Crossing_Point_of_each_Slice,1),1)*z_slices(i),'k','LineWidth',0.1)
            end
        end
    end
    
end


