function [INVALID_PERIOD,PGAMPs] = BA08 (Mw, Rjb, pgp_tag, FaultType)
%BA08 (Mw, Rjb, pgp_tag, FaultType)
%  Estimation of Peak Ground Amplitudes by NGA of Boore & Atkinson 2008.
%
%  Data for Estimation:
%      Mw Input : Reported Moment Magnitude or Centroid Magnitude
%      Rjb Input : Joyner & Boore Distances of Points
%      pgp_tag Input : pgp_tag = 'PGA' For Estimation of PGA
%                      pgp_tag = 'PGV' For Estimation of PGV
%                      pgp_tag = The Desired period For Estimation of PSA
%      FaultType Input : FaultType = 1 For Unspecified Fault Type
%                        FaultType = 2 For Strike Slip Fault
%                        FaultType = 3 For Normal Fault
%                        FaultType = 4 For Reverse, Trust Fault
%
%  Output:
%      PGAMPs Output : Estimated Peak Ground Amplitudes
%     INVALID_PERIOD : INVALID_PERIOD = 1, If The Period Defined in pgp_tag Is Invalid
%                    : INVALID_PERIOD = 1, If The Period Defined in pgp_tag Is valid
% 
% Equations have units of g for PSA and PGA, cm/s for PGV. The units of
% distance and velocity are km and m/s, respectively. The equation for pga4nl is the same
% as for PGA, with VS30760 m/ s (for which FS=0)
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
input_folder = [pwd filesep 'input_folder' filesep 'BA08' filesep];
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd (input_folder)
%%
% Table3BA08 = load ('Table3BA08.txt');
Table6BA08 = load ('Table6BA08.txt');
Table7BA08 = load ('Table7BA08.txt');
Table8BA08 = load ('Table8BA08.txt');


PT = isnumeric(pgp_tag);

if PT == 0
    if (strncmp(pgp_tag, 'PGA', 3) == 1) %PGA
%         b_lin = -0.360;
%         b1 = -0.640;
%         b2 = -0.14;  
        
        c1 = -0.66050;
        c2 = 0.11970;
        c3 = -0.01151;
        h = 1.35;
        
        e1 = -0.53804;
        e2 = -0.50350;
        e3 = -0.75472;
        e4 = -0.50970;
        e5 = 0.28805;
        e6 = -0.10164;
        e7 = 0.00000;
        Mh = 6.75;    
        SigmaTU = 0.566;
        SigmaTM = 0.564;        
    end
    if (strncmp(pgp_tag, 'PGV', 3) == 1) %PGV
%         b_lin = -0.600;
%         b1 = -0.500;
%         b2 = -0.06;
    
        c1 = -0.87370;
        c2 = 0.10060;
        c3 = -0.00334;
        h = 2.54;
        
        e1 = 5.00121;
        e2 = 5.04727;
        e3 = 4.63188;
        e4 = 5.08210;
        e5 = 0.18322;
        e6 = -0.12736;
        e7 = 0.00000;
        Mh = 8.50;  
        SigmaTU = 0.576;
        SigmaTM = 0.560;                
    end   
end

if PT == 1 %PSA
    Period = pgp_tag;

    Periods = Table6BA08(:,1);
%     b_lins = Table3BA08(:,2);
%     b1s = Table3BA08(:,3);
%     b2s = Table3BA08(:,4);
%     
    c1s = Table6BA08(:,2);
    c2s = Table6BA08(:,3);
    c3s = Table6BA08(:,4);
    hs = Table6BA08(:,5);

    e1s = Table7BA08(:,2);
    e2s = Table7BA08(:,3);
    e3s = Table7BA08(:,4);
    e4s = Table7BA08(:,5);
    e5s = Table7BA08(:,6);
    e6s = Table7BA08(:,7);
    e7s = Table7BA08(:,8);
    Mhs = Table7BA08(:,9);
    SigmaTUs = Table8BA08(:,4);
    SigmaTMs = Table8BA08(:,6);
    
    r_period = find (Periods == Period);
    if isempty (r_period) == 1
        PeriodsSTR = num2str (Periods);
        disp('**********************************************************************');
        disp('******************* For Producing PSA Shaking Maps *******************');     
        disp('**** The Variable of pgp_tag Must be One of The Following Numbers ****');     
        disp(PeriodsSTR);     
        disp('**********************************************************************');
        INVALID_PERIOD = 1;
        PGAMPs = 0;
        cd ..
        cd ..
        return
    else
%       b_lin = b_lins(r_period);
%       b1 = b1s(r_period);
%       b2 = b2s(r_period);
    
        c1 = c1s(r_period);
        c2 = c2s(r_period);
        c3 = c3s(r_period);
        h = hs(r_period);
    
        e1 = e1s(r_period);
        e2 = e2s(r_period);
        e3 = e3s(r_period);
        e4 = e4s(r_period);
        e5 = e5s(r_period);
        e6 = e6s(r_period);
        e7 = e7s(r_period);
        Mh = Mhs(r_period);
        SigmaTU = SigmaTUs(r_period);
        SigmaTM = SigmaTMs(r_period);
    end
end
% % Table 4 in BA08
% V1 = 180;
% V2= 300;
% pga_low = 0.06;
% a1 = 0.03;
% a2 = 0.09;
% V_ref = 760;

M_ref = 4.5;
R_ref = 1.0;
%% THE DISTANCEAND MAGNITUDE FUNCTIONS
U = 0;
SS = 0;
NS = 0;
RS = 0;
% Unspecified Fault Type
if FaultType == 1
    U = 1;
    SigmaT = SigmaTU;
else
    SigmaT = SigmaTM;
end
% Strike Slip Fault
if FaultType == 2
    SS = 1;
end
% Normal Fault
if FaultType == 3
    NS = 1;
end
% Reverse, Trust Fault
if FaultType == 4
    RS = 1;
end
% EQ 5a in BA08
if Mw<=Mh
    Fm = e1*U+e2*SS+e3*NS+e4*RS+e5*(Mw-Mh)+e6*(Mw-Mh)^2;
end
% EQ 5b in BA08
if Mw>Mh
    Fm = e1*U+e2*SS+e3*NS+e4*RS+e7*(Mw-Mh);
end
% EQ 4 in BA08
R = (Rjb.^2+h^2).^0.5;
% EQ 3 in BA08
Fd = (c1+c2*(Mw-M_ref)).*log(R/R_ref)+c3*(R-R_ref);
%% SITE AMPLIFICATION FUNCTION
%for the reference velocity of 760 m/ s, FLIN=FNL=FS=0.
Fs = 0;
% if Vs30 ~= 760
% % EQ 13a in BA08
% if V_ref <= Vs30
%     bnl = 0;
% end
% % EQ  13b in BA08
% if Vs30 > V2 && Vs30 < V_ref
%     bnl = (b2*log (Vs30/V_ref))/log (V2/V_ref);
% end
% % EQ  13c in BA08
% if Vs30 > V1 && Vs30 <= V2
%     bnl = (((b1-b2)*log (Vs30/V2))/log (V1/V2))+b2;
% end
% % EQ 13d in BA08
% if Vs30 <= V1
%     bnl = b1;
% end
% 
% % EQ 11 in BA08
% delta_x = log(a2/a1);
% % EQ 12 in BA08
% delta_y = bnl*log(a2/pga_low);
% % EQ 9 in BA08
% c = (3*delta_y-bnl*delta_x)/delta_x^2;
% % EQ 10 in BA08
% d = -(2*delta_y-bnl*delta_x)/delta_x^3;
% % EQ 7 in BA08
% f_lin = b_lin*log(Vs30/V_ref);
% % EQ 8a in BA08
% 
% pga4nl = exp(Fm+Fd+0);
% 
% if pga4nl <= a1
%     f_nl = bnl*log(pga_low/0.1);
% end
% % EQ 8b in BA08
% if pga4nl > a1 && pga4nl <= a2
%     f_nl = bnl*log(pga_low/0.1)+c*((log(pga4nl/a1))^2)+d*(log(pga4nl/a1))^3;
% end
% % EQ 8c in BA08
% if pga4nl>a2
%     f_nl = bnl*log(pga4nl/0.1);
% end
% % EQ 6 in BA08
% Fs = f_nl+f_lin;
% end
%% GMPE AMPLIFICATION FUNCTION
% EQ 1 in BA08
PGAMPs = exp(Fm+Fd+Fs+SigmaT);
INVALID_PERIOD = 0;
%% % % % % % % % % % % % % Changing Directory % % % % % % % % %  % % % % %%
cd ..
cd ..