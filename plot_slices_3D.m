function []= plot_slices_3D(Crossing_Point_of_All_Slices, z_slices,delay)
% ��̬��̬������ά��������
% Crossing_Point_of_All_Slices Ԫ�������ÿһ��Ԫ�������иò���Ƭ�����нڵ㣨XY����ֵ������
% Crossing_Point_of_All_Slices ��Ԫ������������Ƭ���� ��Crossing_Point_of_All_Slices��һά������
% �ú������ڻ���slice_stl_create_path�����������õ����е�ͨ���켣�߱�ʾ����Ƭ�������
% �趨 delayֵ ����ͨ����ʱ��������ͼ�ٶ�
% Crossing_Point_of_All_Slices{i}Ԫ�������ʾ���н��������ֵ
% size(Crossing_Point_of_All_Slices,2)��ʾԪ��������Ԫ���ĸ���������Ƭ����ܸ���
% Crossing_Poin_of_each_Slice ��ʾÿ����Ƭ������н�������ֵ(X,Y)
hold on;
    for i = 1: size(Crossing_Point_of_All_Slices,2)
       
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{i}; % ͨ��forѭ�� �����ȡԪ���Ӿ��� ������Crossing_Poin_of_each_Slice��
        if delay >0     %�ж��ǣ�������ʱ��ͼ����
            if ~isempty(Crossing_Point_of_each_Slice)
                for j = 1:size(Crossing_Point_of_each_Slice,1)-1        % size(mlst_all,1)��ʾԪ���Ӿ��������
                    % plot3(X1,Y1,Z1,LineSpec)����ά�ռ����һ�����߶�����ߡ�
                    % ��Щ������������Ϊ X1��Y1 �� Z1 ��Ԫ�صĵ㡣X1��Y1 �� Z1 ��ֵ��������ֵ������ʱ�䡢����ʱ������ֵ��
                    % LineSpec�������κ���ɫ
                    plot3(Crossing_Point_of_each_Slice(j:j+1,1),Crossing_Point_of_each_Slice(j:j+1,2),ones(2,1)*z_slices(i),'k','LineWidth',0.1)
                    % pause()��ʾ������ʱ����������������Ѿ������˶���s
                    pause(delay)
                end
            end   
                    % [Crossing_Poin_of_each_Slice(:,1),Crossing_Poin_of_each_Slice(:,2)]��ʾ�ཻ�ߵĶ����XY����ֵ
                    % plot3()�еĵ�����������Z�᷽����ƽ�������ֵ
        else        %�жϷ񣬲�������ʱ��ͼ������������ɺ�һ���Խ�ͼ��ȫ����ʾ
            if ~isempty(Crossing_Point_of_each_Slice)
                plot3(Crossing_Point_of_each_Slice(:,1),Crossing_Point_of_each_Slice(:,2),ones(size(Crossing_Point_of_each_Slice,1),1)*z_slices(i),'k','LineWidth',0.1)
            end
        end
    end
    
end


