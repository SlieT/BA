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

% Last Modified by GUIDE v2.5 28-Jan-2014 05:40:14

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


function updateTraLines( handles )

axes( handles.transversal );
handleTraImg = imshow( getDataMainGui( 'currTraImg' ), [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ]);


if getDataMainGui( 'showLines' )
    % draw the sagittal and coronal line
    hold on;
    % draw sag line
    %%%%%%%%%%%%%%%
    % if sliderValue is the same as last time skip drawing
    %%%%%%%%%%%%%%%
    % smaller steps(:0.5:) otherwise the line appears 'dotted'
    plot( get( handles.sliderSag, 'Value' ), 1:0.5:getDataMainGui( 'traColumns' ), 'g-','linewidth', getDataMainGui( 'lineWidth' ) );

    % draw cor line
    plot( 1:0.5:getDataMainGui( 'traRows' ), get( handles.sliderCor, 'Max' )+1 - get( handles.sliderCor, 'Value' ), 'b-','linewidth', getDataMainGui( 'lineWidth' ) );
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
end

updateTraLines( handles );


% --- Executes on slider movement.
function sliderTra_Callback(hObject, eventdata, handles)

% if slider was dragged set to nearest step 
newVal = round( get( hObject,'Value' ));            % since step = 1 we round to the next integer
set( handles.sliderTra, 'Value', newVal ); 

% draw new image
updateTraImg( newVal, handles );

% wenn daten konsisten sind kann hier auch einfach nur -1 übergeben werden
updateSagImg( get( handles.sliderSag, 'Value' ), handles );
updateCorImg( get( handles.sliderCor, 'Value' ), handles );


function updateSagLines( handles )

axes( handles.sagittal );
handleSagImg = imshow( getDataMainGui( 'currSagImg' ), [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ] );

if getDataMainGui( 'showLines' )
    % draw the transversal and coronal line
    hold on;
    % draw tra line
    % because of flip plot(columns, rows)
    plot( 1:0.5:getDataMainGui( 'sagColumns' ), getDataMainGui( 'sagRows' )+1 - getDataMainGui( 'ratioTransSag' ) * get( handles.sliderTra, 'Value' ), 'r-','linewidth', getDataMainGui( 'lineWidth' ) ); 

    % draw cor line
    plot( (get( handles.sliderCor, 'Max' )+1 - get( handles.sliderCor, 'Value' )) * getDataMainGui( 'ratioCorSag' ), 1:0.5:getDataMainGui( 'sagRows' ), 'b-','linewidth', getDataMainGui( 'lineWidth' ) );
    hold off;
    % END draw
    
    set( handleSagImg, 'ButtonDownFcn', { @sagittal_ButtonDownFcn, handles } );
end



% --- updates the sagittal image for its given newVal and redraws the transversal and coronal line
function updateSagImg( newVal, handles )

% calcualte the new image and draw it
% current or new image?
if newVal == -1
    sagImgNew = getDataMainGui( 'currSagImg' );
else
    sagImgNew = getSagImg( newVal );
end


% update data
if newVal ~= -1
    setDataMainGui( 'currSagImg', sagImgNew );
end
% END update

updateSagLines( handles );


% --- Executes on slider movement.
function sliderSag_Callback(hObject, eventdata, handles)

newVal = round( get( hObject,'Value' ));          % since step = 1 we round to the next integer
set( handles.sliderSag, 'Value', newVal );

% draw new image
updateSagImg( newVal, handles );

updateTraImg( get( handles.sliderTra, 'Value' ), handles );
updateCorImg( get( handles.sliderCor, 'Value' ), handles );


function updateCorLines( handles )
axes( handles.coronal );
handleCorImg = imshow( getDataMainGui( 'currCorImg' ), [ getDataMainGui( 'currImin' ), getDataMainGui( 'currImax' ) ] );

if getDataMainGui( 'showLines' )
    % draw the transversal and sagittal line
    hold on;
    % draw tra line
    % because of flip plot(columns, rows)
    plot( 1:0.5:getDataMainGui( 'corColumns' ), getDataMainGui( 'corRows' )+1 - getDataMainGui( 'ratioTransCor' ) * get( handles.sliderTra, 'Value' ), 'r-','linewidth', getDataMainGui( 'lineWidth' ) ); 

    % draw sag line
    plot( get( handles.sliderSag, 'Value' ) * getDataMainGui( 'ratioSagCor' ), 1:0.5:getDataMainGui( 'corRows' ), 'g-','linewidth', getDataMainGui( 'lineWidth' ) );
    hold off;
    % END draw
    
    set( handleCorImg, 'ButtonDownFcn', { @coronal_ButtonDownFcn, handles } );
end



% --- updates the coronal image for its given newVal and redraws the transversal and sagittal line
function updateCorImg( newVal, handles )

% calcualte the new image and draw it
% current or new image?
if newVal == -1
    corImgNew = getDataMainGui( 'currCorImg' );
else
    corImgNew = getCorImg( get( handles.sliderCor,'Max' ) + 1 - newVal );
end

% update data
if newVal ~= -1
    setDataMainGui( 'currCorImg', corImgNew );
end
% END update

updateCorLines( handles );


% --- Executes on slider movement.
function sliderCor_Callback(hObject, eventdata, handles)

newVal = round( get( hObject,'Value' ));          % since step = 1 we round to the next integer
set( handles.sliderCor, 'Value', newVal );

% draw new image
updateCorImg( newVal, handles );

updateTraImg( get( handles.sliderTra, 'Value' ), handles );
updateSagImg( get( handles.sliderSag, 'Value' ), handles );


% --- Executes during object creation, after setting all properties.
function transversal_CreateFcn(hObject, eventdata, handles)


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
function Menu1_Callback(hObject, eventdata, handles)


% --- Executes when prototype is resized.
function prototype_ResizeFcn(hObject, eventdata, handles)


function sagImgNew = getSagImg( value )
Images              = getDataMainGui( 'Images' ); 
sagImg              = Images(:,value,:);                           % vertical slider sliderTop = rightEnd sliderBottom = leftEnd
sagImgSize          = size( sagImg ); 
sagImgReshape       = reshape( sagImg, [ sagImgSize(1), sagImgSize(3) ]);   % original Img without manipulation
manipulate          = maketform( 'affine',[ 0 getDataMainGui( 'flip' )*getDataMainGui( 'scale' ); 1 0; 0 0 ] );        
nearestNeighbour    = makeresampler( 'cubic','fill' );     
sagImgNew           = imtransform( sagImgReshape,manipulate,nearestNeighbour );


function corImgNew = getCorImg( value )
Images              = getDataMainGui( 'Images' ); 
corImg              = Images(value,:,:);
corImgSize          = size( corImg ); 
corImgReshape       = reshape( corImg, [ corImgSize(2), corImgSize(3) ]);       % original Img without manipulation
manipulate          = maketform( 'affine',[ 0 getDataMainGui( 'flip' )*getDataMainGui( 'scale' ); 1 0; 0 0 ] );        
nearestNeighbour    = makeresampler( 'cubic','fill' );     
corImgNew           = imtransform( corImgReshape,manipulate,nearestNeighbour );


% --------------------------------------------------------------------
function menuOpenDir_Callback(hObject, eventdata, handles)

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
    for i = numImages:-1:1
        fname         = fullfile( currentFolder, files(i).name );
        Images(:,:,i) = dicomread( fname ); 
    end
else
    return;
end
   

% set sliders
sliderStep = 1 / numImages;

Isize           = size(Images);
amountRows      = Isize(1);
amountColumns   = Isize(2);
firstImg        = round( numImages/2 ); 
halfC           = amountColumns / 2;            % start in the middle otherwise sagittal and coronal would properbly show nothing
halfR           = amountRows / 2;


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
%%% see *a
flip            = -1;               % flip upside down
scale           = 1;                % scale factor
%%%               % starting from the bottom
lineWidth       = 1;
% transversal
Imin            = min(Images(:));   % since a Matrix is represented as a vecotor we can use min(matrix(:))
Imax            = max(Images(:));
traImg          = Images(:,:,firstImg);
axes(handles.transversal);
imshow( traImg, [ Imin, Imax ]);    


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
setDataMainGui( 'Imin'          , intmin(classI) ); 
setDataMainGui( 'Imax'          , intmax(classI) );
setDataMainGui( 'defaultImin'   , Imin           );
setDataMainGui( 'defaultImax'   , Imax           );
setDataMainGui( 'currImin'      , Imin           );
setDataMainGui( 'currImax'      , Imax           );

setDataMainGui( 'traSize'       , traSize        );
setDataMainGui( 'traRows'       , traRows        );
setDataMainGui( 'traColumns'    , traColumns     );
setDataMainGui( 'currTraImg'    , traImg         );

% sagittal
sagImgNew       = getSagImg( halfC );
axes(handles.sagittal);
imshow( sagImgNew, [ Imin, Imax ]); 
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
imshow( corImgNew, [ Imin, Imax ] );
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
setDataMainGui( 'handles'       , handles  );

% update lines
setDataMainGui( 'showLines'    , get( handles.checkboxShowLines, 'Value' ) );  % is equal to false
updateTraLines( handles );
updateSagLines( handles );
updateCorLines( handles );

set( handles.uipanelAdjust, 'Visible', 'on' );


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


% --- Executes on button press in grayScale.
function grayScale_Callback(hObject, eventdata, handles)

adjustGrayScale;
