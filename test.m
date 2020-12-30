image=imread('crate images/bottle_crate_19.png');

im_back=edge(image,'prewitt');
im_bottle=(image>105);
%figure; imshow(im_back);
%figure; imshow(im_bottle);
se1=strel('line',5,0);
opened=imopen(im_back,se1);
%figure; imshow(opened);
diff=im_bottle-opened;
%figure; imshow(diff);

label=bwlabel(diff,4);
%figure; imshow(label);
s=regionprops(label,'Area'); 
%figure; hist([s.Area],100);
idx = find([s.Area] > 6000);
bw2 = ismember(label,idx);
w_c=diff-bw2;
%figure; imshow(w_c);
  
se_clut=strel('line',1,0);
w_c=imopen(w_c,se_clut);
%figure; imshow(clut_opened);
cand=bwlabel(w_c,4);
%figure; imshow(cand);
s2=regionprops(cand,'Area');
%figure; hist([s2.Area],100);
comp=bwareaopen(cand,175);
%figure; imshow(comp);

se2=strel('line',2,0);
opd=imdilate(comp,se2);
% se3=strel('line',2,0);
% opd=imdilate(opd,se3);
% figure; imshow(opd);
% figure; imshow(d);


c=bwlabel(opd,4);
%figure;imshow(label2rgb(c));
s3=regionprops(c,'Eccentricity');
es=cat(1,s3.Eccentricity);

% s3=regionprops(c);
% for i=1:25 % for loop starting from i=2, because the first region is the background of the image
%     text(s3(i).Centroid(1),s3(i).Centroid(2),num2str(i-1)); %text function prints
%     string to given coordinates, which are in struct s in field Centroid.
%     num2str function converts number to string
% end

idx2 = find([s3.Eccentricity]<=0.65);
bw3 = ismember(c,idx2);
% %figure; imshow(bw3);
% 
bw3=imfill(bw3, 'holes');

%figure; imshow(bw3);

bw3=bwlabel(bw3,4);
%figure;imshow(label2rgb(bw3));
s4=regionprops(bw3,'Area');
a=cat(1,s4.Area);
b=sort(a,'descend');
sz=size(b);
%figure; imshow(label2);
for i=1:sz
    if b(i)>1700 && b(i)<3500 
        idx3 = find([s4.Area]<b(i));
        bw3 = ismember(bw3,idx3);
        b(i)
        figure; imshow(bw3);
    end
    bw3=bwlabel(bw3,4);
    s4=regionprops(bw3,'Area');
end

%figure; imshow(bw3);
bw4=bwlabel(bw3,4);
v=regionprops(bw4,'Centroid','Area');
centres=cat(1,v.Centroid);
area=cat(1,v.Area);

% w_c=bwlabel(w_c);
% s2=regionprops(w_c,'Eccentricity');
% % figure; hist([s2.Eccentricity],20);
% idx2 = find([s2.Eccentricity]<=0.65);
% bw3 = ismember(w_c,idx2);
% b=w_c-bw3;
% %figure; imshow(bw3);
% comp=bwareaopen(bw3,150);
% %figure; imshow(comp);
% se2=strel('line',3,0);
% opd=imdilate(bw3,se2);
% %figure; imshow(opd);
% comp3=bwareaopen(opd,200);
% %figure; imshow(comp3);
% label2=imfill(comp3, 'holes');
% figure; imshow(label2);
% holes=bwlabel(label2,4);
% v=regionprops(holes,'Centroid');
% centres=cat(1,v.Centroid);
% radius=20;
% col=[0 1 0];
% %col=[0.9 0.65 0];