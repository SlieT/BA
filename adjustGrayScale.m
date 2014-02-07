function varargout = adjustGrayScale(varargin)
% ADJUSTGRAYSCALE MATLAB code for adjustGrayScale.fig
%      ADJUSTGRAYSCALE, by itself, creates a new ADJUSTGRAYSCALE or raises the existing
%      singleton*.
%
%      H = ADJUSTGRAYSCALE returns the handle to a new ADJUSTGRAYSCALE or the handle to
%      the existing singleton*.
%
%      ADJUSTGRAYSCALE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADJUSTGRAYSCALE.M with the given input arguments.
%
%      ADJUSTGRAYSCALE('Property','Value',...) creates a new ADJUSTGRAYSCALE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before adjustGrayScale_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to adjustGrayScale_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help adjustGrayScale

% Last Modified by GUIDE v2.5 01-Feb-2014 15:48:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @adjustGrayScale_OpeningFcn, ...
                   'gui_OutputFcn',  @adjustGrayScale_OutputFcn, ...
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


% --- Executes just before adjustGrayScale is made visible.
function adjustGrayScale_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to adjustGrayScale (see VARARGIN)

% Choose default command line output for adjustGrayScale
handles.output = hObject;

hMain = getappdata(0, 'hMainGui');

% set some data
currTraImg  = getappdata( hMain, 'currTraImg' );
currSagImg  = getappdata( hMain, 'currSagImg' );
currCorImg  = getappdata( hMain, 'currCorImg' );
currImin    = getappdata( hMain, 'currImin' );
currImax    = getappdata( hMain, 'currImax' );
setappdata(handles.adjustGrayScale, 'currImg', currTraImg);
setappdata(handles.adjustGrayScale, 'currTraImg', currTraImg );
setappdata(handles.adjustGrayScale, 'currSagImg', currSagImg );
setappdata(handles.adjustGrayScale, 'currCorImg', currCorImg );
setappdata(handles.adjustGrayScale, 'currMin', currImin  );
setappdata(handles.adjustGrayScale, 'currMax', currImax  );
imshow( currTraImg, [ currImin, currImax ]);

% set slider
handlesMain  = getappdata(hMain, 'handles');
sliderMin     = get( handlesMain.sliderTra, 'Min' );
sliderMax     = get( handlesMain.sliderTra, 'Max' );
sliderValue   = get( handlesMain.sliderTra, 'Value' );
set( handles.testViewSlider, 'Min', sliderMin );
set( handles.testViewSlider, 'Max', sliderMax );
set( handles.testViewSlider, 'Value', sliderValue );

% update the rangeInfo
Imin        = getappdata( hMain, 'currImin' );
Imax        = getappdata( hMain, 'currImax' );
imgImin     = min( currTraImg(:) );
imgImax     = max( currTraImg(:) );
s1          = 'Over all images, the min-value is ';
s2          = ' and the max-value is ';
s3          = '.';
s4          = ' In this image, the min-value is ';
s           = [ s1, num2str( Imin ), s2, num2str( Imax ), s3, ...
                    s4, num2str( imgImin ), s2, num2str( imgImax ), s3 ];   % use arraycat to not loose the blanks at the end of a word
set( handles.rangeInfo, 'String', s );

% update the current range
currIminStr = num2str( currImin );
currImaxStr = num2str( currImax );
set( handles.newMin, 'String', currIminStr );
set( handles.newMax, 'String', currImaxStr );

% Update handles structure
guidata(hObject, handles);

% clear the command line
clc;

% UIWAIT makes adjustGrayScale wait for user response (see UIRESUME)
% uiwait(handles.adjustGrayScale);


% --- Outputs from this function are returned to the command line.
function varargout = adjustGrayScale_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- setData globallike
function setDataMainGui( name, value )
hMain = getappdata(0, 'hMainGui');
setappdata(hMain, name, value);


% --- getData globallike
function data = getDataMainGui( name )
hMain = getappdata(0, 'hMainGui');
data  = getappdata(hMain, name);


function newImg = setToZero( image, minMax, val )

if strcmpi('min', minMax)
    image( image < val ) = 0;
elseif strcmpi('max', minMax)
    image( image > val ) = 0;
end

newImg = image;


% --- returns the new minimum or -1
function newMin = checkNewMin( handles )

newVal = round(str2double(get(handles.newMin,'String')));

% is in its border?
if newVal >= getDataMainGui('Imin') && newVal <= getDataMainGui('Imax') ...
        && newVal < getDataMainGui('currImax')
    set(handles.newMin,'String', int2str(newVal));
    newMin = newVal;
else
    % restore old value
    disp( 'Value needs to be in its borders and smaller than the current max' );
    set(handles.newMin,'String', int2str(getDataMainGui('currImin')));
    newMin = -1;
end


function newMin_Callback(hObject, eventdata, handles)
% wenn ich mal besser bin kann ich dsa performanter machen indem ich mir
% das min und max bild hole und UND-verknüpfe überall wo eine 0 steht
% fallen die werte raus
% http://www.mathworks.de/company/newsletters/articles/matrix-indexing-in-matlab.html

% Hints: get(hObject,'String') returns contents of newMin as text
%        str2double(get(hObject,'String')) returns contents of newMin as a double

newMin  = checkNewMin( handles ); 
minImg  = getappdata(handles.adjustGrayScale, 'currImg' );
minImg  = setToZero( minImg, 'min', newMin );
testImg = setToZero( minImg, 'max', str2double(get(handles.newMax,'String')) );

imshow( testImg, [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ]);


% --- Executes during object creation, after setting all properties.
function newMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- returns the new maximum or -1
function newMax = checkNewMax( handles )

newVal = round(str2double(get(handles.newMax,'String')));

% is in its border?
if newVal >= getDataMainGui('Imin') && newVal <= getDataMainGui('Imax') ...
        && newVal > getDataMainGui('currImin')
    set(handles.newMax,'String', int2str(newVal));
    newMax = newVal;
else
    % restore old value
    disp( 'Value needs to be in its borders and greater than the current min' );
    set(handles.newMax,'String', int2str(getDataMainGui('currImax')));
    newMax = -1;
end


function newMax_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'String') returns contents of newMax as text
%        str2double(get(hObject,'String')) returns contents of newMax as a double

newMax  = checkNewMax( handles ); 
minImg  = getappdata(handles.adjustGrayScale, 'currImg' );
minImg  = setToZero( minImg, 'min', str2double(get(handles.newMin,'String')) );
testImg = setToZero( minImg, 'max', newMax );

imshow( testImg, [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ]);


% --- Executes during object creation, after setting all properties.
function newMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in restoreDefault.
function restoreDefault_Callback(hObject, eventdata, handles)


setDataMainGui( 'currImin', getDataMainGui('defaultImin') );
setDataMainGui( 'currImax', getDataMainGui('defaultImax') );
set(handles.newMin,'String', int2str(getDataMainGui('currImin')));
set(handles.newMax,'String', int2str(getDataMainGui('currImax')));

setDataMainGui( 'Images', getDataMainGui( 'defaultImages' ) );

% get default images, set currImg fehlt noch 

imshow( getappdata(handles.adjustGrayScale, 'currImg' ), [ getDataMainGui('currImin'), getDataMainGui('currImax') ]);


function applyToView( handles )

newMin = checkNewMin( handles );
newMax = checkNewMax( handles );

minImg  = getappdata(handles.adjustGrayScale, 'currImg' );
minImg  = setToZero( minImg, 'min', newMin );
testImg = setToZero( minImg, 'max', newMax );

imshow( testImg, [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ]);


% --- Executes on button press in applyToView.
function applyToView_Callback(hObject, eventdata, handles)
% hObject    handle to applyToView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

applyToView( handles );


% --- Executes on button press in applyToImages.
function applyToImages_Callback(hObject, eventdata, handles)
% hObject    handle to applyToImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

min         = str2double(get(handles.newMin,'String'));
max         = str2double(get(handles.newMax,'String'));
images      = getDataMainGui( 'Images' );

s           = size( images );
numImages   = s( 3 );

for i = numImages:-1:1
    img = images(:,:,i);
    img = setToZero( img, 'min', min );
    img = setToZero( img, 'max', max );
    images(:,:,i) = img(:,:);
end

setDataMainGui( 'Images', images );

% update hMain
handles        = getDataMainGui( 'handles' );
fhUpdateTraImg = getDataMainGui( 'fhUpdateTraImg' );
fhUpdateSagImg = getDataMainGui( 'fhUpdateSagImg' );
fhUpdateCorImg = getDataMainGui( 'fhUpdateCorImg' );

% functionEvaluation
feval( fhUpdateTraImg, get( handles.sliderTra, 'Value' ), handles );
feval( fhUpdateSagImg, get( handles.sliderSag, 'Value' ), handles );
feval( fhUpdateCorImg, get( handles.sliderCor, 'Value' ), handles );


% --- Executes on selection change in chooseView.
function chooseView_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns chooseView contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseView

currVal     = get(hObject,'Value'); 

handlesMain = getDataMainGui( 'handles' );

if currVal == 1      % transversal
    currImg       = getappdata(handles.adjustGrayScale, 'currTraImg' );
    sliderMin     = get( handlesMain.sliderTra, 'Min' );
    sliderMax     = get( handlesMain.sliderTra, 'Max' );
    sliderValue   = get( handlesMain.sliderTra, 'Value' );
    set( handles.testViewSlider, 'Min', sliderMin );
    set( handles.testViewSlider, 'Max', sliderMax );
    set( handles.testViewSlider, 'Value', sliderValue );
elseif currVal == 2  % sagittal
    currImg       = getappdata(handles.adjustGrayScale, 'currSagImg' ); 
    sliderMin     = get( handlesMain.sliderSag, 'Min' );
    sliderMax     = get( handlesMain.sliderSag, 'Max' );
    sliderValue   = get( handlesMain.sliderSag, 'Value' );
    set( handles.testViewSlider, 'Min', sliderMin );
    set( handles.testViewSlider, 'Max', sliderMax );
    set( handles.testViewSlider, 'Value', sliderValue );
else                 % coronal
    currImg       = getappdata(handles.adjustGrayScale, 'currCorImg' );
    sliderMin     = get( handlesMain.sliderCor, 'Min' );
    sliderMax     = get( handlesMain.sliderCor, 'Max' );
    sliderValue   = get( handlesMain.sliderCor, 'Value' );
    set( handles.testViewSlider, 'Min', sliderMin );
    set( handles.testViewSlider, 'Max', sliderMax );
    set( handles.testViewSlider, 'Value', sliderValue );
end

setappdata(handles.adjustGrayScale, 'currImg', currImg);
applyToView( handles );


% --- Executes during object creation, after setting all properties.
function chooseView_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooseView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showHistogram.
function showHistogram_Callback(hObject, eventdata, handles)

figure, imhist( getappdata(handles.adjustGrayScale, 'currImg' ) );


% --- Executes on slider movement.
function testViewSlider_Callback(hObject, eventdata, handles)

newVal = round( get( hObject,'Value' ));          % since step = 1 we round to the next integer
set( handles.testViewSlider, 'Value', newVal );

% noch die sliderposition merken!
% und die rangeinfo anpassen
whichView = get( handles.chooseView, 'Value');

if whichView == 1       % transversal
    Images      = getDataMainGui( 'Images' );
    currImg     = Images(:,:,newVal);
    setappdata(handles.adjustGrayScale, 'currTraImg', currImg );
elseif whichView == 2   % sagittal
    fhGetSagImg = getDataMainGui( 'fhGetSagImg' );
    currImg     = feval( fhGetSagImg, newVal );
    setappdata(handles.adjustGrayScale, 'currSagImg', currImg );
else                    % coronal
    fhGetCorImg = getDataMainGui( 'fhGetCorImg' );
    handlesMain = getDataMainGui( 'handles' );
    currImg     = feval( fhGetCorImg, get( handlesMain.sliderCor,'Max' ) + 1 - newVal );
    setappdata(handles.adjustGrayScale, 'currCorImg', currImg );
end
setappdata(handles.adjustGrayScale, 'currImg', currImg );
applyToView( handles );





% --- Executes during object creation, after setting all properties.
function testViewSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testViewSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end







% setappdata(handles.adjustGrayScale, 'currImg', currImg);
% setappdata(handles.adjustGrayScale, 'currMin', currImin  );
% setappdata(handles.adjustGrayScale, 'currMax', currImax  );
% setappdata(handles.adjustGrayScale, 'currTraImg', currTraImg );
% setappdata(handles.adjustGrayScale, 'currSagImg', currSagImg );
% setappdata(handles.adjustGrayScale, 'currCorImg', currCorImg );





% u = 500/65535;
% o = 900/65535;
% 
% a = dicomread('test.dcm');
% subplot(1,4,1), imshow(a, [ 500 900 ]);
% ist das gleiche wie 
% c = imadjust( a, [ u o ], [ 0 1 ] );
% subplot(1,4,4), imshow(c);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

currImin = getappdata( handles.adjustGrayScale, 'currMin' );
currImax = getappdata( handles.adjustGrayScale, 'currMax' );
currIminStr = num2str( currImin );
currImaxStr = num2str( currImax );
set( handles.newMin, 'String', currIminStr );
set( handles.newMax, 'String', currImaxStr );

applyToView( handles );
