function varargout = manualSegmentation(varargin)
% MANUALSEGMENTATION MATLAB code for manualSegmentation.fig
%      MANUALSEGMENTATION, by itself, creates a new MANUALSEGMENTATION or raises the existing
%      singleton*.
%
%      H = MANUALSEGMENTATION returns the handle to a new MANUALSEGMENTATION or the handle to
%      the existing singleton*.
%
%      MANUALSEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALSEGMENTATION.M with the given input arguments.
%
%      MANUALSEGMENTATION('Property','Value',...) creates a new MANUALSEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualSegmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualSegmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manualSegmentation

% Last Modified by GUIDE v2.5 21-Apr-2014 20:23:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualSegmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @manualSegmentation_OutputFcn, ...
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


% --- Executes just before manualSegmentation is made visible.
function manualSegmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualSegmentation (see VARARGIN)

% Choose default command line output for manualSegmentation
handles.output = hObject;

hMain = getappdata(0, 'hMainGui');

% set some data
currTraImg  = getappdata( hMain, 'currTraImg' );
currSagImg  = getappdata( hMain, 'currSagImg' );
currCorImg  = getappdata( hMain, 'currCorImg' );

setappdata(handles.manualSegmentation, 'currView'       , 'tra');
setappdata(handles.manualSegmentation, 'currImg'        , currTraImg);
setappdata(handles.manualSegmentation, 'currTraImg'     , currTraImg );
setappdata(handles.manualSegmentation, 'currSagImg'     , currSagImg );
setappdata(handles.manualSegmentation, 'currCorImg'     , currCorImg );
setappdata(handles.manualSegmentation, 'currImgMask'    , 0 );
setappdata(handles.manualSegmentation, 'currMask'       , 0 );
setappdata(handles.manualSegmentation, 'transparency'   , 0.6 );
setappdata(handles.manualSegmentation, 'maskColor'      , 'blue' );
setappdata(handles.manualSegmentation, 'getpts'         , 0 ); % 0 = not in use
setappdata(handles.manualSegmentation, 'roi'            , 0 );
% if masks exist set mask
dDMasks = getDataMainGui( 'dropDownMasks' );
sizeM = size(dDMasks);
if sizeM(1) > 0
    name        = dDMasks{1};
    masks       = getDataMainGui( 'masks' );
    currMask    = masks.( name );
    setappdata(handles.manualSegmentation, 'currMask'          , currMask );
    
    updateCurrImgMask( handles, 0 );
end

imshow( currTraImg );

% show Mask
if sizeM(1) > 0
    isSet           = get(handles.showMask,'Value');
    showMask( handles, isSet );
end

% set global data
setDataMainGui( 'hmanualSegmentation', handles );
setDataMainGui( 'fhUpdateTestView', @updateTestView );
setDataMainGui( 'fhUpdateCurrImgMask', @updateCurrImgMask );

% Update handles structure
guidata(hObject, handles);

% clear the command line
clc;

% UIWAIT makes manualSegmentation wait for user response (see UIRESUME)
% uiwait(handles.manualSegmentation);


% --- Outputs from this function are returned to the command line.
function varargout = manualSegmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close manualSegmentation.
function manualSegmentation_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to manualSegmentation (see GCBO)
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
    

% --- keep the current zoom state
function h = imshowKeepZoom( img )
xZoom = xlim;
yZoom = ylim;
    
h     = imshow( img ); 

% set current zoom state
xlim(xZoom);
ylim(yZoom);


% --- Executes on selection change in chooseView.
function chooseView_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns chooseView contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseView

currVal     = get(hObject,'Value');

% set currentImgMask
if currVal == 1      % transversal
    currImg         = getDataMainGui( 'currTraImg' );
    setappdata(handles.manualSegmentation, 'currView', 'tra');
    
elseif currVal == 2  % sagittal
    currImg         = getDataMainGui( 'currSagImg' );
    setappdata(handles.manualSegmentation, 'currView', 'sag');
    
else                 % coronal
    currImg             = getDataMainGui( 'currCorImg' );
    setappdata(handles.manualSegmentation, 'currView', 'cor');
    
end
setappdata(handles.manualSegmentation, 'currImg', currImg);

imshowKeepZoom( currImg );

updateCurrImgMask( handles, 1 );


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


function updateTestView(view, currImg)
handles     = getDataMainGui( 'hmanualSegmentation' );
currView    = getappdata(handles.manualSegmentation, 'currView');

if strcmp(currView,'tra') && strcmp(view,'tra')         % transversal
    setappdata(handles.manualSegmentation, 'currTraImg', currImg );
elseif strcmp(currView,'sag') && strcmp(view,'sag')     % sagittal
    setappdata(handles.manualSegmentation, 'currSagImg', currImg );
elseif strcmp(currView,'cor') && strcmp(view,'cor')     % coronal
    setappdata(handles.manualSegmentation, 'currCorImg', currImg );
end
setappdata(handles.manualSegmentation, 'currImg', currImg );

if strcmp(currView,view)
    % due to the sync by the prototype we need to set axes
    axes( handles.testView );

    imshowKeepZoom( currImg );
    
    updateCurrImgMask( handles, 1 );
end


% --- Executes on selection change in chooseMask.
function chooseMask_Callback(hObject, eventdata, handles)
% hObject    handle to chooseMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chooseMask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseMask

masks    = getDataMainGui( 'masks' );
contents = cellstr(get(hObject,'String'));
name     = contents{get(hObject,'Value')};

dDMasks  = getDataMainGui( 'dropDownMasks' );
sizeM    = size(dDMasks);
if sizeM(1) == 0
    warndlg( 'Couldn''t find a label. Create/Load label first.', 'Attention' );
    return;
end

% read from struct
currMask = masks.( name );
setappdata(handles.manualSegmentation, 'currMask', currMask );

% update testView
updateCurrImgMask( handles, 1 );


% --- Executes during object creation, after setting all properties.
function chooseMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooseMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% fill in masks
dDmasks = getDataMainGui( 'dropDownMasks' );
sizeM = size( dDmasks );

if sizeM(1) == 0
    return;
end

set( hObject, 'string', dDmasks );


% update the current image mask
function currImgMask = updateCurrImgMask( handles, show )

% if no mask return
dDmasks = getDataMainGui( 'dropDownMasks' );
sizeM = size( dDmasks );

if sizeM(1) == 0
    return;
end

% updateTestView mit dem zweck currentImgMask zu setzen
currMask        = getappdata(handles.manualSegmentation, 'currMask' );
hMain           = getDataMainGui( 'handles' );
currVal         = get(handles.chooseView,'Value'); 

if currVal == 1      % transversal
    currIndex           = get( hMain.sliderTra, 'Value' );
	currImgMask         = currMask(:,:,currIndex);
    
elseif currVal == 2  % sagittal
    currIndex           = get( hMain.sliderSag, 'Value' );
    currImgMask         = currMask(:,currIndex,:);
    % reshape
    currDefaultMaskSize = size(currImgMask);
    currImgMask         = reshape( currImgMask, [ currDefaultMaskSize(1), currDefaultMaskSize(3) ]);
    manipulate          = maketform( 'affine',[ 0 getDataMainGui( 'flip' )*getDataMainGui( 'scale' ); 1 0; 0 0 ] );        
    nearestNeighbour    = makeresampler( 'cubic','fill' );
    currImgMask         = imtransform( currImgMask,manipulate,nearestNeighbour );
    currImgMask         = flipdim(currImgMask,2);
    
else                 % coronal
    currIndex           = get( hMain.sliderCor, 'Max' )+1 - get( hMain.sliderCor, 'Value' );
    currImgMask         = currMask(currIndex,:,:);
    % reshape
    currDefaultMaskSize = size(currImgMask);
    currImgMask         = reshape( currImgMask, [ currDefaultMaskSize(2), currDefaultMaskSize(3) ]);
    manipulate          = maketform( 'affine',[ 0 getDataMainGui( 'flip' )*getDataMainGui( 'scale' ); 1 0; 0 0 ] );     
    nearestNeighbour    = makeresampler( 'cubic','fill' );
    currImgMask         = imtransform( currImgMask,manipulate,nearestNeighbour );
    currImgMask         = flipdim(currImgMask,2);
    
end

setappdata(handles.manualSegmentation, 'currImgMask' , currImgMask );

if show
    isSet    = get(handles.showMask,'Value');
    showMask( handles, isSet );
end

% --- Executes on button press in showMask.
function showMask_Callback(hObject, eventdata, handles)
% hObject    handle to showMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showMask

dDMasks  = getDataMainGui( 'dropDownMasks' );
sizeM    = size(dDMasks);
if sizeM(1) == 0
    warndlg( 'Couldn''t find a label. Create/Load label first.', 'Attention' );
    return;
end

isSet           = get(hObject,'Value');
showMask( handles, isSet );


% --- show Mask
function showMask( handles, isSet )

img         = getappdata(handles.manualSegmentation, 'currImg' );

if isSet == 0
    imshowKeepZoom( img );
    return;
end

currImgMask = getappdata(handles.manualSegmentation, 'currImgMask' );
maskColor   = getappdata(handles.manualSegmentation, 'maskColor' );

if strcmp( maskColor, 'blue' )
    mask = cat(3, zeros(size(img)), zeros(size(img)), currImgMask );

elseif strcmp( maskColor, 'red' )
    mask = cat(3, currImgMask, zeros(size(img)), zeros(size(img)) );
    
elseif strcmp( maskColor, 'green' )
    mask = cat(3, zeros(size(img)), currImgMask, zeros(size(img)) );
    
end    
imshowKeepZoom( mask );

transparency = getappdata(handles.manualSegmentation, 'transparency' );
hold on;
alpha = transparency;
alpha_matrix = alpha*ones(size(img,1),size(img,2));
h = imshowKeepZoom( img );
set(h,'AlphaData',alpha_matrix);
hold off;


% --- update the current (choosen) mask
function updateCurrMask( handles )

currMask        = getappdata(handles.manualSegmentation, 'currMask' );
currImgMask     = getappdata(handles.manualSegmentation, 'currImgMask' );
hMain           = getDataMainGui( 'handles' );
currVal         = get(handles.chooseView,'Value'); 

if currVal == 1      % transversal
    currIndex               = get( hMain.sliderTra, 'Value' );
	currMask(:,:,currIndex) = currImgMask;
    
elseif currVal == 2  % sagittal
    currIndex      = get( hMain.sliderSag, 'Value' );
    sizeI          = size(currImgMask, 2); % 256
    sizeJ          = size(currImgMask, 1); % 170
        
    for i=1:1:sizeI
        for j=1:1:sizeJ
            currMask(i,currIndex,j) = currImgMask(sizeJ+1 - j, sizeI+1 - i);
        end
    end
    
else                 % coronal
    currIndex      = get( hMain.sliderCor, 'Max' )+1 - get( hMain.sliderCor, 'Value' );
    sizeI          = size(currImgMask, 2); % 256
    sizeJ          = size(currImgMask, 1); % 170
        
    for i=1:1:sizeI
        for j=1:1:sizeJ
            currMask(currIndex,i,j) = currImgMask(sizeJ+1 - j, sizeI+1 - i);
        end
    end
        
end

% update the masks struct
masks           = getDataMainGui( 'masks' );
contents        = cellstr(get(handles.chooseMask,'String'));
name            = contents{get(handles.chooseMask,'Value')};
masks.( name )  = currMask;
setDataMainGui( 'masks', masks );
setappdata(handles.manualSegmentation, 'currMask', currMask );


% --- Executes on button press in selectPixels.
function selectPixels_Callback(hObject, eventdata, handles)
% hObject    handle to selectPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

isInUse = getappdata(handles.manualSegmentation, 'getpts');
if isInUse == 1
    warndlg( 'End your current selection before you start a new one.', 'Attention' );
    return;
end

currImgMask = getappdata( handles.manualSegmentation, 'currImgMask' );
% if no mask loaded yet
if size( currImgMask, 1 ) == 1
    warndlg( 'Couldn''t find a label. Create/Load label first.', 'Attention' );
    return;
end

setappdata(handles.manualSegmentation, 'getpts', 1);

[X, Y] = getpts( handles.testView ); 

% round coordinates
for i=1:1:size(X)
    X(i) = round(X(i));
    Y(i) = round(Y(i));
end

% invert current mask value
for i=1:1:size(X)
    currVal = currImgMask(Y(i), X(i));      % currVal is 1 or 0
    currImgMask(Y(i), X(i)) = 1 - currVal;  % invert value
end

setappdata( handles.manualSegmentation, 'currImgMask', currImgMask );

updateCurrMask( handles );

% redraw image and new mask
img     = getappdata(handles.manualSegmentation, 'currImg' );
imshowKeepZoom( img );
isSet   = get(handles.showMask,'Value');
showMask( handles, isSet );

setappdata(handles.manualSegmentation, 'getpts', 0);


% --- Executes on selection change in maskColor.
function maskColor_Callback(hObject, eventdata, handles)
% hObject    handle to maskColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns maskColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from maskColor

contents  = cellstr(get(hObject,'String'));
maskColor = contents{get(hObject,'Value')};
setappdata(handles.manualSegmentation, 'maskColor', maskColor );

isSet     = get(handles.showMask,'Value');
showMask( handles, isSet );


% --- Executes during object creation, after setting all properties.
function maskColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maskTransparency_Callback(hObject, eventdata, handles)
% hObject    handle to maskTransparency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskTransparency as text
%        str2double(get(hObject,'String')) returns contents of maskTransparency as a double

val     = str2double(get(hObject,'String'));

if val > 1
    val = 1;
elseif val < 0
    val = 0;
end

setappdata(handles.manualSegmentation, 'transparency', val );

isSet   = get(handles.showMask,'Value');
showMask( handles, isSet )


% --- Executes during object creation, after setting all properties.
function maskTransparency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskTransparency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectRegion.
function selectRegion_Callback(hObject, eventdata, handles)
% hObject    handle to selectRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

roi         = getappdata(handles.manualSegmentation, 'roi' );
currImgMask = getappdata( handles.manualSegmentation, 'currImgMask' );

% if no mask loaded yet
if size( currImgMask, 1 ) == 1
    warndlg( 'Couldn''t find a label. Create/Load label first.', 'Attention' );
    return;
end

if roi == 0
    setappdata(handles.manualSegmentation, 'roi', 1 ); % roi in use
    roi = roipoly;

    if size(roi, 1) > 0 % cancel?
        if strcmp( get(hObject,'string'), 'Select region (add)' )
            currImgMask(roi) = 1;
        elseif strcmp( get(hObject,'string'), 'Select region (remove)' )
            currImgMask(roi) = 0;
        end
    end
    
    setappdata(handles.manualSegmentation, 'currImgMask', currImgMask );
    setappdata(handles.manualSegmentation, 'roi', 0 );
    
    updateCurrMask( handles );
    isSet = get(handles.showMask,'Value');
    showMask( handles, isSet );
else
    warndlg( 'You can only create one region at a time, delete the current one, then create a new region.', 'Attention' );
end;


% --- Executes when manualSegmentation is resized.
function manualSegmentation_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to manualSegmentation (see GCBO)
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



% --- Executes when uipanel2 is resized.
function uipanel2_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fhUpDown = getDataMainGui( 'fhUpDown' );
feval( fhUpDown, handles, true );


% --- Executes on button press in up.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fhUpDown = getDataMainGui( 'fhUpDown' );
feval( fhUpDown, handles, false );
