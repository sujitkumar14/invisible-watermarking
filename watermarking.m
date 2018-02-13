function varargout = watermarking(varargin)
% WATERMARKING MATLAB code for watermarking.fig
%      WATERMARKING, by itself, creates a new WATERMARKING or raises the existing
%      singleton*.
%
%      H = WATERMARKING returns the handle to a new WATERMARKING or the handle to
%      the existing singleton*.
%
%      WATERMARKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERMARKING.M with the given input arguments.
%
%      WATERMARKING('Property','Value',...) creates a new WATERMARKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before watermarking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to watermarking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help watermarking

% Last Modified by GUIDE v2.5 09-Apr-2017 22:03:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @watermarking_OpeningFcn, ...
                   'gui_OutputFcn',  @watermarking_OutputFcn, ...
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


% --- Executes just before watermarking is made visible.
function watermarking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to watermarking (see VARARGIN)

% Choose default command line output for watermarking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes watermarking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = watermarking_OutputFcn(hObject, eventdata, handles) 
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
[coverImagefilename coverImagepathname] = uigetfile('*.jpg','select a folder');
axes(handles.axes1);
matlabImage = imread(strcat(coverImagepathname,coverImagefilename));
image(matlabImage);
axis off
axis image
handles.coverImagefilename = coverImagefilename;
handles.coverImagepathname = coverImagepathname;
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[watermarkImagefilename watermarkImagepathname] = uigetfile('*.jpg','select a folder');
axes(handles.axes2);
matlabImage = imread(strcat(watermarkImagepathname,watermarkImagefilename));
image(matlabImage);
axis off
axis image
handles.watermarkImagefilename = watermarkImagefilename;
handles.watermarkImagepathname = watermarkImagepathname;
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
coverImagefilename = handles.coverImagefilename
coverImagepathname = handles.coverImagepathname
watermarkImagefilename = handles.watermarkImagefilename
watermarkImagepathname = handles.watermarkImagepathname

[bBlockOut] = watermarkingFunction(strcat(coverImagepathname,coverImagefilename),strcat(watermarkImagepathname,watermarkImagefilename));
handles.bBlockOut = bBlockOut;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bBlockOut = handles.bBlockOut
deWatermarkingfunction(bBlockOut)
