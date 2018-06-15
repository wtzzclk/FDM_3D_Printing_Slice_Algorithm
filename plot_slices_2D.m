function []= plot_slices_2D(Crossing_Point_of_All_Slices,Number_of_Slice,delay)
% 动态绘制二维截面轮廓
%hold on保持连续绘图
hold on
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{Number_of_Slice}; % 通过for循环 逐个提取元胞子矩阵 到矩阵Crossing_Poin_of_each_Slice中
        if delay >0     %判断是，进行延时绘图操作
            if ~isempty(Crossing_Point_of_each_Slice)
                for j = 1:size(Crossing_Point_of_each_Slice,1)-1        % size(mlst_all,1)表示元胞子矩阵的行数
                    % plot3(X1,Y1,Z1,LineSpec)在三维空间绘制一个或者多个曲线。
                    % 这些线条穿过坐标为 X1、Y1 和 Z1 的元素的点。X1、Y1 和 Z1 的值可以是数值、日期时间、持续时间或类别值。
                    % LineSpec控制线形和颜色
                    plot(Crossing_Point_of_each_Slice(j:j+1,1),Crossing_Point_of_each_Slice(j:j+1,2),'k','LineWidth',0.1)
                    % pause()表示绘制延时，函数的输入参数已经进行了定义s
                    pause(delay)
                    
                end
            end   
                    % [Crossing_Poin_of_each_Slice(:,1),Crossing_Poin_of_each_Slice(:,2)]表示相交线的顶点的XY坐标值
                    % plot3()中的第三个变量是Z轴方向切平面的坐标值
        else        %判断否，不进行延时绘图操作，计算完成后一次性将图形全部显示
            if ~isempty(Crossing_Point_of_each_Slice)
                plot(Crossing_Point_of_each_Slice(:,1),Crossing_Point_of_each_Slice(:,2),'k','LineWidth',0.1)
            end
        end
end
