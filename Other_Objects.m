addpath('C:\Users\mmacis\Desktop\PostDoc\Color_checker\Morteza software\multispectralTools\MCSL_Toolbox')
%Read Target Imgs
fprintf('Select the Target img folder:\n')
folder_img = uigetdir;
listing = dir(folder_img);
indx = 1;
for i = 1:size(listing,1)
    
    [pathstr,name,ext] = fileparts(listing(i).name);
    if strcmpi(ext,'.tiff') | strcmpi(ext,'.tif')
        
        Img_name{indx} = [name ext];
        
        
        Img{indx} = im2double(imread([folder_img '/' Img_name{indx}]));
        indx = indx + 1;
    end
    
end

% Read Flatfield Imgs
fprintf('Select the FlatField img folder:\n')
folder_FF = uigetdir;
listing = dir(folder_FF);


indx = 1;
for i = 1:size(listing,1)
    
    [pathstr,name,ext] = fileparts(listing(i).name);
    if strcmpi(ext,'.tiff') | strcmpi(ext,'.tif')
        
        FF_name{indx} = [name ext];
        
        % blur the white
        FF2{indx} = im2double(imread([folder_FF '/' FF_name{indx}]));
        G = fspecial('gaussian',[5 5],2);
        FF{indx} = imfilter(FF2{indx},G,'same');
        indx = indx + 1;
        
    end
    
end

fprintf('Select the New img folder:\n')
folder_img = uigetdir;
listing = dir(folder_img);
indx = 1;
for i = 1:size(listing,1)
    
    [pathstr,name,ext] = fileparts(listing(i).name);
    if strcmpi(ext,'.tiff') | strcmpi(ext,'.tif')
        
        Img_name{indx} = [name ext];
        
        
        Imgn{indx} = im2double(imread([folder_img '/' Img_name{indx}]));
        indx = indx + 1;
    end
    
end


% Needs to choose a folder to put the flat fielded images and a text file
% with the average counts for each patch
fprintf('Select result folder:')
folder = uigetdir;

fprintf('Select Paint CC:')
s = [4 6];
[mask,coor] = patchmask(Img{1}/max(Img{1}(:)),0.4,s);
save([folder,'/','mask_paint.mat'],'mask','coor')
load([folder,'/','mask_paint.mat']);
% for APT patch is 3, not 19 (for CC and passport)
iw = find(mask == 19);
for i = 1:indx - 1
    Imgw = mean(mean(Img{i}(iw)));
    FFw = mean(mean(FF{i}(iw)));
    white = FFw/Imgw;
    slot_FF = uint16(max(0,min(1,0.88*white*(Imgn{i})./(FF{i})))*65535);  %Yixuan is using .88
    slot_FF(isnan(slot_FF))=0;
    imwrite(slot_FF(:,:), strcat(folder,'/','slotD_FF',num2str(i-1),'.tif'),'tiff');
end