function varargout = contrastStretchHelp(varargin)
% CONTRASTSTRETCHHELP MATLAB code for contrastStretchHelp.fig
%      CONTRASTSTRETCHHELP, by itself, creates a new CONTRASTSTRETCHHELP or raises the existing
%      singleton*.
%
%      H = CONTRASTSTRETCHHELP returns the handle to a new CONTRASTSTRETCHHELP or the handle to
%      the existing singleton*.
%
%      CONTRASTSTRETCHHELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTRASTSTRETCHHELP.M with the given input arguments.
%
%      CONTRASTSTRETCHHELP('Property','Value',...) creates a new CONTRASTSTRETCHHELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before contrastStretchHelp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to contrastStretchHelp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help contrastStretchHelp

% Last Modified by GUIDE v2.5 26-Feb-2014 17:29:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @contrastStretchHelp_OpeningFcn, ...
                   'gui_OutputFcn',  @contrastStretchHelp_OutputFcn, ...
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


% --- Executes just before contrastStretchHelp is made visible.
function contrastStretchHelp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to contrastStretchHelp (see VARARGIN)

% Choose default command line output for contrastStretchHelp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes contrastStretchHelp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = contrastStretchHelp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function E_Callback(hObject, eventdata, handles)
% hObject    handle to E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E as text
%        str2double(get(hObject,'String')) returns contents of E as a double
E = str2double(get( handles.E, 'String' ));

if E < 0
    E = 0;
end

set(hObject,'String', E);

updateAxis( handles );


% --- Executes during object creation, after setting all properties.
function E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m_Callback(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m as text
%        str2double(get(hObject,'String')) returns contents of m as a double

m = str2double(get(hObject,'String'));

if m < 0
    m = 0;
    set(hObject,'String', m);
elseif m > 1
    m = 1;
    set(hObject,'String', m);
end

updateAxis( handles );


% --- update the Axis
function updateAxis( handles )

m = str2double(get( handles.m, 'string' ));
E = str2double(get( handles.E, 'string' ));

x=0:.01:1;
y = 1./(1 + (m./(x + eps)).^E);

cla(gca); %%% clear current axis
axis manual;
hold on;

xlabel('x (input image)', 'FontSize', 12);
ylabel('1 / ( 1 + ( m / ( x + eps )) ''power'' E ) (output image)', 'FontSize', 12);

% draw function
plot(x,y); 

% showHelp?
if get(handles.showHelp, 'Value') 
    
    % m
    plot([ m m ], [ 0 0.5 ], 'g-' );

    % transition
    plot([ 0 m ] ,[ 0.5 0.5 ], 'r-' );

    % annotations
    text(m , 0.25,'    m', 'HorizontalAlignment','left');
    text(m/4 , 0.52 ,'\uparrow transition to bright' ,'HorizontalAlignment','left');
    text(m/4 , 0.48 ,'\downarrow transition to dark' ,'HorizontalAlignment','left')

end

hold off;


% --- Executes during object creation, after setting all properties.
function m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)^
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showHelp.
function showHelp_Callback(hObject, eventdata, handles)
% hObject    handle to showHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showHelp

updateAxis( handles );
