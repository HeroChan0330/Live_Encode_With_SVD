function bitmat = vec2bitmat(vec,bits)
    vec = int32(vec);
    bitmask = int32(ones(1,length(vec)));
    bitmat = zeros(bits,length(vec));
    for bit =1:bits
        bitmat(bit,:) = bitand(vec,bitmask);
        vec = bitshift(vec,-1);
    end
end