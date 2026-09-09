%Biquadratic Scaler
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
function DstImg = biquadratic(DstX,DstY,OrgImg)

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
   X(1) = fix(PosX)-1;
   X(2) = fix(PosX);
   X(3) = fix(PosX)+1;

   if X(1) <= 1 
       X(1) = 1;
   end
   
   if X(2) >= OrgX
       X(2) = OrgX;
       X(3) = OrgX;
   else if X(3) >= OrgX
       X(3) = OrgX;
   end
   
   Y(1) = fix(PosY)-1;
   Y(2) = Y(1)+1;
   Y(3) = Y(2)+1;
  
   if Y(1) <= 1
       Y(1) = 1;
   end
   
   if Y(2) >= OrgY
       Y(2) = OrgY;
       Y(3) = OrgY;
   else if Y(3) >= OrgY
       Y(3) = OrgY;
   end
    
   dx   = double(PosX - X(2));
   dy   = double(PosY - Y(2));

   Ax = X(1) ; Ay = Y(1);
   Bx = X(2) ; By = Y(1);
   Cx = X(3) ; Cy = Y(1);
   
   Dx = X(1) ; Dy = Y(2);
   Ex = X(2) ; Ey = Y(2);
   Fx = X(3) ; Fy = Y(2);
   
   Gx = X(1) ; Gy = Y(3);
   Hx = X(2) ; Hy = Y(3);
   Ix = X(3) ; Iy = Y(3);
   
   qx = 0.5 * dx * dx;
   qy = 0.5 * dy * dy;
   
   dx = 0.5 * dx;
   dy = 0.5 * dy;
   
   

   % R Plane
   for index = 1:3
       J = interpolate( OrgImg(Ay,Ax,index),OrgImg(By,Bx,index),OrgImg(Cy,Cx,index),dx,qx);
       K = interpolate( OrgImg(Dy,Dx,index),OrgImg(Ey,Ex,index),OrgImg(Fy,Fx,index),dx,qx);
       L = interpolate( OrgImg(Gy,Gx,index),OrgImg(Hy,Hx,index),OrgImg(Iy,Ix,index),dx,qx);
   
       DstImg(CurY,CurX,index) = interpolate( J , K, L, dy , qy );
   end
   
  
 % 증분을 반영한다.
   PosX = PosX + IncX;
  end % end of for CurX = 1:DstX
  
  PosX = 1;
  PosY = PosY + IncY;

  PosY
  
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
function PolVal = interpolate(C0,C1,C2,dx,qx)
    C0     = double(C0);
    C1     = double(C1);
    C2     = double(C2);    
    PolVal = C1 + ( C2 - C0 ) * dx + ( C0 - 2 * C1 + C2 ) * qx;
    PolVal = uint8(PolVal);
end % end of function


