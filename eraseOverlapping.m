function varargout = eraseOverlapping(varargin)
% ERASEOVERLAPPING MATLAB code for eraseOverlapping.fig
%      ERASEOVERLAPPING, by itself, creates a new ERASEOVERLAPPING or raises the existing
%      singleton*.
%
%      H = ERASEOVERLAPPING returns the handle to a new ERASEOVERLAPPING or the handle to
%      the existing singleton*.
%
%      ERASEOVERLAPPING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERASEOVERLAPPING.M with the given input arguments.
%
%      ERASEOVERLAPPING('Property','Value',...) creates a new ERASEOVERLAPPING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eraseOverlapping_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eraseOverlapping_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eraseOverlapping

% Last Modified by GUIDE v2.5 14-May-2014 17:52:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eraseOverlapping_OpeningFcn, ...
                   'gui_OutputFcn',  @eraseOverlapping_OutputFcn, ...
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


% --- Executes just before eraseOverlapping is made visible.
function eraseOverlapping_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eraseOverlapping (see VARARGIN)

% Choose default command line output for eraseOverlapping
handles.output = hObject;

hMain = getappdata(0, 'hMainGui');

% set some data
currTraImg  = getappdata( hMain, 'currTraImg' );
currSagImg  = getappdata( hMain, 'currSagImg' );
currCorImg  = getappdata( hMain, 'currCorImg' );

setappdata(handles.eraseOverlapping, 'currView'       , 'tra');
setappdata(handles.eraseOverlapping, 'currImg'        , currTraImg);
setappdata(handles.eraseOverlapping, 'currTraImg'     , currTraImg );
setappdata(handles.eraseOverlapping, 'currSagImg'     , currSagImg );
setappdata(handles.eraseOverlapping, 'currCorImg'     , currCorImg );

% set global data
setDataMainGui( 'heraseOverlapping', handles );
setDataMainGui( 'fhUpdateTestView', @updateTestView );

imshow( currTraImg );

% Update handles structure
guidata(hObject, handles);

% clear the command line
clc;

% UIWAIT makes eraseOverlapping wait for user response (see UIRESUME)
% uiwait(handles.eraseOverlapping);
end


% --- Outputs from this function are returned to the command line.
function varargout = eraseOverlapping_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes when user attempts to close eraseOverlapping.
function eraseOverlapping_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to eraseOverlapping (see GCBO)
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
handles = getDataMainGui( 'heraseOverlapping' );
xZoom   = xlim(handles.testView);
yZoom   = ylim(handles.testView);

imshow( img, 'parent', handles.testView ); 

% set current zoom state
set(handles.testView, 'xlim', xZoom);
set(handles.testView, 'ylim', yZoom);
end


% --- Executes on selection change in chooseView.
function chooseView_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns chooseView contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseView

currVal     = get(hObject,'Value');

% set currentImgMask
if currVal == 1      % transversal
    currImg         = getDataMainGui( 'currTraImg' );
    setappdata(handles.eraseOverlapping, 'currView', 'tra');
    
elseif currVal == 2  % sagittal
    currImg         = getDataMainGui( 'currSagImg' );
    setappdata(handles.eraseOverlapping, 'currView', 'sag');
    
else                 % coronal
    currImg             = getDataMainGui( 'currCorImg' );
    setappdata(handles.eraseOverlapping, 'currView', 'cor');
    
end

set(handles.testView, 'xlim', [ 0.5  size(currImg,2)+0.5 ]);
set(handles.testView, 'ylim', [ 0.5  size(currImg,1)+0.5 ]);
setappdata(handles.eraseOverlapping, 'currImg', currImg);

imshowKeepZoom( currImg );
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
handles     = getDataMainGui( 'heraseOverlapping' );
currView    = getappdata(handles.eraseOverlapping, 'currView');

if strcmp(currView,'tra') && strcmp(view,'tra')         % transversal
    setappdata(handles.eraseOverlapping, 'currTraImg', currImg );
    setappdata(handles.eraseOverlapping, 'currImg', currImg );
elseif strcmp(currView,'sag') && strcmp(view,'sag')     % sagittal
    setappdata(handles.eraseOverlapping, 'currSagImg', currImg );
    setappdata(handles.eraseOverlapping, 'currImg', currImg );
elseif strcmp(currView,'cor') && strcmp(view,'cor')     % coronal
    setappdata(handles.eraseOverlapping, 'currCorImg', currImg );
    setappdata(handles.eraseOverlapping, 'currImg', currImg );
end

if strcmp(currView,view)

    imshowKeepZoom( currImg );
end
end


% --- Executes when eraseOverlapping is resized.
function eraseOverlapping_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to eraseOverlapping (see GCBO)
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


% --- Executes when uipanel2 is resized.
function uipanel2_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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


% --- Executes on button press in addMask.
function addMask_Callback(hObject, eventdata, handles)
% hObject    handle to addMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Labels exist?
dDMasks     = getDataMainGui( 'dropDownMasks' );
sizeM       = size(dDMasks);
if sizeM(1) == 0
    warndlg( 'Couldn''t find a label. Create/Load label first.', 'Attention' );
    return;
end

eraseMasks  = getDataMainGui( 'eraseMasks' );
sizeE       = size( eraseMasks );

% possible to add mask?
if sizeE(2) == sizeM(2)
    warndlg( 'All current labels have been added. Create/Load label first.', 'Attention' );
    return;
end

% delete all used masks (so you only see unused "add-able" masks)
for i=1:1:sizeM(2)
    for j=1:1:sizeE(2)
        % if exists
        if strcmp( dDMasks{i}, eraseMasks{j} )
            % delete it
            dDMasks{i} = '';
        end
    end
end

% select masks to add
[s,v] = listdlg( 'PromptString', 'Select labels to add:', 'ListString', dDMasks );

% cancel?
if v == 0
    return;
end

% get all selected names
sizeS = size(s, 2);
for i=1:1:sizeS
    name = dDMasks{ s(i) };
    % if no "already added mask" ('')
    if strcmp( name, '' ) == 0
        % add them to eraseMasks
        eraseMasks{ sizeE(2) + 1 } = name;
        sizeE(2) = sizeE(2) + 1;
    end
end

setDataMainGui( 'eraseMasks', eraseMasks );
end


% --- Executes on button press in removeMask.
function removeMask_Callback(hObject, eventdata, handles)
% hObject    handle to removeMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dDMasks     = getDataMainGui( 'dropDownMasks' );
sizeM       = size(dDMasks);
eraseMasks  = getDataMainGui( 'eraseMasks' );
sizeE       = size( eraseMasks );

% possible to remove mask?
if sizeE(2) == 0
    warndlg( 'No labels to remove since no label has been added yet. Add label first.', 'Attention' );
    return;
end

% delete all unused masks (so you only see used removable masks)
for i=1:1:sizeM(2)
    for j=1:1:sizeE(2)
        % if exists
        if strcmp( dDMasks{i}, eraseMasks{j} )
            break;
        elseif j == sizeE(2)
            % delete it
            dDMasks{i} = '';
        end
    end
end

% select masks to add
[s,v] = listdlg( 'PromptString', 'Select labels to remove:', 'ListString', dDMasks );

% cancel?
if v == 0
    return;
end

% get all selected names
sizeS = size(s, 2);
for i=1:1:sizeS
    name = dDMasks{ s(i) };
    
    % if no "already removed mask" ('')
    if strcmp( name, '' ) == 0
        
        % remove from eraseMasks
        j = 1;
        while j <= sizeE(2)
            
            if strcmp( eraseMasks{j}, name )
                eraseMasks( j ) = [];
                break;
            end
            j = j + 1;
        end
    end
end

setDataMainGui( 'eraseMasks', eraseMasks );
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over infoText.
function infoText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to infoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get( hObject, 'string' ), 'Click me to get more informations.' )
    set( hObject, 'string', 'Click on the overlapping pixels(color) to add them to one of the masks.' ); 
else
    set( hObject, 'string', 'Click me to get more informations.' );
end
end


% --- Executes on scroll wheel click while the figure is in focus.
function eraseOverlapping_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to eraseOverlapping (see GCBO)
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
