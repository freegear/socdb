%BiLinear Scaler
% Parameter 
%   OrgX : Original X width
%   OrgY : Original Y width
%   DstX : Destination image X width
%   DstY : Destination image Y heigth
%   OrgImg : Original Image array
%   DstImg : DestImage array
%
%    A    E         B
%  +-----O----------+
%  |<--->    dy     |
%  |  dx G          |
%  |                |
%  |                |
%  +-----O----------+
%    C    F          D
%
function DstImg = bilinear(DstX,DstY,OrgImg)

% Make zero image
OrgImageSize = size(OrgImg);
OrgX         = OrgImageSize(2);
OrgY         = OrgImageSize(1);

% 엑스 축의 증가 분을 계산한다.
IncX = OrgX / DstX ;
% 와이 축의 증가 분을 계산한다.
IncY = OrgY / DstY ;

% 목적 이미지의 크기만큼 반복한다.
PosX = 1 ; PosY = 1;

for CurY = 1:DstY
  for CurX = 1:DstX
    
%    하나 작은 와이 값에서
   X(1) = fix(PosX);
   X(2) = fix(PosX)+1;
 
   if X(2) >= OrgX
       X(2) = OrgX;
   end
   
   Y(1) = fix(PosY);
   Y(2) = fix(PosY)+1;
 
   if Y(2) >= OrgY
       Y(2) = OrgY;
   end
 
   dx   = PosX - X(1);
   dy   = PosY - Y(1);

   Ax   = X(1) ; Ay = Y(1);
   Bx   = X(2) ; By = Y(1);
   Cx   = X(1) ; Cy = Y(2);
   Dx   = X(2) ; Dy = Y(2);
   
   % R Plane
   E = interpolate( OrgImg(Ay,Ax,1),OrgImg(By,Bx,1),dx);
   F = interpolate( OrgImg(Cy,Cx,1),OrgImg(Dy,Dx,1),dx);
   DstImg(CurY,CurX,1) = interpolate( E , F, dy );
   
   % G Plane
   E = interpolate( OrgImg(Ay,Ax,2),OrgImg(By,Bx,2),dx);
   F = interpolate( OrgImg(Cy,Cx,2),OrgImg(Dy,Dx,2),dx);
   DstImg(CurY,CurX,2) = interpolate( E , F, dy );

   % B Plane
   E = interpolate( OrgImg(Ay,Ax,3),OrgImg(By,Bx,3),dx);
   F = interpolate( OrgImg(Cy,Cx,3),OrgImg(Dy,Dx,3),dx);
   DstImg(CurY,CurX,3) = interpolate( E , F, dy );
  
 % 증분을 반영한다.
   PosX = PosX + IncX;
  end % end of for CurX = 1:DstX
  
  PosX = 1;
  PosY = PosY + IncY;

end % end of for CurY = 1:DstY

% check for upscale or downscale
% if up scale
%     if dstX > orgX
% if down scale
%     if dstX < orgX

end

% 현재의 값(지정된 R/G/B)에서 하나 작은 엑스 값과 하나 큰 엑스 값
 
% 현재의 값(지정된 R/G/B)에서 하나 작은 와이 값과 하나 큰 와이 값

% 두개의 값 사이의 선형 보간 함수
function PolVal = interpolate(Val1,Val2,delta)
    PolVal = double(Val1) + double((Val2-Val1))*delta;
    PolVal = uint8(PolVal);
end % end of function


