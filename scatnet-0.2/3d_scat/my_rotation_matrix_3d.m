% MY_ROTATION_MATRIX_3D computes a 3-by-3 rotation matrix for a given angle
%
% Usage
%    rotmat = MY_ROTATION_MATRIX_3D(theta)	
% 
% Input
%    theta (numeric): the angle of the rotation
%
% Ouput
%    rotmat (numeric): 3-by-3 rotation matrix corresponding to the axis con-
%       vention of matlab for image coordinates

function rotmat = my_rotation_matrix_3d(theta)	
	temp(:,:,1)=[1 0 0;0 1 0;0 0 1];
    temp(:,:,2)=[cos(theta(1)) 0 -sin(theta(1)) ;0 1 0; sin(theta(1)) 0 cos(theta(1)) ];
    temp(:,:,3)=[cos(theta(2)) sin(theta(2)) 0; -sin(theta(2)) cos(theta(2)) 0;0 0 1];
    
    rotmat = temp(:,:,1)*temp(:,:,2)*temp(:,:,3);
end
