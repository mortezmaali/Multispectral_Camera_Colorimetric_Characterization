load('Mean_Value.mat')
C_sg_mV(1,:) =  1.0882*C_sg(1,:) -0.1947;
C_sg_mV(2,:) =  0.9694 * C_sg(2,:) -0.0645;
C_sg_mV(3,:) =  0.8638 * C_sg(3,:) - 0.0552;
C_sg_mV(4,:) =  0.8559 * C_sg(4,:) - 0.0595;
C_sg_mV(5,:) =  0.8638 * C_sg(5,:) -0.0632;
C_sg_mV(6,:) =  0.8578 * C_sg(6,:) -0.071;
C_sg_mV(7,:) =  0.8772 * C_sg(7,:) -0.0484;
C_sg_mV(8,:) =  0.8623 * C_sg(8,:) -0.0704;
C_sg_mV(9,:) =  0.9558 * C_sg(9,:) -0.0031;
C_sg_mV(10,:) =  0.8779 * C_sg(10,:) -0.0375;
C_sg_mV(11,:) =  0.8475 * C_sg(11,:) -0.0805;
C_sg_mV(12,:) =  0.9428 * C_sg(12,:) -0.0418;


load('XYZ_Value.mat')
M=XYZout*pinv(C_sg_mV);
a = im2double(imread('slotD_FF0.tif'));
[m n ~]=size(a);
im = zeros(m,n,12);
ss = 0;
for i=0:11
    ss = ss+1;
    im(:,:,ss) = im2double(imread(sprintf('slotD_FF%d.tif',i)));
end
im = reshape(im,[m*n,12]);
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

XYZL=M*imL';
SRGB = xyztosrgb(XYZL);
SRGB=imadjust(SRGB,stretchlim(SRGB),[]);
SRGB = min(max(SRGB,0),1);


SRGB = im2uint16(SRGB); 
SRGB = reshape(SRGB',[m,n,3]);

figure(10);imshow(SRGB,[])
imwrite(SRGB,'CC_imagen1.png');

% im2(:,:,3)= imread('slot_FF1.tif');
% im2(:,:,2)= imread('slot_FF6.tif');
% im2(:,:,1)= imread('slot_FF9.tif');
%figure(2);imshow(im2)
%imwrite(im2,'3band_CC_image3.png');

