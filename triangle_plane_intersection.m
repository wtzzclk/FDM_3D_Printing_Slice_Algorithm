function [pts_out,size_pts_out] = triangle_plane_intersection(triangle_checklist,z_slices)
%该函数用于计算三角面片与所有切平面的交线，及交线的端点坐标值
%该函数被slice_stl_create_path函数调用
%% 转置之后triangle_checklist的数据结构
%其前九行，每三行是三角面片的三个顶点坐标，
%每一行就是一个顶点的坐标值
triangle_checklist = triangle_checklist';
% p1,p2,p3分别是三角面片的三个顶点坐标(x1, y1, z1),(x2, y2, z2),(x3, y3, z3)
p1 = triangle_checklist(1:3,:);
p2 = triangle_checklist(4:6,:);
p3 = triangle_checklist(7:9,:);

c = ones(1,size(p1,2))*z_slices;
P = [zeros(1,size(p1,2));zeros(1, size(p1,2));ones(1,size(p1,2))];

% t1,t2,t3 是增量值,用于计算相交点的坐标
t1 = (c-sum(P.*p1))./sum(P.*(p1-p2));
t2 = (c-sum(P.*p2))./sum(P.*(p2-p3));
t3 = (c-sum(P.*p3))./sum(P.*(p3-p1));
% bsxfun(@times,A,B)，即A.*B，对应元素相乘，不等于A*B
% 显然intersect1,intersect2,intersect3是三角面片三条边与切平面的三个交点
intersect1 = p1+bsxfun(@times,p1-p2,t1);
intersect2 = p2+bsxfun(@times,p2-p3,t2);
intersect3 = p3+bsxfun(@times,p3-p1,t3);

% i1,i2,i3表示是否每个交点都在三角面片的三条边上(他们很有可能超出线段的范围)
i1 = intersect1(3,:)<max(p1(3,:),p2(3,:))&intersect1(3,:)>min(p1(3,:),p2(3,:));
i2 = intersect2(3,:)<max(p2(3,:),p3(3,:))&intersect2(3,:)>min(p2(3,:),p3(3,:));
i3 = intersect3(3,:)<max(p3(3,:),p1(3,:))&intersect3(3,:)>min(p3(3,:),p1(3,:));

% 因为三条边不会都与切平面相交，每个三角面片都最多有两条边与切平面相交
% 每个三角面片都最少有一条边与切平面相交(重合的情况)
imain = i1+i2+i3 == 2;

pts_out = [[intersect1(:,i1&i2&imain);intersect2(:,i1&i2&imain)],[intersect2(:,i2&i3&imain);intersect3(:,i2&i3&imain)], [intersect3(:,i3&i1&imain);intersect1(:,i3&i1&imain)]];

pts_out = pts_out'; 
%% 转置之后的pts_out的数据结构
% pts_out表示同一层相交线的两端点的(X,Y,Z)坐标值，对应于函数的输出变量lines
% pts_out的数据结构，lines的每一行表示同一切片层的某个相交线，
% 也可以表述为pts_out的1-3列是切平面与三角面片边的起点坐标值(X,Y,Z)
% 也可以表述为pts_out的4-6列是切平面与三角面片边的终点坐标值(X,Y,Z)
% size_pts_out表示某一切平面相交的三角面片总数，也可以表述为同一层相交线的总数，
% size_pts_out也对应于该函数输出参数linesize(指定某一层相交线的总数)
size_pts_out = size(pts_out,1);

end






