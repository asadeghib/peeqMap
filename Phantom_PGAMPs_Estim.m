function [Obs_Phantom_Coord,Obs_Phantom_PGAMPs] = Phantom_PGAMPs_Estim (sta, Corrected_Values, Phantom_sta_coord, Centroid_Lat, Centroid_Lon, Mw, BF, pgp_tag, FaultType)
%Phantom_PGAMPs_Estim(sta,Corrected_Values,Phantom_sta_coord,Centroid_Lat,Centroid_Lon,Mw,BF)
%  Estimation of Bias Corrected Amplitudes in Phantom Stations and Combination of them with Observational Peaks.
%
%  Data for Estimation:
%      sta Input : Coordinate of Recording Stations
%      Corrected_Values Input :  Redused Amplitudes to the Common Reference Site with Vs30 = 760 m/s.
%      Phantom_sta_coord Input : Coordinate of the Phantom Stations
%      Centroid_Lat Input : Latitude of Centroid
%      Centroid_Lon Input : Longitude of Centroid
%      Mw Input : Mw
%      BF Input : Bias Correction Factor
%      pgp_tag Input : pgp_tag = 'PGA' For Estimation of PGA
%                      pgp_tag = 'PGV' For Estimation of PGV
%                      pgp_tag = The Desired period For Estimation of PSA
%      FaultType Input : FaultType = 1 For Unspecified Fault Type
%                        FaultType = 2 For Strike Slip Fault
%                        FaultType = 3 For Normal Fault
%                        FaultType = 4 For Reverse, Trust Fault
%
%  Output:
%      Obs_Phantom_Coord Output : Coordinate of the Phantom and Observational Stations
%      Obs_Phantom_PGAMPs Output : Peak Ground Amplitudes in Phantom and Observational Stations
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
%% % % % % Determination of Distance of Stations from Centroid % % % % % %%
[Dis_Cent_Phant, Azim] = DistAz_in_km (Phantom_sta_coord, Centroid_Lat, Centroid_Lon);
%% Estimation of Bias Corrected Peak Ground Amplitudes in Phantom Stations%
[INVALID_PERIOD,Phantom_PGAMPs] = BA08 (Mw, Dis_Cent_Phant, pgp_tag, FaultType);
Phantom_PGAMPs = BF.*(Phantom_PGAMPs);
%% Combination of Bias Corrected Amplitudes in Phantom Stations and Observational Peaks%
Obs_PHA= Corrected_Values;
Obs_Phantom_PGAMPs= zeros ((length(Phantom_PGAMPs)+length(Obs_PHA)),1);
Obs_Phantom_PGAMPs (1:length(Phantom_PGAMPs),1)= Phantom_PGAMPs;
Obs_Phantom_PGAMPs ((length(Phantom_PGAMPs)+1):((length(Phantom_PGAMPs)+length(Obs_PHA))),1)= Obs_PHA;
Obs_Phantom_Coord= zeros ((length(Phantom_PGAMPs)+length(Obs_PHA)),2);
Obs_Phantom_Coord (1:length(Phantom_PGAMPs),1)= Phantom_sta_coord(:,1);
Obs_Phantom_Coord (1:length(Phantom_PGAMPs),2)= Phantom_sta_coord(:,2);
    Obs_Phantom_Coord ((length(Phantom_PGAMPs)+1):((length(Phantom_PGAMPs)+length(Obs_PHA))),1)= sta(:,1);
    Obs_Phantom_Coord ((length(Phantom_PGAMPs)+1):((length(Phantom_PGAMPs)+length(Obs_PHA))),2)= sta(:,2);
%%
output_folder = [pwd filesep 'output_folder' filesep 'txt_outputs' filesep];
fid = fopen([output_folder 'Obs_Phantom_Coord.txt'],'wt');
fid1 = fopen([output_folder 'Obs_Phantom_PGAMPs.txt'],'wt');
for jk = 1:(length(Obs_Phantom_Coord))    
    fprintf(fid,['%8.3f'   '%8.3f\n'] , Obs_Phantom_Coord(jk,1),Obs_Phantom_Coord(jk,2));
    fprintf(fid1,'%8.3f\n' , Obs_Phantom_PGAMPs(jk,1));
end
output_folder = [pwd filesep 'output_folder' filesep 'visual_outputs'];
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd (output_folder)
fclose(fid);
fclose(fid1);
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd ..
cd ..