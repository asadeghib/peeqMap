% peeqMap Is A MALAB Code For Portraying The Spatial Distribution of PGA, PGV & PSA 
% Before Running peeqMap Following Variables Must to Be Defined By Users
%    M_Map_tag Input  : 1 if you are interested in using M_Map (http://www2.ocgy.ubc.ca/~rich/map.html) for plotting Results
%                     : 0 if you do not
%    pgp_tag Input    : pgp_tag = 'PGA' For Estimation of PGA
%                     : pgp_tag = 'PGV' For Estimation of PGV
%                     : pgp_tag = The Desired period For Estimation of PSA
%    FaultType Input : FaultType = 1 For Unspecified Fault Type
%                     : FaultType = 2 For Strike Slip Fault
%                     : FaultType = 3 For Normal Fault
%                     : FaultType = 4 For Reverse, Trust Fault
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
clc
if (exist ('M_Map_tag','var'))~=1 || (exist ('pgp_tag','var'))~=1 || (exist ('FaultType','var'))~=1
    disp('*************************************************************************************');
    disp('* peeqMap Is A MALAB Code For Portraying The Spatial Distribution of PGA, PGV & PSA *');
    disp('Before Running peeqMap The Following Variables Must Be Defined By Users');
    disp(' M_Map_tag Input: 1 if you are interested in using M_Map (http://www2.ocgy.ubc.ca/~rich/map.html) for plotting Results');
    disp('                : 0 if you do not');    
    disp('  pgp_tag Input : pgp_tag = PGA, For Estimation of PGA');
    disp('                : pgp_tag = PGV, For Estimation of PGV');
    disp('                : pgp_tag = The Desired period For Estimation of PSA');    
    disp(' FaultType Input : FaultType = 1 For Unspecified Fault Type');
    disp('                 : FaultType = 2 For Strike Slip Fault');
    disp('                 : FaultType = 3 For Normal Fault');
    disp('                 : FaultType = 4 For Reverse, Trust Fault');
    disp('*************************************************************************************');
    return;
end
clear INVALID_PERIOD PT mag_loc h Amplified_Values BF BF_str Centroid_Lat Centroid_Lon Elapsed_time msg F_Final Fa Fv Int_Lat Int_Lon Int_type_tag Interpolated_Values Intpol_Dis_Deg Lat_str Lat Lon_str Lon LlL M_L_tag Mag_str Mw Obs_Phantom_Coord Obs_Phantom_PGAMPs Phantom_sta_Dis_km Phantom_sta_coord Reduced_Values Vo Win_lim Win_lim_tag coordinate current_day current_hour current_minute current_month current_time current_year fid hh input_folder jjk kj lat_down_lim lat_up_lim lon_down_lim lon_up_lim map_title new_format_current_time output_folder output_folder1 s_num shake_scale sta tStart;
fclose all;
tStart=tic;
Addr = [pwd filesep 'output_folder' filesep 'visual_outputs' filesep '*.tif'];
delete(Addr);
Addr1 = [pwd filesep 'output_folder' filesep 'txt_outputs' filesep '*.txt'];
delete(Addr1);
clear Addr Addr1;
close all;
input_folder = [pwd filesep 'input_folder'];
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd (input_folder)
%% % % % % % % % % % % % Loading Observational Data % % % % % % % % % % % %
if (exist ('Vurb_station_info.txt','file') == 2)
    sta = load('Vurb_station_info.txt');
    city_border = load('city_border.txt');
    shake_scale = 1;
end
if (exist ('urb_station_info.txt','file') == 2)
    sta = load('urb_station_info.txt');
    city_border = load('city_border.txt');    
    shake_scale = 2;
end
if (exist ('reg_station_info.txt','file') == 2)
    sta = load('reg_station_info.txt');
    shake_scale = 3;
end
while (exist ('urb_station_info.txt','file') ~= 2 && exist ('reg_station_info.txt','file') ~= 2 && exist ('Vurb_station_info.txt','file') ~= 2)
    disp('**********************************************************');
    disp('***************The input file is missing!*****************');
    input_sta_name = input ('*******************PLEASE ENTER THE NAME OF THE INPUT FILE:');
    disp('');
    disp('**********************************************************');
    if (exist ('input_sta_name','var') == 1 && exist (input_sta_name,'file') == 2)    
        while (strncmp(input_sta_name, 'urb_', 4) ~= 1 && strncmp(input_sta_name, 'reg_', 4) ~= 1)
            disp('**********************************************************');
            disp('******* for producing VERY DENSE URBAN shakemaps *********');    
            disp('** the first 5 characters of the name of the input file **');
            disp('************************* must be Vurb_ *******************');
            disp('************* for producing URBAN shakemaps **************');    
            disp('** the first 4 characters of the name of the input file **');
            disp('************************* must be urb_ *******************');
            disp('*********** for producing REGIONAL shakemaps **************');
            disp('** the first 4 characters of the name of the input file **');
            disp('************************* must be reg_ *******************');
            input_sta_name = input ('PLEASE ENTER THE NAME OF THE INPUT FILE:');
            disp('');
            disp('***********************************************************');
        end
        if (strncmp(input_sta_name, 'Vurb_', 5) == 1)        
            shake_scale = 1;    
        end
        if (strncmp(input_sta_name, 'urb_', 4) == 1)
            shake_scale = 2;    
        end
        if (strncmp(input_sta_name, 'reg_', 4) == 1)        
            shake_scale = 3;
        end
        sta = load(input_sta_name);
    end
end
%% % % % % % % Loading Limitations of the Geographical Window % % % % % % %% %%
    if (exist ('Win_lim.txt','file') == 2)
    Win_lim = load ('Win_lim.txt');
    Win_lim_tag = 1;
    end
    if (exist ('Win_lim.txt','file') ~= 2)
    Win_lim_tag = 0;
    Win_lim = zeros (2, 2);
    msg = ['*' pwd filesep 'Win_lim.txt is missing!*'];
    disp(msg);
    clear msg
    disp('**********************************************************');
    disp('***************** for producing shakemaps ****************');    
    disp(' limitations of the geographical window should be defined ');
    disp('**********************************************************');
    disp('************* peeqMap will produce the map in*************');    
    disp('***** geographical area covered by recording stations*****');
    disp('**********************************************************');     
    end
%% % % % % % % % % % % % % Changing directory % % % % % % % % %  % % % % %%
    cd ..    
%% % % % % % % % producing VERY DENSE URBAN shakemaps % % % % %  % % % % %%
if (shake_scale == 1)
%% % % % % % % % % % % % % Numerical Interpolation % % % % % % % % % % % % % %%
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('********* Numerical Interpolation is Carrying Out by peeqMap *********');
    Intpol_Dis_Deg = 0.01; % THe distance between interpolation points in degree
    Int_type_tag = 4; % 1 for Linear Interpolation, 2 for Natural Interpolation, 3 for Nearest Interpolation, 4 for Thin-plate smoothing spline Interpolation
    s_num =length(sta(:,1));
    PHA_L = abs(sta(1:s_num,3));
    PHA_T = abs(sta(1:s_num,4));
    Corrected_Values = (((PHA_L.^2)+(PHA_T.^2)).^0.5);
    [Int_Lat, Int_Lon, coordinate, Interpolated_Values] = Num_Intpol (sta, Corrected_Values, Intpol_Dis_Deg, Int_type_tag, Win_lim_tag, Win_lim);
%% % % % % % % % % % % % Correction of Minus Values % % % % % % % % %  % %%
    in = inpolygon(coordinate(1,:),coordinate(2,:),city_border(:,1),city_border(:,2));
    Amplified_Values(~in) = NAN;
    [row , col] = find (Amplified_Values < 0 );
    Amplified_Values (row , col) = 0;
    disp('**********************************************************************');    
end   

%% % % % % % % % % % % Producing Urban Shakemap % % % % % % % %  % % % % %%
if (shake_scale == 2)
%% Determination of Correction Factors for Acceleration & Velocity as well as Reducing Amplitudes
    Vo = 760;
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('peeqMap Is Estimating The Amplification Factors and Reducing Amplitudes');
    [Fa, Fv, Reduced_Values] = Site_Red_Factor (sta, Vo, pgp_tag);    
    disp('**********************************************************************');
%% % % % % % % % % % % % % Numerical Interpolation % % % % % % % % % % % % % %%
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('********* Numerical Interpolation is Carrying Out by peeqMap *********');
    Intpol_Dis_Deg = 0.01; % THe distance between interpolation points in degree
    Int_type_tag = 4; % 1 for Linear Interpolation, 2 for Natural Interpolation, 3 for Nearest Interpolation, 4 for Thin-plate smoothing spline Interpolation
    [Int_Lat, Int_Lon, coordinate, Interpolated_Values] = Num_Intpol (sta, Reduced_Values, Intpol_Dis_Deg, Int_type_tag, Win_lim_tag, Win_lim);
    disp('**********************************************************************');
%% % % % % % % % % % % % % % Amplifying Peak values % % % % % % % % % % % %
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('****************** peeqMap Is Amplifying the Peak values *****************'); 
    figure( 'Name', 'Interpolated Surface For Site Amplification','Color',[1 1 1] );
    worldmap([Win_lim(1,1) Win_lim(1,2)],[Win_lim(2,1) Win_lim(2,2)]) 
    [Amplified_Values, F_Final] = Site_Amp_Factor (Win_lim, Vo, pgp_tag, Int_Lat, Int_Lon, Interpolated_Values, Reduced_Values);    
    disp('**********************************************************************');
    output_folder1 = [pwd filesep 'output_folder' filesep 'visual_outputs' filesep];
    cd (output_folder1)
    print('-dtiff','-r300',' Interpolation for Site Amplification.tif')
    cd ..
    cd ..
    clear output_folder1
%% % % % % % % % % % % % Correction of Minus Values % % % % % % % % %  % %%
    in = inpolygon(coordinate(1,:),coordinate(2,:),city_border(:,1),city_border(:,2));
    Amplified_Values(~in) = NaN;
    [row , col] = find (Amplified_Values < 0 );
    Amplified_Values (row , col) = 0;
    disp('**********************************************************************');        
end
%% % % % % % % % % % % Producing Regional Shakemap % % % % % % % % % % % %%
if (shake_scale == 3)
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
    cd (input_folder)
%% % % % % % % % % Loading Magnitude & Location of the Event % % % % % % %%
    if (exist ('mag_loc.txt','file') == 2)
        mag_loc = load ('mag_loc.txt');
        Centroid_Lat = mag_loc(1,2);
        Centroid_Lon = mag_loc(1,1);
        Mw = mag_loc(1,3);
        M_L_tag = 1;
    else
        M_L_tag = 0;        
    end
    if (exist ('mag_loc.txt','file') ~= 2) && (strncmp(pgp_tag, 'PGA', 3) == 0) %PGV & PSA
        msg = ['*' pwd filesep 'mag_loc.txt is missing!*'];
        disp(msg);
        clear msg
        disp('******* The Magnitude & Location of the event is not available *******');
        disp('*******          For Producing PGV & PSA Shaking Maps          *******');
        disp('******  The Magnitude & Location of the event Must be available ******');        
        disp('**********************************************************************');
        M_L_tag = 0;
        return
    end
%% % % % % % % % % Limitations of the Geographical Window % % % % % % % % %
    if  Win_lim_tag == 0
        Lon=sta(:,1);
        Lat=sta(:,2);
        lat_down_lim=min(Lat)-2;
        lat_up_lim=max(Lat)+2;
        lon_down_lim=min(Lon)-2;
        lon_up_lim=max(Lon)+2;
        Win_lim=[lat_down_lim , lat_up_lim ; lon_down_lim , lon_up_lim];
        Win_lim_tag = 1;
    end
%% % % % % % % % % % % % % Changing directory % % % % % % % % %  % % % % %%
    cd ..
%% % % % % % % Estimation of Centroid Coordinate and Magnitude % % % % % %%
    if M_L_tag == 0 && strncmp(pgp_tag, 'PGA', 3) == 1

        [Centroid_Lat,Centroid_Lon,Mw] = Kanamuri_Babaei_Loc_Mw(sta, Win_lim);
        disp('                                   *                                  ');
        disp('**********************************************************************');
        disp('*peeqMap Is Estimating The Magnitude & Centroid Location of the Event*');     
        Lon_str = num2str (Centroid_Lon,6);
        Lat_str = num2str (Centroid_Lat,6);
        disp('**********************************************************************');
        disp('********************                            **********************');
        msg = strcat ('*******************  Centroid Longitude = ', (Lon_str),' *********************');
        disp(msg);
        clear msg
        msg = strcat ('*******************   Centroid Latitude = ', (Lat_str),' *********************');
        disp(msg);
        clear msg
        disp('********************                            **********************');
        disp('**********************************************************************');
    end
%% Determination of Correction Factors for Acceleration & Velocity as well as Reducing Amplitudes
    Vo = 760;
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('peeqMap Is Estimating The Amplification Factors and Reducing Amplitudes');
    [Fa, Fv, Reduced_Values] = Site_Red_Factor (sta, Vo, pgp_tag);    
    disp('**********************************************************************');
%% % % % % % % % % Determination of Bias Correction Factor % % % % % % % %%
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('***********peeqMap Is Estimating The Bias Correction Factor***********');     
    [INVALID_PERIOD, BF, Mw] = Bias_correct_Att(sta, Centroid_Lat, Centroid_Lon, Reduced_Values, Mw, pgp_tag, FaultType);
    if INVALID_PERIOD == 1
        return
    end
    BF_str = num2str (BF,5);
    disp('**********************************************************************');
    disp('*******************                                 ******************');    
    msg = strcat ('******************  Bias Correction Factor = ', (BF_str),'  *****************');        
    disp(msg);
    clear msg
    Mag_str = num2str (Mw, 2);    
    msg = strcat ('******************      Centroid Magnitude = ', (Mag_str),'      *****************');        
    disp(msg);
    clear msg
    disp('*******************                                 ******************');        
    disp('**********************************************************************');
%% % % % % % % % % % % % Locating Phantom Stations % % % % % % % % % % % %%
    disp('                                   *                                  ');
    disp('**************** peeqMap Is Locating Phantom Stations ****************');
    Phantom_sta_Dis_km = 50; % The distance between phantom stations in km
    [Phantom_sta_coord] = Phantom_sta_location (sta, Win_lim, Phantom_sta_Dis_km);
    disp('**********************************************************************');
%% % % % % % % Estimation of Peak Values in Phantom Stations % % % % % % %%
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('******** peeqMap Is Estimating Peak Values in Phantom Stations********');
    [Obs_Phantom_Coord,Obs_Phantom_PGAMPs] = Phantom_PGAMPs_Estim (sta,Reduced_Values,Phantom_sta_coord,Centroid_Lat,Centroid_Lon,Mw,BF,pgp_tag,FaultType);
    disp('**********************************************************************');
%% % % % Numerical Interpolation Betweem Recorded & Estimated Values % % %%
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('********* Numerical Interpolation is Carrying Out by peeqMap *********');
    Intpol_Dis_Deg = 0.02; % THe distance between interpolation points in degree
    Int_type_tag = 4; % 1 for Linear Interpolation, 2 for Natural Interpolation, 3 for Nearest Interpolation, 4 for Thin-plate smoothing spline Interpolation
    [Int_Lat, Int_Lon, coordinate, Interpolated_Values] = Num_Intpol (Obs_Phantom_Coord,Obs_Phantom_PGAMPs, Intpol_Dis_Deg, Int_type_tag, Win_lim_tag, Win_lim);
    disp('**********************************************************************');
%% % % % % % % % % % % % % % Amplifying Peak values % % % % % % % % % % % %
    disp('                                   *                                  ');
    disp('**********************************************************************');
    disp('****************** peeqMap Is Amplifying Peak values *****************'); 
    figure( 'Name', 'Interpolated Surface For Site Amplification','Color',[1 1 1] );
    worldmap([Win_lim(1,1) Win_lim(1,2)],[Win_lim(2,1) Win_lim(2,2)]) 
    [Amplified_Values, F_Final] = Site_Amp_Factor (Win_lim, Vo, pgp_tag, Int_Lat, Int_Lon, Interpolated_Values, Reduced_Values);    
    disp('**********************************************************************');
    output_folder1 = [pwd filesep 'output_folder' filesep 'visual_outputs' filesep];
    cd (output_folder1)
    print('-dtiff','-r300',' Interpolation for Site Amplification.tif')
    cd ..
    cd ..
    clear output_folder1
%% % % % % % % % % % % % Correction of Minus Values % % % % % % % % %  % %%
%     in = inpolygon(coordinate(1,:),coordinate(2,:),city_border(:,1),city_border(:,2));
%     Amplified_Values(~in) = NaN;
    [row , col] = find (Amplified_Values < 0 );
    Amplified_Values (row , col) = 0;
    disp('**********************************************************************');        
end
%% % % % % % % % % Writting Results with .txt Extension % % % % % % % % % %
    output_folder = [pwd filesep 'output_folder' filesep 'txt_outputs' filesep];
    fid = fopen([output_folder 'Amplified_Values.txt'],'wt');    
    for jjk = 1:(length(Amplified_Values))
        fprintf(fid,['%8.3f'   '%8.3f'   '%20.6f\n'] , coordinate(1,jjk),coordinate(2,jjk),Amplified_Values(jjk));
    end
    clear fid
%% % % % % % % % Plotting Final Results with .tif Extension % % % % % % % %
output_folder1 = [pwd filesep 'output_folder' filesep 'visual_outputs' filesep];
cd (output_folder1)    
current_time=clock;
current_year= num2str (current_time(1));
current_month= num2str (current_time(2));
current_day= num2str (current_time(3));
current_hour= num2str (current_time(4));
if current_time(5)==0
    current_time(5)= 59;
    current_minute= num2str (current_time(5));    
    current_time(4)=(current_time(4)-1);
    current_hour= num2str (current_time(4));
    if current_time(4)>10
         current_hour= num2str (current_hour);
    end
else
    current_minute= num2str (current_time(5)-1);
end
if current_time(2) < 10
    current_month= strcat ('0',current_month);
end 
if current_time(3) < 10
    current_day= strcat ('0',current_day);
end 
if current_time(4) < 10
    current_hour= strcat ('0',current_hour);
end 
if (current_time(5) < 10) 
    current_minute= strcat ('0',current_minute);
end 
new_format_current_time= strcat ('               ( ',current_year,'/',current_month,'/',current_day,' - ',current_hour,':',current_minute,')');
map_title= strvcat ('                  Shaking Map ','           *- Produced by peeqMap -*',new_format_current_time);
s_num=length(sta(:,1));
Lon=sta(1:s_num,1);
Lat=sta(1:s_num,2);   
figure( 'Name', 'Shaking Map','Color',[1 1 1]);
worldmap([Win_lim(1,1) Win_lim(1,2)],[Win_lim(2,1) Win_lim(2,2)])
LlL = length(Int_Lat(1,:));
Amplified_Values = reshape (Amplified_Values, [], LlL);
geoshow(Int_Lat,Int_Lon,Amplified_Values, 'DisplayType', 'texturemap');
% contourfm(Int_Lat,Int_Lon,Amplified_Values)
% contourm(Int_Lat,Int_Lon,Amplified_Values,25)
colormap Jet%Hot%Autumn
hh=colorbar('v');
for kj=1:s_num
    plotm(Lat(kj, 1), Lon(kj, 1), 'Marker', '^','MarkerEdgeColor', 'k' , 'MarkerFaceColor', [0 1 0], 'MarkerSize', 7);
end
if shake_scale == 3
    plotm(Centroid_Lat, Centroid_Lon, 'Marker', 'p', 'MarkerEdgeColor', 'k' ,'MarkerFaceColor',[1 0 0], 'MarkerSize', 14)
end
    if (strncmp(pgp_tag, 'PGA', 3) == 1) %PGA
        set(get(hh,'ylabel'),'string','PGA (g)');
    end
    if (strncmp(pgp_tag, 'PGV', 3) == 1) %PGV
        set(get(hh,'ylabel'),'string','PGV (Cm/Sec)');
    end
    PT = isnumeric(pgp_tag);
    if PT == 1 %PSA
        set(get(hh,'ylabel'),'string','PSA (g)');
    end
title(map_title ,'fontsize',10,'fontweight','bold');
[druler, dAZ] = distance(Win_lim(1,1), Win_lim(2,1), Win_lim(1,1), Win_lim(2,2));
scaleruler on
setm(handlem('scaleruler'), ...
    'MajorTick', 0:round(deg2km(druler/8)):round(deg2km(druler/4)),...
    'MinorTick', 0:round(deg2km(druler/16)):round(deg2km(druler/8)), ...
    'TickDir', 'down', ...
    'MajorTickLength', round(deg2km(druler/40)),...
    'MinorTickLength', round(deg2km(druler/40)))
print('-dtiff','-r300','Shaking Map.tif');
%% M_Map
if M_Map_tag == 1
    figure( 'Name', 'Shaking Map','Color',[1 1 1])
    m_proj('UTM','long',[Win_lim(2,1) Win_lim(2,2)],'lat',[Win_lim(1,1) Win_lim(1,2)]);
    h=m_pcolor(Int_Lon,Int_Lat,Amplified_Values); shading interp %shading flat %shading faceted %; 
    colormap Jet%Hot%Autumn
    hh=colorbar('v');
    if (strncmp(pgp_tag, 'PGA', 3) == 1) %PGA
        set(get(hh,'ylabel'),'string','PGA (g)');
    end
    if (strncmp(pgp_tag, 'PGV', 3) == 1) %PGV
        set(get(hh,'ylabel'),'string','PGV (Cm/Sec)');
    end
    PT = isnumeric(pgp_tag);
    if PT == 1 %PSA
        set(get(hh,'ylabel'),'string','PSA (g)');
    end
    set(get(hh,'ylabel'),'string','PGA (g)');
    m_grid('box','fancy','tickdir','in','xtick',(9),'ytick',(6));
    m_ruler([.1 .4],.1,2)
    whitebg([1 1 1]);
    title(map_title ,'fontsize',10,'fontweight','bold');    
    for kj=1:s_num
        m_line(Lon(kj), Lat(kj),'marker','^','markersize',6, 'MarkerEdgeColor', 'k','MarkerFaceColor',[0 1 0]);
    end
    if shake_scale == 3
        m_line(Centroid_Lon, Centroid_Lat, 'Marker', 'p', 'markersize',14, 'MarkerEdgeColor', 'k','MarkerFaceColor',[1 0 0]);
    end
    print('-dtiff','-r300','Shaking M_Map.tif');
end
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
    cd ..
    cd ..
%%
disp('**********************************************************************');
disp('*********** The Process of Producing Shakemap is Finished ***********');     
msg = strcat ('.TXT Results Could Be Found in :', (output_folder));
disp(msg);
clear msg
msg = strcat ('.TIF Results Could Be Found in :', (output_folder1));
disp(msg);
clear msg
disp('**********************************************************************');
%% % % % % % % % % % % % Detrmination of Elapsed time % % % % % % % % % % %
Elapsed_time = toc(tStart);
msg = strcat ('Elapsed Time During Process = ', (num2str (Elapsed_time)), 'Sec');
disp (msg)
clear INVALID_PERIOD PT h s_num mag_loc msg jjk kj hh tStart BF_str Lat_str Lon_str LlL M_L_tag M_Map_tag Mag_str pgp_tag FaultType Win_lim_tag Int_type_tag output_folder1 output_folder new_format_current_time map_title input_folder current_day current_hour current_minute current_month current_time current_year;
fclose all;