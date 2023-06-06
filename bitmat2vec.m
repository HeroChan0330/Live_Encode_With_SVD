function vec = bitmat2vec(bitmat)
    [bits,len] = size(bitmat);
    bitmat = int32(bitmat);
    vec = zeros(1,len);
    vec = int32(vec);
    for bit =1:bits
        vec = bitor(vec,bitshift(bitmat(bit,:),bit-1));
    end
end