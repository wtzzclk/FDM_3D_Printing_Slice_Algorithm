function []= plot_slices_2D(Crossing_Point_of_All_Slices,Number_of_Slice,delay)
% ��̬���ƶ�ά��������
%hold on����������ͼ
hold on
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{Number_of_Slice}; % ͨ��forѭ�� �����ȡԪ���Ӿ��� ������Crossing_Poin_of_each_Slice��
        if delay >0     %�ж��ǣ�������ʱ��ͼ����
            if ~isempty(Crossing_Point_of_each_Slice)
                for j = 1:size(Crossing_Point_of_each_Slice,1)-1        % size(mlst_all,1)��ʾԪ���Ӿ��������
                    % plot3(X1,Y1,Z1,LineSpec)����ά�ռ����һ�����߶�����ߡ�
                    % ��Щ������������Ϊ X1��Y1 �� Z1 ��Ԫ�صĵ㡣X1��Y1 �� Z1 ��ֵ��������ֵ������ʱ�䡢����ʱ������ֵ��
                    % LineSpec�������κ���ɫ
                    plot(Crossing_Point_of_each_Slice(j:j+1,1),Crossing_Point_of_each_Slice(j:j+1,2),'k','LineWidth',0.1)
                    % pause()��ʾ������ʱ����������������Ѿ������˶���s
                    pause(delay)
                    
                end
            end   
                    % [Crossing_Poin_of_each_Slice(:,1),Crossing_Poin_of_each_Slice(:,2)]��ʾ�ཻ�ߵĶ����XY����ֵ
                    % plot3()�еĵ�����������Z�᷽����ƽ�������ֵ
        else        %�жϷ񣬲�������ʱ��ͼ������������ɺ�һ���Խ�ͼ��ȫ����ʾ
            if ~isempty(Crossing_Point_of_each_Slice)
                plot(Crossing_Point_of_each_Slice(:,1),Crossing_Point_of_each_Slice(:,2),'k','LineWidth',0.1)
            end
        end
end
