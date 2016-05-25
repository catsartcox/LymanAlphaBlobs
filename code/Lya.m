%LyA Blobs Graph Program
%Arthur Cox
%acox20@nmsu.edu

%Note, for the time being the lablobs folder needs to be on your desktop
%to work.
%2nd note, the importdata function is deisgned for a mac file stucture.
%Some modifactions need to be made in line 34 of importdata if it is going to
%be used on windows.
%3rd note, the datafiles folder must be inside the same folder as the code

%programstart
clc
clear
close all


%Questions
choice = questdlg('What color?', ...
	'Color?', ...
	'red','blue','both','both');

switch choice
    case 'red';
        disp([choice '--- red confimerd'])
        color = 'red';
    case 'blue';
        disp([choice '--- blue comfired '])
        color = 'blue';
    case 'both';
        disp([choice '--- both comfired '])
        color = 'blue';
end
choice = questdlg('How wide do you want the aperture?', ...
	'Aperture size?', ...
	'1 pixel','5 pixels','wide','wide');
switch choice
    case '1 pixel';
        disp([choice '--- 1 pixel wide confimerd'])
        size = 'velo';
    case '5 pixels';
        disp([choice '--- 5 pixels wide comfired '])
        size = 'velobin';
    case 'wide';
        disp([choice '--- Max width comfired '])
        size = 'wide';
end

choice = questdlg('Which of the two angles do you want?', ...
	'Aperture size?', ...
	'52.44 degrees','146.0 degrees','146.0 degrees');
switch choice
    case '52.44 degrees';
        disp([choice '--- 52.44 degrees confimerd'])
        angle = 'MID_B';
    case '146.0 degrees';
        disp([choice '--- 146.0 degrees comfired '])
        angle = 'A_B';
end

promptx = {sprintf('What should be on the X Axis? \n Enter ether lya, heii, civ, ciii, neiv, nv, siiv or oii \n Leave as 1 if N/A \n\n Line 1:'),'Over'};
prompty = {sprintf('What should be on the Y Axis? \n Enter ether lya, heii, civ, ciii, neiv, nv, siiv or oii \n Leave as 1 if N/A \n\n Line 1:'),'Over'};
defaultansx = {'civ', 'heii'};
defaultansy = {'civ', 'ciii'};
dlg_title = 'What should be on the x axes? ';
num_lines = 1;
answerx = inputdlg(promptx,dlg_title,num_lines,defaultansx);

dlg_title = 'What should be on the y axes? ';
answery = inputdlg(prompty,dlg_title,num_lines,defaultansy);

choice = questdlg('What you like to plot the best fit line?', ...
	'Choose', ...
	'yes','no','no');
switch choice
    case 'yes';
        disp([choice '--- yes confimerd'])
        prompt = {sprintf(' \n\n Line 1:'),'Line 2:'};
        defaultans = {'1', '2'};
        fitonoff = 1;
    case 'no';
        disp([choice '--- no comfired '])
        prompt = {sprintf(' \n\n Line 1:'),'Line 2:', 'Line 3'};
        defaultans = {'1','2','3'};
        fitonoff = 2;
end

choice = questdlg('What you like to plot error?', ...
	'Choose', ...
	'yes','no','no');
switch choice
    case 'yes';
        disp([choice '--- yes confimerd'])
        prompt = {sprintf(' \n\n Line 1:'),'Line 2:'};
        defaultans = {'1', '2'};
        erroronoff = 1;
    case 'no';
        disp([choice '--- no comfired '])
        prompt = {sprintf(' \n\n Line 1:'),'Line 2:', 'Line 3'};
        defaultans = {'1','2','3'};
        erroronoff = 2;
end
if erroronoff==1
choice = questdlg('What you like the error bars to be lya or s/n', ...
	'Choose', ...
	'lya','s/n','s/n');
switch choice
    case 'lya';
        disp([choice '--- lya confimerd'])
        prompt = {sprintf(' \n\n Line 1:'),'Line 2:'};
        optiononoff = 1;
    case 's/n';
        disp([choice '--- s/n comfired '])
        prompt = {sprintf(' \n\n Line 1:'),'Line 2:', 'Line 3'}; 
        optiononoff = 2;
end
end

% prompt = {sprintf('What should be the cut?')};
% defaultans = {'3'};
% dlg_title = 'What should be the cut off? ';
% num_lines = 1;
% cuts = inputdlg(prompt,dlg_title,num_lines,defaultans);



choice = questdlg('What you like to plot color?', ...
	'Choose', ...
	'yes','no','no');
switch choice
    case 'yes';
        disp([choice '--- yes confimerd'])
        prompt = {sprintf(' \n\n Line 1:'),'Line 2:'};
        coloronoff = 1;
    case 'no';
        disp([choice '--- no comfired '])
        prompt = {sprintf(' \n\n Line 1:'),'Line 2:', 'Line 3'};
        coloronoff = 2;
end

y1 = answery(1,1);
x1 = answerx(1,1);
y2 = answery(2,1);
x2 = answerx(2,1);

oii = strcmp(x1,'oii');
if oii == 1;
       color2 = 'red';
else
    color2 = color;
end


% import and parse 
[y1i] = importdata(color,size,angle,y1);
signaly1=y1i(:,10);
errory1=y1i(:,11);

[x1i] = importdata(color2,size,angle,x1);
signalx1=x1i(:,10);
errorx1=x1i(:,11);

[y2i] = importdata(color,size,angle,y2);
signaly2=y2i(:,10);
errory2=y2i(:,11);

[x2i] = importdata(color,size,angle,x2);
signalx2=x2i(:,10);
errorx2=x2i(:,11);

lyaname = 'lya';
[lya] = importdata(color,size,angle,lyaname);
signallya=lya(:,10);
noiselya=lya(:,11);

[nsignaly1]=[];
[nsignaly2]=[];
[nsignalx1]=[];
[nsignalx2]=[];
[nerrory1]=[];
[nerrory2]=[];
[nerrorx1]=[];
[nerrorx2]=[];

%signel to noise cut of 3

%cut number
cut = 2;


if optiononoff==2
for i=1:length(signaly1)
    if signaly1(i)/errory1(i)>cut && signaly2(i)/errory2(i)>cut && signalx1(i)/errorx1(i)>cut && signalx2(i)/errorx2(i)>cut
        [nsignaly1]=[nsignaly1;signaly1(i)]; 
        [nsignaly2]=[nsignaly2;signaly2(i)];
        [nsignalx1]=[nsignalx1;signalx1(i)];
        [nsignalx2]=[nsignalx2;signalx2(i)];
        [nerrory1]=[nerrory1;errory1(i)]; 
        [nerrory2]=[nerrory2;errory2(i)];
        [nerrorx1]=[nerrorx1;errorx1(i)];
        [nerrorx2]=[nerrorx2;errorx2(i)];
    end
end
elseif optiononoff==1
for i=1:length(signaly1)
    if signallya(i)/noiselya(i)>cut
        [nsignaly1]=[nsignaly1;signaly1(i)]; 
        [nsignaly2]=[nsignaly2;signaly2(i)];
        [nsignalx1]=[nsignalx1;signalx1(i)];
        [nsignalx2]=[nsignalx2;signalx2(i)];
        [nerrory1]=[nerrory1;errory1(i)]; 
        [nerrory2]=[nerrory2;errory2(i)];
        [nerrorx1]=[nerrorx1;errorx1(i)];
        [nerrorx2]=[nerrorx2;errorx2(i)];
    end
end
end
logsigvaly=log10(nsignaly1./nsignaly2);
logsigvalx=log10(nsignalx1./nsignalx2);


x=nsignalx1./nsignalx2;
y=nsignaly1./nsignaly2;

err_x = x .* sqrt(((nerrorx1./nsignalx1).^2)+((nerrorx2./nsignalx2).^2));
err_y = y .* sqrt(((nerrory1./nsignaly1).^2)+((nerrory2./nsignaly2).^2));

errorplusx=.434 .* err_x./x;
errornegativex=.434 .* err_x./x;
errorplusy=.434 .* err_y./y;
errornegativey=.434 .* err_y./y;


%best fit line


A=[logsigvalx,ones(length(logsigvalx),1)];
y=log(logsigvaly);
c=(A'*A)\(A'*y);
ec=c(1);
A=[exp(ec*logsigvalx),logsigvalx.^2,logsigvalx,ones(length(logsigvalx),1)];
y=logsigvaly;
c=(A'*A)\(A'*y);
x=linspace(min(logsigvalx)-1,max(logsigvalx),200);
y=c(1)*exp(ec*x)+c(2)*x.^2+c(3)*x+c(4);

%plot
xlab = char(strcat('log(',x1,'/',x2,')'));
ylab = char(strcat('log(',y1,'/',y2,')'));

if fitonoff==1
figure
plot(logsigvalx,logsigvaly,'ro',x,y,'b-')
title('Plot With Best-Fit line')
axis([-3,3,-2,2])
xlabel(xlab)
ylabel(ylab)
end

if erroronoff==1
    figure
    hold on
    errorbar(logsigvalx,logsigvaly,errorplusy,errornegativey,'ro')
    herrorbar(logsigvalx,logsigvaly,errornegativex,'bo')
    plot(logsigvalx,logsigvaly,'bo')
    axis([-3,3,-2,2])
    title('Plot with Error Bars')
    xlabel(xlab)
    ylabel(ylab)
    hold off
end

if coloronoff==1
color=jet(length(logsigvalx));
figure
hold on
for i=1:length(logsigvalx)
    plot3(logsigvalx(i),logsigvaly(i),i,'MarkerEdgeColor',color(i,:),'MarkerFaceColor',color(i,:),'Marker','o')
    axis([-3,3,-2,2])
    title('3D Plot with color')
    xlabel(xlab)
    ylabel(ylab)
    zlabel('Place')
    grid on
end
hold off
end

