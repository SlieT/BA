function varargout = testContrast(varargin)
% testContrast MATLAB code for testContrast.fig
%      testContrast, by itself, creates a new testContrast or raises the existing
%      singleton*.
%
%      H = testContrast returns the handle to a new testContrast or the handle to
%      the existing singleton*.
%
%      testContrast('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in testContrast.M with the given input arguments.
%
%      testContrast('Property','Value',...) creates a new testContrast or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testContrast_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testContrast_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testContrast

% Last Modified by GUIDE v2.5 22-Feb-2014 18:44:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testContrast_OpeningFcn, ...
                   'gui_OutputFcn',  @testContrast_OutputFcn, ...
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


% --- Executes just before testContrast is made visible.
function testContrast_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testContrast (see VARARGIN)

% Choose default command line output for testContrast
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testContrast wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testContrast_OutputFcn(hObject, eventdata, handles) 
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

%close all

u = 0/65535;
o = 2576/65535;

img = dicomread('test.dcm');

%         intensity mapping
% subplot(1,2,1), imshow(img, [ 0 2576 ]);  % ist das gleiche wie  
% 
% b = imadjust( img, [ u o ], [ 0 1 ] );     % ist das gleiche wie 
% subplot(1,2,2), imshow(b);  
% figure, imhist(b);
%
enhImg = im2uint16( mat2gray( img ) );         % das hier ist der standart - ist das gleiche wie 
% subplot(1,2,2), imshow(enhImg);  
% figure, imhist(enhImg);

%         intensity mapping wheighted towards gamma (gamma < 1 => brighter)
% c = imadjust( img, [ u o ], [ 0 1 ], 0.5 ); % last value is gamma
% subplot(1,3,1), imshow(c);
% 
% cd = imadjust( img, [ u o ], [ 0 1 ], 1 );  % last value is gamma
% subplot(1,3,2), imshow(cd);
% 
% d = imadjust( img, [ u o ], [ 0 1 ], 1.5 );  % last value is gamma
% subplot(1,3,3), imshow(d);
% figure, imhist(img);
% figure, imhist(c);
% figure, imhist(cd);
% figure, imhist(d);

%   used Enhanced Image see s.67
% c = imadjust( enhImg, [], [], 0.5 ); % weighted toward highend
% subplot(1,3,1), imshow(c);
% 
% cd = imadjust( enhImg, [], [], 1 );  % last value is gamma
% subplot(1,3,2), imshow(cd);
% 
% d = imadjust( enhImg, [], [], 2 );  % weighted towards low end (darker)
% subplot(1,3,3), imshow(d);
% figure, imhist(enhImg);
% figure, imhist(c);
% figure, imhist(cd);
% figure, imhist(d);


%         image complement 
% e = imadjust( img, [ u o ], [ 1 0 ], 1 ); % imcomplement
% subplot(1,2,1), imshow(e);
% 
% f = imadjust( e, [ 0 1 ], [ 1 0 ], 1 ); % imcomplement
% subplot(1,2,2), imshow(f);
% figure, imhist(e);
% figure, imhist(f);

%        logarithmic transformation - usefull but only in coorp with complement (see below "COMPLEMENT" the imshow(imcomplement(newImg4));) http://codesmesh.com/log-transformation-of-an-image-in-matlab/
% Uses:
% 1. Used to expand the values of dark pixels in an image while compressing the higher values
% 2. It compresses the dynamic range of images with large variations in pixel values
% OR:
% applying log transformation to an image will expand its low valued pixels to a higher level and 
% has little effect on higher valued pixels so in other words it enhances image in such a way that 
% it highlights minor details

% c=80; % 80-100 for brightness else see imhist
% f = im2double(img);
% newImg = c*(log(1 + f));
% newImg2 = im2uint16(newImg);
% subplot(1,2,1), imshow(newImg2); % no rangeadjustment necessary! no imshow( newimg2, [] )
% figure, imhist(img);
% figure, imhist(newImg2);

%   used Enhanced Image
% c=1; % 80-100 for brightness else see imhist
% f = im2double(enhImg);
% newImg2 = 1.2*(log(1 + f));
% newImg2 = im2uint16(newImg2);
% newImg3 = mat2gray(log(1 + double(img))); % normal usecase, zeigt gut die unbrauchbarkeit der methode für diese anwendung
% newImg3 = im2uint16(newImg3);
% newImg4 = 1.7*(log(1 + f));
% newImg4 = im2uint16(newImg4);
% subplot(1,3,1), imshow(newImg2); % no rangeadjustment necessary! no imshow( newimg2, [] )
% subplot(1,3,2), imshow(newImg3);
% subplot(1,3,3), imshow(newImg4);
% figure, imhist(enhImg);
% figure, imhist(newImg2);
% figure, imhist(newImg3);
% figure, imhist(newImg4);

%   used Enhanced COMPLEMENT-Image
% c=1; % 80-100 for brightness else see imhist
% f = im2double(imcomplement(enhImg));
% newImg2 = 1.3*(log(1 + f));
% newImg2 = im2uint16(newImg2);
% newImg3 = mat2gray(log(1 + double(imcomplement(img)))); % normal usecase, zeigt gut die brauchbarkeit der methode für diese anwendung
% newImg3 = im2uint16(newImg3);
% newImg4 = 2*(log(1 + f));
% newImg4 = im2uint16(newImg4);
% subplot(1,4,1), imshow(newImg2); % no rangeadjustment necessary! no imshow( newimg2, [] )
% subplot(1,4,2), imshow(newImg3);
% subplot(1,4,3), imshow(newImg4);
% subplot(1,4,4), imshow(imcomplement(newImg4)); % img4 hat den dunklen bereich (da complement eigentlich den weißen) gestretcht, 
%                                                 % dieses beispiel zeigt gut die verwendbarkeit
% figure, imhist(enhImg);
% figure, imhist(newImg2);
% figure, imhist(newImg3);
% figure, imhist(newImg4);


%         contrast-stretching
% E controls the slope of the function and m is the mid-line where you want to switch from dark values to light values
% f = im2double(enhImg);
% %mean2(f)   % 0.0028
% %max(f(:))  % 0.0134
% m = 0.9;  % m is threshold (range is 0 - 1) 
% % since the information we want is in the bright part of the image we
% % should choose a treshold near to max and then mostly play with E
% E = 4;      % the higher E the less grayleves there are
% newImg = 1./(1 + (m./(f + eps)).^E); % was macht 1.? - es ist der ./ Operator sowie der .^ 
%                                      % also eine array operation im sinne von C=A./B = C(i,j) = A(i,j)/B(i,j)                                     
% %newImg2 = im2uint16(newImg);
% subplot(1,2,1), imshow(newImg, []);
% figure, imhist(f);
% figure, imhist(newImg);



%         histogramm equalisation - due to the high dynamic range properbly
%         useless (bringt haupstächlich was wenn es ein graues bild ist dh der hauptteil des histogramms in der mitte ist)
% b = histeq(enhImg); % adapthisteq
% % b = histeq(enhImg, 65535); % nlev = 65535 ist eine echte imhisteq
% % implemetierung für bilder des formats unit16 default nlev = 64
% subplot(1,2,1), imshow(b); % no rangeadjustment necessary! no imshow( newimg2, [] )
% figure, imhist(enhImg);
% figure, imhist(b);


% adapthisteq sieht auch ganz gut aus (teilt das bild in kleine tiles auf und ehnaced auf ihnen den kontrast)
figure, imshow(adapthisteq(enhImg));
figure, imshow(enhImg);
figure, imhist(adapthisteq(enhImg));
figure, imhist(enhImg);


%         histogramm matching - histogram equalization tries to create an equal probability of each intensity occurring.
%           BBHE technik könnte helfen (aufteilen des histogramms in teile)

% p=manualhist;
% %the following arguments were typed at the prompt  
% % 0.15 0.05 0.75 0.05 1 0.1 0.002  - input is looped don't forget to end with x 
% g=histeq(enhImg, p);  
% figure, imshow(g);  
% figure, imhist(g);
% figure, imhist(enhImg)

function p = manualhist
%MANUALHIST Generates a bimodal histogram interactively.
%   P = MANUALHIST generates a bimodal histogram using
%   TWOMODEGAUSS(m1, sig1, m2, sig2, A1, A2, k). m1 and m2 are the means 
%   of the two modes and must be in the range [0, 1]. sig1 and sig2 are
%   the standard deviations of the two modes.  A1 and A2 are 
%   amplitude values, and k is an offset value that raises the 
%   "floor" of the histogram.  The number of elements in the histogram
%   vector P is 256 and sum(P) is normalized to 1.  MANUALHIST
%   repeatedly prompts for the parameters and plots the resulting 
%   historgram until the user types an 'x' to quit, and then it
%   returns the last histogram computed.
%
%   A good set of starting values is: (0.15, 0.05, 0.75, 0.05, 1,
%   0.07, 0.002).

% Initialize.
repeats = true;
quitnow = 'x';

% Compute a default histogram in case the user quits before 
% estimating at least one histogram.
p = twomodegauss(0.15, 0.05, 0.75, 0.05, 1, 0.07, 0.002);

% Cycle until an x is input.
while repeats
    s = input('Enter m1, sig1, m2, sig2, A1, A2, k OR x to quit:', 's');
    if s == quitnow
        break
    end
    
    % Convert the input string to a vector of numberical values and 
    % verify the number of inputs.
    v = str2num(s);
    if numel(v) ~= 7
        disp('Incorrect number of inputs.')
        continue
    end
    
    p = twomodegauss(v(1), v(2), v(3), v(4), v(5), v(6), v(7));
    % Start a new figure and scale the axes.  Specifying only xlim
    % leaves ylim on auto.
    figure, plot(p)
    xlim([0 255])
end

function p=twomodegauss(m1, sig1, m2, sig2, A1, A2, k)
%TWOMODEGAUSS Generates a bimodal Gaussian function.
%   P = TWOMODEGAUSS(M1, SIG1, M2, SIG2, A1, A2, K) generates a bimodal,
%   Gaussian-like function in the interval [0, 1]. P is a 256-element
%   vector normalized so that SUM(P) equals 1.  The mean and standard
%   deviation of the modes are (M1, SIG1) and (M2, SIG2), respectively.
%   A1 and A2 are the amplitude values of the two modes.  Since the 
%   output is normalized, only the relative values of A1 and A2 are
%   important.  K is an offset value that raises the "floor" of the 
%   function.  A good set of values to try is M1 = 0.15, SIG = 0.05,
%   M2 = 0.75, SIG2 = 0.05, A1 = 1, A2 = 0.07, and K = 0.002.

c1 = A1 * (1 / ((2 * pi) ^ 0.5) * sig1);
k1 = 2 * (sig1 ^ 2);
c2 = A2 * (1 / ((2 * pi) ^ 0.5) * sig2);
k2 = 2 * (sig2 ^ 2);
z = linspace(0, 1, 256);
p = k + c1 * exp(-((z - m1) .^ 2) ./ k1) + ...
    c2 * exp(-((z - m2) .^ 2) ./ k2);
p = p ./ sum(p(:));


%         exponential transformation https://www.youtube.com/watch?v=moT1KzdVR-A&list=PLZ9qNFMHZ-A79y1StvUUqgyL-O0fZh2rs
%                                       minute 9
%         - erzeugt artefakte und bringt keine nennenswerte verbesserung
%         daher unbrauchbar
% r = im2double(enhImg);
% c = 1;
% gamma = 1;  % range 0.00000 -> 50? , 1 is norm
% s = c*r^0.95;
% s = im2uint16(s);
% s1 = c*r^1;
% s1 = im2uint16(s1);
% s2 = c*r^1.05;
% s2 = im2uint16(s2);
% subplot(1,3,1), imshow(s); % no rangeadjustment necessary! no imshow( newimg2, [] )
% subplot(1,3,2), imshow(s1);
% subplot(1,3,3), imshow(s2);
% figure, imhist(enhImg);
% figure, imhist(s);
% figure, imhist(s1);
% figure, imhist(s2);

%best link ever
%http://www.cs.uregina.ca/Links/class-info/425/Lab3/
%bzw
%http://www.cs.uregina.ca/Links/class-info/425/Lab2/
