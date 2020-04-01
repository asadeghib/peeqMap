function [Fa, Fv, Reduced_Values] = Site_Red_Factor (sta, Vo, pgp_tag)
%Det_Corr_Factor (Sta_Vs30)
% Determination of Correction Factors for Acceleration & Velocity as well
% as Reducing Amplitudes
%
%  Data for Estimation:
%      sta Input : Coordinate and Recorded Peak Valus
%      Sta_Vs30 Input : Shear-wave Velocities in Uppermost 30 Meters
%      Vo Input : Shear-wave Velocitiy in Uppermost 30 Meters of the
%                 Reference Site
%      pgp_tag Input : pgp_tag = 'PGA' For Estimation of PGA
%                      pgp_tag = 'PGV' For Estimation of PGV
%                      pgp_tag = The Desired period For Estimation of PSA
%  Output:
%      Fa Output : Correction Factors for Acceleration
%      Fv Output : Correction Factors for Velocity
%      Reduced_Values Output : Reduced Values to Common Reference Site
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
sta_size= size (sta);
Sta_Vs30= sta(:, (sta_size (1,2))); 
s_num=length(Sta_Vs30(:,1));
PHA_L= sta(1:s_num,3);
PHA_T= sta(1:s_num,4);
PHA= (((PHA_L.^2)+(PHA_T.^2)).^0.5);
Fa= zeros (s_num,1);
Fv= zeros (s_num,1);
Reduced_Values= zeros (s_num,1);
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
    if  PHA (i) < 0.4 && 0.3 < PHA (i)
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
%% Reduction of Amplitudes
        if (strncmp(pgp_tag, 'PGA', 3) == 1) %PGA 
            Reduced_Values = PHA./Fa;
        end
        if (strncmp(pgp_tag, 'PGV', 3) == 1) %PGV
            Reduced_Values = PHA./Fv;
        end
        PT = isnumeric(pgp_tag);
        if PT == 1 %PSA
            Reduced_Values = PHA;
        end
