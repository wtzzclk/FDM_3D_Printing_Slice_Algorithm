function [] = generate_gcode( Crossing_Point_of_All_Slices,z_slices,Extrude_Speed,Move_Speed_G0,Move_Speed_G1,slice_height,save_direction)
% Crossing_Point_of_All_Slices 所有分层的交点坐标
% z_slices 所有切片分层的Z坐标值，一维行向量
% Extrude_Speed 挤出速度控制，*mm/两个连续输出的交点
% slice_height 切片分层厚度
% Move_Speed （滑块）挤出头的移动速度，不是挤出速度
% 所有切片层的Z坐标值 z_slices = min_z: slice_height :max_z;
 %% 输出模型的起始代码
fileID = fopen(save_direction,'w'); % 打开并写入文件femur_O.gcode
fprintf(fileID,'Layer height:%.2f\r\n',slice_height); %显示层高
fprintf(fileID,'M104 S200\r\n');  % 在文件中写入Gcode
fprintf(fileID,'M109 S200\r\n'); % 设置喷头的目标温度，然后在加热过程中等待
% 以下的起始代码，每个模型均相同（参考cura软件 Machine_Setting）
fprintf(fileID,'G28;Home\r\n'); %该命令将使挤出机回到坐标原点
fprintf(fileID,'G1 Z15.0 F6000;Move the platform down 15mm\r\n');
fprintf(fileID,';Prime the extruder\r\n');
fprintf(fileID,'G92 E0\r\n'); % G92指定当前各轴的坐标值指定当前各轴的坐标值
fprintf(fileID,'G1 F200 E3\r\n');
fprintf(fileID,'G92 E0\r\n');

%% 输出模型的代码Gcode
fprintf(fileID,';Layer_Count:%d\r\n',size(z_slices,2)); %统计切片和打印的层数
%% 输出第一层G代码
fprintf(fileID,';Layer:%d\r\n',0); %定义初始层0
%关闭风扇 M106 S0也可以达到相同的效果
fprintf(fileID,'M107\r\n'); 
% 提取第一层（第一个元胞）数据
Crossing_Point_of_first_Slice = Crossing_Point_of_All_Slices{1};
if ~isempty(Crossing_Point_of_first_Slice)
    % 快速定位到待打印区域附近，距离打印的第一个点XY方向分别为1mm
    % 如果第一个元胞（第一层）数据非空，则输出当前（第一个）元胞（层）的G代码
    % 快速定位时挤出机不挤出
    fprintf(fileID,'G0 F%d X%.2f Y%.2f Z%.2f\r\n',...
    Move_Speed_G0,...                        
    Crossing_Point_of_first_Slice(1,1)-1,...
    Crossing_Point_of_first_Slice(1,2)-1,...
    z_slices(1));
    Extrude_Length_of_Each_Step = 0;
    % 快速定位后输出同一层其他点的G代码
    % 第一顶点显示G1速度
    fprintf(fileID,'G1 F%.2f X%.2f Y%.2f\r\n',...
    Move_Speed_G1,...                        % 挤出机移动速度
    Crossing_Point_of_first_Slice(1,1),...
    Crossing_Point_of_first_Slice(1,2));

    % 其他点不再显示G1速度
    for l = 2:size(Crossing_Point_of_first_Slice,1)
        % 每个指令都要比上一个指令的挤出长度多一个Extrude_Speed
        % 通过调整Extrude_Speed的大小，同一层打印也可实现变速
        Extrude_Length_of_Each_Step = Extrude_Length_of_Each_Step + Extrude_Speed;
        % 快速定位后输出其他点G代码
        fprintf(fileID,'G1 X%.2f Y%.2f E%.5f\r\n',...
        Crossing_Point_of_first_Slice(l,1),...
        Crossing_Point_of_first_Slice(l,2),...
        Extrude_Length_of_Each_Step);
    end 
    %% 输出第二层及以上层G代码
    % 由于第一层已经输出，所以这里从第二层输出
    for i = 2: size(Crossing_Point_of_All_Slices,2)  
        % 通过for循环 逐个提取每个切片层的元胞子矩阵 到矩阵Crossing_Poin_of_each_Slice中
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{i}; 
        % 每一层输出G代码之前都要定义该层的编号
        fprintf(fileID,';Layer:%d\r\n',i-1); 
        fprintf(fileID,'M106 S255\r\n');
        % 定义打印类型
        fprintf(fileID,';TYPE:WALL-OUTER\r\n');
        
        % 快速定位到当前层的第一个顶点附近
        fprintf(fileID,'G0 F%d X%.2f Y%.2f Z%.2f\r\n',...
        Move_Speed_G0,...                     %快速移动时的挤出机移动速度
        Crossing_Point_of_each_Slice(1,1)-1,... % X坐标
        Crossing_Point_of_each_Slice(1,2)-1,... % Y坐标
        z_slices(i)); 

        % 第一个顶点(j=1)显示挤出机移动速度，同一层的其他点不再显示挤出机速度
        fprintf(fileID,'G1 F%d X%.2f Y%.2f E%.5f\r\n',...
        Move_Speed_G1,...                        % 挤出机移动速度
        Crossing_Point_of_each_Slice(1,1),... % X坐标
        Crossing_Point_of_each_Slice(1,2),... % Y坐标
        Extrude_Length_of_Each_Step);         % 挤出机的挤出速度
        % 同一层，第一个命令G1输出挤出机移动速度，之后的点（j>=2）(之后的指令)不再显示挤出机移动速度
        for j = 2:size(Crossing_Point_of_each_Slice,1)
            % 每个指令都要比上一个指令的挤出长度多一个Extrude_Speed
            % 通过调整Extrude_Speed的大小，同一层打印也可实现变速
            Extrude_Length_of_Each_Step = Extrude_Length_of_Each_Step + Extrude_Speed;
            fprintf(fileID,'G1 X%.2f Y%.2f E%.5f\r\n',...
            Crossing_Point_of_each_Slice(j,1),...
            Crossing_Point_of_each_Slice(j,2),...
            Extrude_Length_of_Each_Step);
        end 
        
    end

%% 读取第一元胞子矩阵时的第二种情况
else 
    Extrude_Length_of_Each_Step = 0;
    % 如果第一个元胞（第一层）数据空，则输出第2个元胞（层）的G代码
    % 输出第一层G代码
    Crossing_Point_of_first_Slice = Crossing_Point_of_All_Slices{2};
    % 快速定位
    fprintf(fileID,'G0 F%d X%.2f Y%.2f Z%.2f\r\n',...
    Move_Speed_G0,... 
    Crossing_Point_of_first_Slice(1,1)-1,...
    Crossing_Point_of_first_Slice(1,2)-1,...
    z_slices(2));
    % 快速定位后输出同一层其他点的G代码
    % 第一顶点显示G1速度，其他点不再显示G1速度
    fprintf(fileID,'G1 F%d X%.2f Y%.2f\r\n',...
    Move_Speed_G1,... 
    Crossing_Point_of_first_Slice(1,1),...
    Crossing_Point_of_first_Slice(1,2));

    for k = 2:size(Crossing_Point_of_first_Slice,1)
        % 每个指令都要比上一个指令的挤出长度多一个Extrude_Speed
        % 通过调整Extrude_Speed的大小，同一层打印也可实现变速
        Extrude_Length_of_Each_Step = Extrude_Length_of_Each_Step + Extrude_Speed;
        % 快速定位后输出同一层其他点的G代码
        fprintf(fileID,'G1 X%.2f Y%.2f E%.5f\r\n',...
        Crossing_Point_of_first_Slice(k,1),...
        Crossing_Point_of_first_Slice(k,2),...
        Extrude_Length_of_Each_Step);
    end  
    % 如果第一层元胞为空，第二层已经输出，所以这里从第三层输出
    for i = 3 : size(Crossing_Point_of_All_Slices,2)
        % 通过for循环 逐个提取每个切片层的元胞子矩阵 到矩阵Crossing_Poin_of_each_Slice中
        Crossing_Point_of_each_Slice = Crossing_Point_of_All_Slices{i}; 
        % 每一层输出G代码之前都要定义该层的编号
        fprintf(fileID,';Layer:%d\r\n',i-2); 
        fprintf(fileID,'M106 S255\r\n');
        % 定义打印类型
        fprintf(fileID,';TYPE:WALL-OUTER\r\n');
        % 每一层都要进行快速定位
        % 快速定位到当前层的第一个顶点附近,距离第一点(X,Y)各1mm
        % 同层快速定位时输出Z轴坐标，其他指令不再输出Z坐标
        fprintf(fileID,'G0 F%d X%.2f Y%.2f Z%.2f\r\n',...
        Move_Speed_G0,...                     %快速移动时的挤出机移动速度
        Crossing_Point_of_each_Slice(1,1)-1,... % X坐标
        Crossing_Point_of_each_Slice(1,2)-1,... % Y坐标
        z_slices(i)); 

        % 同一层的第一个顶点(j=1)显示挤出机移动速度，
        % 同一层的其他点不再显示挤出机移动速度
        fprintf(fileID,'G1 F%d X%.2f Y%.2f E%.5f\r\n',...
        Move_Speed_G1,...                    % G1运动时的挤出机移动速度
        Crossing_Point_of_each_Slice(1,1),...% X坐标
        Crossing_Point_of_each_Slice(1,2),...% Y坐标
        Extrude_Length_of_Each_Step);   

        % 同一层，第一个指令G1输出挤出机移动速度，
        % 之后的点（j>=2）(之后的指令)不再显示挤出机移动速度
        for j = 2:size(Crossing_Point_of_each_Slice,1)
            % 每个指令都要比上一个指令的挤出长度多一个Extrude_Speed
            % 通过调整Extrude_Speed的大小，同一层打印也可实现变速
            Extrude_Length_of_Each_Step = Extrude_Length_of_Each_Step + Extrude_Speed;
            fprintf(fileID,'G1 X%.2f Y%.2f E%.5f\r\n',...
            Crossing_Point_of_each_Slice(j,1),...
            Crossing_Point_of_each_Slice(j,2),...
            Extrude_Length_of_Each_Step);
        end  
        
    end 
end
 
%% 输出模型的终止代码
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

