function varargout = segmentation(varargin)
% SEGMENTATION MATLAB code for segmentation.fig
%      SEGMENTATION, by itself, creates a new SEGMENTATION or raises the existing
%      singleton*.
%
%      H = SEGMENTATION returns the handle to a new SEGMENTATION or the handle to
%      the existing singleton*.
%
%      SEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTATION.M with the given input arguments.
%
%      SEGMENTATION('Property','Value',...) creates a new SEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmentation

% Last Modified by GUIDE v2.5 05-Mar-2014 13:08:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @segmentation_OutputFcn, ...
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


% --- Executes just before segmentation is made visible.
function segmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentation (see VARARGIN)

% Choose default command line output for segmentation
handles.output = hObject;

hMain = getappdata(0, 'hMainGui');

% set some data
currTraImg  = getappdata( hMain, 'currTraImg' );
currSagImg  = getappdata( hMain, 'currSagImg' );
currCorImg  = getappdata( hMain, 'currCorImg' );
rows        = getDataMainGui( 'traRows' );
columns     = getDataMainGui( 'traColumns' );

setappdata(handles.segmentation, 'currView'              , 'tra');
setappdata(handles.segmentation, 'currImg'               , currTraImg);
setappdata(handles.segmentation, 'currTestImg'           , currTraImg);
setappdata(handles.segmentation, 'currTraImg'            , currTraImg );
setappdata(handles.segmentation, 'currSagImg'            , currSagImg );
setappdata(handles.segmentation, 'currCorImg'            , currCorImg );
setappdata(handles.segmentation, 'currMethod'            , 'trimToRect' );

set( handles.val2 , 'string' , strcat( num2str(rows), ',', num2str(columns) ) );

setappdata(handles.segmentation, 'methodHistory'         , {} );
setappdata(handles.segmentation, 'methodHistoryIndex'    , 0 );

imshow( currTraImg );

% set global data
setDataMainGui( 'hsegmentation', handles );
setDataMainGui( 'fhUpdateTestView', @updateTestView );

% Update handles structure
guidata(hObject, handles);

drawTrimToRect( handles );

% clear the command line
clc;

% UIWAIT makes segmentation wait for user response (see UIRESUME)
% uiwait(handles.segmentation);


% --- Outputs from this function are returned to the command line.
function varargout = segmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close segmentation.
function segmentation_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


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

% suppress callback on focusout(/mouse leave + click) if method contains two or more input
% variables
methodNumber = get( handles.chooseMethod, 'Value' );

% 1 = Trim to image section
if methodNumber == 1 && checkTrimToRect( handles )
    drawTrimToRect( handles );
end

% 1 = Trim to image section, 2 = New interval of gray levels
if methodNumber ~= 1 && methodNumber ~= 2
    applyToView( handles, 1 );
end


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

% suppress callback on focusout(/mouse leave + click) if method contains two or more input
% variables
methodNumber = get( handles.chooseMethod, 'Value' );

% 1 = Trim to image section
if methodNumber == 1 && checkTrimToRect( handles )
    drawTrimToRect( handles );
end

% 1 = Trim to image section, 2 = New interval of gray levels
if methodNumber ~= 1 && methodNumber ~= 2
    applyToView( handles, 1 );
end

    

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


function imgSegmented = applyMethods( img, methodHistory, methodHistoryIndex, handles )
    mH      = methodHistory;
    mHIndex = methodHistoryIndex;

% apply previous methods
    for i = 1:1:mHIndex;
        mName = mH{i}(1);
        
        if strcmp(mName, 'trimToRect')
            points       = mH{i}(2);
            points       = points{1};
            img          = setToZero( img, 'rec', points, handles );     
            
        elseif strcmp(mName, 'grayScale')
            newMin       = mH{i}(2); 
            newMax       = mH{i}(3);
            newMin = newMin{1}(1); newMax = newMax{1}(1);
            img          = setToZero( img, 'min', newMin );
            img          = setToZero( img, 'max', newMax );
        end     
    end
    
    imgSegmented = img;


% --- check if the inputvalues are valid 
function check = checkTrimToRect( handles )
    p1 = strsplit( get( handles.val1, 'string' ), ',' );
    p2 = strsplit( get( handles.val2, 'string' ), ',' );
    
    % wrong syntax
    if numel(p1) == 1 || numel(p2) == 1
        warndlg( 'Wrong input, syntax of point: x,y.', 'Attention' );
        check = false;
        return;
    end
    
    p1x = round(str2double( p1{1} ));
    p1y = round(str2double( p1{2} ));
    p2x = round(str2double( p2{1} ));
    p2y = round(str2double( p2{2} ));
    rows        = getDataMainGui( 'traRows' );
    columns     = getDataMainGui( 'traColumns' );
    
    % values within the image?
    if p1x < p2x && p1x > 0 && p2x < rows+1 && p2x > 0 ...
        && p1y < p2y && p1y > 0 && p2y < columns+1 && p2y > 0
        % set values
        set( handles.val1, 'string', strcat( num2str(p1x), ',', num2str(p1y) ));
        set( handles.val2, 'string', strcat( num2str(p2x), ',', num2str(p2y) ));
        check = true;
        return;
    else
        warndlg( 'Wrong input, values need to be within the image and point one is smaller then point two.', 'Attention' );
        check = false;
        return;
    end


% --- draw the rectangle into the image    
function drawTrimToRect( handles )
    currTestImg = getappdata(handles.segmentation, 'currTestImg' );
    % save current zoom state
    xZoom = xlim;
    yZoom = ylim;
    
    imshow( currTestImg );

    % undo current zoom state
    xlim(xZoom);
    ylim(yZoom);
    
    Isize     = getDataMainGui( 'Isize' );
    numImages = Isize(3); 
    p1        = strsplit( get( handles.val1, 'string' ), ',' );
    p2        = strsplit( get( handles.val2, 'string' ), ',' );
    p1x  	  = str2double( p1{1} );
    p1y       = str2double( p1{2} );
    p2x       = str2double( p2{1} );
    p2y       = str2double( p2{2} );
    
    % rectangle( x, y, width, height )
    currView = get( handles.chooseView, 'Value' );
    if currView == 1       % transversal
        rectangle( 'Position', [ p1x  p1y p2x-p1x  p2y-p1y ], 'EdgeColor', 'r' );
    elseif currView == 2  % sagittal
        rectangle( 'Position', [ p1y 1 p2y-p1y  numImages ], 'EdgeColor', 'r' );
    else                  % coronal
        rectangle( 'Position', [ p1x 1 p2x-p1x  numImages ], 'EdgeColor', 'r' );
    end
        
    
    
% --- set pixel to 0 
function newImg = setToZero( image, minMaxRec, val, handles )

if strcmpi( 'min', minMaxRec )
    image( image < val ) = 0;
    
elseif strcmpi( 'max', minMaxRec )
    image( image > val ) = 0;
    
elseif strcmpi( 'rec', minMaxRec )
    sImg        = size(image); % depends on view
    mask        = zeros( sImg(1), sImg(2) );
    mask        = im2uint16( mask );
    
    currView    = get( handles.chooseView, 'Value' );
    % if trans
    if currView == 1
        mask( val(2):val(4), val(1):val(3) ) = 1;
    elseif currView == 2
        mask( 1:sImg(1), val(2):val(4) ) = 1;
    elseif currView == 3
        mask( 1:sImg(1), val(1):val(3) ) = 1;
    end
    % pointwise multiply with 0 or 1 erases or keeps the pixel
    image = image .* mask;
    
end

newImg = image;


% --- applies to view
function applyToView( handles, applyMethod )

% image or view change, or method undo
if applyMethod == 0
    % get current image
    currImg = getappdata(handles.segmentation, 'currImg' );
    setappdata(handles.segmentation, 'currImg', currImg );
    
    testImg = currImg;
    mH      = getappdata(handles.segmentation, 'methodHistory' );
    mHIndex = getappdata(handles.segmentation, 'methodHistoryIndex' );
    
    % no previous methods
    if mHIndex == 0
        imshow( testImg ); 
        setappdata(handles.segmentation, 'currTestImg', testImg );
        return 
    end
    
    % apply previous methods
    testImg = applyMethods( testImg, mH, mHIndex, handles );
 
    imshow( testImg );     
    setappdata(handles.segmentation, 'currTestImg', testImg );
    return
end

% get current method
method  = getappdata(handles.segmentation, 'currMethod' );
% get current test-image
testImg = getappdata(handles.segmentation, 'currTestImg' );

mH      = getappdata( handles.segmentation, 'methodHistory' );
mHIndex = getappdata( handles.segmentation, 'methodHistoryIndex' );
mHIndex = mHIndex + 1;

if strcmp(method, 'trimToRect')
    p1              = strsplit( get( handles.val1, 'string' ), ',' );
    p2              = strsplit( get( handles.val2, 'string' ), ',' );
    
    p1x             = str2double( p1{1} );
    p1y             = str2double( p1{2} );
    p2x             = str2double( p2{1} );
    p2y             = str2double( p2{2} );
 
    mH{ mHIndex }   = { 'trimToRect', [ p1x p1y p2x p2y ] };
    testImg = setToZero( testImg, 'rec', [ p1x p1y p2x p2y ], handles );

elseif strcmp(method, 'grayScale')
    newMin          = round(str2double( get( handles.val1, 'string' )));
    newMax          = round(str2double( get( handles.val2, 'string' )));
    
    % check for correct range
    if newMin < 0 || newMin > newMax
        warndlg( 'Value needs to be greater 0 and lower ''New max''.', 'Attention' );
        return;
    elseif newMax > 65535 || newMax < newMin
        warndlg( 'Value needs to be lower 65535 and greater ''New min''.', 'Attention' );
        return;
    end
    
    % setvalues
    set( handles.val1, 'string', newMin );
    set( handles.val2, 'string', newMax );
        
    mH{ mHIndex }   = { 'grayScale', newMin, newMax };
    testImg         = setToZero( testImg, 'min', newMin );
    testImg         = setToZero( testImg, 'max', newMax );
    
%elseif
end

setappdata(handles.segmentation, 'methodHistory'         , mH );
setappdata(handles.segmentation, 'methodHistoryIndex'    , mHIndex );
setappdata(handles.segmentation, 'currTestImg'           , testImg);

% save current zoom state
xZoom = xlim;
yZoom = ylim;
    
imshow( testImg ); 

% undo current zoom state
xlim(xZoom);
ylim(yZoom);
    

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

images      = getDataMainGui( 'Images' );
s           = size( images );
numImages   = s( 3 );
mH          = getappdata( handles.segmentation, 'methodHistory' );
mHIndex     = getappdata( handles.segmentation, 'methodHistoryIndex' );


% apply methodHistory to all images
for i = numImages:-1:1
    img           = images(:,:,i);
    img           = applyMethods( img, mH, mHIndex, handles );
    images(:,:,i) = img(:,:);
end

setDataMainGui( 'Images', images );
setappdata( handles.segmentation, 'methodHistory'         , {} );
setappdata( handles.segmentation, 'methodHistoryIndex'    , 0 );

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
    setappdata(handles.segmentation, 'currView', 'tra');
elseif currVal == 2  % sagittal
    currImg       = getDataMainGui( 'currSagImg' );
    setappdata(handles.segmentation, 'currView', 'sag');
else                 % coronal
    currImg       = getDataMainGui( 'currCorImg' );
    setappdata(handles.segmentation, 'currView', 'cor');
end

setappdata(handles.segmentation, 'currImg', currImg);
applyToView( handles, 0 );

% current method trimToRect? draw rect
if get( handles.chooseMethod, 'Value' ) == 1
    drawTrimToRect( handles );
end


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

figure, imhist( getappdata(handles.segmentation, 'currTestImg' ) );


function updateTestView(view, currImg)
handles     = getDataMainGui( 'hsegmentation' );
currView    = getappdata(handles.segmentation, 'currView');

if strcmp(currView,'tra') && strcmp(view,'tra')         % transversal
    setappdata(handles.segmentation, 'currTraImg', currImg );
elseif strcmp(currView,'sag') && strcmp(view,'sag')     % sagittal
    setappdata(handles.segmentation, 'currSagImg', currImg );
elseif strcmp(currView,'cor') && strcmp(view,'cor')     % coronal
    setappdata(handles.segmentation, 'currCorImg', currImg );
end
setappdata(handles.segmentation, 'currImg', currImg );

if strcmp(currView,view)
    % due to the sync by the prototype we need to set axes
    axes( handles.testView );

    % save current zoom state
    xZoom = xlim;
    yZoom = ylim;

    applyToView( handles, 0 );
    
    % current method trimToRect? draw rect
    if get( handles.chooseMethod, 'Value' ) == 1
        drawTrimToRect( handles );
    end
    
    % undo current zoom state
    xlim(xZoom);
    ylim(yZoom);
end


% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)

mH      = getappdata(handles.segmentation, 'methodHistory' );
mHIndex = getappdata(handles.segmentation, 'methodHistoryIndex' );

if mHIndex > 0
    mH{ mHIndex } = {};
    mHIndex = mHIndex - 1;

    setappdata(handles.segmentation, 'methodHistory'         , mH );
    setappdata(handles.segmentation, 'methodHistoryIndex'    , mHIndex );
    
else
    warndlg( 'No used method which could be undone.', 'Attention' );
    return;
end


applyToView( handles, 0 );


% --- Executes on selection change in chooseMethod.
function chooseMethod_Callback(hObject, eventdata, handles)
% hObject    handle to chooseMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chooseMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseMethod

currVal     = get(hObject,'Value'); 

if currVal == 1      % Trim to image section *
    setappdata(handles.segmentation, 'currMethod', 'trimToRect' );
    set( handles.valuePanel , 'visible', 'on' );
    set( handles.textVal1   , 'visible', 'on' );
    set( handles.val1       , 'visible', 'on' );
    set( handles.textVal1   , 'string' , 'Point 1');
    set( handles.val1       , 'string' , '1,1');
    set( handles.textVal2   , 'visible', 'on' );
    set( handles.val2       , 'visible', 'on' );
    set( handles.textVal2   , 'string' , 'Point 2' );
    rows        = getDataMainGui( 'traRows' );
    columns     = getDataMainGui( 'traColumns' );
    set( handles.val2       , 'string' , strcat( num2str(rows), ',', num2str(columns) ) );
    set( handles.infoText   , 'string' , 'This method sets every pixel outside of the rectangle to 0. The first point( syntax of a point: x,y ) is the upper left, the second one is the lower right.' );
elseif currVal == 2  % New interval of gray levels
    setappdata(handles.segmentation, 'currMethod', 'grayScale' );
    set( handles.valuePanel , 'visible', 'on' );
    set( handles.textVal1   , 'visible', 'on' );
    set( handles.val1       , 'visible', 'on' );
    set( handles.textVal1   , 'string' , 'New min');
    set( handles.val1       , 'string' , 'Min');
    set( handles.textVal2   , 'visible', 'on' );
    set( handles.val2       , 'visible', 'on' );
    set( handles.textVal2   , 'string' , 'New max' );
    set( handles.val2       , 'string' , 'Max' );
    set( handles.infoText   , 'string' , 'Appling a new grayscale-interval means, that every pixel below or above the new range is set to 0.' );
end

% * if trimToRect 
if currVal == 1
    drawTrimToRect( handles );
else
    currTestImg = getappdata(handles.segmentation, 'currTestImg' );
    imshow( currTestImg );
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


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over infoText.
function infoText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to infoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get( hObject, 'string' ), '(CLICK on this text to get more help) Contrast-stretching transformations increase the contrast at a certain level(m) by transforming everything dark a lot darker and everything bright a lot brighter, with only a few levels of gray around the point of interest. E controls the slope of the function and m is the mid-line where it switches from dark values to light values. Method: 1/(1 + (m/(f + eps))^E)')
    % contrastStretchHelp
end
