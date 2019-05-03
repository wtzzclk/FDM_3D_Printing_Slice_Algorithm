function [pts_out,size_pts_out] = triangle_plane_intersection(triangle_checklist,z_slices)
%�ú������ڼ���������Ƭ��������ƽ��Ľ��ߣ������ߵĶ˵�����ֵ
%�ú�����slice_stl_create_path��������
%% ת��֮��triangle_checklist�����ݽṹ
%��ǰ���У�ÿ������������Ƭ�������������꣬
%ÿһ�о���һ�����������ֵ
triangle_checklist = triangle_checklist';
% p1,p2,p3�ֱ���������Ƭ��������������(x1, y1, z1),(x2, y2, z2),(x3, y3, z3)
p1 = triangle_checklist(1:3,:);
p2 = triangle_checklist(4:6,:);
p3 = triangle_checklist(7:9,:);

c = ones(1,size(p1,2))*z_slices;
P = [zeros(1,size(p1,2));zeros(1, size(p1,2));ones(1,size(p1,2))];

% t1,t2,t3 ������ֵ,���ڼ����ཻ�������
t1 = (c-sum(P.*p1))./sum(P.*(p1-p2));
t2 = (c-sum(P.*p2))./sum(P.*(p2-p3));
t3 = (c-sum(P.*p3))./sum(P.*(p3-p1));
% bsxfun(@times,A,B)����A.*B����ӦԪ����ˣ�������A*B
% ��Ȼintersect1,intersect2,intersect3��������Ƭ����������ƽ�����������
intersect1 = p1+bsxfun(@times,p1-p2,t1);
intersect2 = p2+bsxfun(@times,p2-p3,t2);
intersect3 = p3+bsxfun(@times,p3-p1,t3);

% i1,i2,i3��ʾ�Ƿ�ÿ�����㶼��������Ƭ����������(���Ǻ��п��ܳ����߶εķ�Χ)
i1 = intersect1(3,:)<max(p1(3,:),p2(3,:))&intersect1(3,:)>min(p1(3,:),p2(3,:));
i2 = intersect2(3,:)<max(p2(3,:),p3(3,:))&intersect2(3,:)>min(p2(3,:),p3(3,:));
i3 = intersect3(3,:)<max(p3(3,:),p1(3,:))&intersect3(3,:)>min(p3(3,:),p1(3,:));

% ��Ϊ�����߲��ᶼ����ƽ���ཻ��ÿ��������Ƭ�����������������ƽ���ཻ
% ÿ��������Ƭ��������һ��������ƽ���ཻ(�غϵ����)
imain = i1+i2+i3 == 2;

pts_out = [[intersect1(:,i1&i2&imain);intersect2(:,i1&i2&imain)],[intersect2(:,i2&i3&imain);intersect3(:,i2&i3&imain)], [intersect3(:,i3&i1&imain);intersect1(:,i3&i1&imain)]];

pts_out = pts_out'; 
%% ת��֮���pts_out�����ݽṹ
% pts_out��ʾͬһ���ཻ�ߵ����˵��(X,Y,Z)����ֵ����Ӧ�ں������������lines
% pts_out�����ݽṹ��lines��ÿһ�б�ʾͬһ��Ƭ���ĳ���ཻ�ߣ�
% Ҳ���Ա���Ϊpts_out��1-3������ƽ����������Ƭ�ߵ��������ֵ(X,Y,Z)
% Ҳ���Ա���Ϊpts_out��4-6������ƽ����������Ƭ�ߵ��յ�����ֵ(X,Y,Z)
% size_pts_out��ʾĳһ��ƽ���ཻ��������Ƭ������Ҳ���Ա���Ϊͬһ���ཻ�ߵ�������
% size_pts_outҲ��Ӧ�ڸú����������linesize(ָ��ĳһ���ཻ�ߵ�����)
size_pts_out = size(pts_out,1);

end






