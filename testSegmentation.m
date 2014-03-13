function varargout = testSegmentation(varargin)
% TESTSEGMENTATION MATLAB code for testSegmentation.fig
%      TESTSEGMENTATION, by itself, creates a new TESTSEGMENTATION or raises the existing
%      singleton*.
%
%      H = TESTSEGMENTATION returns the handle to a new TESTSEGMENTATION or the handle to
%      the existing singleton*.
%
%      TESTSEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTSEGMENTATION.M with the given input arguments.
%
%      TESTSEGMENTATION('Property','Value',...) creates a new TESTSEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testSegmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testSegmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testSegmentation

% Last Modified by GUIDE v2.5 13-Mar-2014 17:20:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testSegmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @testSegmentation_OutputFcn, ...
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


% --- Executes just before testSegmentation is made visible.
function testSegmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testSegmentation (see VARARGIN)

% Choose default command line output for testSegmentation
handles.output = hObject;

img = dicomread( 'test.dcm' );

img = imadjust( img );

setappdata( handles.testSegmentation, 'img', img );

axes(handles.ogImg);
imshow(img);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testSegmentation wait for user response (see UIRESUME)
% uiwait(handles.testSegmentation);


% --- Outputs from this function are returned to the command line.
function varargout = testSegmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





function values_Callback(hObject, eventdata, handles)
% hObject    handle to values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of values as text
%        str2double(get(hObject,'String')) returns contents of values as a double


% im ersten edit zahl.zahl liefert pixelwert an dieser stelle
%   zahl(S),zahl(T) wendet regiongrow an 

% im zweiten edit liefert g das fertige bild, SI die seedpoints, 
%   TI das bild vor der connective-8 prüfung


f = getappdata( handles.testSegmentation, 'img' );

% quick and dirty to get pixelvalue
x = get(hObject,'String');
x = x{1};
xy = strsplit( x, '.' );
if numel(xy) == 2
    x = str2double(xy{2});
    y = str2double(xy{1});
    disp(f( x, y ));
    return;
end

% why cell?
x = get(hObject,'String');
x = x{1};
ST = strsplit( x, ',' );


S = round(str2double( ST{1} ));
T = round(str2double( ST{2} ));

[ resultWithLabels, NumberRegions, finalSeedImage, thresholdImage ] = ...
    regiongrow( f, S, T );

disp( NumberRegions );
setappdata( handles.testSegmentation, 'r', resultWithLabels );
setappdata( handles.testSegmentation, 'f', finalSeedImage );
setappdata( handles.testSegmentation, 't', thresholdImage );

guidata(hObject, handles);


function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input as text
%        str2double(get(hObject,'String')) returns contents of input as a double

axes(handles.result)
input = get(hObject, 'String');

if strcmp(input, 'g');
    g = getappdata( handles.testSegmentation, 'r' );
    imshow(g)
elseif strcmp(input, 'SI');
    SI = getappdata( handles.testSegmentation, 'f' );
    imshow(SI);
elseif strcmp(input, 'TI')
    TI = getappdata( handles.testSegmentation, 't' );
    imshow(TI);
end


% --- Executes during object creation, after setting all properties.
function input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function [g NR SI TI] = regiongrow(f, S, T)
 
f = double(f);
 
if numel(S) == 1
    SI = f == S;
    S1 = S;
else
    % Eliminate connectd seed locations
    SI = bwmorph(S, 'shrink', Inf);
    J  = find(SI);
    S1 = f(J);
end
 
TI = false(size(f));
for K = 1:length(S1)
    seedval = S1(K);
    S = abs(f - seedval) <= T;
    TI = TI | S;
end
 
[g, NR] = bwlabel(imreconstruct(SI,TI));


