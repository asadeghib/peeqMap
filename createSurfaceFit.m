function [cfun,gof,output] = createSurfaceFit(Lon, Lat, gh, Win_lim)
%CREATESURFACEFIT(X,L,GH)
%  Fit surface to data.
%
%  Data for fit:
%      X Input : Lon
%      Y Input : Lat
%      Z output: gh
%      Weights : (none)
%
%  Output:
%      cfun Output : an sfit object representing the fit.
%      gof Output : structure with goodness-of fit info.
%
% For more information email: Amir.Sadeghi@Hotmail.com
% 
% TERMS OF USE If you use peeqMap or any function(s) of it, you need to 
% acknowledge peeqMap by citing the following article:
% 
% Sadeghi-Bagherabadi, A., Sadeghi, H., Fatemi Aghda, S.M., Sinaeian, F., 
% Mirzaei Alavijeh, H., Farzanegan, E., Hosseini, S.K., Babaei, P., (2013).
% Real-time mapping of PGA distribution in tehran using TRRNet and peeqMap. 
% Seismol. Res. Lett., 84(6):1004–13. https://doi.org/10.1785/0220120165.
%% Initialization.

% Convert all inputs to column vectors.
Lon = Lon(:);
Lat = Lat(:);
gh = gh(:);

%% Fit
% ft = fittype( '((-0.53804+0.28805.*(m-6.75)+(-0.10164.*(m-6.75).^2))+((-0.66050+0.11970.*(m-4.5)).*log((((6371.01.*2*atan2(((sin(((y.*0.0175)-(lat1*0.0175))./2).^2)+(cos(lat1*0.0175)).*(cos((y.*0.0175))).*((sin(((x.*0.0175)-(lon1*0.0175))./2)).^2)).^0.5 ,(1-((sin(((y.*0.0175)-(lat1*0.0175))./2).^2)+(cos((lat1*0.0175))).*(cos((y.*0.0175))).*((sin(((x.*0.0175)-(lon1*0.0175))./2)).^2)).^0.5).^0.5)).^2)+(1.35^2)).^0.5)+(-0.1151.*((((6371.01.*2*atan2(((sin(((y.*0.0175)-(lat1*0.0175))./2).^2)+(cos(lat1*0.0175)).*(cos((y.*0.0175))).*((sin(((x.*0.0175)-(lon1*0.0175))./2)).^2)).^0.5 ,(1-((sin(((y.*0.0175)-(lat1*0.0175))./2).^2)+(cos((lat1*0.0175))).*(cos((y.*0.0175))).*((sin(((x.*0.0175)-(lon1*0.0175))./2)).^2)).^0.5).^0.5)).^2)+(1.35^2)).^0.5)-1))+0.566)', 'indep', {'x', 'y'}, 'depend', 'z' );
% '((-0.53804+0.28805.*(m-6.75)+(-0.10164.*(m-6.75).^2))+((-0.66050+011970.*(m-4.5)).*log((((6371.01.*2*atan2(((sin(((y.*0.0175)-(lat1*0.0175))./2).^2)+(cos(lat1*0.0175)).*(cos((y.*0.0175))).*((sin(((x.*0.0175)-(lon1*0.0175))./2)).^2)).^0.5 ,(1-((sin(((y.*0.0175)-(lat1*0.0175))./2).^2)+(cos((lat1*0.0175))).*(cos((y.*0.0175))).*((sin(((x.*0.0175)-(lon1*0.0175))./2)).^2)).^0.5).^0.5)).^2)+(1.35^2)).^0.5)+(-0.1151.*((((6371.01.*2*atan2(((sin(((y.*0.0175)-(lat1*0.0175))./2).^2)+(cos(lat1*0.0175)).*(cos((y.*0.0175))).*((sin(((x.*0.0175)-(lon1*0.0175))./2)).^2)).^0.5 ,(1-((sin(((y.*0.0175)-(lat1*0.0175))./2).^2)+(cos((lat1*0.0175))).*(cos((y.*0.0175))).*((sin(((x.*0.0175)-(lon1*0.0175))./2)).^2)).^0.5).^0.5)).^2)+(1.35^2)).^0.5)-1))+0.566)', 'indep', {'x', 'y'}, 'depend', 'z' );
% R = (       6371.01.*(  2*atan2(    ((Sur).^0.5)  ,   (Makh)    )   )        )
% Sur = ( ((cos (CLat.*0.0175).*sin (Clon.*0.0175 - x.*0.0175)).^2)+((cos (y.*0.0175).*sin(CLat.*0.0175)-cos(CLat.*0.0175).*sin(y.*0.0175).*cos(CLon.*0.0175 - x.*0.0175)).^2) )
% Makh = (sin(y.*0.0175).*sin(CLat.*0.0175) + cos(y.*0.0175).*cos(CLat.*0.0175).*cos(CLon.*0.0175 - x.*0.0175))
% R = (       6371.01.*(  2*atan2(    ((( ((cos (CLat.*0.0175).*sin (Clon.*0.0175 - x.*0.0175)).^2)+((cos (y.*0.0175).*sin(CLat.*0.0175)-cos(CLat.*0.0175).*sin(y.*0.0175).*cos(CLon.*0.0175 - x.*0.0175)).^2) )).^0.5)   ,  ((sin(y.*0.0175).*sin(CLat.*0.0175) + cos(y.*0.0175).*cos(CLat.*0.0175).*cos(CLon.*0.0175 - x.*0.0175)))    )   )        );
ft = fittype( '(-0.53804+0.28805.*(m-6.75)+(-0.10164.*(m-6.75).^2))   +  (-0.66050+0.11970.*(m-4.5)).*log(sqrt(((       6371.01.*(  2*atan2(    ((( ((cos (CLat.*0.0175).*sin (CLon.*0.0175 - x.*0.0175)).^2)+((cos (y.*0.0175).*sin(CLat.*0.0175)-cos(CLat.*0.0175).*sin(y.*0.0175).*cos(CLon.*0.0175 - x.*0.0175)).^2) )).^0.5)   ,   ((sin(y.*0.0175).*sin(CLat.*0.0175) + cos(y.*0.0175).*cos(CLat.*0.0175).*cos(CLon.*0.0175 - x.*0.0175)))    )   )        ).^2)+1.35^2))+(-0.01151.*((sqrt(((       6371.01.*(  2*atan2(    ((( ((cos (CLat.*0.0175).*sin (CLon.*0.0175 - x.*0.0175)).^2)+((cos (y.*0.0175).*sin(CLat.*0.0175)-cos(CLat.*0.0175).*sin(y.*0.0175).*cos(CLon.*0.0175 - x.*0.0175)).^2) )).^0.5)    ,   ((sin(y.*0.0175).*sin(CLat.*0.0175) + cos(y.*0.0175).*cos(CLat.*0.0175).*cos(CLon.*0.0175 - x.*0.0175)))    )   )        ).^2)+1.35^2)))-1)+0.566' , 'indep', {'x', 'y'}, 'depend', 'z');
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [Win_lim(1,1) Win_lim(2,1) 3];
opts.StartPoint = [0.955 0.266159949829683 0.420440775936302];
opts.Upper = [Win_lim(1,2) Win_lim(2,2) (10)];
opts.Weights = zeros(1,0);
[cfun,gof,output] = fit( [Lon, Lat], gh, ft, opts );
%% Plot fit with data.
figure( 'Name', 'surface fit','color',[1 1 1]);
plot( cfun, [Lon, Lat], gh );
xlabel({'LONGITUDE'},'FontWeight','bold','FontName','Times');
ylabel({'LATITUDE'},'FontWeight','bold','FontName','Times');
zlabel({'log(PGA) (g)'},'LineWidth',1,'FontWeight','bold','FontName','Times');
map_title= strvcat ('Fitted Attenuation Surface to Recorded Peaks','          *- Produced by peeqMap -*');
title(map_title ,'fontsize',10,'fontweight','bold');
grid on
box off
output_folder = [pwd filesep 'output_folder' filesep 'visual_outputs'];
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd (output_folder)
print('-dtiff','-r300','Surface Fit.tif')
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd ..
cd ..