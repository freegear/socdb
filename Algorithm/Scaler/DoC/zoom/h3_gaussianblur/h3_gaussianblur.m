function varargout = h3_gaussianblur(varargin)
% This GUI demonstrates Gaussian Blur, USM-Filter (Unblur/Sharpen)
% and Laplace-Filter, applied on different images.
%      
% Please start with 'h3_gaussianblur' at command window. 
%
% The original image is displayed on the top and the filtered image
% at the bottom. Different images can be selected from the image
% selection menu. Once a method is selected, the parameter
% selection options change accordingly. To view the filtered image,
% the "Apply" button should be pressed. For the Gaussian and the
% USM-filter, sigma (i.e. the standard deviation) and the size of
% mask are important, whereas for the Laplace filter, the value of
% the diffusion coefficient D and the number of steps influence
% blurriness and sharpness of the image. 
%
% Description of Methods:
% 1) Gaussian Blur:
%    This method uses the Gaussian function to calculate the
%    mask. The standard deviation (sigma) and the size of the mask
%    are parameters to be changed by user. With small sigma and
%    mask size, this filter tends to blur the image slightly. To
%    blur the image heavily, a larger sigma and mask size should be
%    applied. The following gaussian function is used to calculate
%    mask: 
%             G = exp(-a^2/(2*sigma^2)) / (sigma*sqrt(2*pi))
%
%    then, the mask M of size nxn is given as:
%
%        M(x,y) = G(x-(n+1)/2,sigma)*G(y-(n+1)/2,sigma)
%
%    where:  1<=x<=n and 1<=y<=n. 
%
%    Finally the original image matrix is convolved with this mask,
%    to get the filtered image.
%
% 2) USM-Filter:
%    This filter is the inverse of the Gaussian blur filter. It
%    sharpens the gaussian blurred image with the same
%    parameters. It works in the following way: 
%
%    sharpened_image = 2*original_image-gaussian_blured_image
%
% 3) Laplace-Filter:
%    This filter is to sharpen or blur the image. The algorithm is
%    based on the mechanism of diffusion in fluids. Each color
%    value of a pixel is interpreted as a concentration of
%    material. The partial differential equation describing the
%    diffusion process is given by 
%
%                      du/dt = D * (laplace u)
%
%    The value of D is responsible for either blurring or
%    sharpening the image. For positive values it sharpens and for
%    negative it blurs the image. 


% Author : Mirza Faisal Baig
% Version: 1.0
% Date   : July, 27 2003
%
% Variable definitions within GUIDE:
%
% image       : PopupMenu. List of images to be selected by the user
% method      : PopupMenu. Method to be selected by the user
% parameters  : Different in put for different methods
% vector_b    : Text box. User defined vector.
% Apply       : Push Button. To Start applying filter
% info        : Push Button. To display help
% close       : Push Button. to close the application


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h3_gaussianblur_OpeningFcn, ...
                   'gui_OutputFcn',  @h3_gaussianblur_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%----------------------------------------------------------
% --- Executes just before h3_gaussianblur is made visible.
function h3_gaussianblur_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
movegui(hObject,'onscreen')% To display application onscreen
movegui(hObject,'center')  % To display application in the center of screen
image_file = get(handles.image_selection,'String');
image_number = get(handles.image_selection,'Value');
im_original=imread(char(image_file(image_number)));
set(handles.original_image,'HandleVisibility','ON')
set(handles.filtered_image,'HandleVisibility','OFF')
imagesc(im_original)
axis equal;
axis tight;
set(handles.original_image,'XTickLabel',' ','YTickLabel',' ')


%----------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = h3_gaussianblur_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%----------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function image_selection_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%----------------------------------------------------------
% --- Executes on selection change in image_selection.
% Popup menu for image selection
function image_selection_Callback(hObject, eventdata, handles)

image_file = get(handles.image_selection,'String');
image_number = get(handles.image_selection,'Value');
im_original=imread(char(image_file(image_number)));
set(handles.original_image,'HandleVisibility','ON')
set(handles.filtered_image,'HandleVisibility','OFF')
imagesc(im_original)
axis equal;
axis tight;
set(handles.original_image,'XTickLabel',' ','YTickLabel',' ')
colormap(gray)

%----------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function sigma_value_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%----------------------------------------------------------
function sigma_value_Callback(hObject, eventdata, handles)

sigma = (get(handles.sigma_value,'Value'));
set(handles.sigma_value_display,'String',num2str(sigma,2))


%----------------------------------------------------------
% Executes on button press in apply_button.
function apply_button_Callback(hObject, eventdata, handles)

image_file = get(handles.image_selection,'String');  % to read the image filename selected
image_number = get(handles.image_selection,'Value'); % to read the number of the image selected
im_original=imread(char(image_file(image_number)));  % filename

set(handles.original_image,'HandleVisibility','ON')  % to make plot 1 visible for original image plot
set(handles.filtered_image,'HandleVisibility','OFF') % to make plot 2 unvisible to the original image plot
% imagesc(im_original) % to plot original image
set(handles.original_image,'XTickLabel',' ','YTickLabel',' ') % to get rid of tick labels
method_number = get(handles.method_selection,'Value'); % selected method

% For gaussian blur and USM-Filter method
if method_number == 1 | method_number == 2,
    mask_size = get(handles.mask_size,'String');       % size of the mask
    mask_size_number = get(handles.mask_size,'Value'); % size of the mask
    if mask_size_number == 1;
        n = 2;
        m = n;
    elseif mask_size_number  == 2;
        n = 3;
        m = n;
    elseif mask_size_number  == 3;
        n = 4;
        m = n;
    elseif mask_size_number  == 4;
        n = 5;
        m = n;
    end
    sigma = get(handles.sigma_value,'Value');                     % read value of the sigma
    set(handles.sigma_value_display,'String',num2str(sigma,2));     % set value of sigma for diaplay
    if method_number ==1,
        im_filtered = image_blur(im_original,sigma,n,m);          % filter image using image_blur function
    elseif method_number == 2,
         im_filtered = usm_filter(image_blur(im_original, sigma, n, m),im_original);
    end
% For Laplace Filter
elseif method_number == 3,
    D_value = get(handles.sigma_value,'Value');                   % read value of the sigma
    set(handles.sigma_value_display,'String',num2str(D_value,2));   % set value of sigma for diaplay
    n_steps = get(handles.mask_size,'String');                    % size of the mask
    im_filtered = laplace_filter(im_original,D_value,n_steps);    % apply laplace-filter
end

set(handles.original_image,'HandleVisibility','OFF') % to make plot 1 unvisible to the filtered image plot
set(handles.filtered_image,'HandleVisibility','ON')  % to make plot 2 visible to the filtered image plot
imagesc(im_filtered) % to plot filtered image
axis equal;
axis tight;
set(handles.filtered_image,'XTickLabel',' ','YTickLabel',' ') % to get rid of tick labels


%----------------------------------------------------------
% --- Executes on button press in info_button.
function info_button_Callback(hObject, eventdata, handles)
helpwin('h3_gaussianblur.m')   % Display help

%----------------------------------------------------------
% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
close(gcbf) % to close GUI

%----------------------------------------------------------
% Function to calculate filtered gaussian blur image
function res = image_blur(data,sigma,n,m)

x = double(data);                       % convert from uint8 to double
filter1 = i_gauss(n,sigma);             % applying i_gauss function to find filtered image
%center = (n+1)/2;
%res = zeros(size(data));
%for k=1:n
%    ki = k-center
%   for l=1:n
%       li = l-center
%       res(center:end-center+1,center:end-center+1) = ...
%           res(center:end-center+1,center:end-center+1) + ...
%           x(center-ki:end-ki-center+1,center-li:end-center-li+1).*filter1(k,l);
%   end
%end 
%res = uint8(res);

res = uint8(convn(x,filter1,'same'));   % convolve and convert to uint8 from double 

%----------------------------------------------------------
% Function to calculate gaussian mask matrix
function res = i_gauss(x_dim,sigma)
% Sigma is the standard deviation of the gaussian function
n = x_dim;           % Dimensions of gaussian mask matrix i.e., nxn
for i = 1:n,
    for j = 1:n
        M_temp = [j-(n+1)/2 i-(n+1)/2]';       
        M(i,j) = gauss(M_temp(1),sigma)*gauss(M_temp(2),sigma); % mask
    end
end
res = M/sum(sum(M)); % to normalize the mask

%----------------------------------------------------------
%Function to calculate Gaussian function
function res = gauss(x,sigma)

res = exp(-x^2/(2*sigma^2))/(sigma*sqrt(2*pi));

%----------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function method_selection_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%----------------------------------------------------------
% Function to apply USM-Filter
function res = usm_filter(im_filtered,im_original)

res = uint8(2*double(im_original)-double(im_filtered));


%----------------------------------------------------------
% --- Executes on selection change in method_selection.
% Pop up menu function for method selection and change parameter options
% accordingly
function method_selection_Callback(hObject, eventdata, handles)
method_number = get(handles.method_selection,'Value');

%For Gaussian Blur and USM-Filter
if method_number == 1 | method_number == 2,
    check_string = get(handles.text4,'String');
    if strcmp(check_string,'D Value')==1
    set(handles.text4,'String','Sigma  ')
    set(handles.text9,'String','Mask Size   ')
    set(handles.sigma_value,'Max',5,'Min',0.1,'Value',0.1,'String','0.1')
    set(handles.sigma_value_display,'Max',5,'Min',0.1,'Value',0.1,'String','0.1')
    set(handles.mask_size,'Style','popupmenu','String',['2x2'; '3x3'; '4x4'; '5x5'])
    end
% For Laplace Filter
elseif method_number == 3,
    set(handles.text4,'String','D Value')
    set(handles.sigma_value,'SliderStep',[0.01 0.01],'Max',0.01,'Min',-0.01,'Value',0.001)
    set(handles.sigma_value_display,'Value',0.001,'Max',0.01,'Min',-0.01,'String','0.001')
    set(handles.text9,'String','No. of Steps')
    set(handles.mask_size,'Style','Edit','String',50,'HorizontalAlignment','Center')%,'Position',[0.556 3.056 1.056 0.189])
end

%----------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%----------------------------------------------------------
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)

%----------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%----------------------------------------------------------
function edit2_Callback(hObject, eventdata, handles)

%----------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function mask_size_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%----------------------------------------------------------
% --- Executes on selection change in mask_size.
function mask_size_Callback(hObject, eventdata, handles)

%----------------------------------------------------------
function res = laplace_filter(image,D,nsteps)
% This function is to sharpen or blur images. The algorithm is
%    based on the mechanism of diffusion in fluids. Each color
%    value of a pixel is interpreted as a concentration of
%    material. The partial differential equation describing the
%    diffusion process is given by
%        du/dt = D * (laplace u).
%
%    Discretisation of this equation with finite differences gives
%    the following explicit scheme:
%
%        u(x,y,t+dt) = (1-4*dt*D/h^2) * u(x,y,t) +
%                      dt*D/h^2 [ u(x+h,y,t) + u(x-h,y,t) +
%                                 u(x,y+h,t) + u(x,y-h,t) ]
%
% See: Huckle/Schneider, Numerik für Informatiker, P. 298.
%
% Note: Negative values for the diffusion constant D will sharpen
%       the image, positive ones will blur the image.

% Author : Andreas Klimke, University of Stuttgart
% Version: 0.1
% Date   : May 12, 2003

% Define time step size dt and step width h (normalized to 1, since
% they are irrelevant for the application of image processing). 
dt = 1;
h = 1;

src = double(image);

% Perform the explicit iteration process for each pixel (the pixels
% at the boundary are ignored).
for n = 1:nsteps
	src(2:end-1,2:end-1) = (1-4*dt*D/h^2).* ...
			src(2:end-1,2:end-1) + dt*D/h^2*(src(1:end-2,2:end-1) + ...
		    src(3:end,2:end-1) + src(2:end-1,1:end-2) + ...
			src(2:end-1,3:end));
end
res = (uint8(src));
