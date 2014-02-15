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

% Last Modified by GUIDE v2.5 15-Feb-2014 13:31:10

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
Images      = getappdata( hMain, 'Images' );
currTraImg  = getappdata( hMain, 'currTraImg' );
currSagImg  = getappdata( hMain, 'currSagImg' );
currCorImg  = getappdata( hMain, 'currCorImg' );
currImin    = getappdata( hMain, 'currImin' );
currImax    = getappdata( hMain, 'currImax' );
possibleMin = min(Images(:));
possibleMax = max(Images(:));
setappdata(handles.adjustGrayScale, 'currView'      , 'tra');
setappdata(handles.adjustGrayScale, 'currImg'       , currTraImg);
setappdata(handles.adjustGrayScale, 'currTestImg'   , currTraImg);
setappdata(handles.adjustGrayScale, 'currTraImg'    , currTraImg );
setappdata(handles.adjustGrayScale, 'currSagImg'    , currSagImg );
setappdata(handles.adjustGrayScale, 'currCorImg'    , currCorImg );
setappdata(handles.adjustGrayScale, 'currMin'       , possibleMin  );
setappdata(handles.adjustGrayScale, 'currMax'       , possibleMax  );
setappdata(handles.adjustGrayScale, 'possibleMin'   , possibleMin );
setappdata(handles.adjustGrayScale, 'possibleMax'   , possibleMax );
imshow( currTraImg, [ currImin, currImax ]);
% set global data
setDataMainGui( 'hAdjustGrayScale', handles );
setDataMainGui( 'fhUpdateTestView', @updateTestView );

% update the rangeInfo
imgImin     = min( currTraImg(:) );
imgImax     = max( currTraImg(:) );
s1          = 'Over all images, the min-value is ';
s2          = ' and the max-value is ';
s3          = '.';
s4          = ' In this image, the min-value is ';
s           = [ s1, num2str( possibleMin ), s2, num2str( possibleMax ), s3, ...
                    s4, num2str( imgImin ), s2, num2str( imgImax ), s3 ];   % use arraycat to not loose the blanks at the end of a word
set( handles.rangeInfo, 'String', s );

% update the current range
currIminStr = num2str( possibleMin );
currImaxStr = num2str( possibleMax );
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
if newVal >= getappdata(handles.adjustGrayScale, 'possibleMin') && newVal <= getappdata(handles.adjustGrayScale, 'possibleMax') ...
        && newVal < getappdata(handles.adjustGrayScale, 'currMax')
    set(handles.newMin,'String', int2str(newVal));
    newMin = newVal;
    setappdata(handles.adjustGrayScale, 'currMin', newMin);
else
    % restore old value
    disp( 'Value needs to be in its borders and smaller than the current max' );
    set(handles.newMin,'String', int2str(getappdata(handles.adjustGrayScale, 'currMin')));
    newMin = -1;
end


function newMin_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of newMin as text
%        str2double(get(hObject,'String')) returns contents of newMin as a double

newMin  = checkNewMin( handles ); 
if newMin == -1
    return
else
    minImg  = getappdata(handles.adjustGrayScale, 'currImg' );
    minImg  = setToZero( minImg, 'min', newMin );
    testImg = setToZero( minImg, 'max', str2double(get(handles.newMax,'String')) );
    setappdata(handles.adjustGrayScale, 'currTestImg', testImg);
    
    imshow( testImg, [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ]);
end


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
if newVal >= getappdata(handles.adjustGrayScale, 'possibleMin') && newVal <= getappdata(handles.adjustGrayScale, 'possibleMax') ...
        && newVal > getappdata(handles.adjustGrayScale, 'currMin')
    set(handles.newMax,'String', int2str(newVal));
    newMax = newVal;
    setappdata(handles.adjustGrayScale, 'currMax', newMax);
else
    % restore old value
    disp( 'Value needs to be in its borders and greater than the current min' );
    set(handles.newMax,'String', int2str(getappdata(handles.adjustGrayScale, 'currMax')));
    newMax = -1;
end


function newMax_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'String') returns contents of newMax as text
%        str2double(get(hObject,'String')) returns contents of newMax as a double

newMax  = checkNewMax( handles ); 
if newMax == -1
    return
else
    minImg  = getappdata(handles.adjustGrayScale, 'currImg' );
    minImg  = setToZero( minImg, 'min', str2double(get(handles.newMin,'String')) );
    testImg = setToZero( minImg, 'max', newMax );
    setappdata(handles.adjustGrayScale, 'currTestImg', testImg);

    imshow( testImg, [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ]);
end
    

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
setDataMainGui( 'currIlow', getDataMainGui('defaultImin') );
setDataMainGui( 'currIhigh', getDataMainGui('defaultImax') );
set(handles.newMin,'String', int2str(getDataMainGui('currImin')));
set(handles.newMax,'String', int2str(getDataMainGui('currImax')));

setDataMainGui( 'Images', getDataMainGui( 'defaultImages' ) );

% close this figure
close;

% update hMain
handles        = getDataMainGui( 'handles' );
fhUpdateTraImg = getDataMainGui( 'fhUpdateTraImg' );
fhUpdateSagImg = getDataMainGui( 'fhUpdateSagImg' );
fhUpdateCorImg = getDataMainGui( 'fhUpdateCorImg' );

% functionEvaluation
feval( fhUpdateTraImg, get( handles.sliderTra, 'Value' ), handles );
feval( fhUpdateSagImg, get( handles.sliderSag, 'Value' ), handles );
feval( fhUpdateCorImg, get( handles.sliderCor, 'Value' ), handles );


function applyToView( handles )

newMin = checkNewMin( handles );
newMax = checkNewMax( handles );

minImg  = getappdata(handles.adjustGrayScale, 'currImg' );
minImg  = setToZero( minImg, 'min', newMin );
testImg = setToZero( minImg, 'max', newMax );
setappdata(handles.adjustGrayScale, 'currTestImg', testImg);

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

setDataMainGui( 'currIlow', min );
setDataMainGui( 'currIhigh', max );

s           = size( images );
numImages   = s( 3 );

for i = numImages:-1:1
    img = images(:,:,i);
    img = setToZero( img, 'min', min );
    img = setToZero( img, 'max', max );
    images(:,:,i) = img(:,:);
end

setDataMainGui( 'Images', images );

% close this figure
close;

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


if currVal == 1      % transversal
    currImg       = getDataMainGui( 'currTraImg' );
    setappdata(handles.adjustGrayScale, 'currView', 'tra');
elseif currVal == 2  % sagittal
    currImg       = getDataMainGui( 'currSagImg' );
    setappdata(handles.adjustGrayScale, 'currView', 'sag');
else                 % coronal
    currImg       = getDataMainGui( 'currCorImg' );
    setappdata(handles.adjustGrayScale, 'currView', 'cor');
end

setappdata(handles.adjustGrayScale, 'currImg', currImg);
applyToView( handles );


% update the rangeInfo
Imin        = getappdata(handles.adjustGrayScale, 'possibleMin' );
Imax        = getappdata(handles.adjustGrayScale, 'possibleMax' );
imgImin     = min( currImg(:) );
imgImax     = max( currImg(:) );
s1          = 'Over all images, the min-value is ';
s2          = ' and the max-value is ';
s3          = '.';
s4          = ' In this image, the min-value is ';
s           = [ s1, num2str( Imin ), s2, num2str( Imax ), s3, ...
                    s4, num2str( imgImin ), s2, num2str( imgImax ), s3 ];   % use arraycat to not loose the blanks at the end of a word
set( handles.rangeInfo, 'String', s );


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

figure, imhist( getappdata(handles.adjustGrayScale, 'currTestImg' ) );


function updateTestView(view, currImg)
handles     = getDataMainGui( 'hAdjustGrayScale' );
currView    = getappdata(handles.adjustGrayScale, 'currView');

if strcmp(currView,'tra') && strcmp(view,'tra')         % transversal
    setappdata(handles.adjustGrayScale, 'currTraImg', currImg );
elseif strcmp(currView,'sag') && strcmp(view,'sag')     % sagittal
    setappdata(handles.adjustGrayScale, 'currSagImg', currImg );
elseif strcmp(currView,'cor') && strcmp(view,'cor')     % coronal
    setappdata(handles.adjustGrayScale, 'currCorImg', currImg );
end
setappdata(handles.adjustGrayScale, 'currImg', currImg );

if strcmp(currView,view)
    % due to the sync by the prototype we need to set axes
    axes( handles.testView );

    % save current zoom state
    xZoom = xlim;
    yZoom = ylim;

    applyToView( handles );

    % reset current zoom state
    xlim(xZoom);
    ylim(yZoom);

    % update the rangeInfo
    Imin        = getappdata(handles.adjustGrayScale, 'possibleMin' );
    Imax        = getappdata(handles.adjustGrayScale, 'possibleMax' );
    imgImin     = min( currImg(:) );
    imgImax     = max( currImg(:) );
    s1          = 'Over all images, the min-value is ';
    s2          = ' and the max-value is ';
    s3          = '.';
    s4          = ' In this image, the min-value is ';
    s           = [ s1, num2str( Imin ), s2, num2str( Imax ), s3, ...
                    s4, num2str( imgImin ), s2, num2str( imgImax ), s3 ];   % use arraycat to not loose the blanks at the end of a word
    set( handles.rangeInfo, 'String', s );
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

possibleMin = getappdata(handles.adjustGrayScale, 'possibleMin' );
possibleMax = getappdata(handles.adjustGrayScale, 'possibleMax' );
currIminStr = num2str( possibleMin );
currImaxStr = num2str( possibleMax );
set( handles.newMin, 'String', currIminStr );
set( handles.newMax, 'String', currImaxStr );

applyToView( handles );
