fprintf('Select the flat_fielded img folder:\n')
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
indx=13;
s = [4 6];
[mask,coor] = patchmask(Img{1}/max(Img{1}(:)),0.4,s);

for i = 1:indx-1
    for j = 1:24
        img = im2double(imread(strcat(folder_img,'/','slotD_FF',num2str(i-1),'.tif')));
        C_sg(i,j) = mean(mean(img(find(mask == j))));
        C_st(i,j) = std2(img(find(mask == j)));
    end
end
fprintf('Select the result folder:')
folder = uigetdir;
%save as mat file
save([folder,'/','Mean_Value.mat'],'C_sg');
%save as mat file
save([folder,'/','Standard_deviation.mat'],'C_st');
%save as Excel file
filename='mean_value';
xlswrite([folder,'/',filename],C_sg)
