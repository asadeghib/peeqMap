function [Diskm, Azim] = DistAz_in_km (S_points_Coord, T_Point_Lat, T_Point_Lon)
%DistAz_in_km (S_points_Cord, T_Point_Lat, T_Point_Lon)
%  Determination of Distance & Azimuth of a Number of Points from another Point.
%
%  Data for Determination:
%      S_points_Cord Input : Coordinate of Points, The First Column Is Longitude and The Second Column Is Latitude
%      T_Point_Lat Input : Latitude of the Target Point
%      T_Point_Lon Input : Lontitude of the Target Point
%
%  Output:
%      Diskm Output : Distances between Points
%      Azim Output : Azimuth of Points Direction With Respect to Target Point
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
s_num=length(S_points_Coord(:,1));
disdeg = zeros (s_num,1);
az = zeros (s_num,1);
Diskm = zeros (s_num,1);
%% Distance Calculation
for p=1:s_num
    [disdeg(p,1),az(p,1)]= distance(T_Point_Lat, T_Point_Lon, S_points_Coord(p,2), S_points_Coord(p,1));
    Diskm(p)=deg2km(disdeg(p));
    Azim=az;
end