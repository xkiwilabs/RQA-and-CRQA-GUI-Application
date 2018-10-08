function varargout = fnn(varargin)
% FNN MATLAB code for fnn.fig
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
% ?	Steven Boker: University of Virginia
% ?	Charles Coey, Harvard Medical School (and while @ University of Cincinnati
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fnn_OpeningFcn, ...
                   'gui_OutputFcn',  @fnn_OutputFcn, ...
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
% --- Executes just before fnn is made visible.
function fnn_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fnn (see VARARGIN)

% Choose default command line output for fnn
handles.output = hObject;
set(handles.edDelay, 'Enable', 'Off');
set(handles.edMinEDim, 'Enable', 'Off');
set(handles.edMaxEDim, 'Enable', 'Off');
handles.pathname = '';
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = fnn_OutputFcn(hObject, eventdata, handles)
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
fnnCalc(hObject, handles);

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
function edDelay_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to edDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.data;
delay = str2double(get(handles.edDelay, 'String'));
set(handles.edDelay, 'String', num2str(round(delay)));
if delay < 1
    set(handles.edDelay, 'String', '1');
end

if delay > length(data)/4
    set(handles.edDelay, 'String', '1');
end

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edDelay (see GCBO)
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

[n,m]=size(data);

if m~=1
    h = warndlg('Your data must consist of a single column of data; NO DATA LOADED', 'Data Error!'); uiwait(h); 
    set(handles.edFileName,'String','...');
    return
end

delay = str2double(get(handles.edDelay, 'String'));
if delay > length(data)/4
    set(handles.edDelay, 'String', '1');
end

axes(handles.axFnnFunction);
cla;

axes(handles.axTS);
plot(data);
xlabel('Time (samples)');
ylabel('Data');

set(handles.edFileName,'String',FileName);

set(handles.pbCalculate,'Enable','On');
set(handles.edDelay, 'Enable', 'On');
set(handles.edMinEDim, 'Enable', 'On');
set(handles.edMaxEDim, 'Enable', 'On');

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
function edMinEDim_Callback(hObject, eventdata, handles)
% hObject    handle to edMinEDim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.edMinEDim, 'String'));
temp2 = str2double(get(handles.edMaxEDim, 'String'));
set(handles.edMinEDim, 'String', num2str(round(temp)));
if temp < 1
    set(handles.edMinEDim, 'String', '1');
end

if temp > temp2
    set(handles.edMinEDim, 'String', '1');
end

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edMinEDim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMinEDim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function edMaxEDim_Callback(hObject, eventdata, handles)
% hObject    handle to edMaxEDim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2double(get(handles.edMinEDim, 'String'));
temp2 = str2double(get(handles.edMaxEDim, 'String'));
set(handles.edMaxEDim, 'String', num2str(round(temp2)));
if temp2 < 2
    set(handles.edMaxEDim, 'String', '2');
end

if temp2 > 20
    set(handles.edMaxEDim, 'String', '20');
end

if temp2 < temp
    set(handles.edMaxEDim, 'String', num2str(temp+1));
end

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edMaxEDim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edMaxEDim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function fnnCalc(hObject, handles) %#ok<*INUSL>
%Performs Global False Nearest Nieghbor analysis
%input:
%	min_dimension(scalar):the smallest number of dimensions to check
%	max_dimension(scalar):the max number of dimensions to check.
%	lag(scalar):the lag (in samples) to use between dimensions in the embedding
%
%returns:
%	percents(1D):percent(i) is the percent of points in a de(i)embedding who's nearest nieghbor
%	seems to be false.  percents is max_dimension in length.  A neighbor is called false if the change
%	in distance between the point and the nearest neighbor that occurs when another dimension is added
%	to the embedding in greater than 15 time the distance in the current embedding.  See Abarbanel's book,
%	Analysis of Observed Chaotic Data, pages 40-50 for more details. 
%	de(1D):the tested embedding dimensions, such that percent(i) is the percent of false nearest nieghbors
%	in a de(i) embedding
%
%   All based on code borrowed from Steve Boker and Bruce Kay

% Load Data
x_data = handles.data;
time_series = x_data(:,1);
tlag = str2double(get(handles.edDelay, 'String'));
min_dimension = str2double(get(handles.edMinEDim, 'String'));
max_dimension = str2double(get(handles.edMaxEDim, 'String'));

% Borrowed Code from Steve Boker and Bruce Kay
percent=ones(max_dimension-min_dimension+1,1);

%in order to compensate for "short" (not infinite!) time series, it may be necessary to 
%rule points out based on the attractor width.  To estimate this we need the mean and the
%square difference between the mean and each point
mean_x=mean(time_series);
Ra=sqrt((1/length(time_series))*sum((time_series-repmat(mean_x,size(time_series))).^2)); 	

%the main loop indexes through the desired embedding dimensions
de=min_dimension:max_dimension;
h = waitbar(0, 'Processing FNN...');
for c=min_dimension:max_dimension
   %some initialization
   number_false=0;		
   max_l=length(time_series)-(c)*tlag;
   
   %do the embedding
   curr_embedding=embed_time_series(time_series,c,tlag);
   
   %build a kd tree to find neighborhoods.  There are currently 100
   %points set as the limit for leaf creation.  If you wish to 
   %modify this number, change the last argument in the call below
   %to the number of points that you want. 
   
   %I believe it is possible to optimize this routine quite a bit by
   %making better use of the kd-tree.  I just have not done it yet. wjd
   tree=make_kd_tree(curr_embedding,1:length(curr_embedding),500);
   %index through the current embedding 
   for c2=1:max_l
      %search the tree for the nearest neighbor
      [NN,nearest_d]=find_the_nearest_neighbor(tree,curr_embedding(c2,:),c2);
      
      if  NN > max_l
         %we cannot find this point in the next embedding because we are at the end of the data.
         %so we assume it is NOT false
         test_stat1=0;
         test_stat2=0;
      else			
         %we can find the NN in the next embedding, so test the distance change
         if nearest_d==0
            %the (hopefully) unusual case in which two points happen to exactly occupy the
            %same point in embedding space.  This is likely caused by insufficient sampling
            %resolution
            test_stat1=1;
         else
            %in the most common case we will use this line to calculate the 
            %ratio between the change in distance between points c2 and NN that
            %occurs when we add a dimension to the distance between then in the
            %current embedding. 	
            test_stat1=abs(time_series(c2+c*tlag)-time_series(NN+c*tlag))/nearest_d;
         end
         %To test the case of a "distant" nearest neighbor we compare the distance at the next higher
         %embedding d to Ra from above
         test_stat2=abs(time_series(c2+c*tlag)-time_series(NN+c*tlag))/Ra;
         
      end
      
      %Abarbanel suggests that we use 15 (or so as a cut off value) for stat1,  and 2 for stat2, so we will.
      %a nearest neighbor counts as false if either test_stat1 is >=15 or test_stat2 is >=2
      number_false=number_false+((test_stat1>=15)|(test_stat2>=2));
   end
   percent(c-min_dimension+1)=number_false/max_l;
   %fprintf('\tresult-> %5.2f percent\n',percent(c-min_dimension+1)*100);
      
   waitbar(c/length(de), h);
end
delete(h);

% Do Plots
axes(handles.axFnnFunction);
plot(de, percent*100, 'b-o', 'MarkerSize', 8);
strValues = strtrim(cellstr(num2str(percent*100,'%.2f')));
text(de, percent*100,strValues,'VerticalAlignment','bottom', 'FontSize', 10);
ylim([0 max(percent*100)+5]);
xlim([min_dimension max_dimension]);
xlabel('# Embedding Dimensions');
xlabel('Embedding Dimensions');ylabel('%False Nearest Neighbors');



%% - Embed Time-Series Code -
function embedded=embed_time_series(data,embedding_dim,lag)

%usage:
%	embedded=embed_time_series(data,embedding_dim,lag)
%
%input:
%	data(1D):vector time series, may be a row or column.
%	embedding_dim(scalar):the number of dimensions to use in the embedding. 
%	lag(scalar):the lag (in samples) to use between dimensions in the embedding.
%
%returns:
%	embedded:(2D) array NxM where M=embedding_dim 
%	and N=length(data)-(embedding_dim-1)*lag, such the each row is a point in the
%	embedding space.  
%	embedded(i,:)=[data(i),data(i+lag),data(i+2lag),...,data(i+(embedding_dim-1)lag]

%check the dim of data
s=size(data);
if s(1)==1
   %a row
   data=data';
elseif s(2)~=1
   %not a vector
   %error(sprintf('time series (data) must be a vector.  you used a %dX%d matrix',s(1),s(2))); %#ok<*SPERR>
else
   %it is already a column vector.  do nothing.
end

%how long should it be?
l=length(data);
data_length=l-(embedding_dim-1)*lag;
embedded=zeros(data_length,embedding_dim);
for c=1:embedding_dim
   embedded(:,c)=data((1:data_length)+lag*(c-1));
end;

%% - Find Neighborhood KD Search Code -
function [neighborhood,indexes,encounters,moves]=find_neighborhood_kd_search(tree,kd_point)

%this is the kd tree search for neighborhoods.

if ~isempty(tree.values)
   %we are at a leaf
   neighborhood=tree.values;
   indexes=tree.indices;
   moves='';
   encounters=[];
else
   %still climbing down a branch
   
   %each node breaks left and right based on one of the
   %k dimensions.  which one? it is in tree.decission_dimension
   %so we look at the value of kd_point in that dim. to decide
   %which way to go.
   switch_value=kd_point(tree.decission_dimension);
   
   miss_dist=abs(switch_value-tree.decission_value);
   
   if switch_value<tree.decission_value
      %look down the left branch
      [neighborhood,indexes,temp_e,temp_m]=find_neighborhood_kd_search(tree.left,kd_point);
      moves=['l',temp_m];
      encounters=[miss_dist,temp_e];
   else
      %look down the right branch
      [neighborhood,indexes,temp_e,temp_m]=find_neighborhood_kd_search(tree.right,kd_point);
      moves=['r',temp_m];
      encounters=[miss_dist,temp_e];
      
   end
end

%% - Find Nearest Neighbor Code -
function [NN,dist]=find_the_nearest_neighbor(tree,kd_point,points_index)

[neighborhood,indexes,encounters,moves]=find_neighborhood_kd_search(tree,kd_point);

distances=sqrt(sum((neighborhood-(repmat(kd_point,length(neighborhood),1))).^2,2));	
[sort_d,nearest_indexes]=sort(distances);

%if we are in the bin that contains the point, the nearest point will be

%itself (d=0) and we dont want that one but if we are looking in a different
%bin we want the nearest
NN_index=indexes(nearest_indexes(1));
NN=indexes(nearest_indexes(1+(NN_index==points_index)));		
nearest_d_in_bin=sort_d(1+(NN_index==points_index));

%now, if any bin edges are closer to the point than the
%NN in the bin, we need to check for NN there too!

close_flag=encounters<nearest_d_in_bin;
close_encounters_index=find(close_flag);

if isempty(close_encounters_index)
   NN=NN; %#ok<ASGSL>
   dist=nearest_d_in_bin;
else
   for c=1:length(close_encounters_index)
      local_moves=moves(1:close_encounters_index(c));
      switch local_moves(end)
      case 'l'
         local_moves(end)='r';
      case 'r'
         local_moves(end)='l';
      end
      sub_tree=get_sub_tree(tree,local_moves);
      [other_NN(c),other_dist(c)]=find_the_nearest_neighbor(sub_tree,kd_point,points_index); %#ok<*AGROW>
   end	
   potential_NN=[NN,other_NN];
   potential_dist=[nearest_d_in_bin,other_dist];
   [sort_d,index]=sort(potential_dist);
   NN=potential_NN(index(1));
   dist=potential_dist(index(1));
end

%% - Get Sub Tree Code - 
function sub_tree=get_sub_tree(tree,move_sequence)
temp=tree;
for c=1:length(move_sequence)
   if strcmp(move_sequence(c),'l')	
      temp=temp.left;
   elseif strcmp(move_sequence(c),'r')
      temp=temp.right;
   end
end
sub_tree=temp;

%% - Make KD Tree Code -
function search_tree=make_kd_tree(data,indices,threshold)
%usage:
%	search_tree=make_kd_tree(data,indices,threshold)
%
%arguements:
%	data:2D matrix.  data is the point that populate some 
%		space.  For L points in a K dimensional space, data
%		should have L rows and K columns such that each row
%		of data contains that coordinates in K-space of a 
%		single point.
%	indices:1D vector, runs 1:L initially.  This allows the 
%		tree to keep track of the temporal structure of the 
%		values at each leaf in the tree.
%	threshold:scalar integer.  The maximum number of points to 
%		allow at a leaf.  If there are more than threshold,
%		points, the data is subdivided.
%
%returns:
%	search_tree: a KD-binary search tree for data.  This is
%		used in that False Nearest Neighbors algorythm
%		Global_FNN.m the efficiently search for each point's
%		nearest neighbor.  For an entry into range searching
%		KD-trees, see Bently and Friedman, ACM Computing Survey, 
%		11,p279 (1979).

if length(data)<=threshold
   %this is a leaf
   search_tree.decission_dimension=[];
   search_tree.decission_value=[];
   search_tree.left=[];
   search_tree.right=[];
   search_tree.values=data;
   search_tree.indices=indices;
   
else
   %not a leaf.  divide the list and go recursively onward!
   %first decide along which dimension to break the data.
   %the data is assumed to be embedded such that each column
   %of data is dimension, and we split along the one with the greatest
   %range.
   range=max(data)-min(data);
   [v,d_to_split]=max(range); %#ok<*ASGLU>
   search_tree.decission_dimension=d_to_split;	 
   search_tree.decission_value=median(data(:,d_to_split));
   left_points=find(data(:,d_to_split)<search_tree.decission_value);
   right_points=find(data(:,d_to_split)>=search_tree.decission_value);
   left_data=data(left_points,:);
   right_data=data(right_points,:);
   left_indices=indices(left_points);
   right_indices=indices(right_points);
   
   search_tree.left=make_kd_tree(left_data,left_indices,threshold);
   search_tree.right=make_kd_tree(right_data,right_indices,threshold);
   search_tree.values=[];
   search_tree.indices=[];
end
