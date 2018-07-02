function sidetext(str,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7,p8,v8)
%SIDETEXT	label's the right hand side of an axes for 2-D and 3-D plots.
% 	SIDETEXT('text') adds text beside the X-axis on the current axis.
%
%	SIDETEXT('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%	sets the values of the specified properties of the sidetext.
%
%	See also XLABEL, YLABEL, ZLABEL, TITLE, TEXT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Modified 12/15/95 to put text on side of axes - PRM

ax = gca;
h = findobj(get(ax,'children'),'tag','side_text_string');

if h
  set(h,'string',str);
else
  h = text(1.05,0.5,str,'units','normalized','Vertical','middle',...
	'Horizontal','center','rotation',90,'tag','side_text_string');
end

%Over-ride text objects default font attributes with
%the Axes' default font attributes.
set(h,  'FontAngle',  get(ax, 'FontAngle'), ...
	    'FontName',   get(ax, 'FontName'), ...
	    'FontSize',   get(ax, 'FontSize'), ...
	    'FontWeight', get(ax, 'FontWeight'), ...
	    'string',     str);

if nargin > 1,
	if (nargin-1)/2-fix((nargin-1)/2),
		error('Incorrect number of input arguments')
	end
	cmdstr='';
	for i=1:(nargin-1)/2-1,
		cmdstr = [cmdstr,'p',num2str(i),',v',num2str(i),','];
	end
	cmdstr = [cmdstr,'p',num2str((nargin-1)/2),',v',num2str((nargin-1)/2)];
	eval(['set(h,',cmdstr,');']);
end
