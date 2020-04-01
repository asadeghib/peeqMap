function [Amplified_Values, F_Final] = Site_Amp_Factor (Win_lim, Vo, pgp_tag, Int_Lat, Int_Lon, Interpolated_Values, Reduced_Values)
%Det_Corr_Factor (Sta_Vs30)
% Determination of Correction Factors for Acceleration & Velocity as well
% as Reducing & Amlifying Amplitudes
%
%  Data for Estimation:
%      Vo Input : Shear-wave Velocitiy in Uppermost 30 Meters of the Reference Site
%      pgp_tag Input : pgp_tag = 'PGA' For Estimation of PGA
%                      pgp_tag = 'PGV' For Estimation of PGV
%                      pgp_tag = The Desired period For Estimation of PSA
%      Int_Lat Input : Latitude Matrix of the Interpolated Points
%      Int_Lon Input : Longitude Matrix of the Interpolated Points
%      Interpolated_Values Input : Amplitude Values in Interpolated Points

%  Output:
%      Amplified_Values Output : Amplified Values in Interpolated Points
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
Scattered_V30 = [pwd filesep 'input_folder' filesep 'Scattered_V30.txt']; 

% Int_Lat = reshape (Int_Lat, [], 1);
% Int_Lon = reshape (Int_Lon, [], 1);

sta= load(Scattered_V30);
Sta_Vs30= sta(:, 3);
s_num=length(Sta_Vs30);
Int_Lon_Sca= sta(:,1);
Int_Lat_Sca= sta(:,2);
Fa= zeros (s_num,1);
Fv= zeros (s_num,1);
Amplified_Values= zeros (s_num,1);
%% Estimation of Amplitudes in Scattered Points
Obs_Phantom_Coord = [pwd filesep 'output_folder' filesep 'txt_outputs' filesep 'Obs_Phantom_Coord.txt'];
Obs_Phantom_PGAMPs = [pwd filesep 'output_folder' filesep 'txt_outputs' filesep 'Obs_Phantom_PGAMPs.txt'];

if (exist (Obs_Phantom_Coord,'file') == 2) && (exist (Obs_Phantom_PGAMPs,'file') == 2)
    Obs_Phantom_Coord= load(Obs_Phantom_Coord);
    Obs_Phantom_PGAMPs= load(Obs_Phantom_PGAMPs);
else
    Obs_Phantom_PGAMPs = Reduced_Values;
    stainput = [pwd filesep 'input_folder' filesep 'urb_station_info.txt']; 
    Obs_Phantom_Coord = load (stainput);
%     PHA_L = Obs_Phantom_Coord(:,3);
%     PHA_T = Obs_Phantom_Coord(:,4);
%     Obs_Phantom_PGAMPs = (((PHA_L.^2)+(PHA_T.^2)).^0.5);
%     if (strncmp(pgp_tag, 'PGA', 3) == 1) %PGA
%         Obs_Phantom_PGAMPs = Obs_Phantom_PGAMPs./Fa;
%     end
%     if (strncmp(pgp_tag, 'PGV', 3) == 1) %PGV
%         Obs_Phantom_PGAMPs = Obs_Phantom_PGAMPs./Fv;
%     end
end
Int_Func_Vs30 = TriScatteredInterp(Obs_Phantom_Coord(:,1),Obs_Phantom_Coord(:,2),Obs_Phantom_PGAMPs,'nearest');
PHA = Int_Func_Vs30(Int_Lon_Sca, Int_Lat_Sca);

%% Determination of Correction Factors for Acceleration & Velocity as well as Reducing & Amlifying Amplitudes
for i = 1:s_num
%% Determination of Correction Factors for Acceleration & Velocity
    if PHA (i) < 0.2
        Ma = 0.35;
        Mv = 0.65;
        Fa(i) = (Vo/Sta_Vs30(i))^Ma;
        Fv(i) = (Vo/Sta_Vs30(i))^Mv;
    end
    if  PHA (i) < 0.3 && 0.2 < PHA (i)
        Ma = 0.25;
        Mv = 0.6;
        Fa(i) = (Vo/Sta_Vs30(i))^Ma;
        Fv(i) = (Vo/Sta_Vs30(i))^Mv;
    end
    if  PHA (i) < 0.4 && 0.3 < PHA  (i)
        Ma = 0.1;
        Mv = 0.53;
        Fa(i) = (Vo/Sta_Vs30(i))^Ma;
        Fv(i) = (Vo/Sta_Vs30(i))^Mv;
    end
    if PHA (i) > 0.4
        Ma = -0.05;
        Mv = 0.45;
        Fa(i) = (Vo/Sta_Vs30(i))^Ma;
        Fv(i) = (Vo/Sta_Vs30(i))^Mv;
    end
end
%% Amlification of Amplitudes
Interpolated_Values = reshape (Interpolated_Values, [], 1);
if (strncmp(pgp_tag, 'PGA', 3) == 1) %PGA 
    Int_Func_Final = TriScatteredInterp(Int_Lon_Sca,Int_Lat_Sca,Fa,'nearest');
    Fa_Final = Int_Func_Final(Int_Lon, Int_Lat); 

    F_Final = reshape (Fa_Final, [], 1);
    Amplified_Values = Interpolated_Values.*F_Final;
    geoshow(Int_Lat,Int_Lon,Fa_Final, 'DisplayType', 'texturemap');
    %contourfm(Int_Lat,Int_Lon,Amplified_Values)
    colormap Jet%Hot%Autumn
    hh = colorbar('v');
    for kj=1:s_num
        plotm(Int_Lat_Sca (kj, 1), Int_Lon_Sca(kj, 1), 'Marker', 's','MarkerEdgeColor', 'k' , 'MarkerSize', 7);
    end
    [druler, dAZ] = distance(Win_lim(1,1), Win_lim(2,1), Win_lim(1,1), Win_lim(2,2));
    scaleruler on
    setm(handlem('scaleruler'), ...
        'MajorTick', 0:round(deg2km(druler/8)):round(deg2km(druler/4)),...
        'MinorTick', 0:round(deg2km(druler/16)):round(deg2km(druler/8)), ...
        'TickDir', 'down', ...
        'MajorTickLength', round(deg2km(druler/40)),...
        'MinorTickLength', round(deg2km(druler/40)))
    set(get(hh,'ylabel'),'string','Amplification Factor');
    map_title= strvcat ('             Interpolation for Site Amplification             ','                  *- Produced by peeqMap -*');
    title(map_title ,'fontsize',10,'fontweight','bold');
end
if (strncmp(pgp_tag, 'PGV', 3) == 1) %PGV
    Int_Func_Final = TriScatteredInterp(Int_Lon_Sca,Int_Lat_Sca,Fv,'nearest');
    Fv_Final = Int_Func_Final(Int_Lon, Int_Lat);

    F_Final = reshape (Fv_Final, [], 1);
    Amplified_Values = Interpolated_Values.*F_Final;
    
    geoshow(Int_Lat,Int_Lon,Fv_Final, 'DisplayType', 'texturemap');
    colormap Jet%Hot%Autumn
    hh = colorbar('v');
    for kj=1:s_num
        plotm(Int_Lat_Sca (kj, 1), Int_Lon_Sca(kj, 1), 'Marker', 's','MarkerEdgeColor', 'k' , 'MarkerSize', 7);
    end
    [druler, dAZ] = distance(Win_lim(1,1), Win_lim(2,1), Win_lim(1,1), Win_lim(2,2));
    scaleruler on
    setm(handlem('scaleruler'), ...
        'MajorTick', 0:round(deg2km(druler/8)):round(deg2km(druler/4)),...
        'MinorTick', 0:round(deg2km(druler/16)):round(deg2km(druler/8)), ...
        'TickDir', 'down', ...
        'MajorTickLength', round(deg2km(druler/40)),...
        'MinorTickLength', round(deg2km(druler/40)))
    set(get(hh,'ylabel'),'string','Amplification Factor');
    map_title= strvcat ('             Interpolation for Site Amplification             ','                  *- Produced by peeqMap -*');
    title(map_title ,'fontsize',10,'fontweight','bold');
end
PT = isnumeric(pgp_tag);
if PT == 1 %PSA
    Amplified_Values = Interpolated_Values;
    F_Final = 0;
end
%% Correction of Minus Values
% in = inpolygon(coordinate(1,:),coordinate(2,:),city_border(:,1),city_border(:,2));
% Amplified_Values(~in) = NAN;
[row , col] = find (Amplified_Values < 0 );
Amplified_Values (row , col) = 0;
