function varargout = nlsr(varargin)
% NLSR M-file for nlsr.fig
%      NLSR, by itself, creates a new NLSR or raises the existing
%      singleton*.
%
%      H = NLSR returns the handle to a new NLSR or the handle to
%      the existing singleton*.
%
%      NLSR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NLSR.M with the given input arguments.
%
%      NLSR('Property','Value',...) creates a new NLSR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nlsr_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nlsr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nlsr

% Last Modified by GUIDE v2.5 19-Dec-2015 17:10:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nlsr_OpeningFcn, ...
                   'gui_OutputFcn',  @nlsr_OutputFcn, ...
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


% --- Executes just before nlsr is made visible.
function nlsr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nlsr (see VARARGIN)

% Choose default command line output for nlsr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
draw_srnl(handles)
% UIWAIT makes nlsr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nlsr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function SRa0_Callback(hObject, eventdata, handles)
% hObject    handle to SRa0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SRa0 as text
%        str2double(get(hObject,'String')) returns contents of SRa0 as a double
draw_srnl((handles))

% --- Executes during object creation, after setting all properties.
function SRa0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SRa0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SRa1_Callback(hObject, eventdata, handles)
% hObject    handle to SRa1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SRa1 as text
%        str2double(get(hObject,'String')) returns contents of SRa1 as a double
draw_srnl((handles))

% --- Executes during object creation, after setting all properties.
function SRa1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SRa1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SRb_Callback(hObject, eventdata, handles)
% hObject    handle to SRb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SRb as text
%        str2double(get(hObject,'String')) returns contents of SRb as a double
draw_srnl((handles))

% --- Executes during object creation, after setting all properties.
function SRb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SRb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SRc_Callback(hObject, eventdata, handles)
% hObject    handle to SRc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SRc as text
%        str2double(get(hObject,'String')) returns contents of SRc as a double
draw_srnl((handles))

% --- Executes during object creation, after setting all properties.
function SRc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SRc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SRd_Callback(hObject, eventdata, handles)
% hObject    handle to SRd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SRd as text
%        str2double(get(hObject,'String')) returns contents of SRd as a double
draw_srnl((handles))

% --- Executes during object creation, after setting all properties.
function SRd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SRd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SRf_Callback(hObject, eventdata, handles)
% hObject    handle to SRf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SRf as text
%        str2double(get(hObject,'String')) returns contents of SRf as a double
draw_srnl((handles))

% --- Executes during object creation, after setting all properties.
function SRf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SRf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SRg_Callback(hObject, eventdata, handles)
% hObject    handle to SRg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SRg as text
%        str2double(get(hObject,'String')) returns contents of SRg as a double
draw_srnl((handles))


% --- Executes during object creation, after setting all properties.
function SRg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SRg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SRa2_Callback(hObject, eventdata, handles)
% hObject    handle to SRa2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SRa2 as text
%        str2double(get(hObject,'String')) returns contents of SRa2 as a double


% --- Executes during object creation, after setting all properties.
function SRa2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SRa2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function draw_srnl(handles)
SR(1) = str2double(get(handles.SRa0,'String')); 
SR(2) = str2double(get(handles.SRa1,'String')); 
SR(3) = str2double(get(handles.SRa2,'String')); 
SR(4) = str2double(get(handles.SRb,'String')); 
SR(5) = str2double(get(handles.SRc,'String')); 
SR(6)  = str2double(get(handles.SRd,'String')); 
SR(7)  = str2double(get(handles.SRf,'String')); 
SR(8)  = str2double(get(handles.SRg,'String'));

swa=[-90:90];
sr= sr_func(SR,swa);
plot(swa,sr,[-90 90],[mean(sr) mean(sr)],'--')
ylabel('Overall Steer Ratio (deg/deg)')
xlabel('Steering Wheel Angle (deg)')
yl=get(gca,'Ylim');
xlim([-100 100]);
yl=get(gca,'Ylim');
text(-90,yl(2)-.25,'Dashed Line represents the avg. ratio ±90 deg.','color',[0 0 1])
vref(0)
function [RATIO] = sr_func(SR,swa)
X   = SR(7);
X(X==0)=realmax;
SR(7)=X;   % 
RATIO =  SR(1) + SR(2)/10^3*(swa) + SR(3)/10^6*(swa).^2 + SR(4)*cos(2*(swa- SR(5))/57.3) + SR(6)*exp(-(4*(swa-SR(8))/SR(7)).^2);
function ref= vref(pt)
for n=1:length(pt)
    line([pt(n) pt(n)],ylim,'color',[.01 .01 .01])
end
