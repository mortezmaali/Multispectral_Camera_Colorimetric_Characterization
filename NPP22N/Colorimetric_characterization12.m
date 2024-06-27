clc;
clear;
nI = zeros(3648,5472,12);
for i = 0:11
    nI(:,:,i+1) = im2double(imread(sprintf('slotD_FF%d.tif',i)));
end
[m n ~] = size(nI);
im = reshape(nI,[m*n,12]);
imL(:,1) =   1.0882*im(:,1) -0.1947;
imL(:,2) = 0.9694 * im(:,2) -0.0645;
imL(:,3) =  0.8638 * im(:,3) - 0.0552;
imL(:,4) =  0.8559 * im(:,4) - 0.0595;
imL(:,5) =  0.8638 * im(:,5) -0.0632;
imL(:,6) =  0.8578 * im(:,6) -0.071;
imL(:,7) =  0.8772 * im(:,7) -0.0484;
imL(:,8) = 0.8623 * im(:,8) -0.0704;
imL(:,9) =  0.9558 * im(:,9) -0.0031;
imL(:,10) =  0.8779 * im(:,10) -0.0375;
imL(:,11) =  0.8475 * im(:,11) -0.0805;
imL(:,12) = 0.9428 * im(:,12) -0.0418;
load('M12.mat');
XYZL=M12*imL';
SRGB = xyztosrgb(XYZL);

SRGB=imadjust(SRGB,stretchlim(SRGB),[]);
SRGB = min(max(SRGB,0),1);

SRGB = im2uint16(SRGB); 
SRGB = reshape(SRGB',[m,n,3]);
imshow(SRGB)
imwrite(SRGB,'Colorimetric12.png');
a(:,:,3)=nI(:,:,3);
a(:,:,2)=nI(:,:,7);
a(:,:,1)=nI(:,:,11);
figure(2);imshow(a)
a = im2uint16(a); 
imwrite(a,'OldMethod.png');