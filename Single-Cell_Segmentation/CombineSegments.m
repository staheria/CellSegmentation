function [ICEdge  TransitionFrameNum  TransitionPosition] = CombineSegments(IC1Edge , IC2Edge , Fluor, N )

ICEdge = IC2Edge;

Height = round(size(IC1Edge,1)/N);

%Pos = find( Fluor>0.5*max(Fluor), 1, 'first');

DF = diff(Fluor);
[Val Pos]= max(DF);
    
Boundary = (Pos+4)*Height;

ICEdge(1:Boundary, : ) = IC1Edge(1:Boundary, : ); 

TransitionFrameNum = (Pos+4)+1;
TransitionPosition = Boundary+1;
end

