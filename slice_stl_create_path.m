function [Crossing_Point_of_All_Slices,z_slices,model_height,triangles_new] = slice_stl_create_path(triangles,slice_height)
% 该函数将读取的stl文件中的三角面片按照设定的切片高度分层。
% 这会产生一系列坐标，3D打印机需要移动不同的高度对stl文件创建不同的轮廓。
% 函数首先寻找并计算三角面片与切片平面的交线
% 该函数创建连续的路径
% uniquetol函数是在Matlab 2015b 及更高版本中集成
%% 模型Z轴向高度
% 根据三角面片来计算模型的Z轴方向的高度，最大和最小位置
% 12列中的3，6，9列恰恰是三角面片的Z坐标值
min_z = min([triangles(:,3); triangles(:,6);triangles(:,9)])-1e-5;
max_z = max([triangles(:,3); triangles(:,6);triangles(:,9)])+1e-5;
model_height = max_z - min_z;
%% 等厚度分层
% Z轴方向实现等厚度 slice_height 切片。其中 z_slices 是 1X413 维度的一维行向量，
% z_slices 代表所有切平面的Z轴方向坐标值
% 切平面的两个极端值，最高最低位置均穿过三角面片的顶点
z_slices = min_z: slice_height :max_z;
% 初始化元胞数组 movelist_all
Crossing_Point_of_All_Slices = {};
% min(A,[],2)是一个列向量，由A中每一行的最小值组成
% 因此 min(triangles(:,[3 6 9]),[],2)表示triangles(:,[3 6 9])每一行三个顶点Z坐标的最小值(每个三角面片的最低的那个顶点)
% max(triangles(:,[ 3 6 9]),[],2)表示triangles(:,[3 6 9])每一行三个顶点Z坐标的最大值(每个三角面片的最高的那个顶点)
% 最终triangles_new是一个14列矩阵，后两列包含三角面片的最低顶点(第13列)和最高顶点(第14列)
triangles_new = [triangles(:,1:12),min(triangles(:,[3 6 9]),[],2), max(triangles(:,[ 3 6 9]),[],2)];
%% 寻找相交的三角形面片
slices = z_slices; 
% slices所有切平面的Z坐标值，z_slices是一维行矩阵

% 开辟预处理空间 ，size(A,2)表示二维矩阵A的第二个维度大小，即列数
z_triangles = zeros(size(z_slices,2),4000);
z_triangles_size = zeros(size(z_slices,2),1);
% size(triangles_new,1)表示所有三角面片的总个数
for i = 1:size(triangles_new,1) 
    node_lowest = triangles_new(i,13); % triangles_new(i,13)表示三角面片的最低顶点node_lowest，第13列 
    high= size(slices,2); % high表示切平面的总个数，即最高位置的切平面编号
    low = 1; % low表示最低位置的切平面编号
%   start_point = floor((max+min)/2);
    not_match = true;
%   include1 = true;
%   include2 = true;
    while not_match % not_match值为真开始循环
        mid = low + floor((high - low)/2); %二分法求 参考切平面位置索引编号mid
        %check = comparator_floating2(match_node,nodes(mid,:),tol);
%         mid
%         slices(mid)
%         node
        %triangles(i,:)
        %% 判断参考平面与三角面片的相对位置关系
        if mid == 1 && slices(mid) >= node_lowest  % 参考切平面高度高于三角面片的最低顶点，并且参考切平面已经到达最低处的切平面
            check = 2;                      % 这是一个错误的情况  
        elseif slices(mid) <= node_lowest && mid == size(slices,2)     % 参考切平面高度低于三角面片的最低顶点，并且参考切平面已经到达最高处的切平面
            check = 2;                      % 这是一个错误的情况  
        elseif slices(mid)>node_lowest && slices(mid-1)<node_lowest   % 参考切平面高度高于三角面片的最低顶点，并且（紧贴的）下方的切平面低于最低顶点
            check = 0;                      
        elseif slices(mid)>node_lowest     % 参考切平面高度高于三角面片的最低顶点
            check = -1;
        elseif slices(mid) < node_lowest   % 参考切平面高度低于三角面片的最低顶点
            check = 1;
        end

      if check == -1        %当参考切平面高度高于三角面片的最低顶点
          high = mid - 1;   %将参考平面降低一个位置
      elseif check == 1     %当参考切平面高度低于三角面片的最低顶点
          low = mid + 1;    %将参考平面增加一个位置
      elseif check == 0     %当参考切平面高度高于三角面片的最低顶点，并且（紧贴的）下方的切平面低于最低顶点
          node_lowest = mid;       %此时的参考平面刚好位于最低
          not_match = false;%匹配成功
      elseif high > low || check == 2
          include1 = false;
          not_match = false;
      end
    end
    % z_low_index 表示最低切平面的索引指数
    z_low_index = mid; 
    %binary check high
    node_highest = triangles_new(i,14); % triangles_new(i,14)第14列，表示三角面片的最高顶点
    high= size(slices,2); % high表示切平面的总个数，即最高位置的切平面编号
    low = 1;              % low表示最低位置的切平面编号
    %start_point = floor((max+min)/2);
    not_match = true; % 没有匹配成功 not match
    while not_match
        mid = low + floor((high - low)/2); %二分法求 参考切平面位置索引编号mid
        %check = comparator_floating2(match_node,nodes(mid,:),tol);
        if mid == 1 && slices(1) <= node_highest    % 参考切平面编号等于最低处的切平面编号，并且最低切平面高度值小于等于三角面片的最高顶点高度值
            check = 2;                              % check = 2 表示参考切平面位置无效
        elseif mid == size(slices,2) && slices(mid) <=node_highest  % 参考切平面编号等于最高处的切平面编号，并且参考切平面高度值小于等于三角面片的最高顶点高度值
            check = 2;
        elseif slices(mid)>node_highest && slices(mid-1)<node_highest   % 参考切平面高度值大于三角面片的最高顶点高度值，并且参考切平面下方紧挨的平面高度值小于等于三角面片的最高顶点高度值
            check = 0;                                                  % check == 0表示参考平面已经移动到了模型的最高位置处
        elseif slices(mid)>node_highest     % 参考切平面高度值大于三角面片的最高顶点高度值
            check = -1;                     % check = -1表示参考平面位置过高                           
        elseif slices(mid) < node_highest   % 参考切平面高度值小于三角面片的最高顶点高度值
            check = 1;                      % check = 1表示参考平面位置过低   
        end

      if check == -1    % 参考切平面高度值大于三角面片的最高顶点高度值
          high = mid - 1;   % check = -1表示参考平面位置过高，将参考平面下移一个位置
      elseif check == 1     % 参考切平面高度值小于三角面片的最高顶点高度值
          low = mid + 1;    % check = -1表示参考平面位置过低，将参考平面上移一个位置
      elseif check == 0     % 参考切平面高度值大于三角面片的最高顶点高度值，并且参考切平面下方紧挨的平面高度值小于等于三角面片的最高顶点高度值
          node_highest = mid;   % check == 0表示参考平面已经移动到了模型的最高位置处
          not_match = false;
      elseif high > low || check == 2   % 参考切平面编号等于最高处的切平面编号，并且参考切平面高度值小于等于三角面片的最高顶点高度值
          include2 = false;             % 参考切平面编号等于最低处的切平面编号，并且最低切平面高度值小于等于三角面片的最高顶点高度值
          not_match = false;            % check = 2 表示参考切平面位置无效
      end

    end
    z_high_index = mid;                 % z_high_index 表示最高切平面的索引指数
    if z_high_index > z_low_index       % 当最高处的切平面索引指数高于最低处的切平面索引指数
        for j = z_low_index:z_high_index-1      
            z_triangles_size(j) = z_triangles_size(j) + 1;      
            z_triangles(j,z_triangles_size(j)) = i;
        end
    end
end
% size(z_slices,2) 计算z_slices的第二个维度的大小，即列数
% 此处的 k 值表示切片的编号
for  k = 1:size(z_slices,2) 
    triangle_checklist = z_triangles(k,1:z_triangles_size(k));
    % 调用三角面片的交线求取函数 triangle_plane_intersection
    % linesize表示与某一切平面相交的三角面片数量，也可以表述为同一层相交线的个数，
    % size_pts_out也对应于该函数输出参数linesize(交线的数量)
    % lines表示与某一切平面相交的三角面片的顶点，
    % pts_out也对应于该函数的输出参数lines(交线的两个顶点)
    [lines,linesize] = triangle_plane_intersection(triangles_new(triangle_checklist,:), z_slices(k));
    % lines的数据结构，lines的每一行表示指定某一切片层的某个相交线的两端点坐标值，
    % lines的1-2列表示某个直线段的起点坐标值(X,Y)
    % lines的4-5列表示某个直线段的终点坐标值(X,Y)
    % linesize表示指定某一切片层中的相交线的总数
     if linesize ~= 0
            %查找所有分配的节点，并将重复项删除
            start_nodes = lines(1:linesize,1:2);    %交线的开始节点二维坐标
            end_nodes = lines(1:linesize,4:5);      %交线的终止节点坐标
            nodes = [start_nodes; end_nodes];       %汇总交线的所有节点坐标
            % connectivity = [];
            tol_uniquetol = 1e-8;                   %设定容差
            tol = 1e-8;
            %uniquetol函数是在Matlab 2015b 及更高版本中集成
            nodes = uniquetol(nodes,tol_uniquetol,'ByRows',true);
            nodes = sortrows(nodes,[1 2]);
            [~, n1] = ismembertol(start_nodes, nodes, tol, 'ByRows',true);
            [~, n2] = ismembertol(end_nodes, nodes,tol,  'ByRows',true);
            conn1 = [n1 n2];
            %检查损坏的stl文件，重复的边，太薄的表面，不封闭的图形
            %当发现stl模型是损坏的，则进行以下步骤进行修复
            conn2 = [n2 n1];
            check = ismember(conn2,conn1,'rows');
            conn1(check == 1,:)=[];
            %end check
            G = graph(conn1(:,1),conn1(:,2));
            %conncomp 函数用于创建连接几何的图形
            %bins 返回连接节点的数量           
            %   BINS = CONNCOMP(G) 计算图形G中相互连接的几何
            %   BINS(i) 给出了包含节点i的几何的数量
            %   如果有路径连接他们，节点属于相同的几何
            bins = conncomp(G);
        Crossing_Point_of_Slice =[];
          for i = 1: max(bins)
            startNode = find(bins==i, 1, 'first');
            %path =[];%开辟预处理空间
            path = dfsearch(G, startNode);
            path = [path; path(1)];
            %list of x and y axes
            Crossing_Point_of_Slice1 = [nodes(path,1) nodes(path,2)];
            %Crossing_Point_of_Slice包含同一层的所有交点数据
            Crossing_Point_of_Slice = [Crossing_Point_of_Slice;Crossing_Point_of_Slice1];
            Size_Crossing_Point_of_Slice = size(Crossing_Point_of_Slice,1);     
          end
            % 创建元胞数组，每一层的数据是一个子元胞
            Crossing_Point_of_All_Slices(k) = {Crossing_Point_of_Slice}; 
     end
end




