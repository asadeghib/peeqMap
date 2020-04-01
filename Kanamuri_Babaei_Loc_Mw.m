function [Centroid_Lat,Centroid_Lon,Mw] = Kanamuri_Babaei_Loc_Mw(sta, Win_lim)
%Kanamuri_Babaei_Loc_Mw(sta)
%  Estimation of Centroid Coordinate and Magnitude.
%
%  Data for Estimation:
%      sta Input : Coordinate and Recorded Peak Valus
%      Win_lim Input : Limitations for Geographical Window
%
%  Output:
%      Centroid_Lat Output : Latitude of the Centroid
%      Centroid_Lon Output : Longitude of the Centroid
%      Mw Output : Centroid Mw
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
s_num=length(sta(:,1));
Lon=sta(:,1);
Lat=sta(:,2);
PHA_L= sta(:,3);
PHA_T= sta(:,4);
PHA= (((PHA_L.^2)+(PHA_T.^2)).^0.5);
PHA_log= log(PHA);
%% % %  Attenuation relationship (BA08) with respect to lat & long % %%
[cfun,~,~] = createSurfaceFit(Lon, Lat, PHA_log, Win_lim);
% % % % % % % % % % % % % % % valeus of Coefficients % % % % % % % % % % %%
cof = coeffvalues(cfun);
Centroid_Lat = cof(1,1);% Lattitude of Centroid
Centroid_Lon = cof(1,2);% Longitude of Centroid
Mw = cof(1,3);
%% % % % % % % % % % % % % % % % % %Mapping% % % % % % % % % % % % % % % %%
figure( 'Name', 'Stations & Centroid','Color',[1 1 1] );
worldmap([Win_lim(1,1) Win_lim(1,2)],[Win_lim(2,1) Win_lim(2,2)])
Cent_Lat = zeros (s_num, 1);
Cent_Lon = zeros (s_num, 1);
Cent_Lat (1:s_num, 1) = Centroid_Lat;
Cent_Lon (1:s_num, 1) = Centroid_Lon;
[c_lat,c_lon] = scircle2(Lat,Lon,Cent_Lat,Cent_Lon);
plotm(c_lat,c_lon,'b')
for kj=1:s_num
    plotm(Lat(kj, 1), Lon(kj, 1), 'Marker', '^', 'MarkerFaceColor', [0 1 0]);
end
plotm(Centroid_Lat, Centroid_Lon, 'Marker', 'p', 'MarkerFaceColor',[1 0 0], 'MarkerSize', 14) 
scaleruler on
setm(handlem('scaleruler'), ...
    'MajorTick', 0:50:100,...
    'MinorTick', 0:25:50, ...
    'TickDir', 'down', ...
    'MajorTickLength', km2nm(25),...
    'MinorTickLength', km2nm(12.5))
map_title= strvcat ('        Recording Stations & Centroid        ','          *- Produced by peeqMap -*');
title(map_title ,'fontsize',10,'fontweight','bold');
output_folder = [pwd filesep 'output_folder' filesep 'visual_outputs'];
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd (output_folder)
print('-dtiff','-r300','Stations & Centroid.tif')
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd ..
cd ..