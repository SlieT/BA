function varargout = testGUI(varargin)
% TESTGUI MATLAB code for testGUI.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','Value',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testGUI

% Last Modified by GUIDE v2.5 11-Feb-2014 17:56:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @testGUI_OutputFcn, ...
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


% --- Executes just before testGUI is made visible.
function testGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGUI (see VARARGIN)

% Choose default command line output for testGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% handles.output = hObject;
% [FileName, PathName] = uigetfile('*.dcm','select dicom file'); %Looks for .dcm files on your system
% Path = strcat(PathName,FileName);         %Gets the file path
% %set(handles.edit1,'string',Path);                  %Puts the file path on the edit text
% [handles.I, handles.Imap] = dicomread(Path);                     %Putting handles before the variable name makes it accessible by other functions
% handles.info = dicominfo(Path);                 %Gets the DICOM header tags from the file
% %axes(handles.axes1);
% disp(hObject)
% disp(handles);
% imshow(handles.I, [])                                        %Displays the image on the axes
% impixelinfo;                                                          %Displays the pixel position information when you move your cursor
% guidata(hObject, handles);

%Display the DICOM header tags
%disp(handles.info)


u = 500/65535;
o = 900/65535;

a = dicomread('test.dcm');

%         intensity mapping
% subplot(1,2,1), imshow(a, [ 500 900 ]);  % ist das gleiche wie  
% 
% b = imadjust( a, [ u o ], [ 0 1 ] );     % ist das gleiche wie 
% subplot(1,2,2), imshow(b);  
% figure, imhist(b);
%
% b2 = im2uint16( mat2gray( a ) );         % das hier ist der standart - ist das gleiche wie 
% subplot(1,2,2), imshow(b2);  
% figure, imhist(b2);

%         intensity mapping wheighted towards gamma (gamma < 1 => brighter) 
% c = imadjust( a, [ u o ], [ 0 1 ], 0.01 ); % last value is gamma
% subplot(1,2,1), imshow(c);
% 
% d = imadjust( a, [ u o ], [ 0 1 ], 1.5 );  % last value is gamma
% subplot(1,2,2), imshow(d);
% figure, imhist(c);
% figure, imhist(d);

%         image complement 
% e = imadjust( a, [ u o ], [ 1 0 ], 1 ); % imcomplement
% subplot(1,2,1), imshow(e);
% 
% f = imadjust( e, [ 0 1 ], [ 1 0 ], 1 ); % imcomplement
% subplot(1,2,2), imshow(f);
% figure, imhist(e);
% figure, imhist(f);

%        logarithmic transformation - "reducing contrast of brighter regions" (indem quasi helles noch heller wird)
% c=80; % 80-100 for brightness else see imhist
% f = im2double(a);
% newImg = c(log(1 + f));
% newImg2 = im2uint16(newImg);
% subplot(1,2,1), imshow(newImg2); % no rangeadjustment necessary! no imshow( newimg2, [] )
% figure, imhist(newImg2);

%         contrast-stretching
% f = im2double(a);
% %mean2(f)   % 0.0028
% %max(f(:))  % 0.0134
% m = 0.01;  % m is threshold (range is 0 - 1) 
% % since the information we want is in the bright part of the image we
% % should choose a treshold near to max and then mostly play with E
% E = 4;      % slope of the function (degree of compression) e.g. 1 = no compression 200 is binary
% newImg = 1./(1 + (m./(f + eps)).^E); % was macht 1. ? falsch es ist der ./ Operator sowie der .^ 
% % also eine array operation im sinne von C=A./B = C(i,j) = A(i,j)/B(i,j)                                     
% newImg2 = im2uint16(newImg);
% subplot(1,2,1), imshow(newImg2, []);
% figure, imhist(newImg2);





