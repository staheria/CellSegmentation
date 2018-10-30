function cc=GetCellsOtsuSegmentation(I)

%I2 = imadjust(I, double([max(I(:))*0.01; 1.0*max(I(:))])/double(max(I(:))) , [0;1]);
%imshow(double(I2),[]), title('Image minus Gradient magnitude (gradmag)')

bw = im2bw(I, 0.4);
%figure
%imshow(bw);
%hold on

cc = bwconncomp(bw, 8);
