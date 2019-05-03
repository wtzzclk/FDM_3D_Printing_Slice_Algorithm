function [rotated] = orient_stl(tri, ax)
%%%orients the stl file in either x, y or z axis. input is oriented in x
%%%axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Author: Sunil Bhandari%%%%%%%%
%%%%Date: Mar 12, 2018 %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ax == 'x'
    rotated = tri;
elseif ax == 'y'
    rotated = [tri(:,2),tri(:,1),tri(:,3), tri(:,5),tri(:,4),tri(:,6),tri(:,8),tri(:,7),tri(:,9),tri(:,10:12)];
elseif ax == 'z'
    rotated = [tri(:,3:-1:1),tri(:,6:-1:4),tri(:,9:-1:7),tri(:,10:12)];
else
    error('ax needs to be x, y or z');
end

end

        
        