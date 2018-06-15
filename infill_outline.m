function [Crossing_Point_of_each_Slice]= infill_outline(Crossing_Point_of_All_Slices,Number_of_Slice)
        % [Crossing_Poin_of_each_Slice(:,1),Crossing_Poin_of_each_Slice(:,2)]表示该切片层所有交点的XY坐标值
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{Number_of_Slice}; % 通过for循环 逐个提取元胞子矩阵 到矩阵Crossing_Poin_of_each_Slice中
        if ~isempty(Crossing_Point_of_each_Slice)
                % fill(X,Y,C) 根据 X 和 Y 中的数据创建填充的多边形（顶点颜色由 C 指定）。
                % fill 可将最后一个顶点与第一个顶点相连以闭合多边形。X 和 Y 的值可以是数字、日期时间、持续时间或类别值。
                X = (Crossing_Point_of_each_Slice(:,1))';
                Y = (Crossing_Point_of_each_Slice(:,2))';
                fill(X,Y,'w')
        end    
        rotate3d on
end