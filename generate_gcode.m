function [] = generate_gcode( Crossing_Point_of_All_Slices,z_slices,Extrude_Speed,Move_Speed_G0,Move_Speed_G1,slice_height,save_direction)
% Crossing_Point_of_All_Slices ���зֲ�Ľ�������
% z_slices ������Ƭ�ֲ��Z����ֵ��һά������
% Extrude_Speed �����ٶȿ��ƣ�*mm/������������Ľ���
% slice_height ��Ƭ�ֲ���
% Move_Speed �����飩����ͷ���ƶ��ٶȣ����Ǽ����ٶ�
% ������Ƭ���Z����ֵ z_slices = min_z: slice_height :max_z;
 %% ���ģ�͵���ʼ����
fileID = fopen(save_direction,'w'); % �򿪲�д���ļ�femur_O.gcode
fprintf(fileID,'Layer height:%.2f\r\n',slice_height); %��ʾ���
fprintf(fileID,'M104 S200\r\n');  % ���ļ���д��Gcode
fprintf(fileID,'M109 S200\r\n'); % ������ͷ��Ŀ���¶ȣ�Ȼ���ڼ��ȹ����еȴ�
% ���µ���ʼ���룬ÿ��ģ�;���ͬ���ο�cura��� Machine_Setting��
fprintf(fileID,'G28;Home\r\n'); %�����ʹ�������ص�����ԭ��
fprintf(fileID,'G1 Z15.0 F6000;Move the platform down 15mm\r\n');
fprintf(fileID,';Prime the extruder\r\n');
fprintf(fileID,'G92 E0\r\n'); % G92ָ����ǰ���������ֵָ����ǰ���������ֵ
fprintf(fileID,'G1 F200 E3\r\n');
fprintf(fileID,'G92 E0\r\n');

%% ���ģ�͵Ĵ���Gcode
fprintf(fileID,';Layer_Count:%d\r\n',size(z_slices,2)); %ͳ����Ƭ�ʹ�ӡ�Ĳ���
%% �����һ��G����
fprintf(fileID,';Layer:%d\r\n',0); %�����ʼ��0
%�رշ��� M106 S0Ҳ���Դﵽ��ͬ��Ч��
fprintf(fileID,'M107\r\n'); 
% ��ȡ��һ�㣨��һ��Ԫ��������
Crossing_Point_of_first_Slice = Crossing_Point_of_All_Slices{1};
if ~isempty(Crossing_Point_of_first_Slice)
    % ���ٶ�λ������ӡ���򸽽��������ӡ�ĵ�һ����XY����ֱ�Ϊ1mm
    % �����һ��Ԫ������һ�㣩���ݷǿգ��������ǰ����һ����Ԫ�����㣩��G����
    % ���ٶ�λʱ������������
    fprintf(fileID,'G0 F%d X%.2f Y%.2f Z%.2f\r\n',...
    Move_Speed_G0,...                        
    Crossing_Point_of_first_Slice(1,1)-1,...
    Crossing_Point_of_first_Slice(1,2)-1,...
    z_slices(1));
    Extrude_Length_of_Each_Step = 0;
    % ���ٶ�λ�����ͬһ���������G����
    % ��һ������ʾG1�ٶ�
    fprintf(fileID,'G1 F%.2f X%.2f Y%.2f\r\n',...
    Move_Speed_G1,...                        % �������ƶ��ٶ�
    Crossing_Point_of_first_Slice(1,1),...
    Crossing_Point_of_first_Slice(1,2));

    % �����㲻����ʾG1�ٶ�
    for l = 2:size(Crossing_Point_of_first_Slice,1)
        % ÿ��ָ�Ҫ����һ��ָ��ļ������ȶ�һ��Extrude_Speed
        % ͨ������Extrude_Speed�Ĵ�С��ͬһ���ӡҲ��ʵ�ֱ���
        Extrude_Length_of_Each_Step = Extrude_Length_of_Each_Step + Extrude_Speed;
        % ���ٶ�λ�����������G����
        fprintf(fileID,'G1 X%.2f Y%.2f E%.5f\r\n',...
        Crossing_Point_of_first_Slice(l,1),...
        Crossing_Point_of_first_Slice(l,2),...
        Extrude_Length_of_Each_Step);
    end 
    %% ����ڶ��㼰���ϲ�G����
    % ���ڵ�һ���Ѿ��������������ӵڶ������
    for i = 2: size(Crossing_Point_of_All_Slices,2)  
        % ͨ��forѭ�� �����ȡÿ����Ƭ���Ԫ���Ӿ��� ������Crossing_Poin_of_each_Slice��
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{i}; 
        % ÿһ�����G����֮ǰ��Ҫ����ò�ı��
        fprintf(fileID,';Layer:%d\r\n',i-1); 
        fprintf(fileID,'M106 S255\r\n');
        % �����ӡ����
        fprintf(fileID,';TYPE:WALL-OUTER\r\n');
        
        % ���ٶ�λ����ǰ��ĵ�һ�����㸽��
        fprintf(fileID,'G0 F%d X%.2f Y%.2f Z%.2f\r\n',...
        Move_Speed_G0,...                     %�����ƶ�ʱ�ļ������ƶ��ٶ�
        Crossing_Point_of_each_Slice(1,1)-1,... % X����
        Crossing_Point_of_each_Slice(1,2)-1,... % Y����
        z_slices(i)); 

        % ��һ������(j=1)��ʾ�������ƶ��ٶȣ�ͬһ��������㲻����ʾ�������ٶ�
        fprintf(fileID,'G1 F%d X%.2f Y%.2f E%.5f\r\n',...
        Move_Speed_G1,...                        % �������ƶ��ٶ�
        Crossing_Point_of_each_Slice(1,1),... % X����
        Crossing_Point_of_each_Slice(1,2),... % Y����
        Extrude_Length_of_Each_Step);         % �������ļ����ٶ�
        % ͬһ�㣬��һ������G1����������ƶ��ٶȣ�֮��ĵ㣨j>=2��(֮���ָ��)������ʾ�������ƶ��ٶ�
        for j = 2:size(Crossing_Point_of_each_Slice,1)
            % ÿ��ָ�Ҫ����һ��ָ��ļ������ȶ�һ��Extrude_Speed
            % ͨ������Extrude_Speed�Ĵ�С��ͬһ���ӡҲ��ʵ�ֱ���
            Extrude_Length_of_Each_Step = Extrude_Length_of_Each_Step + Extrude_Speed;
            fprintf(fileID,'G1 X%.2f Y%.2f E%.5f\r\n',...
            Crossing_Point_of_each_Slice(j,1),...
            Crossing_Point_of_each_Slice(j,2),...
            Extrude_Length_of_Each_Step);
        end 
        
    end

%% ��ȡ��һԪ���Ӿ���ʱ�ĵڶ������
else 
    Extrude_Length_of_Each_Step = 0;
    % �����һ��Ԫ������һ�㣩���ݿգ��������2��Ԫ�����㣩��G����
    % �����һ��G����
    Crossing_Point_of_first_Slice = Crossing_Point_of_All_Slices{2};
    % ���ٶ�λ
    fprintf(fileID,'G0 F%d X%.2f Y%.2f Z%.2f\r\n',...
    Move_Speed_G0,... 
    Crossing_Point_of_first_Slice(1,1)-1,...
    Crossing_Point_of_first_Slice(1,2)-1,...
    z_slices(2));
    % ���ٶ�λ�����ͬһ���������G����
    % ��һ������ʾG1�ٶȣ������㲻����ʾG1�ٶ�
    fprintf(fileID,'G1 F%d X%.2f Y%.2f\r\n',...
    Move_Speed_G1,... 
    Crossing_Point_of_first_Slice(1,1),...
    Crossing_Point_of_first_Slice(1,2));

    for k = 2:size(Crossing_Point_of_first_Slice,1)
        % ÿ��ָ�Ҫ����һ��ָ��ļ������ȶ�һ��Extrude_Speed
        % ͨ������Extrude_Speed�Ĵ�С��ͬһ���ӡҲ��ʵ�ֱ���
        Extrude_Length_of_Each_Step = Extrude_Length_of_Each_Step + Extrude_Speed;
        % ���ٶ�λ�����ͬһ���������G����
        fprintf(fileID,'G1 X%.2f Y%.2f E%.5f\r\n',...
        Crossing_Point_of_first_Slice(k,1),...
        Crossing_Point_of_first_Slice(k,2),...
        Extrude_Length_of_Each_Step);
    end  
    % �����һ��Ԫ��Ϊ�գ��ڶ����Ѿ��������������ӵ��������
    for i = 3 : size(Crossing_Point_of_All_Slices,2)
        % ͨ��forѭ�� �����ȡÿ����Ƭ���Ԫ���Ӿ��� ������Crossing_Poin_of_each_Slice��
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{i}; 
        % ÿһ�����G����֮ǰ��Ҫ����ò�ı��
        fprintf(fileID,';Layer:%d\r\n',i-2); 
        fprintf(fileID,'M106 S255\r\n');
        % �����ӡ����
        fprintf(fileID,';TYPE:WALL-OUTER\r\n');
        % ÿһ�㶼Ҫ���п��ٶ�λ
        % ���ٶ�λ����ǰ��ĵ�һ�����㸽��,�����һ��(X,Y)��1mm
        % ͬ����ٶ�λʱ���Z�����꣬����ָ������Z����
        fprintf(fileID,'G0 F%d X%.2f Y%.2f Z%.2f\r\n',...
        Move_Speed_G0,...                     %�����ƶ�ʱ�ļ������ƶ��ٶ�
        Crossing_Point_of_each_Slice(1,1)-1,... % X����
        Crossing_Point_of_each_Slice(1,2)-1,... % Y����
        z_slices(i)); 

        % ͬһ��ĵ�һ������(j=1)��ʾ�������ƶ��ٶȣ�
        % ͬһ��������㲻����ʾ�������ƶ��ٶ�
        fprintf(fileID,'G1 F%d X%.2f Y%.2f E%.5f\r\n',...
        Move_Speed_G1,...                    % G1�˶�ʱ�ļ������ƶ��ٶ�
        Crossing_Point_of_each_Slice(1,1),...% X����
        Crossing_Point_of_each_Slice(1,2),...% Y����
        Extrude_Length_of_Each_Step);   

        % ͬһ�㣬��һ��ָ��G1����������ƶ��ٶȣ�
        % ֮��ĵ㣨j>=2��(֮���ָ��)������ʾ�������ƶ��ٶ�
        for j = 2:size(Crossing_Point_of_each_Slice,1)
            % ÿ��ָ�Ҫ����һ��ָ��ļ������ȶ�һ��Extrude_Speed
            % ͨ������Extrude_Speed�Ĵ�С��ͬһ���ӡҲ��ʵ�ֱ���
            Extrude_Length_of_Each_Step = Extrude_Length_of_Each_Step + Extrude_Speed;
            fprintf(fileID,'G1 X%.2f Y%.2f E%.5f\r\n',...
            Crossing_Point_of_each_Slice(j,1),...
            Crossing_Point_of_each_Slice(j,2),...
            Extrude_Length_of_Each_Step);
        end  
        
    end 
end
 
%% ���ģ�͵���ֹ����
fprintf(fileID,'M107\r\n');
fprintf(fileID,'M104 S0\r\n');
fprintf(fileID,'M140 S0\r\n');
fprintf(fileID,'; Retract the filament\r\n');
fprintf(fileID,'G92 E1\r\n');
fprintf(fileID,'G1 E-1 F300\r\n');
fprintf(fileID,'G28 X0 Y0\r\n');
fprintf(fileID,'M84\r\n');
fprintf(fileID,'M104 S0\r\n');
fprintf(fileID,';End of Gcode\r\n');

end

