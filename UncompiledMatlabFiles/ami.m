function varargout = ami(varargin)
% AMI MATLAB code for ami.fig
%
% GUI Compiled By: Michael Richardson using MATLAB guide toolbox.
% 
% Code Developed and Adapted with/from numerous people over the years,  including (but not limited to):
% ?	Michael Richardson, University of Macquarie (and while @ University of Cincinnati)
% ?	Kevin Shockley: University of Cincinnati
% ?	Rick Dale: UCLA (and while @ UC Merced)
% ?	Jay Holden, University of Cincinnati
% ?	Mike Riley: University of Cincinnati
% ?	Bruce Kay: University of Connecticut
% ?	Charles Coey, Harvard Medical School (and while @ University of Cincinnati
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ami_OpeningFcn, ...
                   'gui_OutputFcn',  @ami_OutputFcn, ...
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

% --------------------------------------------------------------------
% --- Executes just before ami is made visible.
function ami_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ami (see VARARGIN)

% Choose default command line output for ami
set(handles.edMinDelay, 'Enable', 'Off');
set(handles.edMaxDelay, 'Enable', 'Off');
handles.output = hObject;
handles.pathname = '';

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = ami_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
% --- Executes on button press in pbCalculate.
function pbCalculate_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to pbCalculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
amiCalc(hObject, handles);

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --------------------------------------------------------------------
function edMinDelay_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to edMinDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delayMax = str2double(get(handles.edMaxDelay, 'String'));
delayMin = str2double(get(handles.edMinDelay, 'String'));
set(handles.edMinDelay, 'String', num2str(round(delayMin)));
if delayMin < 1
    set(handles.edMinDelay, 'String', '1');
end

if delayMin > delayMax
    set(handles.edMinDelay, 'String', '1');
end

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edMinDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMinDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function edMaxDelay_Callback(hObject, eventdata, handles)
% hObject    handle to edMaxDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.data;
delayMax = str2double(get(handles.edMaxDelay, 'String'));
delayMin = str2double(get(handles.edMinDelay, 'String'));
set(handles.edMaxDelay, 'String', num2str(round(delayMax)));
if delayMax < 2
    set(handles.edMaxDelay, 'String', '1');
end

if delayMax < delayMin
    set(handles.edMaxDelay, 'String', num2str(delayMin+1));
end

if delayMax > length(data)/4
    set(handles.edMaxDelay, 'String', num2str(round(length(data)/4)));
end

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edMaxDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMaxDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on button press in pbOpenFile.
function pbOpenFile_Callback(hObject, eventdata, handles)
% hObject    handle to pbOpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.txt','Select a file',handles.pathname);
if ~FileName
    return
end
handles.pathname = PathName;
data=load([PathName FileName]);

[n,m]=size(data); %#ok<*ASGLU>
if m~=1
    h = warndlg('Your data must consist of a single column of data; NO DATA LOADED', 'Data Error!'); uiwait(h); 
    set(handles.edFileName,'String','...');
    return
end
axes(handles.axAmiFunction);
cla;

axes(handles.axTS);
plot(data);
xlabel('Time (samples)');
ylabel('Data');

set(handles.edFileName,'String',FileName);

set(handles.pbCalculate,'Enable','On');
set(handles.edMinDelay, 'Enable', 'On');
set(handles.edMaxDelay, 'Enable', 'On');

handles.data = data;

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function clearGUI(handles)
axes(handles.axTS);
cla;
axes(handles.axTS1);
cla;
axes(handles.axAmiFunction);
cla;
return;

% --------------------------------------------------------------------
function amiCalc(hObject, handles)
%	BY: C. A. Coey and Michael Richardson (03/11/2013)
%   Based on example code  by Alexandros Leontitsis 

x=handles.data;
len = length(x);

min_lag=str2double(get(handles.edMinDelay, 'String'));
max_lag=str2double(get(handles.edMaxDelay, 'String'));

%% Create Lag Vector
if max_lag <= (len/2 - 1)
    if min_lag < max_lag
        i = min_lag;
        j = 1;
        while i <= max_lag
            lag(j) = i;
            j = j+1;
            i = i+1;
        end
    else
        lag = (0:50);
    end
else
    lag = (0:(len/2 - 1));
end

%% Compute Average Mutual Information
x=x-min(x);
x=x/max(x);
h = waitbar(0, 'Processing AMI...');
for i=1:length(lag)
   % Define the number of bins
   k=floor(1+log2(len-lag(i))+0.5);
   
   % If the time series has no variance then the MAI is 0
   if var(x,1)==0
      v(i)=0;
   else
      v(i)=0;
      for k1=1:k
         for k2=1:k
             
            ppp=find((k1-1)/k<x(1:len-lag(i)) & x(1:len-lag(i))<=k1/k ...
               & (k2-1)/k<x(1+lag(i):len) & x(1+lag(i):len)<=k2/k);
            ppp=length(ppp);
            px1=find((k1-1)/k<x(1:len-lag(i)) & x(1:len-lag(i))<=k1/k);
            px2=find((k2-1)/k<x(1+lag(i):len) & x(1+lag(i):len)<=k2/k);
            if ppp>0
               ppp=ppp/(len-lag(i));
               px1=length(px1)/(len-lag(i));
               px2=length(px2)/(len-lag(i));
               v(i)=v(i)+ppp*log2(ppp/px1/px2);
            end
         end
      end
   end
   waitbar(i/length(lag), h);
end
delete(h);

% Plot AMI Function
axes(handles.axAmiFunction);
plot(lag,v,'ko',lag,v,'b:','MarkerSize',4)
xlabel('Delay (data points)')
ylabel('Average Mutual Information (bits)')

return;
