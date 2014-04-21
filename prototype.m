function varargout = prototype(varargin)
% PROTOTYPE MATLAB code for prototype.fig
%      PROTOTYPE, by itself, creates a new PROTOTYPE or raises the existing
%      singleton*.
%
%      H = PROTOTYPE returns the handle to a new PROTOTYPE or the handle to
%      the existing singleton*.
%
%      PROTOTYPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROTOTYPE.M with the given input arguments.
%
%      PROTOTYPE('Property','Value',...) creates a new PROTOTYPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prototype_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prototype_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prototype

% Last Modified by GUIDE v2.5 20-Apr-2014 23:39:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prototype_OpeningFcn, ...
                   'gui_OutputFcn',  @prototype_OutputFcn, ...
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


% --- Executes just before prototype is made visible.
function prototype_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prototype (see VARARGIN)

% Choose default command line output for prototype
handles.output = hObject;

% own variables
handles.lastFolder = '';    % contains the last Folder path

% save a reference to the main gui
setappdata(0, 'hMainGui', hObject);

% mask can be loaded without loaded images
% XXX mask = label - since its technically a mask we use "mask" in the code
% but to the user the word "label" is most familiar 
setDataMainGui( 'masks', struct );
setDataMainGui( 'dropDownMasks' , {} );

% Update handles structure
guidata(hObject, handles);

% Start with clean state
clc; clear all; imtool close all;


% UIWAIT makes prototype wait for user response (see UIRESUME)
% uiwait(handles.prototype);


% --- Outputs from this function are returned to the command line.
function varargout = prototype_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close prototype.
function prototype_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to prototype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if any figure is live close it
if isempty(findobj('type','figure','name','enhanceContrast')) == 0
    henh = getDataMainGui( 'henhanceContrast' );
    delete(henh.output);

elseif isempty(findobj('type','figure','name','segmentation')) == 0
    hseg = getDataMainGui( 'hsegmentation' );
    delete(hseg.output);
    
elseif isempty(findobj('type','figure','name','regionGrow')) == 0
    hreg = getDataMainGui( 'hregionGrow' );
    delete(hreg.output);
elseif isempty(findobj('type','figure','name','manualSegmentation')) == 0
    hreg = getDataMainGui( 'hmanualSegmentation' );
    delete(hreg.output);
end

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


% --- showData globallike (for debugging)
function showDatahMainGui()
hMain = getappdata(0, 'hMainGui');
data  = getappdata(hMain);
disp(data);


% --- update the tra slide info
function updateTraSlide( handles )
val         = num2str( get( handles.sliderTra, 'Value' ));
max         = num2str( get( handles.sliderTra, 'Max' ));
sTraSlide   = strcat( 3, val, '/', max );
set( handles.traSlide, 'string', sTraSlide );


% --- update the sag slide info
function updateSagSlide( handles )
val         = num2str( get( handles.sliderSag, 'Value' ));
max         = num2str( get( handles.sliderSag, 'Max' ));
sSagSlide   = strcat( 3, val, '/', max );
set( handles.sagSlide, 'string', sSagSlide );


% --- update the cor slide info
function updateCorSlide( handles )
val         = num2str( get( handles.sliderCor, 'Value' ));
max         = num2str( get( handles.sliderCor, 'Max' ));
sCorSlide   = strcat( 3, val, '/', max );
set( handles.corSlide, 'string', sCorSlide );


function updateTraLines( handles )

axes( handles.transversal );
handleTraImg = imshow( getDataMainGui( 'currTraImg' ) );

if getDataMainGui( 'showLines' )
    lineWidth       = getDataMainGui( 'lineWidth' );
    startPointXSag  = get( handles.sliderSag, 'Value' );
    endPointYSag    = size( getDataMainGui( 'currTraImg' ), 1 );
    endpointXCor    = size( getDataMainGui( 'currTraImg' ), 1 );
    startpointYCor  = get( handles.sliderCor, 'Max' )+1 - get( handles.sliderCor, 'Value' );
    
    % draw the sagittal and coronal line
    hold on;
    
    % draw sag line
    line([startPointXSag, startPointXSag], [0, endPointYSag], 'Color', 'g', 'LineWidth', lineWidth, 'HitTest', 'off');
    
    % draw cor line
    line([0, endpointXCor], [startpointYCor, startpointYCor], 'Color', 'b', 'LineWidth', lineWidth, 'HitTest', 'off');
    hold off;
    % END draw 
    
    % only if the lines are shown enable the 'jump-to-clickPosition'
    set( handleTraImg, 'ButtonDownFcn', { @transversal_ButtonDownFcn, handles } ); 
end



% --- updates the transversal image for its given newVal and redraws the sagittal and coronal line
function updateTraImg( newVal, handles )

% current or new image?
if newVal == -1
    image = getDataMainGui( 'currTraImg' );
else           
    Images = getDataMainGui( 'Images' );
    image  = Images( :, :, newVal );
end

% update data
if newVal ~= -1
    setDataMainGui( 'currTraImg', image );
    
    % set new static text
    files = getDataMainGui( 'files' );
    set( handles.currImage, 'String', files( newVal ).name );
    
    % update testView in current figure if figure is live
    if isempty(findobj('type','figure','name','segmentation')) == 0 ... % == 0 means "no its not empty"
            || isempty(findobj('type','figure','name','enhanceContrast')) == 0 ...
                || isempty(findobj('type','figure','name','regionGrow')) == 0 ...
                || isempty(findobj('type','figure','name','manualSegmentation')) == 0
        fhUpdateTestView = getDataMainGui( 'fhUpdateTestView' );
        feval( fhUpdateTestView, 'tra', image );
    end
end

updateTraLines( handles );
updateTraSlide( handles );


% --- Executes on slider movement.
function sliderTra_Callback(hObject, eventdata, handles)

% if slider was dragged set to nearest step 
newVal = round( get( hObject,'Value' ));            % since step = 1 we round to the next integer
set( handles.sliderTra, 'Value', newVal ); 

% draw new image
updateTraImg( newVal, handles );
updateSagImg( -1, handles );
updateCorImg( -1, handles );


function updateSagLines( handles )

axes( handles.sagittal );
handleSagImg = imshow( getDataMainGui( 'currSagImg' ) );

if getDataMainGui( 'showLines' )
    lineWidth       = getDataMainGui( 'lineWidth' );
    endPointXTra    = size( getDataMainGui( 'currSagImg' ), 2 );
    startPointYTra  = getDataMainGui( 'sagRows' )+1 - getDataMainGui( 'ratioTransSag' ) * get( handles.sliderTra, 'Value' );
    startPointXCor  = get( handles.sliderCor, 'Max' )+1 - get( handles.sliderCor, 'Value' ); 
    endPointYCor    = size( getDataMainGui( 'currSagImg' ), 1 );
    
    % draw the transversal and coronal line
    hold on;
    % draw tra line
    line([0, endPointXTra], [startPointYTra, startPointYTra], 'Color', 'r', 'LineWidth', lineWidth, 'HitTest', 'off');
    
    % draw cor line
    line([startPointXCor, startPointXCor], [0, endPointYCor], 'Color', 'b', 'LineWidth', lineWidth, 'HitTest', 'off');
    hold off;
    % END draw
    
    set( handleSagImg, 'ButtonDownFcn', { @sagittal_ButtonDownFcn, handles } );
end



% --- updates the sagittal image for its given newVal and redraws the transversal and coronal line
function updateSagImg( newVal, handles )

% calcualte the new image and draw it
% current or new image?
if newVal == -1
    image = getDataMainGui( 'currSagImg' );
else
    image = getSagImg( newVal );
end


% update data
if newVal ~= -1
    setDataMainGui( 'currSagImg', image );
    
    % update testView in current figure if figure is live
    if isempty(findobj('type','figure','name','segmentation')) == 0 ... % == 0 means "no its not empty"
            || isempty(findobj('type','figure','name','enhanceContrast')) == 0 ...
                || isempty(findobj('type','figure','name','regionGrow')) == 0 ...
                || isempty(findobj('type','figure','name','manualSegmentation')) == 0
        fhUpdateTestView = getDataMainGui( 'fhUpdateTestView' );
        feval( fhUpdateTestView, 'sag', image );
    end
end
% END update

updateSagLines( handles );
updateSagSlide( handles );


% --- Executes on slider movement.
function sliderSag_Callback(hObject, eventdata, handles)

newVal = round( get( hObject,'Value' ));          % since step = 1 we round to the next integer
set( handles.sliderSag, 'Value', newVal );

% draw new image
updateSagImg( newVal, handles );
updateTraImg( -1, handles );
updateCorImg( -1, handles );


function updateCorLines( handles )
axes( handles.coronal );
handleCorImg = imshow( getDataMainGui( 'currCorImg' ) );

if getDataMainGui( 'showLines' )
    lineWidth       = getDataMainGui( 'lineWidth' );
    endPointXTra    = size( getDataMainGui( 'currSagImg' ), 2 );
    startPointYTra  = getDataMainGui( 'sagRows' )+1 - getDataMainGui( 'ratioTransSag' ) * get( handles.sliderTra, 'Value' );
    startPointXSag  = get( handles.sliderSag, 'Value' );
    endPointYSag    = size( getDataMainGui( 'currCorImg' ), 1 );
    
    % draw the transversal and sagittal line
    hold on;
    % draw tra line
    line([0, endPointXTra], [startPointYTra, startPointYTra], 'Color', 'r', 'LineWidth', lineWidth, 'HitTest', 'off');
    
    % draw sag line
    line([startPointXSag, startPointXSag], [0, endPointYSag], 'Color', 'g', 'LineWidth', lineWidth, 'HitTest', 'off');
    hold off;
    % END draw
    
    set( handleCorImg, 'ButtonDownFcn', { @coronal_ButtonDownFcn, handles } );
end



% --- updates the coronal image for its given newVal and redraws the transversal and sagittal line
function updateCorImg( newVal, handles )

% calcualte the new image and draw it
% current or new image?
if newVal == -1
    image = getDataMainGui( 'currCorImg' );
else
    image = getCorImg( get( handles.sliderCor,'Max' ) + 1 - newVal );
end

% update data
if newVal ~= -1
    setDataMainGui( 'currCorImg', image );
    
    % update testView in current figure if figure is live
    if isempty(findobj('type','figure','name','segmentation')) == 0 ... % == 0 means "no its not empty"
            || isempty(findobj('type','figure','name','enhanceContrast')) == 0 ...
                || isempty(findobj('type','figure','name','regionGrow')) == 0 ...
                || isempty(findobj('type','figure','name','manualSegmentation')) == 0
        fhUpdateTestView = getDataMainGui( 'fhUpdateTestView' );
        feval( fhUpdateTestView, 'cor', image );
    end
end
% END update

updateCorLines( handles );
updateCorSlide( handles );


% --- Executes on slider movement.
function sliderCor_Callback(hObject, eventdata, handles)

newVal = round( get( hObject,'Value' ));          % since step = 1 we round to the next integer
set( handles.sliderCor, 'Value', newVal );

% draw new image
updateCorImg( newVal, handles );
updateTraImg( -1, handles );
updateSagImg( -1, handles );


% --- Executes during object creation, after setting all properties.
function sliderTra_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sliderSag_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function sliderCor_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function MenuFolder_Callback(hObject, eventdata, handles)


% --- Executes when prototype is resized.
function prototype_ResizeFcn(hObject, eventdata, handles)


function sagImgNew = getSagImg( value )
Images              = getDataMainGui( 'Images' ); 
sagImg              = Images(:,value,:);                           % vertical slider sliderTop = rightEnd sliderBottom = leftEnd
sagImgSize          = size( sagImg ); 
amountImages        = 1;
% check if only one images is in Images
if numel(sagImgSize) > 2
    amountImages = sagImgSize(3);
end 
sagImgReshape       = reshape( sagImg, [ sagImgSize(1), amountImages ]);   % original Img without manipulation
manipulate          = maketform( 'affine',[ 0 getDataMainGui( 'flip' )*getDataMainGui( 'scale' ); 1 0; 0 0 ] );        
nearestNeighbour    = makeresampler( 'cubic','fill' );     
sagImgNew           = imtransform( sagImgReshape,manipulate,nearestNeighbour );


function corImgNew = getCorImg( value )
Images              = getDataMainGui( 'Images' ); 
corImg              = Images(value,:,:);
corImgSize          = size( corImg ); 
amountImages        = 1;
% check if only one images is in Images
if numel(corImgSize) > 2
    amountImages = corImgSize(3);
end 
corImgReshape       = reshape( corImg, [ corImgSize(2), amountImages ]);       % original Img without manipulation
manipulate          = maketform( 'affine',[ 0 getDataMainGui( 'flip' )*getDataMainGui( 'scale' ); 1 0; 0 0 ] );        
nearestNeighbour    = makeresampler( 'cubic','fill' );     
corImgNew           = imtransform( corImgReshape,manipulate,nearestNeighbour );


% --------------------------------------------------------------------
function menuFolderLoad_Callback(hObject, eventdata, handles)

currentFolder = uigetdir( pwd );                            % get the current Folder

if currentFolder == 0                                       % dialogCancel?
    return;
end

files     = dir( fullfile( currentFolder, '*.dcm' ));       % build struct of all dcm-Images in this folder   


% update the static text
set( handles.currFolder, 'String', currentFolder );   


if isempty( files )                                         % contains any images?
    set( handles.currImage, 'String', 'Folder didn''t cointain any .dcm images.' );
    return;
end


% gather some Image information
I         = dicomread( fullfile( currentFolder, files(1).name ));   % read in first image
classI    = class( I );
sizeI     = size( I );
numImages = length( files );
Images    = zeros( sizeI( 1 ), sizeI( 2 ), numImages, classI );


% read all images if folderpath changed
if strcmp( currentFolder, handles.lastFolder ) == false
    h = waitbar(0,'Reading images...');
    for i = 1:1:numImages
        fname         = fullfile( currentFolder, files(i).name );
        Images(:,:,i) = dicomread( fname );
        waitbar(i / numImages);
    end
    close( h );
else
    return;
end

Isize           = size(Images);
amountRows      = Isize(1);
amountColumns   = Isize(2);
firstImg        = round( numImages/2 ); 
halfC           = amountColumns / 2;            % start in the middle otherwise sagittal and coronal would properbly show nothing
halfR           = amountRows / 2;

% enhance the contrast of all images?
label           = get( hObject, 'Label' );
if strcmp( label, 'Load')
    enhanceImg  = Images(:,:,firstImg);
    u           = double(min(enhanceImg(:))) / double(65535);
    o           = double(max(enhanceImg(:))) / double(65535);
    for i = 1:1:numImages
        enhanceImg = Images(:,:,i); 
        enhanceImg = imadjust( enhanceImg, [ u o ], [ 0 1 ] );
        Images(:,:,i) = enhanceImg;
    end
end

% set sliders
sliderStep = 1 / numImages;

set( handles.currImage, 'String'    , files(firstImg).name );
set( handles.sliderTra, 'Min'       , 1 );
set( handles.sliderTra, 'Max'       , numImages );      % 0 to numImages-1 equals amount of images
set( handles.sliderTra, 'SliderStep', [ sliderStep sliderStep ] );
set( handles.sliderTra, 'Value'     , firstImg );
sliderStep = 1 / amountColumns;                         % update sliderStep
set( handles.sliderSag, 'Min'       , 1 );
set( handles.sliderSag, 'Max'       , amountColumns );
set( handles.sliderSag, 'SliderStep', [ sliderStep sliderStep ] );
set( handles.sliderSag, 'Value'     , halfC );
set( handles.sliderCor, 'Min'       , 1 );
set( handles.sliderCor, 'Max'       , amountRows );     % use amountColumns for the rows because the images are square
set( handles.sliderCor, 'SliderStep', [ sliderStep sliderStep ] );
set( handles.sliderCor, 'Value'     , halfR );          % same for half


% display the first image
flip            = -1;               % flip upside down
scale           = 1;                % scale factor
%%%               % starting from the bottom
lineWidth       = 1;
% transversal
traImg          = Images(:,:,firstImg);
axes(handles.transversal);
imshow( traImg );    


traSize         = size( traImg );
traRows         = traSize(1);
traColumns      = traSize(2);


setDataMainGui( 'lastFolder'    , currentFolder  );
setDataMainGui( 'defaultImages' , Images         );
setDataMainGui( 'Images'        , Images         );

setDataMainGui( 'Isize'         , Isize          );
setDataMainGui( 'files'         , files          );
setDataMainGui( 'flip'          , flip           );
setDataMainGui( 'scale'         , scale          );
setDataMainGui( 'lineWidth'     , lineWidth      );

setDataMainGui( 'traSize'       , traSize        );
setDataMainGui( 'traRows'       , traRows        );
setDataMainGui( 'traColumns'    , traColumns     );
setDataMainGui( 'currTraImg'    , traImg         );

% sagittal
sagImgNew       = getSagImg( halfC );
axes(handles.sagittal);
imshow( sagImgNew ); 
sagSize         = size( sagImgNew );
sagRows         = sagSize(1);
sagColumns      = sagSize(2);
setDataMainGui( 'sagSize'       , sagSize        );
setDataMainGui( 'sagRows'       , sagRows        );
setDataMainGui( 'sagColumns'    , sagColumns     );
setDataMainGui( 'currSagImg'    , sagImgNew      );

% coronal
corImgNew = getCorImg( halfR );
axes( handles.coronal );
imshow( corImgNew );
corSize         = size( corImgNew );
corRows         = corSize(1);
corColumns      = corSize(2);
setDataMainGui( 'corSize'       , corSize        );
setDataMainGui( 'corRows'       , corRows        );
setDataMainGui( 'corColumns'    , corColumns     );
setDataMainGui( 'currCorImg'    , corImgNew      );

ratioTransSag   = sagRows / numImages;
ratioTransCor   = corRows / numImages; 
ratioSagCor     = corColumns / sagColumns;
ratioCorSag     = sagColumns / corColumns;
setDataMainGui( 'ratioTransSag' , ratioTransSag  );
setDataMainGui( 'ratioTransCor' , ratioTransCor  );
setDataMainGui( 'ratioSagCor'   , ratioSagCor    );
setDataMainGui( 'ratioCorSag'   , ratioCorSag    );

setDataMainGui( 'fhUpdateTraImg', @updateTraImg  );
setDataMainGui( 'fhUpdateSagImg', @updateSagImg  );
setDataMainGui( 'fhUpdateCorImg', @updateCorImg  );
setDataMainGui( 'fhGetSagImg'   , @getSagImg     );
setDataMainGui( 'fhGetCorImg'   , @getCorImg     );
setDataMainGui( 'fhUpDown'      , @upDown        );
setDataMainGui( 'handles'       , handles  );

% update lines
setDataMainGui( 'showLines'    , get( handles.checkboxShowLines, 'Value' ) );  % is equal to false
updateTraLines( handles );
updateSagLines( handles );
updateCorLines( handles );

set( handles.uipanelAdjust  , 'Visible', 'on' );
set( handles.traSlide       , 'Visible', 'on' );
set( handles.sagSlide       , 'Visible', 'on' );
set( handles.corSlide       , 'Visible', 'on' );

updateTraSlide( handles );
updateSagSlide( handles );
updateCorSlide( handles );


% --------------------------------------------------------------------
function menuFolderSave_Callback(hObject, eventdata, handles)
% hObject    handle to menuFolderSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lastFolder = getDataMainGui( 'lastFolder' );

% no images loaded yet
if isempty(lastFolder)
    warndlg( 'No images available.', 'Attention' );
    return;
end

dirName = uigetdir();

% dialogCancel
if dirName == 0      
  return;
end

% save to disk
files       = getDataMainGui( 'files' );
numImages   = length( files );
images      = getDataMainGui( 'Images' );
lastFolder  = getDataMainGui( 'lastFolder' );

for i = numImages:-1:1
        fname         = fullfile( dirName, files(i).name );
        lastFName     = fullfile( lastFolder, files(i).name );
        metadata      = dicominfo( lastFName );
        dicomwrite( images(:,:,i), fname, metadata );   
end


% --- Checks and correct the val argument to fit the Min and Max argument
function newVal = trimToBorder( val, Min, Max )
if val < Min
    newVal = Min;
elseif val > Max
    newVal = Max;
else
    newVal = val;
end


% --- Executes on mouse press over axes background.
function transversal_ButtonDownFcn(hObject, eventdata, handles)

axesHandle  = get(hObject,'Parent');
coordinates = get(axesHandle,'CurrentPoint');
coordinates = coordinates(1,1:2);
newSagVal = trimToBorder( round( coordinates(1) ), get( handles.sliderSag, 'Min' ), get( handles.sliderSag, 'Max' ));
newCorVal = trimToBorder( round( coordinates(2) ), get( handles.sliderCor, 'Min' ), get( handles.sliderCor, 'Max' ));

set( handles.sliderSag, 'Value', newSagVal );
set( handles.sliderCor, 'Value', get( handles.sliderCor, 'Max' )+1 - newCorVal );
% -1 means nothing changed
updateTraImg( -1, handles );
updateSagImg( newSagVal, handles );
updateCorImg( get( handles.sliderCor, 'Max' )+1 - newCorVal, handles );


% --- Executes on mouse press over axes background.
function sagittal_ButtonDownFcn(hObject, eventdata, handles)

axesHandle  = get(hObject,'Parent');
coordinates = get(axesHandle,'CurrentPoint'); 
coordinates = coordinates(1,1:2);
newTraVal = trimToBorder( round( coordinates(2) ), get( handles.sliderTra, 'Min' ), get( handles.sliderTra, 'Max' ));
newCorVal = trimToBorder( round( coordinates(1) ), get( handles.sliderCor, 'Min' ), get( handles.sliderCor, 'Max' ));

set( handles.sliderTra, 'Value', get( handles.sliderTra, 'Max' )+1 - newTraVal );
set( handles.sliderCor, 'Value', get( handles.sliderCor, 'Max' )+1 - newCorVal );
% -1 means nothing changed
updateSagImg( -1, handles );
updateTraImg( get( handles.sliderTra, 'Max' )+1 - newTraVal, handles );
updateCorImg( get( handles.sliderCor, 'Max' )+1 - newCorVal, handles );


% --- Executes on mouse press over axes background.
function coronal_ButtonDownFcn(hObject, eventdata, handles)

axesHandle  = get(hObject,'Parent');
coordinates = get(axesHandle,'CurrentPoint'); 
coordinates = coordinates(1,1:2);
newTraVal = trimToBorder( round( coordinates(2) ), get( handles.sliderTra, 'Min' ), get( handles.sliderTra, 'Max' ));
newSagVal = trimToBorder( round( coordinates(1) ), get( handles.sliderSag, 'Min' ), get( handles.sliderSag, 'Max' ));

set( handles.sliderTra, 'Value', get( handles.sliderTra, 'Max' )+1 - newTraVal );
set( handles.sliderSag, 'Value', newSagVal );
% -1 means nothing changed
updateCorImg( -1, handles );
updateTraImg( get( handles.sliderTra, 'Max' )+1 - newTraVal, handles );
updateSagImg( newSagVal, handles );


% --- Executes on button press in checkboxShowLines.
function checkboxShowLines_Callback(hObject, eventdata, handles)

setDataMainGui( 'showLines', get( hObject, 'Value' ) );
updateTraLines( handles );
updateSagLines( handles );
updateCorLines( handles );


% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)

if isempty(findobj('type','figure','name','enhanceContrast')) == 0 ... % == 0 means "no its not empty"
        || isempty(findobj('type','figure','name','regionGrow')) == 0 ...
        || isempty(findobj('type','figure','name','manualSegmentation')) == 0 
    warndlg( 'Only one imagemanipulation at a time. Please close your extern window first.', 'Attention' );
    return;
end

segmentation;


% --- Executes on button press in enhanceContrast.
function enhanceContrast_Callback(hObject, eventdata, handles)

if isempty(findobj('type','figure','name','segmentation')) == 0 ...
        || isempty(findobj('type','figure','name','regionGrow')) == 0 ...
        || isempty(findobj('type','figure','name','manualSegmentation')) == 0 
    warndlg( 'Only one imagemanipulation at a time. Please close your extern window first.', 'Attention' );
    return;
end

enhanceContrast;


% --- Executes on button press in regionGrow.
function regionGrow_Callback(hObject, eventdata, handles)
if isempty(findobj('type','figure','name','enhanceContrast')) == 0 ...
        || isempty(findobj('type','figure','name','segmentation')) == 0 ...
        || isempty(findobj('type','figure','name','manualSegmentation')) == 0 
    warndlg( 'Only one imagemanipulation at a time. Please close your extern window first.', 'Attention' );
    return;
end

regionGrow;


% --- Executes on button press in manualSegmentation.
function manualSegmentation_Callback(hObject, eventdata, handles)
if isempty(findobj('type','figure','name','enhanceContrast')) == 0 ...
        || isempty(findobj('type','figure','name','segmentation')) == 0 ...
        || isempty(findobj('type','figure','name','regionGrow')) == 0 
    warndlg( 'Only one imagemanipulation at a time. Please close your extern window first.', 'Attention' );
    return;
end

manualSegmentation;

% --- Executes during object creation, after setting all properties.
function transversal_CreateFcn(hObject, eventdata, handles)
%show no ticks
set(gca,'xtick',[]); 
set(gca,'ytick',[]);


% --- Executes during object creation, after setting all properties.
function sagittal_CreateFcn(hObject, eventdata, handles)
set(gca,'xtick',[]); 
set(gca,'ytick',[]);


% --- Executes during object creation, after setting all properties.
function coronal_CreateFcn(hObject, eventdata, handles)
set(gca,'xtick',[]); 
set(gca,'ytick',[]);


% --- Executes on button press in deleteImage.
function deleteImage_Callback(hObject, eventdata, handles)
% hObject    handle to deleteImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

images   = getDataMainGui( 'Images' ); % array
files    = getDataMainGui( 'files' );  % struct
sldTra   = get( handles.sliderTra, 'Value' );
sldSag   = get( handles.sliderSag, 'Value' );
sldCor   = get( handles.sliderCor, 'Value' );

% check if at least 2 images are available
sizeImages = size( images );
if numel(sizeImages) == 2
    set( handles.sliderTra, 'Max', 1 );
    warndlg( 'Only one image left - can''t delete.', 'Deletionwarning' );
    
    return;
end

% delete image
images(:,:,sldTra) = [];

% delete file
files(sldTra) = [];

setDataMainGui( 'files', files );
setDataMainGui( 'Images', images );

% update Slider
sizeImages = size( images );
if numel(sizeImages) == 2
    numImages = 1;
else
    sizeImages  = size( images );
    numImages   = sizeImages(3);
end

sliderStep  = 1 / numImages;

% current sliderValue greater number of images (has been reduced)
if sldTra > numImages
    sldTra = numImages;
end

set( handles.sliderTra, 'Max', numImages );
set( handles.sliderTra, 'SliderStep', [ sliderStep sliderStep ] );
set( handles.sliderTra, 'Value', sldTra );
set( handles.sliderSag, 'Value', sldSag );
set( handles.sliderCor, 'Value', sldCor );

% update currImage text
set( handles.currImage, 'String', files(sldTra).name );

updateTraImg( sldTra, handles );
updateSagImg( sldSag, handles );
updateCorImg( sldCor, handles );


% --------------------------------------------------------------------
function menuMask_Callback(hObject, eventdata, handles)
% hObject    handle to menuMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuMaskCreate_Callback(hObject, eventdata, handles)
% hObject    handle to menuMaskCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if no images loaded
images  = getDataMainGui( 'Images' );
s       = size(images);
if s(1) == 0
    warndlg('Before you can create a label you need to import images.', 'Warning');
    return;
end

% make sure
w       = warndlg('Before you create a label, DELETE all unnesecarry images FIRST because the label is fixed at its size.', 'Warning');
waitfor(w);
name    = inputdlg('Name of new label:', 'Create label');

% if cancel
if size(name, 1) == 0
    return;
end

name    = name{1};

% if space
k = strfind(name, ' ');
if size(k, 1) >= 1 
    warndlg( 'No space character('' '') in the name of the label allowed.', 'Warning');
    return;
end

% if name already exists
masks         = getDataMainGui( 'masks' );
masksNames    = fieldnames(masks);
sizeNames     = size(masksNames, 1);

for i = 1:1:sizeNames
    if strcmp( masksNames{i}, name )
        warndlg( 'Label with this name already exists.', 'Attention' );
        return;
    end
end

dropDownMasks = getDataMainGui( 'dropDownMasks' );
sizeI   = size( images );
newMask = false( sizeI( 1 ), sizeI( 2 ), sizeI( 3 ) );

% add to struct
masks.( name ) = newMask;
dropDownMasks{ size(dropDownMasks,2) + 1 } = name;

setDataMainGui( 'masks', masks );
setDataMainGui( 'dropDownMasks', dropDownMasks );

% append the name into the regiongrow drowdown if regiongrow fig is alive 
if isempty(findobj('type','figure','name','regionGrow')) == 0
    hregionGrow = getDataMainGui( 'hregionGrow' ); 
    set( hregionGrow.chooseMask, 'string', dropDownMasks ); 
    
    % if first mask 
    if length(fieldnames(masks)) == 1
        setappdata( hregionGrow.regionGrow, 'currMask', newMask );
    end
    
% append the name into the manualSegmentation drowdown if manualSegmentation fig is alive 
elseif isempty(findobj('type','figure','name','manualSegmentation')) == 0
    hmanualSegmentation = getDataMainGui( 'hmanualSegmentation' ); 
    set( hmanualSegmentation.chooseMask, 'string', dropDownMasks ); 
    
    % if first mask 
    if length(fieldnames(masks)) == 1
        setappdata( hmanualSegmentation.manualSegmentation, 'currMask', newMask );
        
        fhUpdateCurrImgMask = getDataMainGui( 'fhUpdateCurrImgMask' );
        hmanualSegmentation = getDataMainGui( 'hmanualSegmentation' );
        axes( hmanualSegmentation.testView );
        feval( fhUpdateCurrImgMask, hmanualSegmentation, 1);
    end
end


% --------------------------------------------------------------------
function menuMaskLoad_Callback(hObject, eventdata, handles)
% hObject    handle to menuMaskLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFolder = uigetdir( pwd );                            % get the current Folder

if currentFolder == 0                                       % dialogCancel?
    return;
end

files         = dir( fullfile( currentFolder, '*.png' ));       % build struct of all png-Images/Masks in this folder   

% get maskName
maskName = files(1).name;
maskName = strsplit(maskName, '_');
maskName = maskName(1);
maskName = maskName{1};

% if name already exists
masks         = getDataMainGui( 'masks' );

if size(masks, 1) > 0
    masksNames    = fieldnames(masks);
    sizeNames     = size(masksNames, 1);

    for i = 1:1:sizeNames
        if strcmp( masksNames{i}, maskName )
            warndlg( 'Label with this name already exists.', 'Attention' );
            return;
        end
    end
end

% load images
numMask       = size(files, 1);
M             = imread( fullfile( currentFolder, files(1).name ));   % read in first mask
sizeM         = size( M );
newMask       = false( sizeM( 1 ), sizeM( 2 ), numMask );

h = waitbar(0,'Loading label...');
for i = 1:1:numMask
    fname          = fullfile( currentFolder, files(i).name );
    newMask(:,:,i) = imread( fname );
    waitbar(i / numMask);
end
close( h );

% add to struct
masks.( maskName )          = newMask;
dropDownMasks               = getDataMainGui( 'dropDownMasks' );
dropDownMasks{ size(dropDownMasks,2) + 1 } = maskName;

setDataMainGui( 'masks', masks );
setDataMainGui( 'dropDownMasks', dropDownMasks );

% append the name into the regiongrow drowdown if regiongrow fig is alive 
if isempty(findobj('type','figure','name','regionGrow')) == 0
    hregionGrow = getDataMainGui( 'hregionGrow' ); 
    set( hregionGrow.chooseMask, 'string', dropDownMasks );
    
    % if first mask 
    if length(fieldnames(masks)) == 1
        setappdata( hregionGrow.regionGrow, 'currMask', newMask );
    end
    
% append the name into the manualSegmentation drowdown if manualSegmentation fig is alive 
elseif isempty(findobj('type','figure','name','manualSegmentation')) == 0
    hmanualSegmentation = getDataMainGui( 'hmanualSegmentation' ); 
    set( hmanualSegmentation.chooseMask, 'string', dropDownMasks ); 
    
    % if first mask 
    if length(fieldnames(masks)) == 1
        setappdata( hmanualSegmentation.manualSegmentation, 'currMask', newMask );
        
        fhUpdateCurrImgMask = getDataMainGui( 'fhUpdateCurrImgMask' );
        hmanualSegmentation = getDataMainGui( 'hmanualSegmentation' );
        axes( hmanualSegmentation.testView );
        feval( fhUpdateCurrImgMask, hmanualSegmentation, 1);
    end
end


% --------------------------------------------------------------------
function menuMaskSave_Callback(hObject, eventdata, handles)
% hObject    handle to menuMaskSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

masks       = getDataMainGui( 'masks' );
masksNames  = fieldnames(masks);

% no images loaded yet
if size( masksNames, 1 ) == 0
    warndlg( 'No label available.', 'Attention' );
    return;
end

[s,v]       = listdlg('PromptString','Select label:',...
                'SelectionMode','single',...
                'ListString',masksNames);

% cancel?
if v == 0
    return;
end

maskName    = masksNames{s};
currMask    = masks.( maskName );
sizeMask    = size(currMask, 3);

dirName = uigetdir();

% dialogCancel
if dirName == 0      
  return;
end

% save images with leading zeros in the filename depending on the amount of
% images e.g. 120 images => 001.png, 017.png, 108.png
numOfDezimal        = floor( log10(sizeMask) ) + 1;
numOfDezimalFormat  = strcat( '%0', num2str(numOfDezimal), 'd' );

% save to disk
h = waitbar(0,'Saving label...');
for i = 1:1:sizeMask
        addOn = strcat( maskName, '_', num2str(i, numOfDezimalFormat), '.png' );
        fname = fullfile( dirName, addOn );
        imwrite( currMask(:,:,i), fname, 'png' ); 
        waitbar(i / sizeMask);
end
close( h );

msgbox( 'Label successfully stored.','Save success');


% --------------------------------------------------------------------
function menuMaskRename_Callback(hObject, eventdata, handles)
% hObject    handle to menuMaskRename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

masks       = getDataMainGui( 'masks' );
masksNames  = fieldnames(masks);

% no images loaded yet
if size( masksNames, 1 ) == 0
    warndlg( 'No label available.', 'Attention' );
    return;
end

dropDownMasks = getDataMainGui( 'dropDownMasks' );

[s,v]       = listdlg('PromptString','Select label:',...
                'SelectionMode','single',...
                'ListString',dropDownMasks);

% cancel?
if v == 0
    return;
end

currMaskName    = dropDownMasks{s};

newMaskName     = inputdlg('Name of new label:', 'Create label');
% if cancel
if size(newMaskName, 1) == 0
    return;
end

% check for duplicates
sizeNames     = size(masksNames, 1);
for i = 1:1:sizeNames
	if strcmp( masksNames{i}, newMaskName )
      	warndlg( 'Label with this name already exists.', 'Attention' );
       	return;
	end
end

newMaskName     = newMaskName{1};

% if space
k = strfind(newMaskName, ' ');
if size(k, 1) >= 1 
    warndlg( 'No space character('' '') in the name of the label allowed.', 'Warning');
    return;
end

% rename through adding the new mask with the old value and removing
% the old mask
[masks.(newMaskName)] = masks.(currMaskName);
masks = rmfield(masks,currMaskName);

% update dropDownMasks
sDDM            = size(dropDownMasks, 2);
% on the correct position
for i=1:1:sDDM
    if strcmp(dropDownMasks{i}, currMaskName)
        dropDownMasks{i} = newMaskName;
    end
end

setDataMainGui( 'masks', masks );
setDataMainGui( 'dropDownMasks', dropDownMasks );

% append the name into the regiongrow drowdown if regiongrow fig is alive 
if isempty(findobj('type','figure','name','regionGrow')) == 0
    hregionGrow = getDataMainGui( 'hregionGrow' ); 
    set( hregionGrow.chooseMask, 'string', dropDownMasks );
    
    % if first mask 
    if length(fieldnames(masks)) == 1
        setappdata( hregionGrow.regionGrow, 'currMask', newMask );
    end
    
% append the name into the manualSegmentation drowdown if manualSegmentation fig is alive 
elseif isempty(findobj('type','figure','name','manualSegmentation')) == 0
    hmanualSegmentation = getDataMainGui( 'hmanualSegmentation' ); 
    set( hmanualSegmentation.chooseMask, 'string', dropDownMasks ); 
    
    % if first mask 
    if length(fieldnames(masks)) == 1
        setappdata( hmanualSegmentation.manualSegmentation, 'currMask', newMask );
        
        fhUpdateCurrImgMask = getDataMainGui( 'fhUpdateCurrImgMask' );
        hmanualSegmentation = getDataMainGui( 'hmanualSegmentation' );
        axes( hmanualSegmentation.testView );
        feval( fhUpdateCurrImgMask, hmanualSegmentation, 1);
    end
end




% --- "upDown" function for the "+" or "-" button in external views
function upDown( externalWindowHandler, isUp )

handles         = externalWindowHandler;
handlesMain     = getDataMainGui( 'handles' );
currView        = get( handles.chooseView, 'Value' ); 

% get val and max according to view
if currView == 1
    val             = get( handlesMain.sliderTra, 'Value' );
    max             = get( handlesMain.sliderTra, 'Max' );
    min             = get( handlesMain.sliderTra, 'Min' );
elseif currView == 2
    val             = get( handlesMain.sliderSag, 'Value' );
    max             = get( handlesMain.sliderSag, 'Max' );
    min             = get( handlesMain.sliderSag, 'Min' );
elseif currView == 3
    val             = get( handlesMain.sliderCor, 'Value' );
    max             = get( handlesMain.sliderCor, 'Max' );
    min             = get( handlesMain.sliderCor, 'Min' );
end

if isUp
    val = val + 1;
    if val > max
        return; 
    end
else
    val = val - 1;
    if val < min
        return;
    end
end

% update img/slider according to view
if currView == 1
    set( handlesMain.sliderTra, 'Value', val );
    fhUpdateTraImg  = getDataMainGui( 'fhUpdateTraImg' );
    feval( fhUpdateTraImg, val, handlesMain );
elseif currView == 2
    set( handlesMain.sliderSag, 'Value', val );
    fhUpdateSagImg  = getDataMainGui( 'fhUpdateSagImg' );
    feval( fhUpdateSagImg, val, handlesMain );
elseif currView == 3
    set( handlesMain.sliderCor, 'Value', val );
    fhUpdateCorImg  = getDataMainGui( 'fhUpdateCorImg' );
    feval( fhUpdateCorImg, val, handlesMain );
end

axes( handles.testView );
