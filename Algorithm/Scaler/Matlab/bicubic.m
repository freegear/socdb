%BiLinear Scaler
% Parameter 
%   DstX : Destination image X width
%   DstY : Destination image Y heigth
%   OrgImg : Original Image array
%   DstImg : DestImage array
%  
%   1       2      3      4   
% 1  a------b--e---c------d------+
%    |      |      |      |      |
%    |      |      |      |      |
% 2  f------g--j---h------i------+
%    |      |      |      |      |
%    |      |  u   |      |      |
% 3  k------l--o---m------n------+
%    |      |      |      |      |
%    |      |      |      |      |
% 4  p------q--t---r------s------+

function DstImg = bicubic(DstX,DstY,OrgImg)

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
   
%   if CurX == 1512 
%       if CurY == 39
%           echo 'Get'
%       end
%   end
   
   X(1) = fix(PosX) - 1;
   X(2) = fix(PosX)    ;
   X(3) = fix(PosX) + 1;
   X(4) = fix(PosX) + 2;
   
   if X(1) <= 1
       X(1) = 1;
   end

   if X(2) >= OrgX
       X(2) = OrgX;
   end

   if X(3) >= OrgX
       X(3) = OrgX;
   end
  
   if X(4) >= OrgX
       X(4) = OrgX;
   end

   Y(1) = fix(PosY) - 1;
   Y(2) = fix(PosY)    ;
   Y(3) = fix(PosY) + 1;
   Y(4) = fix(PosY) + 2;


% Clipping Position Value
   if Y(1) <= 1
       Y(1) = 1;
   end

   if Y(2) >= OrgY
       Y(2) = OrgY;
   end
  
   if Y(3) >= OrgY
       Y(3) = OrgY;
   end

   if Y(4) >= OrgY
       Y(4) = OrgY;
   end 
   
%   if X(2) == X(3)
%       X(2)
%   end
       
   dx   = PosX - X(2);
   dy   = PosY - Y(2);


   %   1       2      3      4   
% 1  a------b--e---c------d------+
%    |      |      |      |      |
%    |      |      |      |      |
% 2  f------g--j---h------i------+
%    |      |      |      |      |
%    |      |  u   |      |      |
% 3  k------l--o---m------n------+
%    |      |      |      |      |
%    |      |      |      |      |
% 4  p------q--t---r------s------+
   
   a(1) = X(1); a(2) = Y(1);
   b(1) = X(2); b(2) = Y(1);
   c(1) = X(3); c(2) = Y(1);
   d(1) = X(4); d(2) = Y(1);

   f(1) = X(1); f(2) = Y(2);
   g(1) = X(2); g(2) = Y(2);
   h(1) = X(3); h(2) = Y(2);
   i(1) = X(4); i(2) = Y(2);
   
   k(1) = X(1); k(2) = Y(3);
   l(1) = X(2); l(2) = Y(3);
   m(1) = X(3); m(2) = Y(3);
   n(1) = X(4); n(2) = Y(3);
   
   p(1) = X(1); p(2) = Y(4);
   q(1) = X(2); q(2) = Y(4);
   r(1) = X(3); r(2) = Y(4);
   s(1) = X(4); s(2) = Y(4);

%   1       2      3      4   
% 1  a------b--e---c------d------+
%    |      |      |      |      |
%    |      |      |      |      |
% 2  f------g--j---h------i------+
%    |      |      |      |      |
%    |      |  u   |      |      |
% 3  k------l--o---m------n------+
%    |      |      |      |      |
%    |      |      |      |      |
% 4  p------q--t---r------s------+
   
   % R Plane
   % function PolVal = interpolate(C0,C1,C2,C3,dx)
   for Index = 1:3
       if X(2) == PosX
           e = OrgImg(b(2),b(1),Index) ;
           j = OrgImg(g(2),g(1),Index) ;
           o = OrgImg(l(2),l(1),Index) ;
           t = OrgImg(q(2),q(1),Index) ;
       else
           e = interpolate( OrgImg(a(2),a(1),Index), OrgImg(b(2),b(1),Index), ...
                            OrgImg(c(2),c(1),Index), OrgImg(d(2),d(1),Index),dx);
           j = interpolate( OrgImg(f(2),f(1),Index), OrgImg(g(2),g(1),Index), ...
                            OrgImg(h(2),h(1),Index), OrgImg(i(2),i(1),Index),dx);
           o = interpolate( OrgImg(k(2),k(1),Index), OrgImg(l(2),l(1),Index), ...
                            OrgImg(m(2),m(1),Index), OrgImg(n(2),n(1),Index),dx);
           t = interpolate( OrgImg(p(2),p(1),Index), OrgImg(q(2),q(1),Index), ...
                            OrgImg(r(2),r(1),Index), OrgImg(s(2),s(1),Index),dx);
       end 
       
       if Y(2) == PosY
          DstImg(CurY,CurX,Index) = j;
       else
          DstImg(CurY,CurX,Index) = interpolate( e,j,o,t, dy );
       end
  
   end
   
   
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
function PolVal = interpolate(C0,C1,C2,C3,dx)

    d0 = double(C0) - double(C1);
    d2 = double(C2) - double(C1);
    d3 = double(C3) - double(C1);

    a0 = double(C1);
    a1 = -(d0/3) + d2     - (d3/6);
    a2 = ( 1/2)*d0 + (1/2)*d2;
    a3 = -(1/6)*d0   - (1/2)*d2 + (1/6)*d3;

    PreVal = a0 + a1 * dx + a2 * dx * dx + a3 * dx * dx * dx;
    
    PolVal = uint8(PreVal);
    
end % end of function




