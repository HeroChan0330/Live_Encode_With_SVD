function ret =pca_decode(img_encode,PCA_Q)
    % only for image whose size is 1920*1080
    img_decode = img_encode;
    H = 1080;
    W = 1920;

    RESCALE_W = PCA_Q * 6;
    RESCALE_H_U = H*PCA_Q/RESCALE_W;
    RESCALE_H_V = W*PCA_Q/RESCALE_W;
    RESCALE_H_S = ceil(32*PCA_Q/RESCALE_W);
    RESCALE_H = RESCALE_H_U + RESCALE_H_V +RESCALE_H_S ;
    align_cnt = RESCALE_H_S*RESCALE_W - 32*PCA_Q; % align the bitmat of S to the frame size

    
    
    U_pca_reshape = img_decode(1:RESCALE_H_U,:);
    V_pca_reshape = img_decode(RESCALE_H_U+1:RESCALE_H_U+RESCALE_H_V,:);
    S_pca_reshape = img_decode(RESCALE_H_U+RESCALE_H_V+1:end,:);
    S_pca_reshape(S_pca_reshape>0.5) = 1;
    S_pca_reshape(S_pca_reshape<0.5) = 0;

    V_pca_reshape = flip(V_pca_reshape);
    U_pca_reshape = U_pca_reshape';
    V_pca_reshape = V_pca_reshape';
    S_pca_reshape = S_pca_reshape';

    U_pca = reshape(U_pca_reshape,H,PCA_Q);
    V_pca = reshape(V_pca_reshape,W,PCA_Q);
    S_pca = reshape(S_pca_reshape,32,PCA_Q+align_cnt/32);
    S_pca = bitmat2vec(S_pca);
    S_pca = S_pca(:,1:PCA_Q);
    S_pca = double(S_pca);
    S_pca = diag(S_pca);


    U_pca = U_pca*2 -1;
    V_pca = V_pca*2 -1;
    U_normal = sqrt(sum(U_pca.^2));
    V_normal = sqrt(sum(V_pca.^2));
    U_pca = U_pca./U_normal;
    V_pca = V_pca./V_normal;

    ret = U_pca*S_pca*V_pca';



end