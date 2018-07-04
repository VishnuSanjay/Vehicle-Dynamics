function varargout = Linear_Sim_GUI(varargin)
% LINEAR_SIM_GUI MATLAB code for Linear_Sim_GUI.fig
%      LINEAR_SIM_GUI, by itself, creates a new LINEAR_SIM_GUI or raises the existing
%      singleton*.
%
%      H = LINEAR_SIM_GUI returns the handle to a new LINEAR_SIM_GUI or the handle to
%      the existing singleton*.
%
%      LINEAR_SIM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINEAR_SIM_GUI.M with the given input arguments.
%
%      LINEAR_SIM_GUI('Property','Value',...) creates a new LINEAR_SIM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Linear_Sim_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Linear_Sim_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Linear_Sim_GUI

% Last Modified by GUIDE v2.5 03-Jul-2018 23:10:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Linear_Sim_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Linear_Sim_GUI_OutputFcn, ...
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


% --- Executes just before Linear_Sim_GUI is made visible.
function Linear_Sim_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Linear_Sim_GUI (see VARARGIN)

% Choose default command line output for Linear_Sim_GUI
handles.output = hObject;
m = str2num(get(handles.m,'string'));
% Update handles structure
guidata(hObject, handles);
make_xfers(hObject);


% UIWAIT makes Linear_Sim_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Linear_Sim_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function x=make_xfers(hObject)
handles=guidata(hObject);
handles.output = hObject;
DF=str2double(get(handles.DF,'String'));
DR=str2double(get(handles.DR,'String'));
wb =str2double(get(handles.wb,'String'));
m=str2double(get(handles.m,'String'));
mf=str2double(get(handles.mf,'String'));
SR=str2double(get(handles.SR,'String'));
speed=str2double(get(handles.speed,'String'));
kdash=str2double(get(handles.kdash,'String'));
fintim=str2double(get(handles.fintim,'String'));
tmid=str2double(get(handles.tmid,'String'));
hw=str2double(get(handles.hw,'String'));
pwr=str2double(get(handles.pwr,'String'));
swamp=str2double(get(handles.swamp,'String'));
mr = m - mf/100 * m;
a=mr/m * wb; 
b=mf/m * wb;

IZZ = (kdash+1) * m * a * b;%% yaw moment of inertia of the vehicle, in kg m^2
CF =  57.3 * mf * 9.81 / DF;%% Front tire cornering stiffness, input in N/deg, gets converted to N/rad
CR =  57.3 * mr * 9.81 / DR;%% Same as above, for rear tires

t =[0:.01:fintim];
 
u=speed / 3.6; 


%%% Computation area
D1 = m * u * IZZ;
D2 = (IZZ * (CF+CR)) + (m * (a^2 * CF + b^2 * CR));
D3 = ((a+b)^2 * CF * CR / u) + (m * u * (b * CR - a * CF));
denom = [D1 D2 D3];

%%% Yaw velocity numerator
N1 = a * m * u * CF;
N2 = (a+b) * CF * CR;
yawn = [N1 N2];
yawan = [N1 N2 0];

%%% Sideslip angle numerator
N3 = IZZ * CF;
N4 = (CF * CR * (b^2 + a * b) / u) - a * m * u * CF;
betan = [N3 N4];
dbetan = [N3 N4 0];

%%% Lateral acceleration numerator
N5 = u * IZZ * CF;
N6 = CF * CR * (b^2 + a * b);
N7 = (a+b) * CF * CR * u;
ayn = [N5 N6 N7];

%%% transfer functions
yawvtxy = tf(yawn, denom); %%yaw velocity to steer 
betatxy = tf(betan, denom); %% sideslip by steer
aytxy = tf(ayn, denom); %% lateral acceleration by steer
sstxy = tf(betan, ayn); %% sideslip by lateral acceleration
yawatxy = tf(yawan, denom); %%yaw acceleration to steer
dbetaxy = tf(dbetan, denom); %%sideslip velocity by steer

steer=(-2./pi*atan(abs((t-tmid)./hw).^pwr)+1.).*swamp; %% in degrees
swavel=max(gradient(steer,.01)); %in degrees per second
steerrad = steer / 57.3;

%%% Responses and plots
yawvresp = lsim(yawvtxy,steerrad / SR ,t); %% yaw response wrt wheel angle
betaresp = lsim(betatxy, steerrad / SR, t); %%beta response wrt wheel angle
latresp = lsim(aytxy, steerrad / SR ,t);
yawaresp = lsim(yawatxy, steerrad / SR , t); %%yaw acceleration response wrt wheel angle
sideresp = lsim(sstxy, steerrad / SR, t);

[mag,phase,w] = bode(yawvtxy);
mag           = squeeze(mag);
w             = squeeze(w);
[mag1,phase1,w1] = bode(sstxy);
mag1           = squeeze(mag1);
w1             = squeeze(w1);
[mag2,phase2,w2] = bode(aytxy);
mag2           = squeeze(mag2);
w2             = squeeze(w2);
[mag3,phase3,w3] = bode(yawatxy);
mag3           = squeeze(mag3);
w3            = squeeze(w3);

axes(handles.plot12)
plot(w/2/pi,mag*100/SR,'b-');
xlim([0 4])
grid on
ylabel('Yaw velocity Gain (deg / sec / 100 deg SWA)')
legend('Theory')

axes(handles.plot13)
plot(w1/2/pi,mag1 * 57.3 * 9.807,'b-');
xlim([0 4])
grid on
ylabel('Sideslip Gain')
legend('Theory')

axes(handles.plot21)
plot(w2/2/pi,mag2* 100/ 57.3 /SR /9.807,'b-');
xlim([0 4])
grid on
ylabel('Lateral acceleration Gain (gs per 100 deg SWA)')
legend('Theory')

axes(handles.plot22)
plot(w/2/pi,mag3*100/SR,'b-');
xlim([0 4])
grid on
ylabel('Yaw acceleratoin (deg / sec^2 / 100 deg SWA)')
legend('Theory')

axes(handles.plot31)
plot(t, yawvresp * 180 / pi, 'k')
xlabel('Time (s)') 
ylabel('Yaw velocity (deg/sec)')

axes(handles.plot32)
plot(t,betaresp * 180 / pi , 'r')
xlabel('Time (s)') 
ylabel('Sideslip angle (deg)')

axes(handles.plot33)
plot(t,latresp / 9.807 , 'b')
xlabel('Time (s)') 
ylabel('Lateral acceleration (g)')

axes(handles.plot11)
plot(t ,steer, 'y')
xlabel('Time (s)') 
ylabel('Steer (deg)')

function m_Callback(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m as text
%        str2double(get(hObject,'String')) returns contents of m as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mf_Callback(hObject, eventdata, handles)
% hObject    handle to mf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mf as text
%        str2double(get(hObject,'String')) returns contents of mf as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function mf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wb_Callback(hObject, eventdata, handles)
% hObject    handle to wb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wb as text
%        str2double(get(hObject,'String')) returns contents of wb as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function wb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kdash_Callback(hObject, eventdata, handles)
% hObject    handle to kdash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kdash as text
%        str2double(get(hObject,'String')) returns contents of kdash as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function kdash_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kdash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DF_Callback(hObject, eventdata, handles)
% hObject    handle to DF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DF as text
%        str2double(get(hObject,'String')) returns contents of DF as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function DF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DR_Callback(hObject, eventdata, handles)
% hObject    handle to DR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DR as text
%        str2double(get(hObject,'String')) returns contents of DR as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function DR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed as text
%        str2double(get(hObject,'String')) returns contents of speed as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SR_Callback(hObject, eventdata, handles)
% hObject    handle to SR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SR as text
%        str2double(get(hObject,'String')) returns contents of SR as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function SR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Pulse_Steer.
function Pulse_Steer_Callback(hObject, eventdata, handles)
% hObject    handle to Pulse_Steer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Pulse_Steer
make_xfers(hObject);


function swamp_Callback(hObject, eventdata, handles)
% hObject    handle to swamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of swamp as text
%        str2double(get(hObject,'String')) returns contents of swamp as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function swamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pwr_Callback(hObject, eventdata, handles)
% hObject    handle to pwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pwr as text
%        str2double(get(hObject,'String')) returns contents of pwr as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function pwr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tmid_Callback(hObject, eventdata, handles)
% hObject    handle to tmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tmid as text
%        str2double(get(hObject,'String')) returns contents of tmid as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function tmid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fintim_Callback(hObject, eventdata, handles)
% hObject    handle to fintim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fintim as text
%        str2double(get(hObject,'String')) returns contents of fintim as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function fintim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fintim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function hw_Callback(hObject, eventdata, handles)
% hObject    handle to hw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hw as text
%        str2double(get(hObject,'String')) returns contents of hw as a double
make_xfers(hObject);

% --- Executes during object creation, after setting all properties.
function hw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
