function varargout = pacejka4(varargin)
% PACEJKA4 M-file for pacejka4.fig
%      PACEJKA4, by itself, creates a new PACEJKA4 or raises the existing
%      singleton*.
%
%      H = PACEJKA4 returns the handle to a new PACEJKA4 or the handle to
%      the existing singleton*.
%
%      PACEJKA4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PACEJKA4.M with the given input arguments.
%
%      PACEJKA4('Property','Value',...) creates a new PACEJKA4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pacejka4_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pacejka4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pacejka4

% Last Modified by GUIDE v2.5 14-Jan-2016 13:59:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pacejka4_OpeningFcn, ...
                   'gui_OutputFcn',  @pacejka4_OutputFcn, ...
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


% --- Executes just before pacejka4 is made visible.
function pacejka4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pacejka4 (see VARARGIN)

% Choose default command line output for pacejka4
movegui(hObject,'center')
handles.output = hObject;
handles.slips=(0:-.5:-20)';

W1= -9.806*str2double(get(handles.LOAD1,'string')) ;
W2= -9.806*str2double(get(handles.LOAD2,'string')) ;

handles.loads1= W1*ones(length(handles.slips)); 
handles.loads2= W2*ones(length(handles.slips)); 

D1 = get(handles.D1_slider,'value');set(handles.D1,'String',num2str(D1))
D2 = get(handles.D2_slider,'value');set(handles.D2,'String',num2str(D2))
B  = get(handles.B_slider,'value');set(handles.B,'String',num2str(B))
C  = get(handles.C_slider,'value');set(handles.C,'String',num2str(C))
f0=[D1 D2 B C];

set(handles.bcd1,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads1(1)])/handles.loads1(1)));
set(handles.bcd2,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads2(1)])/handles.loads2(1)));
axes(handles.axes1)
handles.p=plot(handles.slips,Pacejka4_Model(f0,[handles.slips,handles.loads1]),handles.slips,Pacejka4_Model(f0,[handles.slips,handles.loads2]));
grid on
xlabel('Slip Angle') 
ylabel('Lateral Force')
set(gca, 'XDir', 'reverse')

legend(['W1 = ' num2str(handles.loads1(1)) 'N'],['W2 = ' num2str(handles.loads2(1)) 'N'])
legend boxoff
title('Example FSAE Tire Specification:')
sidetext('cibachrome')
guidata(hObject, handles);

% UIWAIT makes pacejka4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pacejka4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function LOAD1_Callback(hObject, eventdata, handles)
% hObject    handle to LOAD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LOAD1 as text
%        str2double(get(hObject,'String')) returns contents of LOAD1 as a double
W1= -9.806*str2double(get(handles.LOAD1,'string'))  
W2= -9.806*str2double(get(handles.LOAD2,'string'))  
handles.loads1=  W1*ones(length(handles.slips));
D1 = get(handles.D1_slider,'value');set(handles.D1,'String',num2str(D1))
D2 = get(handles.D2_slider,'value');set(handles.D2,'String',num2str(D2))
B  = get(handles.B_slider,'value');set(handles.B,'String',num2str(B))
C  = get(handles.C_slider,'value');set(handles.C,'String',num2str(C))
f0=[D1 D2 B C];
set(handles.bcd1,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads1(1)])/handles.loads1(1)));
y1=Pacejka4_Model(f0,[handles.slips,handles.loads1]);
set(handles.p(1),'YData',y1)
legend(['W1 = ' num2str(handles.loads1(1)) 'N'],['W2 = ' num2str(handles.loads2(1)) 'N'])
legend boxoff
guidata(hObject);

% --- Executes during object creation, after setting all properties.
function LOAD1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LOAD1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LOAD2_Callback(hObject, eventdata, handles)
% hObject    handle to LOAD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LOAD2 as text
%        str2double(get(hObject,'String')) returns contents of LOAD2 as a double
% W1= -9.806*str2double(get(handles.LOAD1,'string')) ;
W1= -9.806*str2double(get(handles.LOAD1,'string'))  
W2= -9.806*str2double(get(handles.LOAD2,'string'))  

handles.loads1=  W1*ones(length(handles.slips));
handles.loads2=  W2*ones(length(handles.slips));
D1 = get(handles.D1_slider,'value');set(handles.D1,'String',num2str(D1))
D2 = get(handles.D2_slider,'value');set(handles.D2,'String',num2str(D2))
B  = get(handles.B_slider,'value');set(handles.B,'String',num2str(B))
C  = get(handles.C_slider,'value');set(handles.C,'String',num2str(C))
f0=[D1 D2 B C];
set(handles.bcd2,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads2(1)])/handles.loads2(1)));
y2=Pacejka4_Model(f0,[handles.slips,handles.loads2]);
set(handles.p(2),'YData',y2)
legend(['W1 = ' num2str(handles.loads1(1)) 'N'],['W2 = ' num2str(handles.loads2(1)) 'N'])
legend boxoff
guidata(hObject);

% --- Executes during object creation, after setting all properties.
function LOAD2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LOAD2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function B_slider_Callback(hObject, eventdata, handles)
% hObject    handle to B_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
W1= -9.806*str2double(get(handles.LOAD1,'string')) ;
W2= -9.806*str2double(get(handles.LOAD2,'string')) ;

handles.loads1=  W1*ones(length(handles.slips));
handles.loads2=  W2*ones(length(handles.slips));
D1 = get(handles.D1_slider,'value');set(handles.D1,'String',num2str(D1));
D2 = get(handles.D2_slider,'value');set(handles.D2,'String',num2str(D2));
B  = get(handles.B_slider,'value');set(handles.B,'String',num2str(B));
C  = get(handles.C_slider,'value');set(handles.C,'String',num2str(C));
f0=[D1 D2 B C];
set(handles.bcd1,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads1(1)])/handles.loads1(1)));
set(handles.bcd2,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads2(1)])/handles.loads2(1)));
y1=Pacejka4_Model(f0,[handles.slips,handles.loads1]);
y2=Pacejka4_Model(f0,[handles.slips,handles.loads2]);
set(handles.p(1),'YData',y1);
set(handles.p(2),'YData',y2);
legend(['W1 = ' num2str(handles.loads1(1)) 'N'],['W2 = ' num2str(handles.loads2(1)) 'N']);
legend boxoff
guidata(hObject);


% --- Executes during object creation, after setting all properties.
function B_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function C_slider_Callback(hObject, eventdata, handles)
% hObject    handle to C_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
W1= -9.806*str2double(get(handles.LOAD1,'string')) ;
W2= -9.806*str2double(get(handles.LOAD2,'string')) ;

handles.loads1=  W1*ones(length(handles.slips));
handles.loads2=  W2*ones(length(handles.slips));
D1 = get(handles.D1_slider,'value');set(handles.D1,'String',num2str(D1));
D2 = get(handles.D2_slider,'value');set(handles.D2,'String',num2str(D2));
B  = get(handles.B_slider,'value');set(handles.B,'String',num2str(B));
C  = get(handles.C_slider,'value');set(handles.C,'String',num2str(C));
f0=[D1 D2 B C];
set(handles.bcd1,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads1(1)])/handles.loads1(1)));
set(handles.bcd2,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads2(1)])/handles.loads2(1)));
y1=Pacejka4_Model(f0,[handles.slips,handles.loads1]);
y2=Pacejka4_Model(f0,[handles.slips,handles.loads2]);
set(handles.p(1),'YData',y1);
set(handles.p(2),'YData',y2);
legend(['W1 = ' num2str(handles.loads1(1)) 'N'],['W2 = ' num2str(handles.loads2(1)) 'N'])
legend boxoff
guidata(hObject);


% --- Executes during object creation, after setting all properties.
function C_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to C_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function D1_slider_Callback(hObject, eventdata, handles)
% hObject    handle to D1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
W1= -9.806*str2double(get(handles.LOAD1,'string')) ;
W2= -9.806*str2double(get(handles.LOAD2,'string')) ;

handles.loads1=  W1*ones(length(handles.slips));
handles.loads2=  W2*ones(length(handles.slips));
D1 = get(handles.D1_slider,'value');set(handles.D1,'String',num2str(D1));
D2 = get(handles.D2_slider,'value');set(handles.D2,'String',num2str(D2));
B  = get(handles.B_slider,'value');set(handles.B,'String',num2str(B));
C  = get(handles.C_slider,'value');set(handles.C,'String',num2str(C));
f0=[D1 D2 B C];
set(handles.bcd1,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads1(1)])/handles.loads1(1)));
set(handles.bcd2,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads2(1)])/handles.loads2(1)));
y1=Pacejka4_Model(f0,[handles.slips,handles.loads1]);
y2=Pacejka4_Model(f0,[handles.slips,handles.loads2]);
set(handles.p(1),'YData',y1);
set(handles.p(2),'YData',y2);
legend(['W1 = ' num2str(handles.loads1(1)) 'N'],['W2 = ' num2str(handles.loads2(1)) 'N']);
legend boxoff
guidata(hObject);


% --- Executes during object creation, after setting all properties.
function D1_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function D2_slider_Callback(hObject, eventdata, handles)
% hObject    handle to D2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
W1= -9.806*str2double(get(handles.LOAD1,'string')) ;
W2= -9.806*str2double(get(handles.LOAD2,'string')) ;
handles.loads1=  W1*ones(length(handles.slips));
handles.loads2=  W2*ones(length(handles.slips));
D1 = get(handles.D1_slider,'value');set(handles.D1,'String',num2str(D1));
D2 = get(handles.D2_slider,'value');set(handles.D2,'String',num2str(D2));
B  = get(handles.B_slider,'value');set(handles.B,'String',num2str(B));
C  = get(handles.C_slider,'value');set(handles.C,'String',num2str(C));
f0=[D1 D2 B C];
set(handles.bcd1,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads1(1)])/handles.loads1(1)));
set(handles.bcd2,'string',num2str(-Pacejka4_Model(f0,[-1 handles.loads2(1)])/handles.loads2(1)));
y1=Pacejka4_Model(f0,[handles.slips,handles.loads1]);
y2=Pacejka4_Model(f0,[handles.slips,handles.loads2]);
set(handles.p(1),'YData',y1);
set(handles.p(2),'YData',y2);
legend(['W1 = ' num2str(handles.loads1(1)) 'N'],['W2 = ' num2str(handles.loads2(1)) 'N']);
legend boxoff
guidata(hObject);


% --- Executes during object creation, after setting all properties.
function D2_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in freeze_scale.
function freeze_scale_Callback(hObject, eventdata, handles)
% hObject    handle to freeze_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of freeze_scale
if get(handles.freeze_scale,'Value')
    axis manual
else 
    axis auto
end


