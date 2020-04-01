function [INVALID_PERIOD, BF, Mw] = Bias_correct_Att(sta, Centroid_Lat, Centroid_Lon, Corrected_Values, Mw, pgp_tag, FaultType)
%Bias_correct_Att(sta, Centroid_Lat, Centroid_Lon, Corrected_Values, Mw)
%  Determination of Bias Correction Factor & Estimation of Magnitude.
%
%  Data for Estimation:
%      sta Input : Coordinates of Recording Stations
%      Centroid_Lat Input : Latitude of Centroid
%      Centroid_Lon Input : Longitude of Centroid
%      Corrected_Values Input : Redused Amplitudes to Common Reference Site with Vs30 = 760 m/s.
%      Mw Input : Reported Moment Magnitude or Estimated Centroid Magnitude by Kanamori_Babaei_Loc_Mw.m
%      pgp_tag Input : pgp_tag = 'PGA' For Estimation of PGA
%                      pgp_tag = 'PGV' For Estimation of PGV
%                      pgp_tag = The Desired period For Estimation of PSA
%      FaultType Input : FaultType = 1 For Unspecified Fault Type
%                        FaultType = 2 For Strike Slip Fault
%                        FaultType = 3 For Normal Fault
%                        FaultType = 4 For Reverse, Trust Fault
% 
%  Output:
%      BF Output : Bias Correction Factor
%      Mw Output : Estimated Magnitude
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
Corrected_Values = reshape(Corrected_Values,[],1);
r= 0:1:200;
[CentDiskm, Azim] = DistAz_in_km (sta, Centroid_Lat, Centroid_Lon);
[INVALID_PERIOD,PGAMPs_att] = BA08 (Mw, CentDiskm, pgp_tag, FaultType);
if INVALID_PERIOD == 1
    BF = 0;
    Mw = 0;
    return
end
DIF_OBSERV_EST= (Corrected_Values-PGAMPs_att);
BF = mean((DIF_OBSERV_EST./PGAMPs_att)+1);
[INVALID_PERIOD,N_B_C_PGAMPs_rel] = BA08 (Mw, r, pgp_tag, FaultType);
B_C_PGAMPs_rel = BF.*N_B_C_PGAMPs_rel;
B_C_PGAMPs = BF.*PGAMPs_att;
%% % % % % % % % % % % % % % % % % plotting % % % % % % % % % % % % % % % %
figure( 'Name', 'GMPE Bias Correction','color',[1 1 1]);
loglog (CentDiskm,Corrected_Values,'*b')
hold on
loglog (r,N_B_C_PGAMPs_rel,'-b')
hold on
loglog (r,B_C_PGAMPs_rel,'-r')
hold on
loglog (CentDiskm,B_C_PGAMPs,'*m')
%% Magnitude Estimation by Solving BA08 Equation With Respect to Magnitude
if (strncmp(pgp_tag, 'PGA', 3) == 1) %PGA 
    b = zeros (length(CentDiskm),1);
    c = zeros (length(CentDiskm),1);
    M1 = zeros (length(CentDiskm),1);
    M2 = zeros (length(CentDiskm),1);
    for ilil=1:length(CentDiskm)
        b(ilil) = 1.66019+0.11970*log(CentDiskm(ilil));
        c(ilil) = -(6.54735+1.19915*(log(CentDiskm(ilil)))+0.01151*CentDiskm(ilil)+log(B_C_PGAMPs(ilil)));
        M1(ilil) = 4.9193231011412829594647776465958*b(ilil) - 4.9193231011412829594647776465958*((b(ilil))^2 + 0.40656*c(ilil))^(1/2);
        M2(ilil) = 4.9193231011412829594647776465958*b(ilil) + 4.9193231011412829594647776465958*((b(ilil))^2 + 0.40656*c(ilil))^(1/2);
    end
    Mw1 = mean(M1);
    Mw2 = mean(M2);
    if Mw1 < Mw2
        Mw = Mw1;
    else
        Mw = Mw2;
    end
%% Reestimation of BF
[INVALID_PERIOD,Mw_PGAMPs_rel] = BA08 (Mw, r, 'PGA', FaultType);
[INVALID_PERIOD,Mw_PGAMPs_att] = BA08 (Mw, CentDiskm, 'PGA', FaultType);
Mw_DIF_OBSERV_EST= (B_C_PGAMPs-Mw_PGAMPs_att);
BF = mean((Mw_DIF_OBSERV_EST./Mw_PGAMPs_att)+1);
Mw_B_C_PGAMPs_rel = BF.*Mw_PGAMPs_rel;

%% % % % % % % % % % % % % % % % % plotting % % % % % % % % % % % % % % % %
loglog (r,Mw_B_C_PGAMPs_rel,'--r')
hold on
loglog (r,Mw_PGAMPs_rel,'-m')
ylabel({'PHA (g)'},'FontWeight','bold','FontName','Times')
end
if (strncmp(pgp_tag, 'PGV', 3) == 1) %PGV
    ylabel({'PGV (Cm/Sec)'},'FontWeight','bold','FontName','Times')
end
PT = isnumeric(pgp_tag);
if PT == 1 %PSA
    ylabel({'PSA (g)'},'FontWeight','bold','FontName','Times')
end
xlabel({'Distance (km)'},'FontWeight','bold','FontName','Times')
map_title= strvcat ('    Bias Corrected GMPE & Recorded Peaks    ','          *- Produced by peeqMap -*');
title(map_title ,'fontsize',10,'fontweight','bold');
hold off
output_folder = [pwd filesep 'output_folder' filesep 'visual_outputs'];
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd (output_folder)
print('-dtiff','-r300','Bias Corrected GMPE.tif')
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd ..
cd ..