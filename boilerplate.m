% ######################## Boilerplate ####################################
%
% To add functionality to the application that fits the current 
% look and feel, this Boilerplate gives you what you need. But to use it
% there are some things you have to do first.
%
% 1. boilerplate.fig
%
% For every UI-component and the figure iteself you have to manually change
% the name "boilerplate" with the name of your current figure.
% 
% First open the figure with GUIDE then change:
%
% - On the figure itself (double click between the ui-components) change
% the CloseRequestFcn, ResizeFcn, Tag and the WindowScrollWheelFcn
%
% Now lets see what you have to change for every ui-component
% The principle is as follows:
% Name of Tag(ui-component) - Attribute you need to change the name within
%
% infoText   - ButtonDownFcn
% down       - Callback
% up         - Callback
% chooseView - Callback, CreateFcn
%
% 2. boilerplate.m
%
% In this file you need to replace ever occurence of boilerplate with your
% new filename. The best way to do this is to use find and replace. 
% 
% Look for:
%
% boilerplate
% BOILERPLATE
% boilerplate_...
% @boilerplate_...
% hboilerplate
%
% 3. Congratulations you have done it! Now delete this comment so no one
%    knows that you needed help to do this.
%
% ######################## Boilerplate ####################################

function varargout = boilerplate(varargin)
% BOILERPLATE MATLAB code for boilerplate.fig
%      BOILERPLATE, by itself, creates a new BOILERPLATE or raises the existing
%      singleton*.
%
%      H = BOILERPLATE returns the handle to a new BOILERPLATE or the handle to
%      the existing singleton*.
%
%      BOILERPLATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOILERPLATE.M with the given input arguments.
%
%      BOILERPLATE('Property','Value',...) creates a new BOILERPLATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before boilerplate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to boilerplate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help boilerplate

% Last Modified by GUIDE v2.5 23-May-2014 02:54:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @boilerplate_OpeningFcn, ...
                   'gui_OutputFcn',  @boilerplate_OutputFcn, ...
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


% --- Executes just before boilerplate is made visible.
function boilerplate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to boilerplate (see VARARGIN)

% Choose default command line output for boilerplate
handles.output = hObject;

hMain = getappdata( 0, 'hMainGui' );

% set some data
currTraImg  = getappdata( hMain, 'currTraImg' );
currSagImg  = getappdata( hMain, 'currSagImg' );
currCorImg  = getappdata( hMain, 'currCorImg' );

setappdata( handles.boilerplate, 'currView'       , 'tra' );
setappdata( handles.boilerplate, 'currImg'        , currTraImg );
setappdata( handles.boilerplate, 'currTraImg'     , currTraImg );
setappdata( handles.boilerplate, 'currSagImg'     , currSagImg );
setappdata( handles.boilerplate, 'currCorImg'     , currCorImg );

% set global data
setDataMainGui( 'hboilerplate', handles );
setDataMainGui( 'fhUpdateTestView', @updateTestView );

% show the image of the current view
imshow( currTraImg );

% Update handles structure
guidata(hObject, handles);

% clear the command line
clc;

% UIWAIT makes boilerplate wait for user response (see UIRESUME)
% uiwait(handles.boilerplate);
end


% --- Outputs from this function are returned to the command line.
function varargout = boilerplate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes when user attempts to close boilerplate.
function boilerplate_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to boilerplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);
end


% --- setData globallike
function setDataMainGui( name, value )
hMain = getappdata( 0, 'hMainGui' );
setappdata( hMain, name, value );
end


% --- getData globallike
function data = getDataMainGui( name )
hMain = getappdata( 0, 'hMainGui' );
data  = getappdata( hMain, name );
end
    

% --- keep the current zoom state
function imshowKeepZoom( img )
handles = getDataMainGui( 'hboilerplate' );
xZoom   = xlim( handles.testView );
yZoom   = ylim( handles.testView );

imshow( img, 'parent', handles.testView ); 

% set current zoom state
set( handles.testView, 'xlim', xZoom );
set( handles.testView, 'ylim', yZoom );
end


% --- Executes on selection change in chooseView.
function chooseView_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns chooseView contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseView

currVal = get( hObject,'Value' );

% set currentImgMask
if currVal == 1      % transversal
    currImg = getDataMainGui( 'currTraImg' );
    setappdata( handles.boilerplate, 'currView', 'tra' );
    
elseif currVal == 2  % sagittal
    currImg = getDataMainGui( 'currSagImg' );
    setappdata( handles.boilerplate, 'currView', 'sag' );
    
else                 % coronal
    currImg = getDataMainGui( 'currCorImg' );
    setappdata( handles.boilerplate, 'currView', 'cor' );
    
end

% on view change reset zoomlimits 
set( handles.testView, 'xlim', [ 0.5  size(currImg,2)+0.5 ]);
set( handles.testView, 'ylim', [ 0.5  size(currImg,1)+0.5 ]);

% set current image
setappdata( handles.boilerplate, 'currImg', currImg );

% display current image
imshowKeepZoom( currImg );

end

% XXX brauchts die? wenn nein lösche das attribute in der figure und passe
% oben im text an das diese nicht angepasst werden muss
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

% --- since the view is synced to the main figure, we need a function
%       to update the testView through feval
function updateTestView(view, currImg)
handles     = getDataMainGui( 'hboilerplate' );
currView    = getappdata( handles.boilerplate, 'currView' );

% XXX überall noch den klammerabstand ( text ) einbauen nicht (text)
% XXX ist nicht einfacher zu lesen
% if strcmp(view, currView) && strcmp(view,'tra')
if strcmp(currView,'tra') && strcmp(view,'tra')         % transversal
    setappdata(handles.boilerplate, 'currTraImg', currImg );
    setappdata(handles.boilerplate, 'currImg', currImg );
    
elseif strcmp(currView,'sag') && strcmp(view,'sag')     % sagittal
    setappdata(handles.boilerplate, 'currSagImg', currImg );
    setappdata(handles.boilerplate, 'currImg', currImg );
    
elseif strcmp(currView,'cor') && strcmp(view,'cor')     % coronal
    setappdata(handles.boilerplate, 'currCorImg', currImg );
    setappdata(handles.boilerplate, 'currImg', currImg );
    
end

% XXX noch ordentlichen kommentar if the changed image in the main 
if strcmp(currView,view)
    imshowKeepZoom( currImg );
end
end


% --- Executes when boilerplate is resized.
function boilerplate_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to boilerplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% testViewPanel and testView have the property "units" set to "normalized"

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
oldUnitsUIPanel2    = get(handles.testViewPanel,'Units');
set(handles.testViewPanel,'Units','pixels');
UIPanel2Pos         = get(handles.testViewPanel,'Position');
%methodPanelPos(1)-(UIPanel2Pos(1)+UIPanel2Pos(3)) = 32 % space between
%testViewPanel and methodPanel
newLeft             = UIPanel2Pos(1) + UIPanel2Pos(3) + 32;
%newLeft         = figPos(3) - methodPanelPos(3) - 21; % keep method Panel
%on the right edge
upos                = [newLeft, newBottom, methodPanelPos(3), methodPanelPos(4)];
set(handles.methodPanel,'Position',upos);
set(handles.testViewPanel,'Units',oldUnitsUIPanel2);

set(hObject,'Units',oldUnits);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over infoText.
function infoText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to infoText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get( hObject, 'string' ), 'Click me to get more informations.' )
    set( hObject, 'string', 'Click me again to get less informations.' ); 
else
    set( hObject, 'string', 'Click me to get more informations.' );
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


% --- Executes on scroll wheel click while the figure is in focus.
function boilerplate_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to boilerplate (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

% get next or previous image depending on the scroll direction
if eventdata.VerticalScrollCount > 0
    fhUpDown = getDataMainGui( 'fhUpDown' );
    feval( fhUpDown, handles, false );
else
    fhUpDown = getDataMainGui( 'fhUpDown' );
    feval( fhUpDown, handles, true );
end
end
