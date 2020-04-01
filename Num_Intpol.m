function [Int_Lat, Int_Lon, coordinate, Interpolated_Values] = Num_Intpol (sta, Corrected_Values, Intpol_Dis_Deg, Int_type_tag, Win_lim_tag, Win_lim)
%Num_Intpol (sta, Corrected_Values, Intpol_Dis_Deg, Win_lim_tag, Win_lim)
%  Numerical Interpolation Between a Number of Scattered Points
%
%  Data for Interpolation:
%      sta Input : Coordinates of Scattered Points
%      Corrected_Values Input : Values in Scattered Points
%      Intpol_Dis_Deg Input : The Interval Space Between Interpolated Points in Degree
%      Int_type_tag Input : Int_type_tag = 1 for Linear Interpolation
%                         : Int_type_tag = 2 for Natural Interpolation
%                         : Int_type_tag = 3 for Nearest Interpolation
%                         : Int_type_tag = 4 for Thin-plate smoothing spline Interpolation
%      Win_lim_tag Input : Win_lim_tag = 0 for Urban & Very Dense Urban
%      Shakemaps with not Defined Geographical Window
%      Win_lim Input : Limitations for Geographical Window for Regional Shakemaps & Urban In Case that It Is Defined by User
%                    : Zero Matrix for Urban Shakemaps if User did not Define that.
%
%  Output:
%      Int_Lat Output : Latitudes Matrix of the Interpolated Points
%      Int_Lon Output : Longitudes Matrix of the Interpolated Points
%      coordinate Output : Its First Row Is Longitudes of the Interpolated Points
%                        : Its Second Row Is Latitudes of the Interpolated Points
%      Interpolated_Values Output : Amplitude Values in Interpolated Points
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
Lon=sta(1:s_num,1);
Lat=sta(1:s_num,2);
% % % % % % % % % % % % % % % % % limitation % % % % % % % % % % % % % % %%
if Win_lim_tag == 0;
    lat_down_lim=min(Lat);
    lat_up_lim=max(Lat);
    lon_down_lim=min(Lon);
    lon_up_lim=max(Lon);
    Win_lim=[lat_down_lim , lat_up_lim ; lon_down_lim , lon_up_lim];
end
%% Interpolation
% % % % % % % % % % % Locating Interpolation Points % % % % % % % % % % % %
[Int_Lat,Int_Lon] = meshgrid((Win_lim(1,1)):Intpol_Dis_Deg:(Win_lim(1,2)),(Win_lim(2,1)):Intpol_Dis_Deg:(Win_lim(2,2)));
% % % % % % % % % % % % % % % % Interpolation % % % % % % % % % % % % % % %
if Int_type_tag == 1;
    Int_Func = TriScatteredInterp(Lon,Lat,Corrected_Values,'linear');
    Interpolated_Values = Int_Func(Int_Lon, Int_Lat);
end
if Int_type_tag == 2;
    Int_Func = TriScatteredInterp(Lon,Lat,Corrected_Values,'natural');
    Interpolated_Values = Int_Func(Int_Lon, Int_Lat);
end
if Int_type_tag == 3;
    Int_Func = TriScatteredInterp(Lon,Lat,Corrected_Values,'nearest');
    Interpolated_Values = Int_Func(Int_Lon, Int_Lat);
end
coordinate= zeros(2,((length(Int_Lat(1,:)))*(length(Int_Lon(:,1)))));
for i = 1:(length(Int_Lat(1,:)))
    coordinate(1,((i*(length(Int_Lon(:,1)))-(length(Int_Lon(:,1))))+1):(i*(length(Int_Lon(:,1)))))=Int_Lon(:,1);
    coordinate(2,((i*(length(Int_Lon(:,1)))-(length(Int_Lon(:,1))))+1):(i*(length(Int_Lon(:,1)))))=Int_Lat(1,i);
end
if Int_type_tag == 4;
    LonLat(1,:) = Lon(:,1);
    LonLat(2,:) = Lat(:,1);
    Corrected_Values = reshape(Corrected_Values,1,[]);
    sm_sp = tpaps(LonLat, Corrected_Values, 1.0);
    Interpolated_Values = fnval(sm_sp, coordinate);
end
%% % % % % % % % % % % Plotting Interpolated Surface % % % % % % % % % % %%
figure( 'Name', 'Interpolated Surface','Color',[1 1 1] );
if Int_type_tag == 3 || Int_type_tag == 2 || Int_type_tag == 1
    mesh(Int_Lon, Int_Lat, Interpolated_Values);
    hold on
    plot3(Lon,Lat,Corrected_Values,'o','markerfacecolor','k');
    hold off
end
if Int_type_tag == 4;
    fnplt(sm_sp);
    hold on
    plot3(Lon,Lat,Corrected_Values,'o','markerfacecolor','k');
    hold off    
end
xlabel({'LONGITUDE'},'FontWeight','bold','FontName','Times');
ylabel({'LATITUDE'},'FontWeight','bold','FontName','Times');
map_title= strvcat ('             Interpolated Surface             ','          *- Produced by peeqMap -*');
title(map_title ,'fontsize',10,'fontweight','bold');
output_folder = [pwd filesep 'output_folder' filesep 'visual_outputs']; 
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd (output_folder)
print('-dtiff','-r300',' Interpolated Surface.tif')
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd ..
cd ..