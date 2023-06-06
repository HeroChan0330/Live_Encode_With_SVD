function ret =pca_encode(img_src,PCA_Q)
    % only for image whose size is 1920*1080
    H = 1080;
    W = 1920;

    RESCALE_W = PCA_Q * 6;
    RESCALE_H_U = H*PCA_Q/RESCALE_W;
    RESCALE_H_V = W*PCA_Q/RESCALE_W;
    RESCALE_H_S = ceil(32*PCA_Q/RESCALE_W);
    RESCALE_H = RESCALE_H_U + RESCALE_H_V +RESCALE_H_S ;

    
    img_gray = mean(img_src,3)/255;

    [U,S,V] = svd(img_gray);

    U_max = max(abs(U));
    V_max = max(abs(V));

    U_rescale = ((U./U_max)+1)/2;
    V_rescale = ((V./V_max)+1)/2;


    S_pca = S(1:PCA_Q,1:PCA_Q);
    U_pca = U_rescale(:,1:PCA_Q);
    V_pca = V_rescale(:,1:PCA_Q);

    S_pca_32bit = diag(S_pca);
    S_pca_32bit = S_pca_32bit';
    S_pca_32bit = int32(floor(S_pca_32bit));
    S_pca_32bitmat = vec2bitmat(S_pca_32bit,32);

    align_cnt = RESCALE_H_S*RESCALE_W - 32*PCA_Q; % align the bitmat of S to the frame size
    align_ele = (sign(rand(32,align_cnt/32)-0.5)+1)/2; % add some noise to align
    S_pca_32bitmat = [S_pca_32bitmat,align_ele];
    S_pca_reshape = reshape(S_pca_32bitmat,RESCALE_W,RESCALE_H_S);
    S_pca_reshape = S_pca_reshape';
    S_pca_reshape = S_pca_reshape + (rand(size(S_pca_reshape))-0.5)*0.3; % add some noise to make the frame look like noise
    S_pca_reshape(S_pca_reshape>1) = 1;
    S_pca_reshape(S_pca_reshape<0) = 0;



    U_pca_reshape = reshape(U_pca,RESCALE_W,RESCALE_H_U);
    V_pca_reshape = reshape(V_pca,RESCALE_W,RESCALE_H_V);
    U_pca_reshape = U_pca_reshape';
    V_pca_reshape = V_pca_reshape';
    V_pca_reshape = flip(V_pca_reshape); % flip the V part to make the frame more reasonable

    img_encode = zeros(RESCALE_H,RESCALE_W);
    img_encode(1:RESCALE_H_U,:) = U_pca_reshape;
    img_encode(RESCALE_H_U+1:RESCALE_H_U+RESCALE_H_V,:) = V_pca_reshape;
    img_encode(RESCALE_H_U+RESCALE_H_V+1:end,:) = S_pca_reshape;

    ret = img_encode;

end