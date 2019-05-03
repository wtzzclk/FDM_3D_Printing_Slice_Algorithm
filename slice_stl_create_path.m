function [Crossing_Point_of_All_Slices,z_slices,model_height,triangles_new] = slice_stl_create_path(triangles,slice_height)
% �ú�������ȡ��stl�ļ��е�������Ƭ�����趨����Ƭ�߶ȷֲ㡣
% ������һϵ�����꣬3D��ӡ����Ҫ�ƶ���ͬ�ĸ߶ȶ�stl�ļ�������ͬ��������
% ��������Ѱ�Ҳ�����������Ƭ����Ƭƽ��Ľ���
% �ú�������������·��
% uniquetol��������Matlab 2015b �����߰汾�м���
%% ģ��Z����߶�
% ����������Ƭ������ģ�͵�Z�᷽��ĸ߶ȣ�������Сλ��
% 12���е�3��6��9��ǡǡ��������Ƭ��Z����ֵ
min_z = min([triangles(:,3); triangles(:,6);triangles(:,9)])-1e-5;
max_z = max([triangles(:,3); triangles(:,6);triangles(:,9)])+1e-5;
model_height = max_z - min_z;
%% �Ⱥ�ȷֲ�
% Z�᷽��ʵ�ֵȺ�� slice_height ��Ƭ������ z_slices �� 1X413 ά�ȵ�һά��������
% z_slices ����������ƽ���Z�᷽������ֵ
% ��ƽ�����������ֵ��������λ�þ�����������Ƭ�Ķ���
z_slices = min_z: slice_height :max_z;
% ��ʼ��Ԫ������ movelist_all
Crossing_Point_of_All_Slices = {};
% min(A,[],2)��һ������������A��ÿһ�е���Сֵ���
% ��� min(triangles(:,[3 6 9]),[],2)��ʾtriangles(:,[3 6 9])ÿһ����������Z�������Сֵ(ÿ��������Ƭ����͵��Ǹ�����)
% max(triangles(:,[ 3 6 9]),[],2)��ʾtriangles(:,[3 6 9])ÿһ����������Z��������ֵ(ÿ��������Ƭ����ߵ��Ǹ�����)
% ����triangles_new��һ��14�о��󣬺����а���������Ƭ����Ͷ���(��13��)����߶���(��14��)
triangles_new = [triangles(:,1:12),min(triangles(:,[3 6 9]),[],2), max(triangles(:,[ 3 6 9]),[],2)];
%% Ѱ���ཻ����������Ƭ
slices = z_slices; 
% slices������ƽ���Z����ֵ��z_slices��һά�о���

% ����Ԥ����ռ� ��size(A,2)��ʾ��ά����A�ĵڶ���ά�ȴ�С��������
z_triangles = zeros(size(z_slices,2),4000);
z_triangles_size = zeros(size(z_slices,2),1);
% size(triangles_new,1)��ʾ����������Ƭ���ܸ���
for i = 1:size(triangles_new,1) 
    node_lowest = triangles_new(i,13); % triangles_new(i,13)��ʾ������Ƭ����Ͷ���node_lowest����13�� 
    high= size(slices,2); % high��ʾ��ƽ����ܸ����������λ�õ���ƽ����
    low = 1; % low��ʾ���λ�õ���ƽ����
%   start_point = floor((max+min)/2);
    not_match = true;
%   include1 = true;
%   include2 = true;
    while not_match % not_matchֵΪ�濪ʼѭ��
        mid = low + floor((high - low)/2); %���ַ��� �ο���ƽ��λ���������mid
        %check = comparator_floating2(match_node,nodes(mid,:),tol);
%         mid
%         slices(mid)
%         node
        %triangles(i,:)
        %% �жϲο�ƽ����������Ƭ�����λ�ù�ϵ
        if mid == 1 && slices(mid) >= node_lowest  % �ο���ƽ��߶ȸ���������Ƭ����Ͷ��㣬���Ҳο���ƽ���Ѿ�������ʹ�����ƽ��
            check = 2;                      % ����һ����������  
        elseif slices(mid) <= node_lowest && mid == size(slices,2)     % �ο���ƽ��߶ȵ���������Ƭ����Ͷ��㣬���Ҳο���ƽ���Ѿ�������ߴ�����ƽ��
            check = 2;                      % ����һ����������  
        elseif slices(mid)>node_lowest && slices(mid-1)<node_lowest   % �ο���ƽ��߶ȸ���������Ƭ����Ͷ��㣬���ң������ģ��·�����ƽ�������Ͷ���
            check = 0;                      
        elseif slices(mid)>node_lowest     % �ο���ƽ��߶ȸ���������Ƭ����Ͷ���
            check = -1;
        elseif slices(mid) < node_lowest   % �ο���ƽ��߶ȵ���������Ƭ����Ͷ���
            check = 1;
        end

      if check == -1        %���ο���ƽ��߶ȸ���������Ƭ����Ͷ���
          high = mid - 1;   %���ο�ƽ�潵��һ��λ��
      elseif check == 1     %���ο���ƽ��߶ȵ���������Ƭ����Ͷ���
          low = mid + 1;    %���ο�ƽ������һ��λ��
      elseif check == 0     %���ο���ƽ��߶ȸ���������Ƭ����Ͷ��㣬���ң������ģ��·�����ƽ�������Ͷ���
          node_lowest = mid;       %��ʱ�Ĳο�ƽ��պ�λ�����
          not_match = false;%ƥ��ɹ�
      elseif high > low || check == 2
          include1 = false;
          not_match = false;
      end
    end
    % z_low_index ��ʾ�����ƽ�������ָ��
    z_low_index = mid; 
    %binary check high
    node_highest = triangles_new(i,14); % triangles_new(i,14)��14�У���ʾ������Ƭ����߶���
    high= size(slices,2); % high��ʾ��ƽ����ܸ����������λ�õ���ƽ����
    low = 1;              % low��ʾ���λ�õ���ƽ����
    %start_point = floor((max+min)/2);
    not_match = true; % û��ƥ��ɹ� not match
    while not_match
        mid = low + floor((high - low)/2); %���ַ��� �ο���ƽ��λ���������mid
        %check = comparator_floating2(match_node,nodes(mid,:),tol);
        if mid == 1 && slices(1) <= node_highest    % �ο���ƽ���ŵ�����ʹ�����ƽ���ţ����������ƽ��߶�ֵС�ڵ���������Ƭ����߶���߶�ֵ
            check = 2;                              % check = 2 ��ʾ�ο���ƽ��λ����Ч
        elseif mid == size(slices,2) && slices(mid) <=node_highest  % �ο���ƽ���ŵ�����ߴ�����ƽ���ţ����Ҳο���ƽ��߶�ֵС�ڵ���������Ƭ����߶���߶�ֵ
            check = 2;
        elseif slices(mid)>node_highest && slices(mid-1)<node_highest   % �ο���ƽ��߶�ֵ����������Ƭ����߶���߶�ֵ�����Ҳο���ƽ���·�������ƽ��߶�ֵС�ڵ���������Ƭ����߶���߶�ֵ
            check = 0;                                                  % check == 0��ʾ�ο�ƽ���Ѿ��ƶ�����ģ�͵����λ�ô�
        elseif slices(mid)>node_highest     % �ο���ƽ��߶�ֵ����������Ƭ����߶���߶�ֵ
            check = -1;                     % check = -1��ʾ�ο�ƽ��λ�ù���                           
        elseif slices(mid) < node_highest   % �ο���ƽ��߶�ֵС��������Ƭ����߶���߶�ֵ
            check = 1;                      % check = 1��ʾ�ο�ƽ��λ�ù���   
        end

      if check == -1    % �ο���ƽ��߶�ֵ����������Ƭ����߶���߶�ֵ
          high = mid - 1;   % check = -1��ʾ�ο�ƽ��λ�ù��ߣ����ο�ƽ������һ��λ��
      elseif check == 1     % �ο���ƽ��߶�ֵС��������Ƭ����߶���߶�ֵ
          low = mid + 1;    % check = -1��ʾ�ο�ƽ��λ�ù��ͣ����ο�ƽ������һ��λ��
      elseif check == 0     % �ο���ƽ��߶�ֵ����������Ƭ����߶���߶�ֵ�����Ҳο���ƽ���·�������ƽ��߶�ֵС�ڵ���������Ƭ����߶���߶�ֵ
          node_highest = mid;   % check == 0��ʾ�ο�ƽ���Ѿ��ƶ�����ģ�͵����λ�ô�
          not_match = false;
      elseif high > low || check == 2   % �ο���ƽ���ŵ�����ߴ�����ƽ���ţ����Ҳο���ƽ��߶�ֵС�ڵ���������Ƭ����߶���߶�ֵ
          include2 = false;             % �ο���ƽ���ŵ�����ʹ�����ƽ���ţ����������ƽ��߶�ֵС�ڵ���������Ƭ����߶���߶�ֵ
          not_match = false;            % check = 2 ��ʾ�ο���ƽ��λ����Ч
      end

    end
    z_high_index = mid;                 % z_high_index ��ʾ�����ƽ�������ָ��
    if z_high_index > z_low_index       % ����ߴ�����ƽ������ָ��������ʹ�����ƽ������ָ��
        for j = z_low_index:z_high_index-1      
            z_triangles_size(j) = z_triangles_size(j) + 1;      
            z_triangles(j,z_triangles_size(j)) = i;
        end
    end
end
% size(z_slices,2) ����z_slices�ĵڶ���ά�ȵĴ�С��������
% �˴��� k ֵ��ʾ��Ƭ�ı��
for  k = 1:size(z_slices,2) 
    triangle_checklist = z_triangles(k,1:z_triangles_size(k));
    % ����������Ƭ�Ľ�����ȡ���� triangle_plane_intersection
    % linesize��ʾ��ĳһ��ƽ���ཻ��������Ƭ������Ҳ���Ա���Ϊͬһ���ཻ�ߵĸ�����
    % size_pts_outҲ��Ӧ�ڸú����������linesize(���ߵ�����)
    % lines��ʾ��ĳһ��ƽ���ཻ��������Ƭ�Ķ��㣬
    % pts_outҲ��Ӧ�ڸú������������lines(���ߵ���������)
    [lines,linesize] = triangle_plane_intersection(triangles_new(triangle_checklist,:), z_slices(k));
    % lines�����ݽṹ��lines��ÿһ�б�ʾָ��ĳһ��Ƭ���ĳ���ཻ�ߵ����˵�����ֵ��
    % lines��1-2�б�ʾĳ��ֱ�߶ε��������ֵ(X,Y)
    % lines��4-5�б�ʾĳ��ֱ�߶ε��յ�����ֵ(X,Y)
    % linesize��ʾָ��ĳһ��Ƭ���е��ཻ�ߵ�����
     if linesize ~= 0
            %�������з���Ľڵ㣬�����ظ���ɾ��
            start_nodes = lines(1:linesize,1:2);    %���ߵĿ�ʼ�ڵ��ά����
            end_nodes = lines(1:linesize,4:5);      %���ߵ���ֹ�ڵ�����
            nodes = [start_nodes; end_nodes];       %���ܽ��ߵ����нڵ�����
            % connectivity = [];
            tol_uniquetol = 1e-8;                   %�趨�ݲ�
            tol = 1e-8;
            %uniquetol��������Matlab 2015b �����߰汾�м���
            nodes = uniquetol(nodes,tol_uniquetol,'ByRows',true);
            nodes = sortrows(nodes,[1 2]);
            [~, n1] = ismembertol(start_nodes, nodes, tol, 'ByRows',true);
            [~, n2] = ismembertol(end_nodes, nodes,tol,  'ByRows',true);
            conn1 = [n1 n2];
            %����𻵵�stl�ļ����ظ��ıߣ�̫���ı��棬����յ�ͼ��
            %������stlģ�����𻵵ģ���������²�������޸�
            conn2 = [n2 n1];
            check = ismember(conn2,conn1,'rows');
            conn1(check == 1,:)=[];
            %end check
            G = graph(conn1(:,1),conn1(:,2));
            %conncomp �������ڴ������Ӽ��ε�ͼ��
            %bins �������ӽڵ������           
            %   BINS = CONNCOMP(G) ����ͼ��G���໥���ӵļ���
            %   BINS(i) �����˰����ڵ�i�ļ��ε�����
            %   �����·���������ǣ��ڵ�������ͬ�ļ���
            bins = conncomp(G);
        Crossing_Point_of_Slice =[];
          for i = 1: max(bins)
            startNode = find(bins==i, 1, 'first');
            %path =[];%����Ԥ����ռ�
            path = dfsearch(G, startNode);
            path = [path; path(1)];
            %list of x and y axes
            Crossing_Point_of_Slice1 = [nodes(path,1) nodes(path,2)];
            %Crossing_Point_of_Slice����ͬһ������н�������
            Crossing_Point_of_Slice = [Crossing_Point_of_Slice;Crossing_Point_of_Slice1];
            Size_Crossing_Point_of_Slice = size(Crossing_Point_of_Slice,1);     
          end
            % ����Ԫ�����飬ÿһ���������һ����Ԫ��
            Crossing_Point_of_All_Slices(k) = {Crossing_Point_of_Slice}; 
     end
end




