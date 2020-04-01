function [Phantom_sta_coord] = Phantom_sta_location (sta,Win_lim,Phantom_sta_Dis_km)
%Phantom_sta_location (sta,Win_lim,Phantom_sta_Dis_km)
%  Locating Phantom Stations.
%
%  Data for Estimation:
%      sta Input : Coordinate and Recorded Peak Valus
%      Win_lim Input : Limitations for Geographical Window
%      Phantom_sta_Dis_km Input : The Distance Between Phantom Stations
%
%
%  Output:
%      Phantom_sta_coord Output : Coordinates of the Phantom Stations
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
%%
s_num = length(sta(:,1));
Lon = sta(1:s_num,1);
Lat = sta(1:s_num,2);
Phantom_sta_Dis_Deg = km2deg(Phantom_sta_Dis_km);
Phantom_Lat = (Win_lim(1,1)- Phantom_sta_Dis_Deg):Phantom_sta_Dis_Deg:(Win_lim(1,2)+ Phantom_sta_Dis_Deg);
Phantom_Lon = (Win_lim(2,1)- Phantom_sta_Dis_Deg):Phantom_sta_Dis_Deg:(Win_lim(2,2)+ Phantom_sta_Dis_Deg);
Phantom_Lon = reshape(Phantom_Lon,[],1);
Phantom_Lat = reshape(Phantom_Lat,[],1);
coordinate = zeros((length(Phantom_Lon)*length(Phantom_Lat)),2);
for j = 1:length(Phantom_Lat)
    for i = 1:length(Phantom_Lon)
        l = (length(Phantom_Lon)*j)-length(Phantom_Lon);
        coordinate(l+i,1) = Phantom_Lat(j);
        coordinate(l+i,2) = Phantom_Lon(i);
        for k = 1:s_num          
            LD = distance(sta(k,2),sta(k,1),coordinate(l+i,1),coordinate(l+i,2));
            if LD <= Phantom_sta_Dis_Deg                
                coordinate(l+i,1) = 0;
                coordinate(l+i,2) = 0;
            end
        end
    end
end
Llat = coordinate(:,1);
Llon = coordinate(:,2);
b = find (Llat);
c = find (Llon);
Phantom_sta_coord(:,1) = Llon(b);
Phantom_sta_coord(:,2) = Llat(c);
Lon_fan = Phantom_sta_coord(:,1);
Lat_fan = Phantom_sta_coord(:,2);

output_folder = [pwd filesep 'output_folder' filesep 'txt_outputs' filesep];
fid = fopen([output_folder 'Phantom_sta_coord.txt'],'wt');
%% % % % % % % % % % % % % % % % % %Mapping% % % % % % % % % % % % % % % %%
figure( 'Name', 'Observational & Phantom Stations','Color',[1 1 1]  );
worldmap([Win_lim(1,1) Win_lim(1,2)], [Win_lim(2,1) Win_lim(2,2)])
for kj = 1:s_num
    plotm(Lat(kj, 1), Lon(kj, 1), 'Marker', '^', 'MarkerFaceColor', [1 0 0]);
end
for jk = 1:(length(Lon_fan))
    
    plotm(Lat_fan(jk), Lon_fan(jk), 'marker','o', 'MarkerFaceColor', [0 1 0]);    
    fprintf(fid,['%8.3f'   '%8.3f\n'] , Phantom_sta_coord(jk,1),Phantom_sta_coord(jk,2));
end
scaleruler on
setm(handlem('scaleruler'), ...
    'MajorTick', 0:50:100,...
    'MinorTick', 0:25:50, ...
    'TickDir', 'down', ...
    'MajorTickLength', km2nm(25),...
    'MinorTickLength', km2nm(12.5))
map_title= strvcat ('      Observational & Phantom Stations      ','          *- Produced by peeqMap -*');
title(map_title ,'fontsize',10,'fontweight','bold');
output_folder = [pwd filesep 'output_folder' filesep 'visual_outputs'];
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd (output_folder)
print('-dtiff','-r300','Observational & Phantom Stations.tif');
fclose(fid);
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd ..
cd ..