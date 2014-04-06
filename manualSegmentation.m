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

% Last Modified by GUIDE v2.5 06-Apr-2014 21:18:09

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

setappdata(handles.manualSegmentation, 'currView'              , 'tra');
setappdata(handles.manualSegmentation, 'currImg'               , currTraImg);
setappdata(handles.manualSegmentation, 'currTraImg'            , currTraImg );
setappdata(handles.manualSegmentation, 'currSagImg'            , currSagImg );
setappdata(handles.manualSegmentation, 'currCorImg'            , currCorImg );
setappdata(handles.manualSegmentation, 'currImgMask'           , 0 );
setappdata(handles.manualSegmentation, 'currMask'              , 0 );
setappdata(handles.manualSegmentation, 'getpts'                , 0 ); % 0 = not in use
% if masks exist set mask
dDMasks = getDataMainGui( 'dropDownMasks' );
sizeM = size(dDMasks);
if sizeM(1) > 0
    name        = dDMasks{1};
    masks       = getDataMainGui( 'masks' );
    currMask    = masks.( name );
    setappdata(handles.manualSegmentation, 'currMask'          , currMask );
    
    updateCurrImgMask( handles );
end

imshow( currTraImg );

% set global data
setDataMainGui( 'hmanualSegmentation', handles );
setDataMainGui( 'fhUpdateTestView', @updateTestView );

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

updateCurrImgMask( handles );
isSet = get(handles.showMask,'Value');
showMask( handles, isSet );


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
    
    updateCurrImgMask( handles );
    isSet = get(handles.showMask,'Value');
    showMask( handles, isSet );
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

% read from struct
currMask = masks.( name );
setappdata(handles.manualSegmentation, 'currMask', currMask );

% update testView
updateCurrImgMask( handles );
isSet    = get(handles.showMask,'Value');
showMask( handles, isSet );


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
function currImgMask = updateCurrImgMask( handles )

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

% --- Executes on button press in showMask.
function showMask_Callback(hObject, eventdata, handles)
% hObject    handle to showMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showMask

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

blue = cat(3, zeros(size(img)), zeros(size(img)), currImgMask);
imshowKeepZoom( blue );

hold on;
alpha = 0.6;
alpha_matrix = alpha*ones(size(img,1),size(img,2));
h = imshowKeepZoom( img );
set(h,'AlphaData',alpha_matrix);
hold off;


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
setappdata(handles.manualSegmentation, 'getpts', 1);

[X, Y] = getpts( handles.testView ); 

% round coordinates
for i=1:1:size(X)
    X(i) = round(X(i));
    Y(i) = round(Y(i));
end

currImgMask     = getappdata( handles.manualSegmentation, 'currImgMask' );

% invert current mask value
for i=1:1:size(X)
    currVal = currImgMask(Y(i), X(i));      % currVal is 1 or 0
    currImgMask(Y(i), X(i)) = 1 - currVal;  % invert value
end

setappdata( handles.manualSegmentation, 'currImgMask', currImgMask );

% set new currImgMask according to current view
dDMasks = getDataMainGui( 'dropDownMasks' );
sizeM = size(dDMasks);
if sizeM(1) == 0
    warndlg( 'Couldn''t found a mask to save. Create/Load mask first.', 'Attention' );
    return;
end

currMask        = getappdata(handles.manualSegmentation, 'currMask' );
hMain           = getDataMainGui( 'handles' );
img             = getappdata(handles.manualSegmentation, 'currImg' );
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
masks    = getDataMainGui( 'masks' );
contents = cellstr(get(handles.chooseMask,'String'));
name     = contents{get(handles.chooseMask,'Value')};
masks.( name ) = currMask;
setDataMainGui( 'masks', masks );

% redraw image and new mask
imshowKeepZoom( img );
isSet    = get(handles.showMask,'Value');
showMask( handles, isSet )

setappdata(handles.manualSegmentation, 'currMask', currMask );
setappdata(handles.manualSegmentation, 'getpts', 0);
