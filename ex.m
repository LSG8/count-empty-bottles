function [centres,area]=ex(image)

im_back=edge(image,'prewitt'); %edge detection is applied to extract out the background components
im_bottle=(image>105); %thresholding performed to extract out the bottle components
%figure; imshow(im_back);
%figure; imshow(im_bottle);
se1=strel('line',5,0); %structuring element created for opening
opened=imopen(im_back,se1); %background components are opened 
%figure; imshow(opened);
diff=im_bottle-opened; %removed the background from bottle image
%figure; imshow(diff);

label=bwlabel(diff,4); %labeling 4-connectivity components
%figure; imshow(label);
s=regionprops(label,'Area'); %finding the area of the different components
%figure; hist([s.Area],100);
idx = find([s.Area] > 6000); %finding the area values which are greater than 6000 pixels
bw2 = ismember(label,idx); %finding the components which are greater than 6000 pixel area i.e clutter
w_c=diff-bw2; %removing the clutter
%figure; imshow(w_c);
  
se_clut=strel('line',1,0); %structuring element creation for opening the clutter free image
w_c=imopen(w_c,se_clut); %opening
%figure; imshow(clut_opened);
cand=bwlabel(w_c,4); %labeling 4-connectivity components
%figure; imshow(cand);
s2=regionprops(cand,'Area'); %finding the area of the different components
%figure; hist([s2.Area],100);
comp=bwareaopen(cand,175); %removing the small noises which contains maximum 175 pixel area
%figure; imshow(comp);

se2=strel('line',2,0); %structuring element creation for dilation
opd=imdilate(comp,se2); %dilation is done to make full circle of the bottle components
% se3=strel('line',2,0);
% opd=imdilate(opd,se3);
% figure; imshow(opd);
% figure; imshow(d);


c=bwlabel(opd,4); %labeling 4-connectivity components
%figure;imshow(label2rgb(c));
s3=regionprops(c,'Eccentricity'); %finding the eccentricity of the components
%es=cat(1,s3.Eccentricity); %making 

% s3=regionprops(c);
% for i=1:25 % for loop starting from i=2, because the first region is the background of the image
%     text(s3(i).Centroid(1),s3(i).Centroid(2),num2str(i-1)); %text function prints
%     string to given coordinates, which are in struct s in field Centroid.
%     num2str function converts number to string
% end

idx2 = find([s3.Eccentricity]<=0.65); %finding the circular components
bw3 = ismember(c,idx2); %circular components are extracted
% %figure; imshow(bw3);
% 
bw3=imfill(bw3, 'holes'); %filling the holes

%figure; imshow(bw3);

bw3=bwlabel(bw3,4); %labeling 4-connectivity components
%figure;imshow(label2rgb(bw3));
s4=regionprops(bw3,'Area'); %finding the area of the different components
a=cat(1,s4.Area); %concatenating area values into an array

sz=size(a); %finding the size of the array
%figure; imshow(label2);
for i=1:sz							%checking iteratively the areas of the circular components which are not bottles 
    if a(i)>1800 && a(i)<3500 		%bottles are placed either correctly or upside down. If it is placed correctly then the mouth of the bottles are upside
        idx3 = find([s4.Area]<a(i));%and if placed wrongly then back is upside which is bigger circle than the mouth
        bw3 = ismember(bw3,idx3);	%so the components should have areas of mouth or areas of back. The components with middle area is suspicious
       %figure; imshow(bw3);		%here, I have found the mouth can be of maximum 1800 pixels and back is not less than 3500 pixels.
    end								%so, I removed the middle components
    bw3=bwlabel(bw3,4);
    s4=regionprops(bw3,'Area');
 end

bw4=bwlabel(bw3,4);	%labeling 4-connectivity components
v=regionprops(bw4,'Centroid','Area'); %finding the centroid and area of the different components
centres=cat(1,v.Centroid); %concatenating the centroid in centres array and returning the centres		
area=cat(1,v.Area); %concatenating the area in area array and returning the area
end


