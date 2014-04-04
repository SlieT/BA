function varargout = testSegmentation(varargin)
% TESTSEGMENTATION MATLAB code for testSegmentation.fig
%      TESTSEGMENTATION, by itself, creates a new TESTSEGMENTATION or raises the existing
%      singleton*.
%
%      H = TESTSEGMENTATION returns the handle to a new TESTSEGMENTATION or the handle to
%      the existing singleton*.
%
%      TESTSEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTSEGMENTATION.M with the given input arguments.
%
%      TESTSEGMENTATION('Property','Value',...) creates a new TESTSEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testSegmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testSegmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testSegmentation

% Last Modified by GUIDE v2.5 13-Mar-2014 17:20:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testSegmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @testSegmentation_OutputFcn, ...
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


% --- Executes just before testSegmentation is made visible.
function testSegmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testSegmentation (see VARARGIN)

% Choose default command line output for testSegmentation
handles.output = hObject;

img = dicomread( 'test.dcm' );

img = imadjust( img );

setappdata( handles.testSegmentation, 'img', img );

axes(handles.ogImg);
imshow(img);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testSegmentation wait for user response (see UIRESUME)
% uiwait(handles.testSegmentation);


% --- Outputs from this function are returned to the command line.
function varargout = testSegmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





function values_Callback(hObject, eventdata, handles)
% hObject    handle to values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of values as text
%        str2double(get(hObject,'String')) returns contents of values as a double


% im ersten edit zahl.zahl liefert pixelwert an dieser stelle
%   zahl(S),zahl(T) wendet regiongrow an 

% im zweiten edit liefert g das fertige bild, SI die seedpoints, 
%   TI das bild vor der connective-8 prüfung


f = getappdata( handles.testSegmentation, 'img' );

% regiongrow - gut
% quick and dirty to get pixelvalue
% x = get(hObject,'String');
% x = x{1};
% xy = strsplit( x, '.' );
% if numel(xy) == 2
%     x = str2double(xy{2});
%     y = str2double(xy{1});
%     disp(f( x, y ));
%     return;
% end
% 
% % why cell?
% x = get(hObject,'String');
% x = x{1};
% ST = strsplit( x, ',' );
% 
% 
% S = round(str2double( ST{1} ));
% T = round(str2double( ST{2} ));

% % input with getpts
S = false(size(f));
[X, Y] = getpts(handles.ogImg); % einfaches rounden
for i=1:1:size(X)
    X(i) = round(X(i));
    Y(i) = round(Y(i));
    S(Y(i), X(i)) = 1;
end

T = get(hObject,'String');
T = str2double(T);
% % input with getpts

% global resultWithLabels; % type the same again in the commandline to see
% the variable in the workspace
[ resultWithLabels, NumberRegions, finalSeedImage, thresholdImage ] = ...
    regiongrow( f, S, T );

% figure, imshow(thresholdImage)
% figure, imshow(finalSeedImage)
% figure, imshow(resultWithLabels)

% disp( NumberRegions );
setappdata( handles.testSegmentation, 'r', resultWithLabels );
setappdata( handles.testSegmentation, 'f', finalSeedImage );
setappdata( handles.testSegmentation, 't', thresholdImage );
% [ resultWithLabels, NumberRegions, finalSeedImage, thresholdImage ] = ...
%     regiongrow( image, arryOrValueSeedpoint, arrayOrValueThresh );
% regiongrow


% % roipoly to get mask - gut
% -Double-click to add a final vertex  to the polygon and
% close the polygon. 
% -Right-click to close the polygon without adding a
% vertex. 
% -You can adjust the position of the polygon and individual
% vertices in the polygon by clicking and dragging. 
% -To add new vertices, position the pointer along an edge of the polygon
% and press the "A" key.
% 
% bw = roipoly( f );  % bw = mask
% g = f;
% g(~bw) = 0;         % Set all elements in A corresponding to false values in mask to 0
% axes( handles.result );
% imshow( g );
% auswählen eines einzigen punktes geschieht durch ginput(1) 
% % roipoly to get mask



% % multithresh - ganz ok bis gut
% amountThresholds = get(hObject,'String'); % 2 thresholds mean 3 different regions
% amountThresholds = str2double(amountThresholds);
% thresh = multithresh(f,amountThresholds);
% seg_F = imquantize(f,thresh);		% apply the thresholds to obtain segmented image
% g = label2rgb(seg_F); 
% axes( handles.result );
% imshow(g);
% % multithresh



% % Active contours without edges - build in function - edge ist nicht gut
% % und chan-vese bildet auch nur foreground and background und kann von
% % der mask aus in das bild hineinexpandieren oder in die mask hinein.
% % kann man sich mal vormerken aber eher so lala
% mask = roipoly;
% maxIterations = 400; % More iterations may be needed to get accurate segmentation. 
% g = activecontour(f, mask, maxIterations, 'Chan-Vese');
% g = activecontour(f, mask, maxIterations, 'edge'); 
% axes( handles.result );
% imshow( g );
% % chen vese externe implementation
% % I = imread('test.jpg'); seg = chenvese(I,'whole',400,0.2,'multiphase');



% % splitmerge - eine gute regel zu finden wird schwer
% mindim = get(hObject,'String');
% mindim = str2double(mindim);
% % qtdecomp(f, @split_test, mindim, @predicate)
% g = splitmerge(f, mindim, @predicate);
% axes( handles.result );
% imshow( g );
% % splitmerge


% % watershed - gradients - nicht so doll
% h = fspecial('sobel'); % 'prewitt' bzw If you need to emphasize vertical edges, transpose the filter H: H'
% fd = double(f);
% g = sqrt( imfilter( fd, h, 'replicate' ) .^ 2 + ...
%         imfilter( fd, h, 'replicate' ) .^ 2 ); % wendet filter h auf fd an
% L = watershed( g );
% wr = L == 0; % übersegmentiertes bild
% % smooth gradient before watershed (besser aber auch nicht gut)
% g2 = imclose( imopen( g, ones(3,3)), ones(3,3));
% L2 = watershed(g2);
% wr2 = L2 == 0;
% f2 = f;
% f2(wr2) = 65535;
% % watershed - gradients

% % watershed - marker-controlled - auch nicht so doll
% h = fspecial('sobel'); % 'prewitt' bzw If you need to emphasize vertical edges, transpose the filter H: H'
% fd = double(f);
% g = sqrt( imfilter( fd, h, 'replicate' ) .^ 2 + ...
%         imfilter( fd, h, 'replicate' ) .^ 2 ); % wendet filter h auf fd an
% L = watershed( g );
% wr = L == 0; % übersegmentiertes bild
% rm = imregionalmin(g);
% im = imextendedmin(f,2);
% fim = f;
% fim(im) = 44200; % 175
% Lim = watershed(bwdist(im));
% em = Lim == 0;
% g2 = imimposemin(g, im | em );
% L2 = watershed(g2);
% f2 = f;
% f2(L2 == 0) = 65535; % 255
% % watershed - marker-controlled

    

guidata(hObject, handles);



function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input as text
%        str2double(get(hObject,'String')) returns contents of input as a double

axes(handles.result)
input = get(hObject, 'String');

% regiongrow
if strcmp(input, 'g');
    g = getappdata( handles.testSegmentation, 'r' );
    %imshow(g)
    
    % show the result within the original image
    g = im2bw(g); % too reduce all values to 1 and 0
    axes(handles.ogImg);
    f = getappdata( handles.testSegmentation, 'img' );
    imshow(f);
    hold on;
    alpha = 0.3;
    alpha_matrix = alpha*ones(size(g,1),size(g,2));
    green = cat(3, zeros(size(g)), g, zeros(size(g)));
    h = imshow(green);
    set(h,'AlphaData',alpha_matrix);
    hold off;
    % show the result within the original image
    
elseif strcmp(input, 'SI');
    SI = getappdata( handles.testSegmentation, 'f' );
    imshow(SI);
elseif strcmp(input, 'TI')
    TI = getappdata( handles.testSegmentation, 't' );
    imshow(TI);
end
% regiongrow



% --- Executes during object creation, after setting all properties.
function input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





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


function flag = predicate(region)	
	sd = std2(region);
    m = mean2(region);
    %flag = (sd > 10) & (m > 0) & (m < 125);
    % definiere regel nach der gesplittet bzw gemerged werden soll
    % flag = (m > 40000) && (m < 65000); 
    % warum wird nicht so lange
    % gesplitet bis die bedingung stimmt?

function g = splitmerge(f, mindim, fun)
%SPLITMERGE Segment an image using a split-and-merge algorithm.
%   G = SPLITMERGE(F, MINDIM, @PREDICATE) segments image F by using a
%   split-and-merge approach based on quadtree decomposition. MINDIM
%   (a positive integer power of 2) specifies the minimum dimension
%   of the quadtree regions (subimages) allowed. If necessary, the
%   program pads the input image with zeros to the nearest square  
%   size that is an integer power of 2. This guarantees that the  
%   algorithm used in the quadtree decomposition will be able to 
%   split the image down to blocks of size 1-by-1. The result is  
%   cropped back to the original size of the input image. In the  
%   output, G, each connected region is labeled with a different
%   integer.
%
%   Note that in the function call we use @PREDICATE for the value of 	
%   fun.  PREDICATE is a function in the MATLAB path, provided by the
%   user. Its syntax is
%
%       FLAG = PREDICATE(REGION) which must return TRUE if the pixels	
%       in REGION satisfy the predicate defined by the code in the
%       function; otherwise, the value of FLAG must be FALSE.
% 
%   The following simple example of function PREDICATE is used in 	
%   Example 10.9 of the book.  It sets FLAG to TRUE if the 
%   intensities of the pixels in REGION have a standard deviation  
%   that exceeds 10, and their mean intensity is between 0 and 125. 
%   Otherwise FLAG is set to false. 
%
%       function flag = predicate(region)	
%       sd = std2(region);
%       m = mean2(region);
%       flag = (sd > 10) & (m > 0) & (m < 125);

%   Copyright 2002-2004 R. C. Gonzalez, R. E. Woods, & S. L. Eddins	
%   Digital Image Processing Using MATLAB, Prentice-Hall, 2004
%   $Revision: 1.6 $  $Date: 2003/10/26 22:36:01 $

% Pad image with zeros to guarantee that function qtdecomp will	
% split regions down to size 1-by-1.
Q = 2^nextpow2(max(size(f)));
[M, N] = size(f);
f = padarray(f, [Q - M, Q - N], 'post');

%Perform splitting first. 
S = qtdecomp(f, @split_test, mindim, fun);

% Now merge by looking at each quadregion and setting all its 
% elements to 1 if the block satisfies the predicate.

% Get the size of the largest block. Use full because S is sparse.	
Lmax = full(max(S(:)));
% Set the output image initially to all zeros.  The MARKER array is
% used later to establish connectivity.
g = zeros(size(f));
MARKER = zeros(size(f));
% Begin the merging stage.
for K = 1:Lmax 
   [vals, r, c] = qtgetblk(f, S, K);
   if ~isempty(vals)
      % Check the predicate for each of the regions
      % of size K-by-K with coordinates given by vectors
      % r and c.
      for I = 1:length(r)
         xlow = r(I); ylow = c(I);
         xhigh = xlow + K - 1; yhigh = ylow + K - 1;
         region = f(xlow:xhigh, ylow:yhigh);
         flag = feval(fun, region);
         if flag 
            g(xlow:xhigh, ylow:yhigh) = 1;
            MARKER(xlow, ylow) = 1;
         end
      end
   end
end

% Finally, obtain each connected region and label it with a
% different integer value using function bwlabel.
g = bwlabel(imreconstruct(MARKER, g));

% Crop and exit
	
g = g(1:M, 1:N);

%-------------------------------------------------------------------%
	
function v = split_test(B, mindim, fun)
	
% THIS FUNCTION IS PART OF FUNCTION SPLIT-MERGE. IT DETERMINES 
% WHETHER QUADREGIONS ARE SPLIT. The function returns in v 
% logical 1s (TRUE) for the blocks that should be split and 
% logical 0s (FALSE) for those that should not.

% Quadregion B, passed by qtdecomp, is the current decomposition of
% the image into k blocks of size m-by-m.

% k is the number of regions in B at this point in the procedure.
k = size(B, 3);

% Perform the split test on each block. If the predicate function
% (fun) returns TRUE, the region is split, so we set the appropriate
% element of v to TRUE. Else, the appropriate element of v is set to
% FALSE.
v(1:k) = false;
for I = 1:k
   quadregion = B(:, :, I);
   if size(quadregion, 1) <= mindim
      v(I) = false;
      continue
   end
   flag = feval(fun, quadregion);
   if flag
      v(I) = true;
   end
end
