function Iout = SobelEdgePhase(Iin, N)

Iout = false( size(Iin) );

Height = round(size(Iin,1)/N);

PN = 7;

%figure

for i=1:N
    

    I = Iin( (i-1)*Height+(1:Height+1), :);
    
    %%%%%%%% opening by reconstruction %%%%%%%%
    se = strel('disk', 5);
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    % subplot(PN,1,1);
    % imshow(I, []), title('Original')
    
    % subplot(PN,1,2);
    % imshow(Iobr, []), title('Opening-by-reconstruction (Iobr)')
    
    %%%%%%%%%% opening %%%%%%%%%
    Io = imopen(Iobr, se);
    % subplot(PN,1,3);    
    % imshow(Io, []), title('Opening (Io)')

    %%%%%%%%%% sobel 1 %%%%%%%%%%%%
    %hy = fspecial('sobel');
    %hx = hy';
    %Iy = imfilter(double(Iobr), hy, 'replicate');
    %Ix = imfilter(double(Iobr), hx, 'replicate');
    %gradmag = sqrt(Ix.^2 + Iy.^2);
    %subplot(PN,1,4);    
    %imshow(gradmag,[]), title('Gradient magnitude (gradmag) from Iobr')

    %%%%%%%%%% sobel 1 %%%%%%%%%%%%
    %hy = fspecial('sobel');
    %hx = hy';
    %Iy = imfilter(double(Io), hy, 'replicate');
    %Ix = imfilter(double(Io), hx, 'replicate');
    %gradmag = sqrt(Ix.^2 + Iy.^2);
    %subplot(PN,1,5);    
    %imshow(gradmag,[]), title('Gradient magnitude (gradmag) from Io')
    
    %%%%%%%%%% fill 1 %%%%%%%%%%%%
    Ifill = imfill(Io, 'hole');
    % subplot(PN,1,4);    
    % imshow( Ifill ,[]), title('Filling magnitude (Ifill) from Io');
    
    %%%%%%%%%% subtract fill = cell area %%%%%%%%%%%%
    Icell = imadjust(Ifill-Io);     
    % subplot(PN,1,5);    
    % imshow( Icell ), title('Cell area (Icell) by Ifill-Io');

    %%%%%%%%%% subtract fill = cell area %%%%%%%%%%%%
    IBW = im2bw( Icell , 0.3);
    % subplot(PN,1,6);    
    % imshow( IBW,[]), title('Binary image (IBW) from Icell');
    
    %%%%%%%%%% Boundry demonstartion %%%%%%%%%%%%
    %subplot(PN,1,7);
    %imshow(I, []), title('Original')
    %hold on;
    %B = bwboundaries(IBW);
    %plot(B{1}(:,2), B{1}(:,1), '-r', 'linewidth', 2);
    %hold off
    
    %drawnow;
    
    Iout( (i-1)*Height+(1:Height+1), :) = IBW;

end
