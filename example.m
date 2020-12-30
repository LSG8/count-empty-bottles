% Machine Vision
%
% example code for Home Assignment: Counting Empty Bottles


number_of_points=10000; % used for drawing circles
t=linspace(0,2*pi,number_of_points); % used for drawing circles
daspect([1 1 1]) % the axis aspect ratios are set to equal ratios

number_of_bottles=[20 18 20 20 20 20 20 20 13 17 20 17 19 20 18 20 17 20 16 19 11 11 20 20];
estimated_number_of_bottles=zeros(1,length(number_of_bottles));

for i=1:length(number_of_bottles)
    fname=sprintf('crate images/bottle_crate_%02i.png',i);
    f=imread(fname);
    imshow(f),title('original image')
    hold on
    [centres,area]=detect(f);
    sz=size(centres);
    j=0;
    for j=1:sz(1)
        centroid=centres(j,:);
        if (area(j) < 3500)
            radius=20;
            col=[0 1 0];
        else
            radius=(sqrt(area(j)/pi));
            col=[0.9 0.65 0];
        end
        h=circle(centroid,radius,number_of_points,'-');
        set(h,'LineWidth',5)
        set(h,'Color',col)
    end
    hold off
    estimated_number_of_bottles(i)=j;
    [estimated_number_of_bottles(i) number_of_bottles(i)]
pause
end

