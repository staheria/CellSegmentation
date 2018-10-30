function [Iout Fluor]= SobelEdgeFluor(Iin, N)

Iout = false( size(Iin) );
Fluor = zeros(1,N);

Height = round(size(Iin,1)/N);

PN = 5;

%figure

for i=N:-1:1
    
    I = Iin( (i-1)*Height+(1:Height+1), :);
    
    %%%%%%%% opening by reconstruction %%%%%%%%
    se = strel('disk', 8);
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
    %Ifill = imfill(Io, 'hole');
    %subplot(PN,1,4);    
    %imshow( Ifill ,[]), title('Filling magnitude (Ifill) from Io');
    
    %%%%%%%%%% subtract fill = cell area %%%%%%%%%%%%
    %subplot(PN,1,5);    
    %Icell = imadjust(Ifill-Io);     
    %imshow( Icell ), title('Cell area (Icell) by Ifill-Io');

    %%%%%%%%%% subtract fill = cell area %%%%%%%%%%%%
    level = graythresh(I);
    IBW1 = im2bw( Iobr , level);
    
    seD = strel('diamond',1);
    BWfinal = imerode(IBW1,seD);
    IBW = imerode(BWfinal,seD);

    % subplot(PN,1,4);   
    % imshow( IBW,[]), title('Binary image (IBW) from Iobr');
    
    %%%%%%%%%% Get rid of small bad segments %%%%%%%%%%%%
    IBW = bwareaopen(IBW, 500);
    IBW = bwmorph( IBW , 'thicken'  );

    %%%%%%%%%% Boundry demonstartion %%%%%%%%%%%%
    %subplot(PN,1,5);
    %imshow(I, []), title('Original')
    %B = bwboundaries(IBW);
    %if numel(B)>0
    %    hold on;
    %    plot(B{1}(:,2), B{1}(:,1), '-r', 'linewidth', 2);
    %    hold off
    %end
    
    Fluor(i) = sum(sum( double(I).*double(IBW) )) / sum(sum( double(IBW) ));
    Iout( (i-1)*Height+(1:Height+1), :) = IBW;

    %drawnow;
    
end
