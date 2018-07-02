function varargout = Linear_Sim(varargin)
% Linear_Sim M-file for Linear_Sim.fig
%      Linear_Sim, by itself, creates a new Linear_Sim or raises the existing
%      singleton*.
%
%      H = Linear_Sim returns the handle to a new Linear_Sim or the handle to
%      the existing singleton*.
%
%      Linear_Sim('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Linear_Sim.M with the given input arguments.
%
%      Linear_Sim('Property','Value',...) creates a new Linear_Sim or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VHSIM_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Linear_Sim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Linear_Sim

% Last Modified by GUIDE v2.5 29-Aug-2017 22:55:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Linear_Sim_OpeningFcn, ...
                   'gui_OutputFcn',  @Linear_Sim_OutputFcn, ...
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

% --- Executes just before Linear_Sim is made visible.
function Linear_Sim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Linear_Sim (see VARARGIN)

% Choose default command line output for Linear_Sim
handles.output = hObject;
% Update handles structure
movegui(hObject,'center')
guidata(hObject, handles);
make_xfers(hObject);

% UIWAIT makes Linear_Sim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Linear_Sim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function DF_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function DF_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DR_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function DR_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function L_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function L_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WF_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function WF_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WR_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function WR_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)


function edit6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SPEED_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function SPEED_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function IZZ_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function IZZ_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function PWR_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function PWR_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function x=make_xfers(hObject)
handles=guidata(hObject);
handles.output = hObject;
df=str2double(get(handles.DF,'String'));
dr=str2double(get(handles.DR,'String'));
l=str2double(get(handles.L,'String'));
wf=str2double(get(handles.WF,'String'));
wr=str2double(get(handles.WR,'String'));
sr=str2double(get(handles.SR,'String'));
speed=str2double(get(handles.SPEED,'String'));
IZZ=str2double(get(handles.IZZ,'String'));
t=[0:.01:1.5];
tmid=1.5;
hw=1;
pwr=get(handles.PWR,'Value');
wb=l/1000 ;
a=wb*wr /(wf+wr); 
b=wb-a; 
u=speed*.2778; 
conv=9.806*180/pi;

% YAW VELOCITY TRANSFER FUNCTION Numerator factors:
	r2=0.;	
    r1=a*b*conv*u  / (df*wb);
    r0=a*b*conv^2 / (df*dr*wb);
% lateral acceleration numerator factors:
    a2=IZZ*b*conv*u / (df*wb*(wf+wr));
    a1=a*b^2*conv^2 / (df*dr*wb);
    a0=a*b*conv^2*u / (df*dr*wb);
% sideslip numerator factors:
    b2=0.;
    b1=IZZ*b*conv / (df*wb*(wf+wr));
    b0=a*b*conv*(b*conv-dr*u^2)/(df*dr*wb*u);
% common denominator factors:
    d2=IZZ*u/(wf+wr);
    d1=conv*(a^2*b*(wf+wr)*dr+a*df*(b^2*(wf+wr)+IZZ)+b*dr*IZZ)/(df*dr*wb*(wf+wr));
    d0=a*b*conv*(conv*wb+u^2*(df-dr)) / (df*dr*u*wb);
      
   % inputs to transfer functions are radians of steer.
   % output of Ay is m/sec^2
   
rsys  = tf([   r1 r0],[d2 d1 d0]);
rdsys = tf([r1 r0 0] ,[d2 d1 d0]);
bsys  = tf([   b1 b0],[d2 d1 d0]);
bdsys = tf([b1 b0 0] ,[d2 d1 d0]);
aysys  =tf([a2 a1 a0],[d2 d1 d0]); 

r_bw=bandwidth(rsys); 
b_bw=bandwidth(bsys); 
ay_bw=bandwidth(aysys);

set(handles.R_BW,'String',num2str(round(100*r_bw/(2*pi))/100))
set(handles.TAU_R,'String',num2str(2/r_bw))

set(handles.B_BW ,'String',num2str(round(100*b_bw/(2*pi))/100))
set(handles.TAU_B,'String',num2str(round(100*2/b_bw)/100))

set(handles.AY_BW,'String',num2str(round(100*ay_bw/(2*pi))/100))
set(handles.TAU_AY,'String',num2str(2/ay_bw))

[wn,z]=damp(rsys);
set(handles.WN,'String',num2str(wn(1)/2/pi))
set(handles.ZETA,'String',num2str(z(1)))

swamp=str2double(get(handles.SW_AMP,'String')); 

steer=(-2./pi*atan(abs((t-tmid)./hw).^pwr)+1.).*swamp;
swavel=max(gradient(steer,.01));
set(handles.SWAVEL,'String',num2str(round(swavel)))

axes(handles.axes1)
plot(t,steer,'linewidth',2)
xlabel('Simulated Time (sec)')
ylabel('Steer Input Profile (deg)')
href(0)
vref(.5)

rd=lsim(rdsys,steer./sr,t);
axes(handles.axes2)
plot(t,rd,'linewidth',2)
% xlabel('Simulated Time (sec)')
ylabel('Yaw Accel. (deg/sec^2)')
href(0)
vref(.5)
a=gca;
set(a,'XTicklabel',[])
set(handles.RD_MAX,'String',num2str(round(max(rd))))
set(handles.RD_MIN,'String',num2str(round(min(rd))))


r=lsim(rsys,steer./sr,t);
axes(handles.axes3)
plot(t,r,'linewidth',2)
% xlabel('Simulated Time (sec)')
ylabel('Yaw Vel. (deg/sec)')
href(0)
vref(.5)
a=gca;
set(a,'XTicklabel',[])

bd=lsim(bdsys,steer./sr,t);

axes(handles.axes4);
plot(t,bd,'linewidth',2)
% xlabel('Simulated Time (sec)')
ylabel('Sideslip Vel. (deg/sec)')
href(0)
vref(.5)
a=gca;
set(a,'XTicklabel',[])
set(handles.BD_MAX,'String',num2str(round(100*max(bd))/100))
set(handles.BD_MIN,'String',num2str(round(100*min(bd))/100))

beta=lsim(bsys,steer./sr,t);
axes(handles.axes5);
plot(t,beta,'linewidth',2)
% xlabel('Simulated Time (sec)')
ylabel('Sideslip Angle (deg)')
href(0)
vref(.5)
a=gca;
set(a,'XTicklabel',[])


ay=lsim(aysys,(steer/sr/57.295),t);
axes(handles.axes6);
plot(t,ay,'linewidth',2)
xlabel('Simulated Time (sec)')
ylabel('Lateral Accel. (m/sec^2)')
href(0)
vref(.5)

function ref= href(pt)
for n=1:length(pt)
    line(xlim,[pt(n) pt(n)],'color',[.01 .01 .01])
end

function ref= vref(pt)
for n=1:length(pt)
    line([pt(n) pt(n)],ylim,'color',[.01 .01 .01])
end


function SW_AMP_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function SW_AMP_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function SWA_D_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function SWA_D_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




function SWAVEL_Callback(hObject, eventdata, handles)

function SWAVEL_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%%function IZZ_Callback(hObject, eventdata, handles)
% hObject    handle to IZZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IZZ as text
%        str2double(get(hObject,'String')) returns contents of IZZ as a double


% --- Executes during object creation, after setting all properties.
%%function IZZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IZZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
