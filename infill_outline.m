function [Crossing_Point_of_each_Slice]= infill_outline(Crossing_Point_of_All_Slices,Number_of_Slice)
        % [Crossing_Poin_of_each_Slice(:,1),Crossing_Poin_of_each_Slice(:,2)]��ʾ����Ƭ�����н����XY����ֵ
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{Number_of_Slice}; % ͨ��forѭ�� �����ȡԪ���Ӿ��� ������Crossing_Poin_of_each_Slice��
        if ~isempty(Crossing_Point_of_each_Slice)
                % fill(X,Y,C) ���� X �� Y �е����ݴ������Ķ���Σ�������ɫ�� C ָ������
                % fill �ɽ����һ���������һ�����������Ապ϶���Ρ�X �� Y ��ֵ���������֡�����ʱ�䡢����ʱ������ֵ��
                X = (Crossing_Point_of_each_Slice(:,1))';
                Y = (Crossing_Point_of_each_Slice(:,2))';
                fill(X,Y,'w')
        end    
        rotate3d on
end