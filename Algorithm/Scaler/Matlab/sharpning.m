% Gen Sharpning Filter
function sharpfilter = sharpning(n)
% n : Filter Order

sm = 0 ;
k  = 1 ;
index_offset = n+1;
for j = -n:n
    for i = -n:n
        ra = sqrt(i*i+j*j)/n;
        ra = exp(-2*ra*ra);
        fs(i+index_offset,j+index_offset)=ra;
        if ( i ~= 0 ) || ( j ~=0 )
            sm = sm + ra;
        end
    end
end


for j = -n:n
    for i = -n:n
        fs(i+index_offset,j+index_offset)=-fs(i+index_offset,j+index_offset)/sm;
        if ( i == 0 ) && ( j ==0 )
            fs(i+index_offset,j+index_offset)=2.0;
        end        
    end
end

sharpfilter = fs;

