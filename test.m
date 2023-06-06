
%% image test
clc
clear
img_src = imread('1080p.png');
img_encode = pca_encode(img_src,128);

imwrite(img_encode,'encode.jpg','Quality',80); 
img_encode = imread('encode.jpg');
img_encode = double(img_encode)/255;

img_decode = pca_decode(img_encode,128);

img_gray = mean(img_src,3)/255;

figure(1);
imshow(img_gray);

figure(2);
imshow(img_decode);
gray = mean(img_src,3)/255;
imwrite(gray,'gray.jpg','Quality',99); 
imwrite(img_decode,'decode.jpg','Quality',99); 


%% Write Gray Video
clc
clear

vidreader = VideoReader('rainbow6.mp4');
vidreader.NumFrames

vidwriter = VideoWriter('gray.avi','Motion JPEG AVI');
vidwriter.Quality = 95;
vidwriter.FrameRate = 24;
open(vidwriter);
frame_cnt = 0;
while hasFrame(vidreader)
    frame = readFrame(vidreader);
    frame = mean(frame,3)/255;
    writeVideo(vidwriter,frame)
    frame_cnt = frame_cnt + 1;
    disp(frame_cnt);
end
close(vidwriter);



%% Write encoded Video
clc
clear

vidreader = VideoReader('rainbow6.mp4');
vidreader.NumFrames

vidwriter = VideoWriter('encode.avi','Motion JPEG AVI');
vidwriter.Quality = 50;
vidwriter.FrameRate = 24;
open(vidwriter);
frame_cnt = 0;
while hasFrame(vidreader)
    frame = readFrame(vidreader);
    img_encode = pca_encode(frame,128);
    writeVideo(vidwriter,img_encode)
    frame_cnt = frame_cnt + 1;
    disp(frame_cnt);
end
close(vidwriter);



%% Write decoded Video
clc
clear

vidreader = VideoReader('encode.avi');
vidreader.NumFrames

vidwriter = VideoWriter('decode.avi','Motion JPEG AVI');
vidwriter.Quality = 95;
vidwriter.FrameRate = 24;
open(vidwriter);
frame_cnt = 0;
while hasFrame(vidreader)
    frame = readFrame(vidreader);
    frame = double(frame);
    frame = mean(frame,3)/255;
    img_decode = pca_decode(frame,128);
    img_decode(img_decode>1) = 1;
    img_decode(img_decode<0) = 0;
    writeVideo(vidwriter,img_decode)
    frame_cnt = frame_cnt + 1;
    disp(frame_cnt);
end

close(vidwriter);