function varargout = rqa(varargin)
% RQA MATLAB code for rqa.fig
%
% GUI Compiled By: Michael Richardson using MATLAB guide toolbox.
% 
% Code Developed and Adapted with/from numerous people over the years,  including (but not limited to):
% -	Michael Richardson, University of Macquarie (and while @ University of Cincinnati)
% -	Kevin Shockley: University of Cincinnati
% -	Rick Dale: UCLA (and while @ UC Merced)
% -	Jay Holden, University of Cincinnati
% -	Mike Riley: University of Cincinnati
% -	Bruce Kay: University of Connecticut
% -	Charles Coey, Harvard Medical School (and while @ University of Cincinnati
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rqa_OpeningFcn, ...
                   'gui_OutputFcn',  @rqa_OutputFcn, ...
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
% --- Executes just before rqa is made visible.
function rqa_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rqa (see VARARGIN)

% Choose default command line output for rqa
handles.output = hObject;
handles.RPMxtOut = 0;
handles.runBatch = 0;
handles.rescale = 1;
handles.normalize = 1;
handles.data1 = 0;
handles.data2 = 0;
handles.xRQA = 0;
handles.CatRQA = 0;
handles.file2open = 0;
handles.data1Length = 0;
handles.data2Length = 0;
set(handles.rbMean,'Value',1);
set(handles.rbMax,'Value',0);
set(handles.rbZscore,'Value',1);
set(handles.rbUnitInterval,'Value',0);

handles.pathname = '';

handles.prec = 0.0;
handles.pdet = 0.0;
handles.maxline = 0.0;
handles.meanline = 0.0;
handles.trend = 0.0;
handles.entropy = 0.0;

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = rqa_OutputFcn(hObject, eventdata, handles)
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
mll = str2double(get(handles.etMinLineLength, 'String'));
delay = str2double(get(handles.edTLag, 'String'));
embed = str2double(get(handles.edED, 'String'));
radius = str2double(get(handles.edRadius, 'String'));
rescale=handles.rescale;
normalize=handles.normalize;

if (handles.runBatch == 1)
    for i=1:handles.filesnum

        if handles.xRQA == 1
            handles.data1filename = strcat(handles.pathname, char(cellstr(handles.filenames1(i,:))));
            data1 = load(handles.data1filename);

            [n,m]=size(data1); %#ok<*ASGLU>

            if m~=1
                h = warndlg('Your data must consist of a single column of data; NO DATA LOADED', 'Data Error!'); uiwait(h); 
                set(handles.edFileName,'String','...');
                return
            end

            if n < 10
                h = warndlg('Your data must contain at least 10 samples', 'Data Error!'); uiwait(h); 
                set(handles.edFileName,'String','...');
                return
            end
            
            handles.data2filename = strcat(handles.pathname, char(cellstr(handles.filenames2(i,:))));
            data2 = load(handles.data2filename);
            [n,m]=size(data2); %#ok<*ASGLU>

            if m~=1
                h = warndlg('Your data must consist of a single column of data; NO DATA LOADED', 'Data Error!'); uiwait(h); 
                set(handles.edFileName,'String','...');
                return
            end

            if n < 10
                h = warndlg('Your data must contain at least 10 samples', 'Data Error!'); uiwait(h); 
                set(handles.edFileName,'String','...');
                return
            end

            rpFileName1 = char(cellstr(handles.filenames1(i,:)));
            rpFileName1 = strrep(rpFileName1, '.txt', '_');
            rpFileName2 = char(cellstr(handles.filenames2(i,:)));
            rpFileName2 = strrep(rpFileName2, '.txt', '_rpM.csv');
            handles.rpFileName = strcat(rpFileName1, rpFileName2);
            guidata(hObject, handles);

            CrossRecurrenceAnalysis (data1, data2, mll, delay, embed, radius, rescale, normalize, handles);
            OutputData(hObject, eventdata, handles); %, char(cellstr(handles.filenames1(i,:))), char(cellstr(handles.filenames2(i,:))));
        else
            handles.data1filename = strcat(handles.pathname, char(cellstr(handles.filenames1(i,:))));
            data1 = load(handles.data1filename);
            [n,m]=size(data1); %#ok<*ASGLU>

            rpFileName = char(cellstr(handles.filenames1(i,:)));
            rpFileName = strrep(rpFileName, '.txt', '_rpM.csv');
            handles.rpFileName = rpFileName;
            guidata(hObject, handles);

            if m~=1
                h = warndlg('Your data must consist of a single column of data; NO DATA LOADED', 'Data Error!'); uiwait(h); 
                set(handles.edFileName,'String','...');
                return
            end

            if n < 10
                h = warndlg('Your data must contain at least 10 samples', 'Data Error!'); uiwait(h); 
                set(handles.edFileName,'String','...');
                return
            end

            AutoRecurrenceAnalysis (data1, mll, delay, embed, radius, rescale, handles);
            OutputData(hObject, eventdata, handles); %, char(cellstr(handles.filenames1(i,:))), 'N/A');
        end

        pause(1);
    end
else
    if handles.xRQA == 1
        data1 = handles.data1;
        data2 = handles.data2;        
        CrossRecurrenceAnalysis (data1, data2, mll, delay, embed, radius, rescale, normalize,handles);
    else
        data1 = handles.data1;
        AutoRecurrenceAnalysis (data1, mll, delay, embed, radius, rescale,handles);
    end
    set(handles.pbOutputData,'Enable','On');
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles) %#ok<*INUSL>
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
function edTLag_Callback(hObject, eventdata, handles)
% hObject    handle to edTLag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
len = length(handles.data1);
temp = str2double(get(handles.edTLag, 'String'));
set(handles.edTLag, 'String', num2str(round(temp)));
if temp < 1
   temp = 1;
   set(handles.edTLag, 'String', num2str(temp));
end

if temp > len/4
    delay = 1;
    set(handles.edTLag, 'String', '1');
end

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edTLag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edTLag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function edED_Callback(hObject, eventdata, handles)
% hObject    handle to edED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
temp = str2double(get(handles.edED, 'String'));
set(handles.edED, 'String', num2str(round(temp)));
if temp < 1
   temp = 1;
   set(handles.edED, 'String', num2str(temp));
end

if temp > 20
   temp = 20;
   set(handles.edED, 'String', num2str(temp));
end

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function edRadius_Callback(hObject, eventdata, handles)
% hObject    handle to edRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.edRadius, 'String'));
if temp < 1
   temp = 1;
   set(handles.edRadius, 'String', num2str(temp));
end

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edREC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edREC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edDET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edDET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edMaxLine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMaxLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
% --- Executes on button press in pbOpenFile1.
function pbOpenFile1_Callback(hObject, eventdata, handles)
% hObject    handle to pbOpenFile1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.runBatch == 1)
    OpenBatchFile(hObject, eventdata, handles);
else
    currentFolder = pwd;
    inpath = strcat(currentFolder,'/*.txt');
    [FileName,PathName] = uigetfile(inpath,'Select a file',handles.pathname);
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

    if n < 10
        h = warndlg('Your data must contain at least 10 samples', 'Data Error!'); uiwait(h); 
        set(handles.edFileName,'String','...');
        return
    end

    shortest = n;
    handles.data1Length = n;
    guidata(hObject, handles);

    if (handles.xRQA == 1 && handles.file2open == 1)
        if handles.data1Length~=handles.data2Length
            shortest=min([handles.data1Length handles.data2Length]);
        else
            shortest = n;
        end
    end

    axes(handles.axRP);
    cla;
    axes(handles.axTS1);
    cla;
    axes(handles.axTS2);
    cla;

    set(handles.edREC,'String',' ');
    set(handles.edDET,'String',' ');
    set(handles.edMaxLine,'String',' ');
    set(handles.edMeanLine,'String',' ');
    set(handles.edEntropy,'String',' ');
    set(handles.edFileName,'String',FileName);
    handles.data1filename = FileName;

    if handles.xRQA == 1 && handles.file2open == 0
        set(handles.pbCalculate,'Enable','off');
    else
        set(handles.pbCalculate,'Enable','On');
    end
    set(handles.pbOutputData,'Enable','Off');

    handles.data1 = data;
    guidata(hObject, handles);

    axes(handles.axTS1);
    plot(handles.data1(1:shortest), 1:shortest, 'b');
    ylim([1 shortest]);

    axes(handles.axTS2);
    if (handles.xRQA == 1 && handles.file2open == 1)
        if handles.data1Length~=handles.data2Length
            shortest=min([handles.data1Length handles.data2Length]);
        else
            shortest = handles.data2Length;
        end
        plot(handles.data2(1:shortest), 'r');
        xlim([1 shortest]);
    else
        plot(handles.data1(1:shortest), 'b');
        xlim([1 shortest]);
    end
end

% --------------------------------------------------------------------
% --- Executes on button press in pbOpenBatchFile.
function OpenBatchFile(hObject, eventdata, handles)

[FileName,PathName] = uigetfile('*.txt','Select file with filenames to be analyzed');
handles.pathname = PathName;

if ~FileName 
    return
end

if handles.xRQA == 1 %#ok<*NODEF>
    [filenames1,filenames2]=textread([PathName FileName],'%s %s'); %#ok<*DTXTRD>
    [filesnum,trash]=size(filenames1);
    
    handles.filenames1 = filenames1;
    handles.filenames2 = filenames2;
    handles.filesnum = filesnum;
    guidata(hObject, handles);
    
else
    [filenames1]=textread([PathName FileName],'%s');
    [filesnum,trash]=size(filenames1);

    handles.filenames1 = filenames1;
    handles.filenames2 = filenames1;
    handles.filesnum = filesnum;
    guidata(hObject, handles);
end

clearGUI(handles);

axes(handles.axRP);
cla;
axes(handles.axTS1);
cla;
axes(handles.axTS2);
cla;

set(handles.edREC,'String',' ');
set(handles.edDET,'String',' ');
set(handles.edMaxLine,'String',' ');
set(handles.edMeanLine,'String',' ');
set(handles.edEntropy,'String',' ');
set(handles.edFileName,'String',FileName);
set(handles.pbCalculate,'Enable','On');

guidata(hObject, handles);
return


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
% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'rbMax'
        handles.rescale = 2;
    case 'rbMean'
         handles.rescale = 1;
end
guidata(hObject, handles);


% --------------------------------------------------------------------
% --- Executes on button press in pbOpenFile2.
function pbOpenFile2_Callback(hObject, eventdata, handles)
% hObject    handle to pbOpenFile2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentFolder = pwd;
inpath = strcat(currentFolder,'/*.txt');
[FileName2,PathName2] = uigetfile(inpath,'Select a file',handles.pathname);
if ~FileName2 
    return
end
handles.pathname = PathName2;
data2=load([PathName2 FileName2]);

[n,m]=size(data2);

if m~=1
    h = warndlg('Your data must consist of a single column of data; NO DATA LOADED', 'Data Error!'); uiwait(h); 
    set(handles.edFileName2,'String','...');
    return
end

if n < 10
    h = warndlg('Your data must contain at least 10 samples', 'Data Error!'); uiwait(h); 
    set(handles.edFileName2,'String','...');
    return
end

handles.data2Length = n;
guidata(hObject, handles);

axes(handles.axRP);
cla;
axes(handles.axTS1);
cla
axes(handles.axTS2);
cla;

set(handles.edREC,'String',' ');
set(handles.edDET,'String',' ');
set(handles.edMaxLine,'String',' ');
set(handles.edMeanLine,'String',' ');
set(handles.edEntropy,'String',' ');
set(handles.edFileName2,'String',FileName2);
handles.data2filename = FileName2;
handles.file2open = 1;
set(handles.pbCalculate,'Enable','On');
set(handles.pbOutputData,'Enable','Off');

handles.data2 = data2;
guidata(hObject, handles);

if handles.data1Length~=handles.data2Length
    shortest=min([handles.data1Length handles.data2Length]);
else
    shortest = handles.data2Length;
end

axes(handles.axTS1);
plot(handles.data1(1:shortest), 1:shortest, 'b');
ylim([1 shortest]);

axes(handles.axTS2);
plot(handles.data2(1:shortest), 'r');
xlim([1 shortest]);


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edFileName2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edFileName2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edMeanLine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMeanLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edEntropy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edEntropy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes on button press in cbXRQA.
function cbXRQA_Callback(hObject, eventdata, handles)
% hObject    handle to cbXRQA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xRQA = get(hObject,'Value');
set(handles.edFileName,'String','...');
set(handles.edFileName2,'String','...');
guidata(hObject, handles);
if (handles.xRQA == 1 && handles.runBatch == 0)
    set(handles.pbOpenFile2,'Enable','On');
    set(handles.pbCalculate,'Enable','Off');
    set(handles.pbOutputData,'Enable','Off');
    guidata(hObject, handles);
    clearGUI(handles)
    axes(handles.axTS1);
    cla;
    axes(handles.axTS2);
    cla;

else
    set(handles.pbOpenFile2,'Enable','Off');
    handles.file2open = 0;
    handles.data2Length = 0;
    set(handles.pbOutputData,'Enable','Off');
    guidata(hObject, handles);
    clearGUI(handles);
    axes(handles.axTS1);
    cla;
    axes(handles.axTS2);
    cla;
end

% --------------------------------------------------------------------
function clearGUI(handles)
    axes(handles.axRP);
    cla;

    set(handles.edREC,'String',' ');
    set(handles.edDET,'String',' ');
    set(handles.edMaxLine,'String',' ');
    set(handles.edMeanLine,'String',' ');
    set(handles.edEntropy,'String',' ');

    
% --------------------------------------------------------------------
% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'rbZscore'
        handles.normalize = 1;
    case 'rbUnitInterval'
         handles.normalize = 2;
end
guidata(hObject, handles);

% --------------------------------------------------------------------
% --- Executes on button press in pbOutputData.
function pbOutputData_Callback(hObject, eventdata, handles)
% hObject    handle to pbOutputData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputData(hObject, eventdata, handles);

% --------------------------------------------------------------------
% --- Executes on button press in pbOutputData.
function OutputData(hObject, eventdata, handles)
currentFolder = pwd;
outfilename = strcat(currentFolder,'/rqaStats.csv');

rescale = handles.rescale;
normalize = handles.normalize;
mll = str2double(get(handles.etMinLineLength, 'String'));
delay = str2double(get(handles.edTLag, 'String'));
embed = str2double(get(handles.edED, 'String'));
radius = str2double(get(handles.edRadius, 'String'));
prec = str2double(get(handles.edREC,'String'));
pdet = str2double(get(handles.edDET,'String'));
maxline = str2double(get(handles.edMaxLine,'String'));
meanline = str2double(get(handles.edMeanLine,'String'));
entropy = str2double(get(handles.edEntropy,'String'));

if exist(outfilename, 'file')==2
    fout = fopen(outfilename, 'a');
    if (handles.xRQA == 1)
        fprintf(fout,'%s, %s,',handles.data1filename, handles.data2filename);
    else
        fprintf(fout,'%s, N/A,',handles.data1filename);
    end
    fprintf(fout,'%d,%d,%d,%d,%d,%f,', normalize, mll, embed, delay, rescale, radius);
    fprintf(fout,'%f,%f,%f,%f,%f,%f,%f,', prec, pdet, maxline, meanline, entropy);
    fprintf(fout,'\n');
    fclose(fout);
else
    fout = fopen(outfilename, 'a');
    fprintf(fout,'File1,File2,Normalize (1=zscore),MLL,EDim,TLag,Rescale (1=mean),Radius,REC,DET,Maxline,Meanline,Entropy\n');
    if (handles.xRQA == 1)
        fprintf(fout,'%s, %s,',handles.data1filename, handles.data2filename);
    else
        fprintf(fout,'%s, N/A,',handles.data1filename);
    end
    fprintf(fout,'%d,%d,%d,%d,%d,%f,', normalize, mll,embed, delay, rescale, radius);
    fprintf(fout,'%f,%f,%f,%f,%f,%f,%f,', prec, pdet, maxline, meanline, entropy);
    fprintf(fout,'\n');
    fclose(fout);
end

% --------------------------------------------------------------------
% --- Executes on button press in pbDelay.
function pbDelay_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to pbDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ami;
%system('amiGUI.exe');

% --------------------------------------------------------------------
% --- Executes on button press in pbEmbed.
function pbEmbed_Callback(hObject, eventdata, handles)
% hObject    handle to pbEmbed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fnn;
%system('fnnGUI.exe');

% --------------------------------------------------------------------
% --- Executes on button press in cbCategorical.
function cbCategorical_Callback(hObject, eventdata, handles)
% hObject    handle to cbCategorical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CatRQA = get(hObject,'Value');
guidata(hObject, handles);
if handles.CatRQA == 1
    set(handles.edRadius,'String','0.0');
    set(handles.edRadius,'Enable','Off');
    set(handles.edTLag,'String','1');
    set(handles.edED,'String','1');    
    set(handles.rbMean,'Enable','Off');
    set(handles.rbMean,'Value',0);
    set(handles.rbMax,'Enable','Off');
    set(handles.rbMax,'Value',0);   
    set(handles.rbZscore,'Enable','Off');
    set(handles.rbZscore,'Value',0);
    set(handles.rbUnitInterval,'Enable','Off');
    set(handles.rbUnitInterval,'Value',0);
    set(handles.pbOutputData,'Enable','Off');
    set(handles.pbDelay,'Enable','Off');
    set(handles.pbEmbed,'Enable','Off');
    clearGUI(handles)
else
    set(handles.edRadius,'String','10');
    set(handles.edRadius,'Enable','On');
    set(handles.edTLag,'String','15');
    set(handles.edED,'String','3');
    set(handles.rbMean,'Enable','On');
    set(handles.rbMean,'Value',1);
    set(handles.rbMax,'Enable','On');
    set(handles.rbMax,'Value',0);
    set(handles.rbZscore,'Enable','On');
    set(handles.rbUnitInterval,'Enable','On');
    set(handles.rbZscore,'Value',1);
    set(handles.rbUnitInterval,'Value',0);
    set(handles.pbOutputData,'Enable','Off');
    set(handles.pbDelay,'Enable','On');
    set(handles.pbEmbed,'Enable','On');
    clearGUI(handles);
end

% --------------------------------------------------------------------
function AutoRecurrenceAnalysis (data, mll, delay, embed, radius, rescale, handles)

[rows,cols]=size(data); %#ok<*NASGU>

markersize=round(10000/rows)./10;

counter=0;
wb = waitbar(counter,'Computing Recurrence Matrix. Please wait...');

counter=counter+.1;
waitbar(counter,wb);

%Create surrogate dimension data vectors
for loop=1:embed
    vectorstart=(loop-1).*delay+1;
    vectorend=rows-((embed-loop).*delay);
    eval(['v' num2str(loop) '=data(' num2str(vectorstart) ':' num2str(vectorend) ');']);
end %embedding loop

counter=counter+.1;
waitbar(counter,wb);


%Create matrix from vectors to use for distance matrix calcs
for loop=1:embed
    if loop==1
        dimdata=v1;
    else
        eval(['dimdata=[dimdata v' num2str(loop) '];']);
    end %End if statement
end %loop loop

counter=counter+.1;
waitbar(counter,wb);

%Calculate Euclidean Distance Matrix dm

[vlength,columns]=size(v1);

%Compute euclidean distance matrix
dm=squareform(pdist(dimdata));

counter=counter+.1;
waitbar(counter,wb);

%Find indeces of the distance matrix that fall within prescribed radius.
if handles.CatRQA ~= 1 % dont do if categorical reccurrence
    switch rescale
        case 1
            %Create a distance matrix that is re-scaled to the mean distance
            rescaledist=mean(mean(dm)');
            dmrescale=(dm./rescaledist).*100;
        case 2
            %Create a distance matrix that is re-scaled to the max distance
            rescaledist=max(max(dm)');
            dmrescale=(dm./rescaledist).*100;
    end%End switch rescale
end

%Compute recurrence matrix
if handles.CatRQA ~= 1 % dont do if categorical reccurrence
    [r,c]=find(dmrescale<=radius);
else
    [r,c]=find(dm==0);
end
%[r,c]=find(dmrescale<=radius);

S=sparse(r,c,1);     % Create a SPARSE matrix, S, use as the Recurrence maxtrix. 
                         % One could clear the DistanceMatrix to free memory at this
                         % point.

counter=counter+.1;
waitbar(counter,wb);

[recurs,nothing]=size(r);

%disp(['Get triangular regions']);tic
newindexr=find(r>c);
newindexc=find(c>r);
%lowertricoord=[r(newindexr) c(newindexr)];
uppertri=triu(S,1);

%uppertricoord=[r(newindexc) c(newindexc)];
lowertri=tril(S,-1);

%disp(['Calcualte recur on one triangular region']);tic
numrecurs=nnz(uppertri);
percentrecurs=(numrecurs./((vlength.^2-vlength)./2)).*100;

counter=counter+.1;
waitbar(counter,wb);

clear lines

[B,d]=spdiags(uppertri);

 
%% COMPUTING THE LINE COUNTS
minline=mll; % set a minimum line length, this can become an option.

% This section finds the index of the zeros in the matrix B,
% which contains the diagonals of one triangle of the recurrence matrix
% (the idenity line excluded). The find command indexes the matrix sequentially
% from 1 to the total number of elements. The element numbers for a 2X2 matrix
% would be [1 3; 2 4]. You get a hit for every zero. If you take the
% difference of the resulting vector, minus 1, it yields the length of an
% interceding vector of ones, a line. Here is an e.g. using a row vector
% rather than a col. vector, since it types easier: B=[0 1 1 1 0], a line of
% length 3.  find(B==0) yields [1 5], diff([1 5])-1=3, the line length. So
% this solution finds line lengths in the interior of the B matrix, BUT
% fails if a line butts up against either edge of the B matrix, e.g. say
% B=[0 1 1 1 1], find(B==0) returns a 1, and you miss the line of length 4.
% A solution is to "bracket" B with a row of zeros at each top and bottom.

%"Bracket B with zeros"
B=[zeros(1,size(B,2)); B ; zeros(1,size(B,2))];
%Get list of line lengths, sorted from largest to smallest
lines=sort(diff(find(B==0))-1,'descend');

%Delete line counts less than the minimum.
lines(lines<minline)=[]; %lines(lines>200)=[]; % Can define a maximum line length too.
numlines=length(lines);
maxline=max(lines);
meanline=mean(lines);
    
   
    
%% COMPUTE ENTROPY, USE LOG BASE 2, DIVIDE BY MAX ENTROPY TO GET RELATIVE
%  ENTROPY
    [count,bin]=hist(lines,minline:maxline);
    total=sum(count);
    p=count./total;
    del=find(count==0); p(del)=[];
    entropy=-1*sum(p.*log2(p));
    % Transform to relative entropy: entropy/max entropy
    % More comparable across contexts and conditions.
    RelEnt=entropy/(-1*log2(1/length(bin)));

%% COMPUTE PERCENT DETERMINISM
    pdeter=(sum(lines)/numrecurs)*100;


counter=counter+.1;
waitbar(counter,wb);

close(wb)

axes(handles.axRP);
plot(r,c,'.m','MarkerSize',markersize,'MarkerEdgeColor',[1 .5 .2]);xlim([1 vlength]);ylim([1 vlength]);axis square;xlabel('i');ylabel('j');

axes(handles.axTS1);
plot(data, 1:length(data));
ylim([1 length(data)]);

axes(handles.axTS2);
plot(data);
xlim([1 length(data)]);

if (handles.RPMxtOut == 1)
    rpMxt = full(S);
    
    rpFileName = get(handles.edFileName, 'String');
    rpFileName = strrep(rpFileName, '.txt', '_rpM.csv');
    
    currentFolder = pwd;
    inpath = strcat(currentFolder,'/rpFileName');
    csvwrite(rpFileName, rot90(rpMxt));
end

set(handles.edREC,'String',num2str(percentrecurs));
set(handles.edDET,'String',num2str(pdeter));
set(handles.edMaxLine,'String',num2str(maxline));
set(handles.edMeanLine,'String',num2str(meanline));
set(handles.edEntropy,'String',num2str(entropy));


% --------------------------------------------------------------------
function CrossRecurrenceAnalysis (data1, data2, mll, delay, embed, radius, rescale, normalize, handles)

if length(data1)~=length(data2)
    shortest=min([length(data1) length(data2)]);
    data1=data1(1:shortest);
    data2=data2(1:shortest);
end

[rows,cols]=size(data1);
markersize=round(10000/rows)./10;

if handles.CatRQA ~= 1 % dont do if categorical reccurrence
    switch normalize
        case 1
            data1=zscore(data1);data2=zscore(data2);        
        case 2
            data1=(data1-min(data1));
            data1=data1./max(data1);
            data2=(data2-min(data2));
            data2=data2./max(data2);
    end  %End switch
end
counter=0;
wb = waitbar(counter,'Computing Recurrence Matrix. Please wait...');

clear euclid
[rows,cols]=size(data1);

counter=counter+.1;
waitbar(counter,wb);

%Create surrogate dimension data vectors
for loop=1:embed
    vectorstart=(loop-1).*delay+1;
    vectorend=rows-((embed-loop).*delay);
    eval(['v1' num2str(loop) '=data1(' num2str(vectorstart) ':' num2str(vectorend) ');']);
end %embedding loop

for loop=1:embed
    vectorstart=(loop-1).*delay+1;
    vectorend=rows-((embed-loop).*delay);
    eval(['v2' num2str(loop) '=data2(' num2str(vectorstart) ':' num2str(vectorend) ');']);
end %embedding loop

%plot3(vector1,vector2,vector3)

counter=counter+.1;
waitbar(counter,wb);

%Create matrix from vectors to use for distance matrix calcs
for loop=1:embed
    if loop==1
        dimdata1=v11;
    else
        eval(['dimdata1=[dimdata1 v1' num2str(loop) '];']);
    end %End if statement
end %loop loop

for loop=1:embed
    if loop==1
        dimdata2=v21;
    else
        eval(['dimdata2=[dimdata2 v2' num2str(loop) '];']);
    end %End if statement
end %loop loop

dimdata=[dimdata1;dimdata2];

counter=counter+.1;
waitbar(counter,wb);

%Calculate Euclidean Distance Matrix dm

[vlength,columns]=size(v11);

%Compute euclidean distance matrix
dmtemp=squareform(pdist(dimdata));

dm=dmtemp(1:vlength,vlength+1:2*vlength);

counter=counter+.1;
waitbar(counter,wb);

%disp(['Finding distances within radius']);tic
%Find indeces of the distance matrix that fall within prescribed radius.
if handles.CatRQA ~= 1 % dont do if categorical reccurrence
    switch rescale
        case 1
            %Create a distance matrix that is re-scaled to the mean distance
            rescaledist=mean(mean(dm)'); %#ok<*UDIM>
            dmrescale=(dm./rescaledist).*100;
        case 2
            %Create a distance matrix that is re-scaled to the max distance
            rescaledist=max(max(dm)');
            dmrescale=(dm./rescaledist).*100;
    end%End switch rescale
end

%Compute recurrence matrix
if handles.CatRQA ~= 1 % dont do if categorical reccurrence
    [r,c]=find(dmrescale<=radius);
else
    [r,c]=find(dm==0);
end

S=sparse(r,c,1);  


[B,d]=spdiags(S);

counter=counter+.1;
waitbar(counter,wb);

numrecurs=nnz(B);
percentrecurs=(numrecurs./((vlength.^2))).*100;

counter=counter+.1;
waitbar(counter,wb);

clear lines

%% COMPUTING THE LINE COUNTS
minline=mll; % set a minimum line length, this can become an option.

% This section finds the index of the zeros in the matrix B,
% which contains the diagonals of one triangle of the recurrence matrix
% (the idenity line excluded). The find command indexes the matrix sequentially
% from 1 to the total number of elements. The element numbers for a 2X2 matrix
% would be [1 3; 2 4]. You get a hit for every zero. If you take the
% difference of the resulting vector, minus 1, it yields the length of an
% interceding vector of ones, a line. Here is an e.g. using a row vector
% rather than a col. vector, since it types easier: B=[0 1 1 1 0], a line of
% length 3.  find(B==0) yields [1 5], diff([1 5])-1=3, the line length. So
% this solution finds line lengths in the interior of the B matrix, BUT
% fails if a line butts up against either edge of the B matrix, e.g. say
% B=[0 1 1 1 1], find(B==0) returns a 1, and you miss the line of length 4.
% A solution is to "bracket" B with a row of zeros at each top and bottom.

%"Bracket B with zeros"
B=[zeros(1,size(B,2)); B ; zeros(1,size(B,2))];
%Get list of line lengths, sorted from largest to smallest
lines=sort(diff(find(B==0))-1,'descend');

%Delete line counts less than the minimum.
lines(lines<minline)=[]; %lines(lines>200)=[]; % Can define a maximum line length too.
numlines=length(lines);
maxline=max(lines);
meanline=mean(lines);
    
%% COMPUTE ENTROPY, USE LOG BASE 2, DIVIDE BY MAX ENTROPY TO GET RELATIVE
%  ENTROPY
    [count,bin]=hist(lines,minline:maxline);
    total=sum(count);
    p=count./total;
    del=find(count==0); p(del)=[]; %#ok<*FNDSB>
    entropy=-1*sum(p.*log2(p));
    % Transform to relative entropy: entropy/max entropy
    % More comparable across contexts and conditions.
    RelEnt=entropy/(-1*log2(1/length(bin)));

%% COMPUTE PERCENT DETERMINISM
    pdeter=(sum(lines)/numrecurs)*100;
    
counter=counter+.1;
waitbar(counter,wb);

close(wb)
axes(handles.axRP);
plot(r,c,'.m','MarkerSize',markersize,'MarkerEdgeColor',[1 .5 .2]);xlim([1 vlength]);ylim([1 vlength]);axis square;xlabel('i');ylabel('j');

axes(handles.axTS1);
plot(data1, 1:length(data1), 'b');
ylim([1 length(data1)]);

axes(handles.axTS2);
plot(data2, 'r');
xlim([1 length(data2)]);

if (handles.RPMxtOut == 1)
    rpMxt = full(S);
    rpFileName1 = get(handles.edFileName, 'String');
    rpFileName1 = strrep(rpFileName1, '.txt', '_');
    rpFileName2 = get(handles.edFileName2, 'String');
    rpFileName2 = strrep(rpFileName2, '.txt', '_rpM.csv');
    rpFileName = strcat(rpFileName1, rpFileName2);
    
    currentFolder = pwd;
    inpath = strcat(currentFolder,'/rpFileName');
    csvwrite(rpFileName, rot90(rpMxt));
end

set(handles.edREC,'String',num2str(percentrecurs));
set(handles.edDET,'String',num2str(pdeter));
set(handles.edMaxLine,'String',num2str(maxline));
set(handles.edMeanLine,'String',num2str(meanline));
set(handles.edEntropy,'String',num2str(entropy));


% --------------------------------------------------------------------
function etMinLineLength_Callback(hObject, eventdata, handles)
% hObject    handle to etMinLineLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mll = str2double(get(handles.etMinLineLength, 'String'));

if mll < 2
   mll = 2;
end

if mll > 50
    mll = 2;
end

set(handles.etMinLineLength, 'String', num2str(round(mll)));

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function etMinLineLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etMinLineLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes on button press in cbRPMatrix.
function cbRPMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to cbRPMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.RPMxtOut = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in chBatch.
function chBatch_Callback(hObject, eventdata, handles)
% hObject    handle to chBatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.runBatch = get(hObject,'Value');
guidata(hObject, handles);
if (handles.runBatch == 1)
    set(handles.pbCalculate,'String','Run Batch');
    set(handles.pbOpenFile2,'Enable','Off');
    set(handles.edFileName,'String','...');
    set(handles.edFileName2,'String','...');
    set(handles.pbOpenFile1, 'String','Open Batch File');
    handles.file2open = 0;
    handles.data2Length = 0;
    set(handles.pbOutputData,'Enable','Off');
    guidata(hObject, handles);
    clearGUI(handles);
    axes(handles.axTS2);
    cla;
    axes(handles.axTS1);
    cla;
else
    set(handles.pbCalculate,'String','Calculate');
    set(handles.edFileName,'String','...');
    set(handles.edFileName2,'String','...');
    set(handles.pbOpenFile1, 'String','Open File 1');
    if (handles.xRQA == 1)
        set(handles.pbOpenFile2,'Enable','On');
    end
    set(handles.pbCalculate,'Enable','Off');
    set(handles.pbOutputData,'Enable','Off');
    guidata(hObject, handles);
    clearGUI(handles)
    axes(handles.axTS2);
    cla;
    axes(handles.axTS1);
    cla;
end
guidata(hObject, handles);
