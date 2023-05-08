// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Vector3(_x2, _y2, _z2, _x1 = 0, _y1 = 0, _z1 = 0) : Vector2(_x2, _y2, _x1, _y1) constructor
{
	z1 = _z1;
	z2 = _z2;
	
	dz = z2 - z1;
	
	magnitude = sqrt(sqr(dx) + sqr(dy) + sqr(dz));
	
	angle_xy = arc tan2(-dy, dx);
	
	if (angle_xy < 0)
	{
		angle_xy += 2 * pi;
	}
	
	angle_xz = arctan2(dz, dx);
	
	if (angle_xz < 0)
	{
		angle_xz += 2 * pi;
	}
	
	angle_yz = arctan2(dz, -dy);
	
	if (angle_yz < 0)
	{
		angle_yz += 2 * pi;
	}
	
	dangle_xy = radtodeg(angle_xy);
	dangle_xz = radtodeg(angle_xz);
	dangle_yz = radtodeg(angle_yz);
	
	static update_angle = function()
	{
		angle_xy = arctan2(-dy, dx);
	
		if (angle_xy < 0)
		{
			angle_xy += 2 * pi;
		}
	
		angle_xz = arctan2(dz, dx);
	
		if (angle_xz < 0)
		{
			angle_xz += 2 * pi;
		}
	
		angle_yz = arctan2(dz, -dy);
	
		if (angle_yz < 0)
		{
			angle_yz += 2 * pi;
		}
		
		dangle_xy = radtodeg(angle_xy);
		dangle_xz = radtodeg(angle_xz);
		dangle_yz = radtodeg(angle_yz);
	}
}