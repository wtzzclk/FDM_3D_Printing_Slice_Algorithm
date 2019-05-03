function varargout = GUI_DEV(varargin)
% GUI_DEV MATLAB code for GUI_DEV.fig
%      GUI_DEV, by itself, creates a new GUI_DEV or raises the existing
%      singleton*.
%
%      H = GUI_DEV returns the handle to a new GUI_DEV or the handle to
%      the existing singleton*.
%
%      GUI_DEV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DEV.M with the given input arguments.
%
%      GUI_DEV('Property','Value',...) creates a new GUI_DEV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_DEV_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_DEV_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_DEV

% Last Modified by GUIDE v2.5 02-Oct-2018 10:43:20

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_DEV_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_DEV_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_DEV is made visible.
function GUI_DEV_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_DEV (see VARARGIN)

% Choose default command line output for GUI_DEV
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_DEV wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_DEV_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fulldir_GUI = evalin('base','fulldir');
slice_height_GUI = evalin('base','slice_height');

% 读取二进制的STL模型文件
[numTriangles_GUI,triangles_GUI] = read_binary_stl_file(fulldir_GUI);
assignin('base','numTriangles',numTriangles_GUI);
assignin('base','triangles',triangles_GUI);
% 切片处理
[Crossing_Point_of_All_Slices_GUI,z_slices_GUI,model_height_GUI,triangles_new_GUI] = ...
    slice_stl_create_path(triangles_GUI, slice_height_GUI);

Total_Slices_GUI = size(Crossing_Point_of_All_Slices_GUI,2);

assignin('base','Crossing_Point_of_All_Slices',Crossing_Point_of_All_Slices_GUI);
assignin('base','z_slices',z_slices_GUI);
assignin('base','model_height',model_height_GUI);
assignin('base','triangles_new',triangles_new_GUI);
assignin('base','Total_Slices',Total_Slices_GUI);

set(handles.text14 ,'string', Total_Slices_GUI);
set(handles.text16 ,'string', model_height_GUI);
set(handles.text37,'string','1');
set(handles.text36,'string',Total_Slices_GUI);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.stl','All STL Files';...
          '*.*','All Files' });
fulldir_GUI = fullfile(pathname,filename);
assignin('base','fulldir',fulldir_GUI);
set(handles.text2 ,'string', fulldir_GUI);
% 将 stl 模型的数据存入工作区的 fv 中
assignin('base','fv',read_binary_or_ascii_stl(fulldir_GUI));
% 将工作区变量fv中的模型数据读入GUI存储空间的fv_GUI中
fv_GUI = evalin('base','fv');
axes(handles.axes1);
% 这个模型通过PATCH图像函数进行润色，添加了一些动态光源
% 并且调整了材料属性以改变模型的光泽
title('STL原始模型');
xlabel('X');ylabel('Y');zlabel('Z');
patch(fv_GUI,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);
rotate3d on 
% 增加相机光源，并且调整反光强度
camlight('headlight'); 
material('dull'); 
% 设定查看角度 使图形适合窗口大小显示
axis('image');
view([-135 40]);


function Slice_Height_Callback(hObject, eventdata, handles)
% hObject    handle to Slice_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Slice_Height as text
%        str2double(get(hObject,'String')) returns contents of Slice_Height as a double
str = get(hObject,'String');
slice_height_GUI = str2double(str);
set(handles.text20 ,'string', slice_height_GUI);
% 将可编辑文本获取的数值存入工作空间
assignin('base','slice_height',slice_height_GUI);

% --- Executes during object creation, after setting all properties.
function Slice_Height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slice_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

Number_of_Slice_GUI = str2double(get(hObject,'String'));
% set(handles.slider2,'value',Number_of_Slice_GUI);
assignin('base','Number_of_Slice',Number_of_Slice_GUI);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
if str2double(get(hObject,'String')) == 0
    Delay_Time_3D_GUI = 0;
else
    Delay_Time_3D_GUI = (10^(-6))/str2double(get(hObject,'String'));
end
% 将可编辑文本获取的数值存入工作空间
assignin('base','Delay_Time_3D',Delay_Time_3D_GUI);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_plot3D.
function pushbutton_plot3D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
title('模型分层与轮廓提取')
xlabel('X');ylabel('Y');zlabel('Z');
view(-135,40);
z_slices_GUI = evalin('base','z_slices');
Crossing_Point_of_All_Slices_GUI = evalin('base','Crossing_Point_of_All_Slices');
Delay_Time_3D_GUI = evalin('base','Delay_Time_3D');
axis([-Inf Inf -Inf Inf z_slices_GUI(1) z_slices_GUI(end)])

plot_slices_3D(Crossing_Point_of_All_Slices_GUI,z_slices_GUI,Delay_Time_3D_GUI);
rotate3d on

% --- Executes on button press in pushbutton_empty.
function pushbutton_empty_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_empty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
cla;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
cla reset
%cla;
title('二维切片绘图');
Delay_Time_2D_GUI = evalin('base','Delay_Time_2D');
Number_of_Slice_GUI = evalin('base','Number_of_Slice');
Crossing_Point_of_All_Slices_GUI = evalin('base','Crossing_Point_of_All_Slices');
plot_slices_2D(Crossing_Point_of_All_Slices_GUI,Number_of_Slice_GUI,Delay_Time_2D_GUI);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
if str2double(get(hObject,'String')) == 0
    Delay_Time_2D_GUI = 0;
else
    Delay_Time_2D_GUI = (10^(-6))/str2double(get(hObject,'String'));
end
% 将可编辑文本获取的数值存入工作空间
assignin('base','Delay_Time_2D',Delay_Time_2D_GUI);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
Extrude_Speed_GUI = str2double(get(hObject,'String'));

% 将可编辑文本获取的数值存入工作空间
assignin('base','Extrude_Speed',Extrude_Speed_GUI);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
Move_Speed_G1_GUI = str2double(get(hObject,'String'));

% 将可编辑文本获取的数值存入工作空间
assignin('base','Move_Speed_G1',Move_Speed_G1_GUI);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
Move_Speed_G0_GUI = str2double(get(hObject,'String'));
% 将可编辑文本获取的数值存入工作空间
assignin('base','Move_Speed_G0',Move_Speed_G0_GUI);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
z_slices1_GUI = str2double(get(hObject,'String'));
% 更改第一层切片高度值
z_slices_GUI = evalin('base','z_slices');
z_slices_GUI(1) = z_slices1_GUI;
assignin('base','z_slices',z_slices_GUI);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename ,pathname]=uiputfile({'*.gcode','Gcode-files(*.gcode)'},'Save as');
%pathname获取保存数据路径，filename获取保存数据名称
save_direction=strcat(pathname,filename);%字符串连接
set(handles.text30,'string',save_direction);

Crossing_Point_of_All_Slices_GUI = evalin('base','Crossing_Point_of_All_Slices');
z_slices_GUI = evalin('base','z_slices');
Extrude_Speed_GUI = evalin('base','Extrude_Speed');
Move_Speed_G0_GUI = evalin('base','Move_Speed_G0');
Move_Speed_G1_GUI = evalin('base','Move_Speed_G1');
slice_height_GUI = evalin('base','slice_height');

generate_gcode(Crossing_Point_of_All_Slices_GUI,z_slices_GUI,...
    Extrude_Speed_GUI,Move_Speed_G0_GUI,Move_Speed_G1_GUI,slice_height_GUI,save_direction);


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function text30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
% 不需要循环，用下边这个命令，就可以把所有edit控件里的数据清空
% set(findobj('style','edit'),'string','')
set(handles.Slice_Height,'string','0.2');
set(handles.edit3,'string','0');
set(handles.edit2,'string','5');
set(handles.edit5,'string','0');
set(handles.text2,'string','OPENING PATH DIR ...');
set(handles.text14,'string','Num');
set(handles.text16,'string','Num');
set(handles.text20,'string','Num');
set(handles.text30,'string','SAVING PATH DIR ...');
set(handles.edit6,'string','0.01485');
set(handles.edit7,'string','1800');
set(handles.edit8,'string','3600');
set(handles.edit9,'string','0.1');
set(handles.text36,'string','Max');
set(handles.text34,'string','Num');
set(handles.text37,'string','Min');
clear variables
clc


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Total_Slices_GUI = evalin('base','Total_Slices');
set(handles.slider2,'Min',1);
set(handles.slider2,'Max',Total_Slices_GUI);
set(handles.slider2,'SliderStep',[1/Total_Slices_GUI,1/Total_Slices_GUI]);
Slider_value_GUI_Oringinal = get(hObject,'value');
if ~isempty(Slider_value_GUI_Oringinal) && ...
        (Slider_value_GUI_Oringinal >= 1 & ...
        Slider_value_GUI_Oringinal <=Total_Slices_GUI)
    set(handles.text34,'string',num2str(Slider_value_GUI_Oringinal,'%3.0f'));
    Slider_value_GUI = round(Slider_value_GUI_Oringinal);
else
    set(handles.slider2, 'Value', 1);
end
axes(handles.axes2);
cla reset
%cla;
title('二维切片绘图');
Crossing_Point_of_All_Slices_GUI = evalin('base','Crossing_Point_of_All_Slices');
plot_slices_2D(Crossing_Point_of_All_Slices_GUI,Slider_value_GUI,0.0);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile({'*.jpg','JPEG(*.jpg)';... 
    '*.bmp','Bitmap(*.bmp)';... 
    '*.gif','GIF(*.gif)';... 
    '*.*', 'All Files (*.*)'},... 
    'Save Picture','Untitled'); 
    if FileName == 0 
        disp('保存失败'); 
        return; 
    else
        h=getframe(handles.axes2);%picture是GUI界面绘图的坐标系句柄
        imwrite(h.cdata,[PathName,FileName]); 
    end 
