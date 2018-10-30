% This code segments E coli cells in an image that is a time lapse series of phase contrast along with a fluorescent channel 
% with varying levels of uniform fluorescent signal in the cytoplasmic area of the cell

clear all;

ColonyDim{5}(1, :) = [1602  375  142   64]; % dimention of sample colony

Directory = 'IndividualColonies/';

for xy = 5:5 % 5:5 is for sample, otherwise use 1:FOV 
    
    figure;
    title(['Fiel of view #' num2str(xy) ] );
    
    XYColonySize = size( ColonyDim{xy},1 ); 
    
    for colony = 1:1 % for sample, otherwise use 1:XYColonySize
        
        LoadDirectory = [Directory 'XY' num2str(xy, '%02d') '_stitch/'];

        FileName = [ '10uM-LL37_' 'xy' num2str(xy,'%02d') '_colony' num2str(colony, '%02d') '_c1' '.tif'  ]; 
        IC1 = imread( [LoadDirectory FileName] );
        XY{xy}.IPhase{colony} = IC1;
        
        FileName = [ '10uM-LL37_' 'xy' num2str(xy,'%02d') '_colony' num2str(colony, '%02d') '_c2' '.tif'  ]; 
        IC2 = imread( [LoadDirectory FileName] );
        XY{xy}.IFluorescent{colony} = NormalizeFluorescentTimeLapseStitch(IC2,46);
        
        [XY{xy}.IC2Edge{colony} Fluor] = SobelEdgeFluor(IC2, 46);
        XY{xy}.IC1Edge{colony} = SobelEdgePhase(IC1, 46);
        
        Fluor(1) = min(Fluor);
        Fluor = Fluor - min(Fluor);
        
        [XY{xy}.ICEdge{colony} XY{xy}.TransitionToFluorFrameNum(colony) XY{xy}.TransitionToFluorPosition(colony)] = CombineSegments(XY{xy}.IC1Edge{colony} , XY{xy}.IC2Edge{colony} , Fluor, 46 );

        hold off;
        imshow( IC2' );
        hold on;
        
        XY{xy}.ICEdge{colony} = imfill( XY{xy}.ICEdge{colony}, 'holes' ); 
        
        XY{xy}.ICEdge{colony} = bwareaopen(XY{xy}.ICEdge{colony}, 150);
        
        cc = bwconncomp(XY{xy}.ICEdge{colony}, 4);
        CellData = regionprops(cc,'basic');
        Xposition = cat(1,CellData.Centroid);
        [~, indx]=sort(Xposition(:,2));
        
        Area = cat(2,CellData.Area);
        Area = Area(indx)/min(Area);
        
        if(max(diff(Area))>0.3 | min(diff(Area))<-0.3)
            
            XY{xy}.SegmentError(colony) = 1;
            fprintf('Segmentation error\n');
            try 
                B = bwboundaries( XY{xy}.ICEdge{colony} );
                hold on;
                for i=1:46
                    plot(B{i}(:,1), B{i}(:,2), '-r' ); 
                end
            catch 
                1;
            end

        else

            XY{xy}.SegmentError(colony) = 0;
            try 
                B = bwboundaries( XY{xy}.ICEdge{colony} );
                hold on;
                for i=1:46
                    plot(B{i}(:,1), B{i}(:,2), '-g');% , 'linewidth', 2);
                end
            catch 
                fprintf('Segmentation error\n');
            end
    
        end
        drawnow;
        
        
    end
    
end

save(['ColonyImage_and_Segmentation_All_XYs' '_auto_NormalizedFluorescentTimeLapse'], 'XY');
