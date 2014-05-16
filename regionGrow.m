function varargout = regionGrow(varargin)
% REGIONGROW MATLAB code for regionGrow.fig
%      REGIONGROW, by itself, creates a new REGIONGROW or raises the existing
%      singleton*.
%
%      H = REGIONGROW returns the handle to a new REGIONGROW or the handle to
%      the existing singleton*.
%
%      REGIONGROW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGIONGROW.M with the given input arguments.
%
%      REGIONGROW('Property','Value',...) creates a new REGIONGROW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before regionGrow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to regionGrow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help regionGrow

% Last Modified by GUIDE v2.5 16-May-2014 20:48:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @regionGrow_OpeningFcn, ...
                   'gui_OutputFcn',  @regionGrow_OutputFcn, ...
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


% --- Executes just before regionGrow is made visible.
function regionGrow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to regionGrow (see VARARGIN)

% Choose default command line output for regionGrow
handles.output = hObject;

hMain = getappdata(0, 'hMainGui');

% set some data
currTraImg  = getappdata( hMain, 'currTraImg' );
currSagImg  = getappdata( hMain, 'currSagImg' );
currCorImg  = getappdata( hMain, 'currCorImg' );
seedMask    = false(size( currTraImg ));
regionMask  = false(size( currTraImg ));

setappdata(handles.regionGrow, 'currView'           , 'tra');
setappdata(handles.regionGrow, 'currImg'            , currTraImg);
setappdata(handles.regionGrow, 'currTraImg'         , currTraImg );
setappdata(handles.regionGrow, 'currSagImg'         , currSagImg );
setappdata(handles.regionGrow, 'currCorImg'         , currCorImg );
setappdata(handles.regionGrow, 'currSeedMask'       , seedMask );
setappdata(handles.regionGrow, 'currImgMask'        , 0 );
setappdata(handles.regionGrow, 'currImgMaskMethod'  , regionMask );
setappdata(handles.regionGrow, 'currSeedMethod'     , 'New Seeds' );
setappdata(handles.regionGrow, 'currMask'           , 0 );
setappdata(handles.regionGrow, 'getpts'             , 0 ); % 0 = not in use
setappdata(handles.regionGrow, 'isTransparent'      , 1 );
setappdata(handles.regionGrow, 'alpha'              , 0.6 );
% if masks exist set mask
dDMasks = getDataMainGui( 'dropDownMasks' );
sizeM = size(dDMasks);
if sizeM(1) > 0
    name        = dDMasks{1};
    masks       = getDataMainGui( 'masks' );
    currMask    = masks.( name );
    setappdata(handles.regionGrow, 'currMask'          , currMask );
end

imshow( currTraImg );

% set global data
setDataMainGui( 'hregionGrow', handles );
setDataMainGui( 'fhUpdateTestView', @updateTestView );

% Update handles structure
guidata(hObject, handles);

% show default mask if available
dDMasks = getDataMainGui( 'dropDownMasks' );
sizeM = size(dDMasks);
if sizeM(1) ~= 0
    applyToView( handles, 0 );
end

% clear the command line
clc;

% UIWAIT makes regionGrow wait for user response (see UIRESUME)
% uiwait(handles.regionGrow);
end


% --- Outputs from this function are returned to the command line.
function varargout = regionGrow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes when user attempts to close regionGrow.
function regionGrow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to regionGrow (see GCBO)
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
function h = imshowKeepZoom( img )
handles = getDataMainGui( 'hregionGrow' );
xZoom   = xlim(handles.testView);
yZoom   = ylim(handles.testView);

h       = imshow( img, 'parent', handles.testView ); 

% set current zoom state
set(handles.testView, 'xlim', xZoom);
set(handles.testView, 'ylim', yZoom);
end


% --- choose your seeds
function [X, Y] = chooseSeeds( handles )

[X, Y] = getpts( handles.testView ); 

% round coordinates
for i=1:1:size(X)
    X(i) = round(X(i));
    Y(i) = round(Y(i));
end
end


% --- add seeds to seedMask
function seedMask = addSeedsToMask( handles, X, Y )

seedMask = getappdata( handles.regionGrow, 'currSeedMask' );

% add
for i=1:1:size(X)
    seedMask(Y(i), X(i)) = 1;
end

setappdata(handles.regionGrow, 'currSeedMask', seedMask );
end


% --- delete seeds from seedMask
function seedMask = deleteSeedsFromMask( handles, X, Y )

seedMask = getappdata( handles.regionGrow, 'currSeedMask' );

% delete
for i=1:1:size(X)
    seedMask(Y(i), X(i)) = 0;
end

setappdata(handles.regionGrow, 'currSeedMask', seedMask );
end


% --- draw seeds below current image
function drawSeeds( handles, seedMask )

red             = cat( 3, seedMask, zeros(size(seedMask)), zeros(size(seedMask)) );
imshowKeepZoom(red);

% the "data cursor" gets the pixelvalue of the top image so we overlay the
% current image (importent to find a good thresh)
hold on;
alpha           = 0.2;
alpha_matrix    = alpha * ones(size( seedMask,1 ), size( seedMask, 2 ));
img             = getappdata( handles.regionGrow, 'currImg' );
h               = imshowKeepZoom(img);
set( h,'AlphaData',alpha_matrix );
    
hold off;
end


% --- regiongrow algorithem
function [g, NR, SI, TI] = regiongrow(f, S, T)
%REGIONGROW Perform segmentation by region growing.
%   [G, NR, SI, TI] = REGIONGROW(F, SR, T).  S can be an array (the
%   same size as F) with a 1 at the coordinates of every seed point
%   and 0s elsewhere.  S can also be a single seed value. Similarly,
%   T can be an array (the same size as F) containing a threshold
%   value for each pixel in F. T can also be a scalar, in which
%   case it becomes a global threshold.   
%
%   On the output, G is the result of region growing, with each
%   region labeled by a different integer, NR is the number of
%   regions, SI is the final seed image used by the algorithm, and TI
%   is the image consisting of the pixels in F that satisfied the
%   threshold test. 

%   Copyright 2002-2004 R. C. Gonzalez, R. E. Woods, & S. L. Eddins
%   Digital Image Processing Using MATLAB, Prentice-Hall, 2004
%   $Revision: 1.4 $  $Date: 2003/10/26 22:35:37 $

f = double(f);
% If S is a scalar, obtain the seed image.
if numel(S) == 1
   SI = f == S;
   S1 = S;
else
   % S is an array. Eliminate duplicate, connected seed locations 
   % to reduce the number of loop executions in the following 
   % sections of code.
   SI = bwmorph(S, 'shrink', Inf);  
   %J = find(SI);
   %S1 = f(J); % Array of seed values.
   S1 = f(SI);
end

TI = false(size(f));	
for K = 1:length(S1)
   seedvalue = S1(K);
   S = abs(f - seedvalue) <= T;	
   TI = TI | S;
end

% Use function imreconstruct with SI as the marker image to
% obtain the regions corresponding to each seed in S. Function
% bwlabel assigns a different integer to each connected region.	
[g, NR] = bwlabel(imreconstruct(SI, TI));
end


% --- applies to view
function applyToView( handles, applyMethod )

% image or view change
if applyMethod == 0
    
    showMaskMethod( handles );
    return;
end

img         = getappdata(handles.regionGrow, 'currImg' );
seedMask    = getappdata(handles.regionGrow, 'currSeedMask' );
% if the user didn't submit on the inputfield, the value still might be
% incorrect
thresh      = str2double( get( handles.thresh, 'string' ));
thresh      = round( thresh );
if thresh < 0
    thresh = 0;
end

[g, ~, ~, ~] = regiongrow(img, seedMask, thresh );

% too reduce all values to 1 and 0
g = im2bw(g); 
setappdata(handles.regionGrow, 'currImgMask', g );
% not used "chooseMaskMethod" so this must be currImgMaskMethod (otherwise it would not showing it till chooseMaskMethod is used)
setappdata(handles.regionGrow, 'currImgMaskMethod', g );

green = cat(3, zeros(size(g)), g, zeros(size(g)));
imshowKeepZoom( green );

hold on;
alpha = 0.7;
alpha_matrix = alpha*ones(size(g,1),size(g,2));
h = imshowKeepZoom( img );
set(h,'AlphaData',alpha_matrix);
hold off;

showMaskMethod( handles );
end


% --- Executes on button press in applyToView.
function applyToView_Callback(hObject, eventdata, handles)
% hObject    handle to applyToView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

applyToView( handles, 1 );
end


% --- Executes on selection change in chooseView.
function chooseView_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns chooseView contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseView

currVal     = get(hObject,'Value');

% set currentImgMask
if currVal == 1      % transversal
    currImg         = getDataMainGui( 'currTraImg' );
    setappdata(handles.regionGrow, 'currView', 'tra');
    
elseif currVal == 2  % sagittal
    currImg         = getDataMainGui( 'currSagImg' );
    setappdata(handles.regionGrow, 'currView', 'sag');
    
else                 % coronal
    currImg             = getDataMainGui( 'currCorImg' );
    setappdata(handles.regionGrow, 'currView', 'cor');
    
end

set(handles.testView, 'xlim', [ 0.5  size(currImg,2)+0.5 ]);
set(handles.testView, 'ylim', [ 0.5  size(currImg,1)+0.5 ]);
setappdata(handles.regionGrow, 'currImgMask', 0 );
setappdata(handles.regionGrow, 'currImg', currImg);
applyToView( handles, 0 );
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


function updateTestView(view, currImg)
handles     = getDataMainGui( 'hregionGrow' );
currView    = getappdata(handles.regionGrow, 'currView');

if strcmp(currView,'tra') && strcmp(view,'tra')         % transversal
    setappdata(handles.regionGrow, 'currTraImg', currImg );
    setappdata(handles.regionGrow, 'currImg', currImg );
elseif strcmp(currView,'sag') && strcmp(view,'sag')     % sagittal
    setappdata(handles.regionGrow, 'currSagImg', currImg );
    setappdata(handles.regionGrow, 'currImg', currImg );
elseif strcmp(currView,'cor') && strcmp(view,'cor')     % coronal
    setappdata(handles.regionGrow, 'currCorImg', currImg );
    setappdata(handles.regionGrow, 'currImg', currImg );
end

if strcmp(currView,view)
    applyToView( handles, 0 );
end
end


% --- Executes on selection change in chooseSeedMethod.
function chooseSeedMethod_Callback(hObject, eventdata, handles)
% hObject    handle to chooseSeedMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chooseSeedMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseSeedMethod

isInUse = getappdata(handles.regionGrow, 'getpts');
if isInUse == 1
    warndlg( 'You can only use one method at a time, end(see tooltip) the current one, then choose a new method.', 'Attention' );
    return;
end
setappdata(handles.regionGrow, 'getpts', 1);

currMethod = get(hObject,'Value');

if currMethod == 1      % New Seeds
    % redraw image and reset seedMask
    img         = getappdata( handles.regionGrow, 'currImg' );
	seedMask    = false(size( img ));
    imshowKeepZoom( img );
    setappdata( handles.regionGrow, 'currSeedMask', seedMask );
    
    [X, Y] = chooseSeeds( handles );
    seedMask = addSeedsToMask( handles, X, Y );
    drawSeeds( handles, seedMask );
    
elseif currMethod == 2  % Add to current seeds
    img  = getappdata( handles.regionGrow, 'currImg' );
    seedMask = getappdata( handles.regionGrow, 'currSeedMask' );
    imshowKeepZoom( img );
    drawSeeds( handles, seedMask );
    
    [X, Y] = chooseSeeds( handles );
    seedMask = addSeedsToMask( handles, X, Y );
    drawSeeds( handles, seedMask );


elseif currMethod == 3  % Delete from current seeds
    img  = getappdata( handles.regionGrow, 'currImg' );
    seedMask = getappdata( handles.regionGrow, 'currSeedMask' );
    imshowKeepZoom( img );
    drawSeeds( handles, seedMask );
    
    [X, Y] = chooseSeeds( handles );
    seedMask = deleteSeedsFromMask( handles, X, Y );
    drawSeeds( handles, seedMask );
    
end

setappdata(handles.regionGrow, 'getpts', 0);
end


% --- Executes during object creation, after setting all properties.
function chooseSeedMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooseSeedMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function thresh_Callback(hObject, eventdata, handles)
% hObject    handle to thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh as text
%        str2double(get(hObject,'String')) returns contents of thresh as a double

thresh = str2double( get( hObject, 'string' ));
thresh = round( thresh );

if thresh < 0
    thresh = 0;
end

set( hObject, 'string', thresh );   

% invoke regiongrow
applyToView( handles, 1 );
end


% --- Executes during object creation, after setting all properties.
function thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in createMask.
function createMask_Callback(hObject, eventdata, handles)
% hObject    handle to createMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fhMenuMaskCreate = getDataMainGui( 'fhMenuMaskCreate' );
hMain            = getDataMainGui( 'handles' );
feval( fhMenuMaskCreate, hMain);
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
setappdata(handles.regionGrow, 'currMask', currMask );

showMaskMethod( handles );
end


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
end


% --- retuns the current default mask
function currDefaultMask = getCurrDefaultMask( handles ) 
hMain           = getDataMainGui( 'handles' );
currMask        = getappdata(handles.regionGrow, 'currMask' );

% get mask according to current View
currVal         = get(handles.chooseView,'Value'); 
if currVal == 1      % transversal
    currIndex           = get( hMain.sliderTra, 'Value' );
	currDefaultMask     = currMask(:,:,currIndex);
    
elseif currVal == 2  % sagittal
    currIndex           = get( hMain.sliderSag, 'Value' );
    currDefaultMask     = currMask(:,currIndex,:);
    % reshape
    currDefaultMaskSize = size(currDefaultMask);
    currDefaultMask     = reshape( currDefaultMask, [ currDefaultMaskSize(1), currDefaultMaskSize(3) ]);
    manipulate          = maketform( 'affine',[ 0 getDataMainGui( 'flip' )*getDataMainGui( 'scale' ); 1 0; 0 0 ] );        
    nearestNeighbour    = makeresampler( 'cubic','fill' );
    currDefaultMask     = imtransform( currDefaultMask,manipulate,nearestNeighbour );
    
else                 % coronal
    currIndex           = get( hMain.sliderCor, 'Max' )+1 - get( hMain.sliderCor, 'Value' );
    currDefaultMask     = currMask(currIndex,:,:);
    % reshape
    currDefaultMaskSize = size(currDefaultMask);
    currDefaultMask     = reshape( currDefaultMask, [ currDefaultMaskSize(2), currDefaultMaskSize(3) ]);
    manipulate          = maketform( 'affine',[ 0 getDataMainGui( 'flip' )*getDataMainGui( 'scale' ); 1 0; 0 0 ] );     
    nearestNeighbour    = makeresampler( 'cubic','fill' );
    currDefaultMask     = imtransform( currDefaultMask,manipulate,nearestNeighbour );
    
end
end


% --- show the current mask method
function showMaskMethod( handles )
% set axes otherwise it cant draw the transparent image over the mask (Situation:
% main figure and regiongrow figure open, sliderTra used to update next image. 
% See h = imshowKeepZoom, the h returned would be from the main axis and it
% couldn't draw the mask since the mask is in this (regionGrow) figure - set(h,'AlphaData',alpha_matrix);)
axes(handles.testView);

dDMasks = getDataMainGui( 'dropDownMasks' );
sizeM = size(dDMasks);
if sizeM(1) == 0
    % update on "new image" (slider up/down or +/-) if no mask exist
    img         = getappdata(handles.regionGrow, 'currImg' );
    imshowKeepZoom(img);
    return;
end

currMethod      = get(handles.chooseMaskMethod,'Value');
img             = getappdata(handles.regionGrow, 'currImg' );
currImgMask     = getappdata(handles.regionGrow, 'currImgMask' );
% if regiongrow hasn't been used yet create empty mask
if currImgMask == 0
    currImgMask = zeros(size(img));
end

currDefaultMask = getCurrDefaultMask( handles );
isTrans         = getappdata(handles.regionGrow, 'isTransparent');
maxNumber       = getDataMainGui( 'maxNumber' );

% what method?
if currMethod == 1      % New/Renew Mask
    if isTrans
        colorMask           = cat(3, zeros(size(img)), currImgMask, currDefaultMask);
    else
        % cut out mask
        img(currImgMask         ==1) = 0;
        img(currDefaultMask     ==1) = 0;
        % set maskcolor to max
        green = img;
        blue  = img;
        green(currImgMask       ==1) = maxNumber;
        blue(currDefaultMask    ==1) = maxNumber;
        colorMask                    = cat(3, img, green, blue);
    end
    
    imshowKeepZoom( colorMask );

elseif currMethod == 2  % New/Renew Mask (show current mask only)
    if isTrans
        colorMask           = cat(3, zeros(size(img)), currImgMask, zeros(size(img)));
    else
        img(currImgMask         ==1) = 0;
        green = img;
        green(currImgMask       ==1) = maxNumber;
        colorMask                    = cat(3, img, green, img);
    end
    imshowKeepZoom( colorMask );
    
elseif currMethod == 3  % Add to current Mask
    currImgMask( currDefaultMask==1 ) = 0;
    if isTrans
        colorMask = cat(3, zeros(size(img)), currImgMask, currDefaultMask);
    else
        % cut out mask
        img(currImgMask         ==1) = 0;
        img(currDefaultMask     ==1) = 0;
        % set maskcolor to max
        green = img;
        blue  = img;
        green(currImgMask       ==1) = maxNumber;
        blue(currDefaultMask    ==1) = maxNumber;
        colorMask                    = cat(3, img, green, blue);
    end
    imshowKeepZoom( colorMask );
    currDefaultMask( currImgMask==1 ) = 1;
    currImgMask = currDefaultMask;
    
elseif currMethod == 4  % Delete from current Mask
    % mask is only the overlapping
    currImgMask( currDefaultMask==1 - currImgMask==1 == 0 ) = 1;
    currImgMask( currDefaultMask==1 - currImgMask==1 > 0 ) = 0;
    if isTrans
        colorMask = cat(3, zeros(size(img)), currImgMask, currDefaultMask);
    else
        % cut out mask
        img(currImgMask         ==1) = 0;
        img(currDefaultMask     ==1) = 0;
        % set maskcolor to max
        green = img;
        blue  = img;
        green(currImgMask       ==1) = maxNumber;
        blue(currDefaultMask    ==1) = maxNumber;
        colorMask                    = cat(3, img, green, blue);
    end
    imshowKeepZoom( colorMask );
    % delete the overlapping
    currDefaultMask( currImgMask==1 ) = 0;
    currImgMask = currDefaultMask;
end

setappdata(handles.regionGrow, 'currImgMaskMethod', currImgMask );

if isTrans      
    hold on;
    alpha = getappdata(handles.regionGrow, 'alpha' );
    alpha_matrix = alpha*ones(size(img,1),size(img,2));
    h = imshowKeepZoom( img );
    set(h,'AlphaData',alpha_matrix);
    hold off;
end
end


% --- Executes on selection change in chooseMaskMethod.
function chooseMaskMethod_Callback(hObject, eventdata, handles)
% hObject    handle to chooseMaskMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chooseMaskMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseMaskMethod

showMaskMethod( handles );
end


% --- Executes during object creation, after setting all properties.
function chooseMaskMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooseMaskMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in applyToMask.
function applyToMask_Callback(hObject, eventdata, handles)
% hObject    handle to applyToMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dDMasks         = getDataMainGui( 'dropDownMasks' );
sizeM           = size(dDMasks);
if sizeM(1) == 0
    warndlg( 'Couldn''t find a label to save. Create/Load label first.', 'Attention' );
    return;
end

currImgMask     = getappdata(handles.regionGrow, 'currImgMask' );
if currImgMask == 0
    warndlg( 'Couldn''t find a seeded label to save. First choose seeds then apply a thresh to create the seeded label.', 'Attention' );
    return;
end

currMaskMethod  = getappdata(handles.regionGrow, 'currImgMaskMethod' );
currMask        = getappdata(handles.regionGrow, 'currMask' );
hMain           = getDataMainGui( 'handles' );
img             = getappdata(handles.regionGrow, 'currImg' );

% save mask according to current View
currVal         = get(handles.chooseView,'Value');
if currVal == 1      % transversal
    currIndex               = get( hMain.sliderTra, 'Value' );
	currMask(:,:,currIndex) = currMaskMethod;
    
elseif currVal == 2  % sagittal
    currIndex      = get( hMain.sliderSag, 'Value' );
    sizeI          = size(currMaskMethod, 2); % 256
    sizeJ          = size(currMaskMethod, 1); % 170
        
    for i=1:1:sizeI
        for j=1:1:sizeJ
            currMask(i,currIndex,j) = currMaskMethod(sizeJ+1 - j, i);
        end
    end
    
else                 % coronal
    currIndex      = get( hMain.sliderCor, 'Max' )+1 - get( hMain.sliderCor, 'Value' );
    sizeI          = size(currMaskMethod, 2); % 256
    sizeJ          = size(currMaskMethod, 1); % 170
        
    for i=1:1:sizeI
        for j=1:1:sizeJ
            currMask(currIndex,i,j) = currMaskMethod(sizeJ+1 - j, i);
        end
    end
        
end

setappdata(handles.regionGrow, 'currMask', currMask );

% update labelChanged struct
currLabel    = get( handles.chooseMask, 'Value' );
labelChanged = getDataMainGui( 'labelChanged' );
labelChanged{ currLabel } = 1;
setDataMainGui( 'labelChanged', labelChanged );

% show the current img with the current default mask
currDefaultMask = getCurrDefaultMask( handles );
blue = cat(3, zeros(size(img)), zeros(size(img)), currDefaultMask);
imshowKeepZoom( blue );
hold on;
alpha = 0.6;
alpha_matrix = alpha*ones(size(img,1),size(img,2));
h = imshowKeepZoom( img );
set(h,'AlphaData',alpha_matrix);
hold off;

setappdata(handles.regionGrow, 'currImgMask', 0 );

% update the masks struct
masks    = getDataMainGui( 'masks' );
contents = cellstr(get(handles.chooseMask,'String'));
name     = contents{get(handles.chooseMask,'Value')};
masks.( name ) = currMask;
setDataMainGui( 'masks', masks );
end


% --- Executes when regionGrow is resized.
function regionGrow_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to regionGrow (see GCBO)
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


% --- Executes on button press in transToggle.
function transToggle_Callback(hObject, eventdata, handles)
% hObject    handle to transToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of transToggle

val = get(hObject,'Value');

if val
    set( handles.transInput, 'enable', 'on' );
else
    set( handles.transInput, 'enable', 'off' );
end

setappdata(handles.regionGrow, 'isTransparent', val );
showMaskMethod( handles );
end


function transInput_Callback(hObject, eventdata, handles)
% hObject    handle to transInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transInput as text
%        str2double(get(hObject,'String')) returns contents of transInput as a double

val = str2double(get(hObject,'String'));
setappdata(handles.regionGrow, 'alpha', val );
showMaskMethod( handles );
end


% --- Executes during object creation, after setting all properties.
function transInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
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


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over infoText.
function infoText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to infoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% no isInfo necessary since there is only one infoText

if strcmp(get( hObject, 'string' ), 'Click me to get more informations.' )
    set( hObject, 'string', 'Seeds(red) are the starting point for the "region grow"(green) algorithm whereas the threshold decides which pixels are added to the growing reagion. Blue shows the "old/current" label while the overlapped parts are colored teal.' ); 
else
    set( hObject, 'string', 'Click me to get more informations.' );
end
end


% --- Executes on scroll wheel click while the figure is in focus.
function regionGrow_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to regionGrow (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

if eventdata.VerticalScrollCount > 0
    fhUpDown = getDataMainGui( 'fhUpDown' );
    feval( fhUpDown, handles, false );
else
    fhUpDown = getDataMainGui( 'fhUpDown' );
    feval( fhUpDown, handles, true );
end
end
