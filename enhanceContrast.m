function varargout = enhanceContrast(varargin)
% ENHANCECONTRAST MATLAB code for enhanceContrast.fig
%      ENHANCECONTRAST, by itself, creates a new ENHANCECONTRAST or raises the existing
%      singleton*.
%
%      H = ENHANCECONTRAST returns the handle to a new ENHANCECONTRAST or the handle to
%      the existing singleton*.
%
%      ENHANCECONTRAST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENHANCECONTRAST.M with the given input arguments.
%
%      ENHANCECONTRAST('Property','Value',...) creates a new ENHANCECONTRAST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before enhanceContrast_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to enhanceContrast_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help enhanceContrast

% Last Modified by GUIDE v2.5 24-Feb-2014 11:59:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @enhanceContrast_OpeningFcn, ...
                   'gui_OutputFcn',  @enhanceContrast_OutputFcn, ...
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


% --- Executes just before enhanceContrast is made visible.
function enhanceContrast_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to enhanceContrast (see VARARGIN)

% Choose default command line output for enhanceContrast
handles.output = hObject;

hMain = getappdata(0, 'hMainGui');

% set some data
currTraImg  = getappdata( hMain, 'currTraImg' );
currSagImg  = getappdata( hMain, 'currSagImg' );
currCorImg  = getappdata( hMain, 'currCorImg' );
currImin    = getappdata( hMain, 'currImin' );
currImax    = getappdata( hMain, 'currImax' );

setappdata(handles.enhanceContrast, 'currView'      , 'tra');
setappdata(handles.enhanceContrast, 'currImg'       , currTraImg);
setappdata(handles.enhanceContrast, 'currTestImg'   , currTraImg);
setappdata(handles.enhanceContrast, 'currTraImg'    , currTraImg );
setappdata(handles.enhanceContrast, 'currSagImg'    , currSagImg );
setappdata(handles.enhanceContrast, 'currCorImg'    , currCorImg );
setappdata(handles.enhanceContrast, 'currMethod'    , 'imadjust' );

imshow( currTraImg, [ currImin, currImax ]);

% set global data
setDataMainGui( 'henhanceContrast', handles );
setDataMainGui( 'fhUpdateTestView', @updateTestView );

% Update handles structure
guidata(hObject, handles);

% clear the command line
clc;

% UIWAIT makes enhanceContrast wait for user response (see UIRESUME)
% uiwait(handles.enhanceContrast);


% --- Outputs from this function are returned to the command line.
function varargout = enhanceContrast_OutputFcn(hObject, eventdata, handles) 
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


function val1_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of val1 as text
%        str2double(get(hObject,'String')) returns contents of val1 as a double

applyToView( handles, 1 );


% --- Executes during object creation, after setting all properties.
function val1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to val1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function val2_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'String') returns contents of val2 as text
%        str2double(get(hObject,'String')) returns contents of val2 as a double

applyToView( handles, 1 );
    

% --- Executes during object creation, after setting all properties.
function val2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to val2 (see GCBO)
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
set(handles.val1,'String', int2str(getDataMainGui('currImin')));
set(handles.val2,'String', int2str(getDataMainGui('currImax')));

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


% --- applies to view
function applyToView( handles, applyMethod )
% get current image
testImg = getappdata(handles.enhanceContrast, 'currImg' );

if applyMethod == 0
    imshow( testImg, [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ]); 
    setappdata(handles.enhanceContrast, 'currImg', testImg);
    return
end

% get current method
method  = getappdata(handles.enhanceContrast, 'currMethod' );

if strcmp(method, 'imadjust')
    u = double(min(testImg(:))) / double(65535);
    o = double(max(testImg(:))) / double(65535); 
    testImg = imadjust( testImg, [ u o ], [ 0 1 ] );
    % min(testImg(:)) % always 0
    % max(testImg(:)) % always 65535 due to the nature of this operation
elseif strcmp(method, 'gamma')
    u = double(min(testImg(:))) / double(65535);
    o = double(max(testImg(:))) / double(65535); 
    testImg = imadjust( testImg, [ u o ], [ 0 1 ], str2double( get( handles.val1, 'string' )));
    % min(testImg(:)) % always 0
    % max(testImg(:)) % always 65535 due to the nature of this operation
elseif strcmp(method, 'imcomplement')
    testImg = imcomplement( testImg ); 
elseif strcmp(method, 'log')
    c = str2double( get( handles.val1, 'string' ));
    %%%%% Zeile noch umbedingt anpassen!!!!!!!! %
    testImg = im2double(imcomplement( im2uint16( mat2gray( testImg ) ) ));
    testImg = c*(log( 1 + testImg ));
    %%%%% Zeile noch umbedingt anpassen!!!!!!!! %
    testImg = im2uint16(imcomplement( testImg ));
end

setappdata(handles.enhanceContrast, 'currTestImg', testImg);
imshow( testImg, [ min(testImg(:)) max(testImg(:)) ] );


% --- Executes on button press in applyToView.
function applyToView_Callback(hObject, eventdata, handles)
% hObject    handle to applyToView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

applyToView( handles, 1 );


% --- Executes on button press in applyToImages.
function applyToImages_Callback(hObject, eventdata, handles)
% hObject    handle to applyToImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%newCurrImin = min(:) bei applytoImages muss gesetzt werden

min         = str2double(get(handles.val1,'String'));
max         = str2double(get(handles.val2,'String'));
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
    setappdata(handles.enhanceContrast, 'currView', 'tra');
elseif currVal == 2  % sagittal
    currImg       = getDataMainGui( 'currSagImg' );
    setappdata(handles.enhanceContrast, 'currView', 'sag');
else                 % coronal
    currImg       = getDataMainGui( 'currCorImg' );
    setappdata(handles.enhanceContrast, 'currView', 'cor');
end

setappdata(handles.enhanceContrast, 'currImg', currImg);
applyToView( handles, 0 );


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

figure, imhist( getappdata(handles.enhanceContrast, 'currTestImg' ) );


function updateTestView(view, currImg)
handles     = getDataMainGui( 'henhanceContrast' );
currView    = getappdata(handles.enhanceContrast, 'currView');

if strcmp(currView,'tra') && strcmp(view,'tra')         % transversal
    setappdata(handles.enhanceContrast, 'currTraImg', currImg );
elseif strcmp(currView,'sag') && strcmp(view,'sag')     % sagittal
    setappdata(handles.enhanceContrast, 'currSagImg', currImg );
elseif strcmp(currView,'cor') && strcmp(view,'cor')     % coronal
    setappdata(handles.enhanceContrast, 'currCorImg', currImg );
end
setappdata(handles.enhanceContrast, 'currImg', currImg );

if strcmp(currView,view)
    % due to the sync by the prototype we need to set axes
    axes( handles.testView );

    % save current zoom state
    xZoom = xlim;
    yZoom = ylim;

    applyToView( handles, 0 );

    % reset current zoom state
    xlim(xZoom);
    ylim(yZoom);
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

possibleMin = getappdata(handles.enhanceContrast, 'possibleMin' );
possibleMax = getappdata(handles.enhanceContrast, 'possibleMax' );
currIminStr = num2str( possibleMin );
currImaxStr = num2str( possibleMax );
set( handles.val1, 'String', currIminStr );
set( handles.val2, 'String', currImaxStr );

applyToView( handles, 0 );


% --- Executes on selection change in chooseMethod.
function chooseMethod_Callback(hObject, eventdata, handles)
% hObject    handle to chooseMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chooseMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseMethod

currVal     = get(hObject,'Value'); 

if currVal == 1      % Distribute intensities
    setappdata(handles.enhanceContrast, 'currMethod', 'imadjust' );
    set( handles.valuePanel , 'visible', 'off' );
    set( handles.infoText   , 'string', 'Distributes the given intensities over the hole spectrum of possible ones. Method: imadjust' );
elseif currVal == 2  % Weighted distribute intensities
    setappdata(handles.enhanceContrast, 'currMethod', 'gamma' );
    set( handles.valuePanel , 'visible', 'on' );
    set( handles.textVal1   , 'string', 'Gamma');
    set( handles.val1       , 'string', '1');
    set( handles.textVal2   , 'visible', 'off' );
    set( handles.val2       , 'visible', 'off' );
    set( handles.infoText   , 'string', 'Distributes the given intensities over the hole spectrum of possible ones - weighted towards the brighter (gamma < 1) or the darker(gamma > 1) end. Method: imadjust( ... , gamma )' );
elseif currVal == 3  % Complement 
    setappdata(handles.enhanceContrast, 'currMethod', 'imcomplement' );
    set( handles.valuePanel , 'visible', 'off' );
    set( handles.infoText   , 'string', 'This method complements the current image. Method: imcomplement' );
elseif currVal == 4  % Logarithmic transformation
    setappdata(handles.enhanceContrast, 'currMethod', 'log' );
    set( handles.valuePanel , 'visible', 'on' );
    set( handles.textVal1   , 'string', 'c');
    set( handles.val1       , 'string', '1.4');
    set( handles.textVal2   , 'visible', 'off' );
    set( handles.val2       , 'visible', 'off' );
    set( handles.infoText   , 'string', 'To enhance the contrast of bright pixels COMPLEMENT the image first, because applying the logarithmic transformation will expand values of dark pixels in an image while compressing the bright pixels. Method: c*(log(1 + image))' );
elseif currVal == 5  % Contrast-stretching transformation
    setappdata(handles.enhanceContrast, 'currMethod', 'stretch' );
    set( handles.valuePanel , 'visible', 'on' );
    set( handles.textVal1   , 'string', 'E');
    set( handles.val1       , 'string', '4');
    set( handles.textVal2   , 'string', 'm or pixelToM');
    set( handles.val2       , 'string', 'see tooltip');
    set( handles.textVal2   , 'tooltipString', 'if m is between [0 - 1] it will take the number as ''m''. Otherwise it will take the number as a pixelvalue to compute ''m'' (m=pixelvalue/65535).');
    set( handles.val2       , 'tooltipString', 'if m is between [0 - 1] it will take the number as ''m''. Otherwise it will take the number as a pixelvalue to compute ''m'' (m=pixelvalue/65535).');
    set( handles.infoText   , 'string', 'Contrast-stretching transformations increase the contrast at a certain level(m) by transforming everything dark a lot darker and everything bright a lot brighter, with only a few levels of gray around the point of interest. E controls the slope of the function and m is the mid-line where it switches from dark values to light values(click on this text to get more help). Method: 1/(1 + (m/(f + eps))^E)' );
else                 

end


% --- Executes during object creation, after setting all properties.
function chooseMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooseMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
