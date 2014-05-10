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

% Last Modified by GUIDE v2.5 19-Apr-2014 14:38:19

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
end


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
setappdata(handles.segmentation, 'roi'                   , -1 );    % regionOfInterest -1 = not used, 1 = used
setappdata(handles.segmentation, 'isInfo'                , 0 );

set( handles.val2 , 'string' , strcat( num2str(rows), ',', num2str(columns) ) );

setappdata(handles.segmentation, 'methodHistoryROI'         , {} );
setappdata(handles.segmentation, 'methodHistoryIndexROI'    , 0 );
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
end


% --- Outputs from this function are returned to the command line.
function varargout = segmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes when user attempts to close segmentation.
function segmentation_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
end


% --- setData globallike
function setDataMainGui( name, value )
hMain = getappdata(0, 'hMainGui');
setappdata(hMain, name, value);
end


% --- getData globallike
function data = getDataMainGui( name )
hMain = getappdata(0, 'hMainGui');
data  = getappdata(hMain, name);
end


% --- keep the current zoom state
function imshowKeepZoom( img )
handles = getDataMainGui( 'hsegmentation' );
xZoom   = xlim(handles.testView);
yZoom   = ylim(handles.testView);

imshow( img, 'parent', handles.testView ); 

% set current zoom state
set(handles.testView, 'xlim', xZoom);
set(handles.testView, 'ylim', yZoom);
end


function val1_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of val1 as text
%        str2double(get(hObject,'String')) returns contents of val1 as a double

% suppress callback on focusout(/mouse leave + click) if method contains two or more input
% variables
methodNumber = get( handles.chooseMethod, 'Value' );

% 1 = Trim to rectangle
if methodNumber == 1 && checkTrimToRect( handles )
    drawTrimToRect( handles );
end

% 1 = Trim to rectangle, 2 = New interval of gray levels, 3 = Cut out inner/outer circle
if methodNumber ~= 1 && methodNumber ~= 2 && methodNumber ~= 3
    applyToView( handles, 1 );
end
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
end


function val2_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'String') returns contents of val2 as text
%        str2double(get(hObject,'String')) returns contents of val2 as a double

% suppress callback on focusout(/mouse leave + click) if method contains two or more input
% variables
methodNumber = get( handles.chooseMethod, 'Value' );

% 1 = Trim to rectangle
if methodNumber == 1 && checkTrimToRect( handles )
    drawTrimToRect( handles );
end

% 1 = Trim to rectangle, 2 = New interval of gray levels
if methodNumber ~= 1 && methodNumber ~= 2
    applyToView( handles, 1 );
end
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
end


function imgSegmented = applyMethods( img, methodHistory, methodHistoryIndex, handles )
    mH      = methodHistory;
    mHIndex = methodHistoryIndex;

    % apply previous methods
    for i = 1:1:mHIndex;
        mName = mH{i}(1);
        
        if strcmp(mName, 'trimToRect')
            points       = mH{i}{2};
            img          = setToZero( img, 'rec', points, handles );     
            
        elseif strcmp(mName, 'grayScale')
            newMin       = mH{i}{2}; 
            newMax       = mH{i}{3};
            img          = setToZero( img, 'min', newMin );
            img          = setToZero( img, 'max', newMax );
        end     
    end
    
    imgSegmented = img;
end


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
end


% --- draw the rectangle into the image    
function drawTrimToRect( handles )
    currTestImg = getappdata(handles.segmentation, 'currTestImg' );

    imshowKeepZoom( currTestImg );
    
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
        rectangle( 'Position', [ p1x  p1y p2x-p1x  p2y-p1y ], 'EdgeColor', 'r', 'parent', handles.testView );
    elseif currView == 2  % sagittal
        rectangle( 'Position', [ p1y 1 p2y-p1y  numImages ], 'EdgeColor', 'r', 'parent', handles.testView );
    else                  % coronal
        rectangle( 'Position', [ p1x 1 p2x-p1x  numImages ], 'EdgeColor', 'r', 'parent', handles.testView );
    end
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
    
    currView    = get( handles.chooseView, 'Value' );
    % if trans
    if currView == 1
        mask( val(2):val(4), val(1):val(3) ) = 1;
    elseif currView == 2
        mask( 1:sImg(1), val(2):val(4) ) = 1;
    elseif currView == 3
        mask( 1:sImg(1), val(1):val(3) ) = 1;
    end
    
    image( mask==0 ) = 0;
end

newImg = image;
end


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
        imshowKeepZoom( testImg ); 
        setappdata(handles.segmentation, 'currTestImg'   , testImg );
        setappdata(handles.segmentation, 'currTestImgRoi', testImg );
        return 
    end
    
    % apply previous methods
    testImg = applyMethods( testImg, mH, mHIndex, handles );
 
    imshowKeepZoom( testImg );     
    setappdata(handles.segmentation, 'currTestImg'   , testImg );
    setappdata(handles.segmentation, 'currTestImgRoi', testImg );
    return
end

% now a method can be undone
set( handles.undo, 'enable', 'on' );
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
    maxNumber       = getDataMainGui( 'maxNumber' );
    
    % check for correct range
    if newMin < 0 || newMin > newMax
        warndlg( 'Value needs to be greater 0 and lower ''New max''.', 'Attention' );
        return;
    elseif newMax > maxNumber || newMax < newMin
        s = strcat( ['Value needs to be lower ', num2str(maxNumber), ' and greater ''New min''.'] );
        warndlg( s, 'Attention' );
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

imshowKeepZoom( testImg );
end
    

% --- Executes on button press in applyToView.
function applyToView_Callback(hObject, eventdata, handles)
% hObject    handle to applyToView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

applyToView( handles, 1 );
end


% --- Executes on button press in applyToImage.
function applyToImage_Callback(hObject, eventdata, handles)
% hObject    handle to applyToImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currFigure  = gcf();
images      = getDataMainGui( 'Images' );
currMethod  = get( handles.chooseMethod, 'Value' );
currTestImg = getappdata( handles.segmentation, 'currTestImg' );
currView    = get( handles.chooseView, 'Value' );
hMain       = getDataMainGui( 'handles' );
mHIndex     = getappdata( handles.segmentation, 'methodHistoryIndex' );
mHIndexROI  = getappdata( handles.segmentation, 'methodHistoryIndexROI' );

if mHIndex == 0 && mHIndexROI == 0
    return;
end

% if single image methode
% if "Cut out inner/outer circle"
if currMethod == 3 
    mH              = getappdata( handles.segmentation, 'methodHistoryROI' );
    currTestImgRoi  = getappdata( handles.segmentation, 'currTestImgRoi' );
    
    if currView == 1        % tra
        logView   = 'tra';
        currIndex = get( hMain.sliderTra, 'Value' );
        images(:,:,currIndex) = currTestImgRoi;
        
    elseif currView == 2    % sag
        logView   = 'sag';
        currIndex = get( hMain.sliderSag, 'Value' );
        img       = images(:,currIndex,:);
        sizeI     = size(img, 1); % 256
        sizeJ     = size(img, 3); % 170
        
        for i=1:1:sizeI
            for j=1:1:sizeJ
                images(i,currIndex,j) = currTestImgRoi(sizeJ+1 - j, i);
            end
        end

    else                    % cor
        logView   = 'cor';
        currIndex = get( hMain.sliderCor, 'Max' )+1 - get( hMain.sliderCor, 'Value' );
        img       = images(currIndex,:,:);
        sizeI     = size(img, 2); % 256
        sizeJ     = size(img, 3); % 170
        
        for i=1:1:sizeI
            for j=1:1:sizeJ
                images(currIndex,i,j) = currTestImgRoi(sizeJ+1 - j, i);
            end
        end
    end
    
    set( handles.undo, 'enable', 'off' );
    setappdata( handles.segmentation, 'methodHistoryROI'         , {} );
	setappdata( handles.segmentation, 'methodHistoryIndexROI'    , 0 );

else
    mH = getappdata( handles.segmentation, 'methodHistory' );
    
    if currView == 1      % transversal
        logView               = 'tra';
        currIndex             = get( hMain.sliderTra, 'Value' );
        images(:,:,currIndex) = currTestImg;
    
    elseif currView == 2  % sagittal
        logView        = 'sag';
        currIndex      = get( hMain.sliderSag, 'Value' );
        sizeI          = size(currTestImg, 2); % 256
        sizeJ          = size(currTestImg, 1); % 170
        
        for i=1:1:sizeI
            for j=1:1:sizeJ
                images(i,currIndex,j) = currTestImg(sizeJ+1 - j, i);
            end
        end
    
    else                 % coronal
        logView        = 'cor';
        currIndex      = get( hMain.sliderCor, 'Max' )+1 - get( hMain.sliderCor, 'Value' );
        sizeI          = size(currTestImg, 2); % 256
        sizeJ          = size(currTestImg, 1); % 170
        
        for i=1:1:sizeI
            for j=1:1:sizeJ
                images(currIndex,i,j) = currTestImg(sizeJ+1 - j, i);
            end
        end 
    end
end

setDataMainGui( 'Images', images );
   
% update hMain
hMain          = getDataMainGui( 'handles' );
fhUpdateTraImg = getDataMainGui( 'fhUpdateTraImg' );
fhUpdateSagImg = getDataMainGui( 'fhUpdateSagImg' );
fhUpdateCorImg = getDataMainGui( 'fhUpdateCorImg' );

% functionEvaluation
feval( fhUpdateTraImg, get( hMain.sliderTra, 'Value' ), hMain );
feval( fhUpdateSagImg, get( hMain.sliderSag, 'Value' ), hMain );
feval( fhUpdateCorImg, get( hMain.sliderCor, 'Value' ), hMain );

% set currFigure as the current figure
figure( currFigure );

% update Log
fhUpdateLog = getDataMainGui( 'fhUpdateLog' );
feval( fhUpdateLog, mH, logView, currIndex );
end


% --- Executes on button press in applyToImages.
function applyToImages_Callback(hObject, eventdata, handles)
% hObject    handle to applyToImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currFigure  = gcf();
images      = getDataMainGui( 'Images' );
s           = size( images );
numImages   = s( 3 );
mH          = getappdata( handles.segmentation, 'methodHistory' );
mHIndex     = getappdata( handles.segmentation, 'methodHistoryIndex' );

if mHIndex == 0
    return;
end

% XXX quick bugfix in absence of time
% the method trimToRect or better setToZero returns a false result if 
% the current view is not transversal
currView = get( handles.chooseView, 'Value' );
set( handles.chooseView, 'Value', 1 );

% apply methodHistory to all images
for i = numImages:-1:1
    img           = images(:,:,i);
    img           = applyMethods( img, mH, mHIndex, handles );
    images(:,:,i) = img(:,:);
end

% XXX part of bugfix
set( handles.chooseView, 'Value', currView );

setDataMainGui( 'Images', images );
setappdata( handles.segmentation, 'methodHistory'         , {} );
setappdata( handles.segmentation, 'methodHistoryIndex'    , 0 );
   
% update hMain
hMain          = getDataMainGui( 'handles' );
fhUpdateTraImg = getDataMainGui( 'fhUpdateTraImg' );
fhUpdateSagImg = getDataMainGui( 'fhUpdateSagImg' );
fhUpdateCorImg = getDataMainGui( 'fhUpdateCorImg' );

% functionEvaluation
feval( fhUpdateTraImg, get( hMain.sliderTra, 'Value' ), hMain );
feval( fhUpdateSagImg, get( hMain.sliderSag, 'Value' ), hMain );
feval( fhUpdateCorImg, get( hMain.sliderCor, 'Value' ), hMain );

% set currFigure as the current figure
figure( currFigure );
set( handles.undo, 'enable', 'off' );

% update Log
fhUpdateLog = getDataMainGui( 'fhUpdateLog' );
feval( fhUpdateLog, mH, 'all', -1 );
end


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

set(handles.testView, 'xlim', [ 0.5  size(currImg,2)+0.5 ]);
set(handles.testView, 'ylim', [ 0.5  size(currImg,1)+0.5 ]);
setappdata(handles.segmentation, 'currImg', currImg);
applyToView( handles, 0 );

% current method trimToRect? draw rect
if get( handles.chooseMethod, 'Value' ) == 1
    drawTrimToRect( handles );
end
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
end


% --- Executes on button press in showHistogram.
function showHistogram_Callback(hObject, eventdata, handles)

figure, imhist( getappdata(handles.segmentation, 'currTestImg' ) );
end


function updateTestView(view, currImg)
handles     = getDataMainGui( 'hsegmentation' );
currView    = getappdata(handles.segmentation, 'currView');

if strcmp(currView,'tra') && strcmp(view,'tra')         % transversal
    setappdata(handles.segmentation, 'currTraImg', currImg );
    setappdata(handles.segmentation, 'currImg', currImg );
elseif strcmp(currView,'sag') && strcmp(view,'sag')     % sagittal
    setappdata(handles.segmentation, 'currSagImg', currImg );
    setappdata(handles.segmentation, 'currImg', currImg );
elseif strcmp(currView,'cor') && strcmp(view,'cor')     % coronal
    setappdata(handles.segmentation, 'currCorImg', currImg );
    setappdata(handles.segmentation, 'currImg', currImg );
end

if strcmp(currView,view)
    applyToView( handles, 0 );
    
     % current method trimToRect? draw rect
    if get( handles.chooseMethod, 'Value' ) == 1
        drawTrimToRect( handles );
    end
end
end


% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)

% if single image methode undo only this method
currMethod = get( handles.chooseMethod, 'Value' );

% if "Cut out inner/outer circle"
if currMethod == 3 
    mH      = getappdata(handles.segmentation, 'methodHistoryROI' );
    mHIndex = getappdata(handles.segmentation, 'methodHistoryIndexROI' );

    if mHIndex > 0
        mH{ mHIndex } = {};
        mHIndex = mHIndex - 1;
        
        if mHIndex == 0
            set( hObject, 'enable', 'off' );
        end 
        
        currTestImg = getappdata(handles.segmentation, 'currTestImg' );
        
        for i = 1:1:mHIndex;
            mName = mH{i}{1};
            
            if strcmp( mName, 'roipoly' )
                innerOuter = mH{i}{2};
                roi        = mH{i}{3};

                if strcmp( innerOuter, 'outer' )
                    currTestImg(~roi) = 0;
                
                else
                    currTestImg(roi) = 0;
                end
            end
        end
        setappdata(handles.segmentation, 'currTestImgRoi'         , currTestImg);
        setappdata(handles.segmentation, 'methodHistoryROI'       , mH );
        setappdata(handles.segmentation, 'methodHistoryIndexROI'  , mHIndex );
        imshowKeepZoom( currTestImg ); 
        return;
    end
end

% else use code below

mH      = getappdata(handles.segmentation, 'methodHistory' );
mHIndex = getappdata(handles.segmentation, 'methodHistoryIndex' );

if mHIndex > 0
    mH{ mHIndex } = {};
    mHIndex = mHIndex - 1;

    setappdata(handles.segmentation, 'methodHistory'     , mH );
    setappdata(handles.segmentation, 'methodHistoryIndex', mHIndex );

end

% since mHIndex = mHIndex - 1, we can check if the new mHIndex is == 0
if mHIndex == 0
    set( hObject, 'enable', 'off' );
end 

applyToView( handles, 0 );
end


% --- Executes on selection change in chooseMethod.
function chooseMethod_Callback(hObject, eventdata, handles)
% hObject    handle to chooseMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chooseMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseMethod

currVal     = get(hObject,'Value'); 
isInfo      = getappdata(handles.segmentation, 'isInfo' );

if currVal == 1      % Trim to rectangle *
    setappdata(handles.segmentation, 'currMethod', 'trimToRect' );
    set( handles.valuePanel     , 'visible' , 'on' );
    set( handles.textVal1       , 'visible' , 'on' );
    set( handles.val1           , 'visible' , 'on' );
    set( handles.textVal1       , 'string'  , 'Point 1');
    set( handles.val1           , 'string'  , '1,1');
    set( handles.textVal2       , 'visible' , 'on' );
    set( handles.val2           , 'visible' , 'on' );
    set( handles.textVal2       , 'string'  , 'Point 2' );
    rows        = getDataMainGui( 'traRows' );
    columns     = getDataMainGui( 'traColumns' );
    set( handles.val2           , 'string'  , strcat( num2str(rows), ',', num2str(columns) ) );
    set( handles.applyToImage   , 'visible' , 'off' );
    set( handles.applyToImages  , 'visible' , 'on' );
    set( handles.undo           , 'string'  , 'Undo' );
    set( handles.applyToView    , 'visible' , 'on' );
    set( handles.newCircle      , 'visible' , 'off' ); 
    
    if isInfo
        set( handles.infoText       , 'string'  , 'This method sets every pixel outside of the rectangle to 0. The first point( syntax of a point: x,y ) is the upper left, the second one is the lower right.' );
    end
    
elseif currVal == 2  % New interval of gray levels
    setappdata(handles.segmentation, 'currMethod', 'grayScale' );
    set( handles.valuePanel     , 'visible' , 'on' );
    set( handles.textVal1       , 'visible' , 'on' );
    set( handles.val1           , 'visible' , 'on' );
    set( handles.textVal1       , 'string'  , 'New min');
    set( handles.val1           , 'string'  , 'Min');
    set( handles.textVal2       , 'visible' , 'on' );
    set( handles.val2           , 'visible' , 'on' );
    set( handles.textVal2       , 'string'  , 'New max' );
    set( handles.val2           , 'string'  , 'Max' );
    set( handles.applyToImage   , 'visible' , 'on' );
    set( handles.applyToImages  , 'visible' , 'on' );
    set( handles.undo           , 'string'  , 'Undo' );
    set( handles.applyToView    , 'visible' , 'on' );
    set( handles.newCircle      , 'visible' , 'off' ); 
    
    if isInfo
        set( handles.infoText       , 'string'  , 'Appling a new grayscale-interval means, that every pixel below or above the new range is set to 0.' );
    end
    
elseif currVal == 3 % Cut out inner/outer circle
    setappdata(handles.segmentation, 'currMethod', 'roipoly' );
    currTestImg = getappdata(handles.segmentation, 'currTestImg' );
    setappdata(handles.segmentation, 'currTestImgRoi'           , currTestImg );
    setappdata(handles.segmentation, 'methodHistoryROI'         , {} );
    setappdata(handles.segmentation, 'methodHistoryIndexROI'    , 0 );
    set( handles.valuePanel     , 'visible' , 'on' );
    set( handles.textVal1       , 'visible' , 'on' );
    set( handles.val1           , 'visible' , 'on' );
    set( handles.textVal1       , 'string'  , 'Cut');
    set( handles.val1           , 'string'  , 'outer');
    set( handles.textVal2       , 'visible' , 'off' );
    set( handles.val2           , 'visible' , 'off' );
    set( handles.applyToImage   , 'visible' , 'on' );
    set( handles.applyToImages  , 'visible' , 'off' );
    set( handles.newCircle      , 'visible' , 'on' ); 
    set( handles.applyToView    , 'visible' , 'off' );
    set( handles.undo           , 'string'  , 'Undo only this method' );
    
    if isInfo
        set( handles.infoText       , 'string'  , 'Create a circle by adding points to the image, then choose if you want to cut out the "inner" or the "outer" part. (-Adjust the position of the polygon and individual vertices by clicking and dragging. -To add new vertices, position the pointer along an edge and press the "a" key. -Double-click to add a final vertex and double-click again to submit the polygon. -Right-click to close the polygon without adding a vertex. -Delete by pressing Backspace or Escape.)' );
    end
    
end

% * if trimToRect 
if currVal == 1
    drawTrimToRect( handles );
else
    currTestImg = getappdata(handles.segmentation, 'currTestImg' );
    imshowKeepZoom( currTestImg );
end
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
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over infoText.
function infoText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to infoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get( hObject, 'string' ), 'Click me to get more informations.' )
    % info is shown
    setappdata(handles.segmentation, 'isInfo', 1 );
    
    currVal     = get(handles.chooseMethod,'Value'); 

    if currVal == 1     % Trim to rectangle
        set( handles.infoText, 'string', 'This method sets every pixel outside of the rectangle to 0. The first point( syntax of a point: x,y ) is the upper left, the second one is the lower right.' );
    
    elseif currVal == 2 % New interval of gray levels
        set( handles.infoText, 'string', 'Appling a new grayscale-interval means, that every pixel below or above the new range is set to 0.' );
    
    elseif currVal == 3 % Cut out inner/outer circle
        set( handles.infoText, 'string', 'Create a circle by adding points to the image, then choose if you want to cut out the "inner" or the "outer" part. (-Adjust the position of the polygon and individual vertices by clicking and dragging. -To add new vertices, position the pointer along an edge and press the "a" key. -Double-click to add a final vertex and double-click again to submit the polygon. -Right-click to close the polygon without adding a vertex. -Delete by pressing Backspace or Escape.)' );
    
    end
    
else
    set( hObject, 'string', 'Click me to get more informations.' );
    setappdata(handles.segmentation, 'isInfo', 0 );
end
end


% --- Executes on button press in newCircle.
function newCircle_Callback(hObject, eventdata, handles)
% hObject    handle to newCircle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

roi     = getappdata(handles.segmentation, 'roi' );
mH      = getappdata( handles.segmentation, 'methodHistoryROI' );
mHIndex = getappdata( handles.segmentation, 'methodHistoryIndexROI' );
mHIndex = mHIndex + 1;

if roi == -1
    setappdata(handles.segmentation, 'roi', 1 ); % roi in use
    [roi, x, y] = roipoly;
    if size(roi, 1) > 0 % no cancel?
        % now method can be undone
        set( handles.undo, 'enable', 'on' );

        currTestImgRoi = getappdata(handles.segmentation, 'currTestImgRoi' );
        %inner outer?
        innerOuter = get( handles.val1, 'string');
        if strcmp( innerOuter, 'outer' )
            currTestImgRoi(~roi) = 0;
            mH{ mHIndex }   = { 'roipoly', 'outer', roi, x, y };
            
        elseif strcmp( innerOuter, 'inner' )
            currTestImgRoi(roi) = 0;
            mH{ mHIndex }   = { 'roipoly', 'inner', roi, x, y };
            
        else
            set( handles.val1, 'string', 'outer' );
            setappdata(handles.segmentation, 'roi', -1 );
            warndlg( 'Possible values are "outer" or "inner.', 'Attention' );
            return;
            
        end
        imshowKeepZoom( currTestImgRoi );
        setappdata(handles.segmentation, 'methodHistoryROI'     , mH );
        setappdata(handles.segmentation, 'methodHistoryIndexROI', mHIndex );
        setappdata(handles.segmentation, 'currTestImgRoi'       , currTestImgRoi );
    end
    setappdata(handles.segmentation, 'roi', -1 );
else
    warndlg( 'You can only create one circle at a time, delete the current one, then create a new circle.', 'Attention' );
end
end


% --- Executes when segmentation is resized.
function segmentation_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% uipanel2 and testView have the property "units" set to "normalized"

oldUnits        = get(hObject,'Units');
set(hObject,'Units','pixels');
figPos          = get(hObject,'Position');

% set infoText
set(handles.infoText,'Units','pixels');
infoTextPos     = get(handles.infoText,'Position');
% upos          = left, bottom, widht, height
% new bottom    = heightFigure-hightInfo-7pxDefaultSpace(the space between infoText and upper border of the figure)
% 7pxDefaultSpace = figPos(4) - infoTextPos(2) - infoTextPos(4)
newBottom       = figPos(4) - infoTextPos(4) - 7;
upos            = [infoTextPos(1), newBottom, infoTextPos(3), infoTextPos(4)];
set(handles.infoText,'Position',upos);

% set methodPanel
set(handles.methodPanel,'Units','pixels');
methodPanelPos      = get(handles.methodPanel,'Position');
newBottom           = figPos(4) - methodPanelPos(4) - 49;
oldUnitsUIPanel2    = get(handles.uipanel2,'Units');
set(handles.uipanel2,'Units','pixels');
UIPanel2Pos         = get(handles.uipanel2,'Position');
%methodPanelPos(1)-(UIPanel2Pos(1)+UIPanel2Pos(3)) = 32 % space between
%uipanel2 and methodPanel
newLeft             = UIPanel2Pos(1) + UIPanel2Pos(3) + 32;
%newLeft         = figPos(3) - methodPanelPos(3) - 21; % keep method Panel
%on the right edge
upos                = [newLeft, newBottom, methodPanelPos(3), methodPanelPos(4)];
set(handles.methodPanel,'Position',upos);
set(handles.uipanel2,'Units',oldUnitsUIPanel2);

set(hObject,'Units',oldUnits);
end


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fhUpDown = getDataMainGui( 'fhUpDown' );
feval( fhUpDown, handles, true );
end


% --- Executes on button press in up.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fhUpDown = getDataMainGui( 'fhUpDown' );
feval( fhUpDown, handles, false );
end
