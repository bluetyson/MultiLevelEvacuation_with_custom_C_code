function config = loadConfig(config_file)
% load the configuration file
%
%  arguments:
%   config_file     string, which configuration file to load
%
%  return:
%   config.img(i).img_build
%                   building structure images for floor i
%                   2d matrix, values: R<<16 + G<<8 + B
%   config.img(i).img_soc_forces
%                   social forces images for floor i
%
%                   other config values are stored as
%                       config.<config_file_key>
%                   also see the config_file_structure file


% get the path from the config file -> to read the images
config_path = fileparts(config_file);
if strcmp(config_path,'')==1
    config_path='.';
end

fid = fopen(config_file);
input = textscan(fid, '%s=%s');
fclose(fid);

keynames = input{1};
values = input{2};

%convert numerical values from string to double
v = str2double(values);
idx = ~isnan(v);
values(idx) = num2cell(v(idx));

config = cell2struct(values, keynames);


% read the images
for i=1:config.floor_count
    %building structure
    file = config.(sprintf('floor_%d_build', i));
    file_name = [config_path '/' file];
    img_build = imread(file_name);
    %config.img(i).img_build = imageToMat(imread(file_name));
    config.floor(i).img_wall = (img_build(:,:,1) ==   0 ...
                              & img_build(:,:,2) ==   0 ...
                              & img_build(:,:,3) ==   0);
    config.floor(i).img_spawn = (img_build(:,:,1) == 255 ...
                               & img_build(:,:,2) ==   0 ...
                               & img_build(:,:,3) == 255);
    config.floor(i).img_exit = (img_build(:,:,1) ==   0 ...
                              & img_build(:,:,2) == 255 ...
                              & img_build(:,:,3) ==   0);
    config.floor(i).img_stairs_up = (img_build(:,:,1) == 255 ...
                                   & img_build(:,:,2) ==   0 ...
                                   & img_build(:,:,3) ==   0);
    config.floor(i).img_stairs_down = (img_build(:,:,1) ==   0 ...
                                     & img_build(:,:,2) ==   0 ...
                                     & img_build(:,:,3) == 255);
    
    
    %social forces
    file = config.(sprintf('floor_%d_soc_forces', i));
    file_name = [config_path '/' file];
    config.img(i).img_soc_forces = imageToMat(imread(file_name));
    
end

