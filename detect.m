function [centres,area]=detect(image)	%function for detecting the bottles;
				%input is original image and output is centroid and area array

im_back=edge(image,'prewitt'); 	%edge detection is applied to extract out the background components
im_bottle=(image>105); 		%thresholding performed to extract out the bottle components
se1=strel('line',5,0); 		%structuring element created for opening
opened=imopen(im_back,se1); 	%background components are opened 
diff=im_bottle-opened;		 %removed the background from bottle image

label=bwlabel(diff,4); 		%labeling 4-connectivity components
s=regionprops(label,'Area');	%finding the area of the different components
idx = find([s.Area] > 6000); 	%finding the area values which are greater than 6000 pixels
bw2 = ismember(label,idx);	%finding the components which are greater than 6000 pixel area i.e clutter
w_c=diff-bw2;			%removing the clutter
se_clut=strel('line',1,0); 		%structuring element creation for opening the clutter free image
w_c=imopen(w_c,se_clut); 	%opening
cand=bwlabel(w_c,4); 		%labeling 4-connectivity components
s2=regionprops(cand,'Area'); 	%finding the area of the different components
comp=bwareaopen(cand,175); 	%removing the small noises which contains maximum 175 pixel area
se2=strel('line',2,0); 		%structuring element creation for dilation
opd=imdilate(comp,se2); 		%dilation is done to make full circle of the bottle components
c=bwlabel(opd,4); 		%labeling 4-connectivity components
s3=regionprops(c,'Eccentricity'); 	%finding the eccentricity of the components
idx2 = find([s3.Eccentricity]<=0.65); %finding the circular components
bw3 = ismember(c,idx2); 		%circular components are extracted
bw3=imfill(bw3, 'holes'); 		%filling the holes
bw3=bwlabel(bw3,4); 		%labeling 4-connectivity components
s4=regionprops(bw3,'Area'); 	%finding the area of the different components
a=cat(1,s4.Area); 			%concatenating area values into an array
sz=size(a); 			%finding the size of the array
for i=1:sz			%checking iteratively the areas of the circular components which are not bottles 
    if a(i)>1800 && a(i)<3500 	%bottles are placed either correctly or upside down. 
        idx3 = find([s4.Area]<a(i));	%If it is placed correctly then the mouth of the bottles are upside
        bw3 = ismember(bw3,idx3);	%and if placed wrongly then back is upside which is bigger circle than the mouth
    end				%so the components should have areas of mouth or areas of back. 
    bw3=bwlabel(bw3,4);		%The components with middle area is suspicious
    s4=regionprops(bw3,'Area');	%here, I have found the mouth can be of 
end				%maximum 1800 pixels and back is not less than 3500 pixels.	
%so, I removed the middle components
bw4=bwlabel(bw3,4);		%labeling 4-connectivity components
v=regionprops(bw4,'Centroid','Area'); %finding the centroid and area of the different components
centres=cat(1,v.Centroid); 		%concatenating the centroid in centres array and returning the centres	
area=cat(1,v.Area); 		%concatenating the area in area array and returning the area
end
