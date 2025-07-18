///2D vector functions

#macro TPI (2 * pi)

/// @func			Vector2(_x2, _y2, _x1, _y1)
/// @desc			Creates a 2D vector using the given coordinates.
/// @param {real}	_x2 The x value for the end point of the vector. 
/// @param {real}	_y2 The y value for the end point of the vector. 
/// @param {real}	_x1 (Optional) The x value for the start point of the vector. 
/// @param {real}	_y1 (Optional) The y value for the start point of the vector. 
/// @return {struct.Vector2}

function Vector2(_x2, _y2, _x1 = 0, _y1 = 0) constructor
{
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	
	dx = x2 - x1;
	dy = y2 - y1;
	magnitude2 = sqr(dx) + sqr(dy);
	
	angle = arctan2(-dy, dx);
	
	if (angle < 0)
	{
		angle += TPI;
	}
	
	dangle = radtodeg(angle);
	
	//Update the squared magnitude
	
	static update_mag = function()
	{
		magnitude2 = sqr(dx) + sqr(dy);
	}
	
	//Return the magnitude of the vector
	
	static get_magnitude = function()
	{
		return sqrt(magnitude2);
	}
	
	//Update the angle, making sure it varies from 0 to 2*pi / 0 to 360
	
	static update_angle = function()
	{
		angle = arctan2(-dy, dx);
	
		if (angle < 0)
		{
			angle += TPI;
		}
	
		dangle = radtodeg(angle);
	}
	
	//Copy constructor
	
	static copy = function()
	{
		return new Vector2(x2, y2, x1, y1);
	}
	
	//Change the location of the end point
	
	static repoint = function(_x, _y)
	{
		x2 = _x;
		y2 = _y;
		dx = x2 - x1;
		dy = y2 - y1;
		
		update_angle();
		update_mag();
	}
	
	//Set a new starting point for the vector
	
	static rebase = function(_x, _y)
	{
		x1 = _x;
		y1 = _y;
		dx = x2 - x1;
		dy = y2 - y1;
		
		update_angle();
		update_mag();
	}
	
	//Set a new starting point for the vector based on vec2.
	//Optionally, get the point by interpolation along vec2 by c.
	//By default, c = 1 (i.e., the endpoint of vec2). c must be between 0 and 1.
	
	static rebase_from_vector = function(vec2, c = 1)
	{
		c = clamp(c, 0, 1);
		
		if (c == 1)
		{
			rebase(vec2.x2, vec2.y2);
		}
		else
		{
			xx = vec2.interp_x(c);
			yy = vec2.interp_y(c);
			rebase(xx, yy);
		}
	}
	
	//Join the base of the vector to that of vec2.
	
	static lock_base = function(vec2)
	{
		rebase(vec2.x1, vec2.y1);
	}
	
	//Completely redefine the points of the vector. Essentially reinstantiating the vector.
	//As such, start point is optional and is (0,0) by default.
	
	static redefine = function(_x2, _y2, _x1 = 0, _y1 = 0)
	{
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
	
		dx = x2 - x1;
		dy = y2 - y1;
		
		update_angle();
		update_mag();
	}
	
	//Return the Manhattan distance.
	
	static manhattan = function()
	{
		return dx + dy;
	}
	
	//Add vec2 to the vector
	
	static add = function(vec2)
	{
		x2 += vec2.dx;
		y2 += vec2.dy;
		dx = x2 - x1;
		dy = y2 - y1;
		
		update_mag();
		update_angle();
	}
	
	//Subtract (Add inverse) vec2 to the vector
	
	static sub = function(vec2)
	{
		x2 -= vec2.dx;
		y2 -= vec2.dy;
		dx = x2 - x1;
		dy = y2 - y1;
		
		update_mag();
		update_angle();
	}
	
	//Scale the vector by c

	static scale = function(c)
	{
		dx *= c;
		dy *= c;
		x2 = x1 + dx;
		y2 = y1 + dy;
		
		update_mag();
	}
	
	//Invert the vector (scale by -1)
	
	static invert = function()
	{
		dx *= -1;
		dy *= -1;
		x2 += 2 * dx;
		y2 += 2 * dy;
		
		update_angle();
	}
	
	//Divide the vector by c (scale by inverse).
	
	static divide = function(c)
	{
		scale(1 / c);
	}
	
	//Transform the vector by the given scalar values. Like multiplying by a diagonal matrix.
	
	static two_scale = function(c1, c2)
	{
		dx *= c1;
		dy *= c2;
		x2 = x1 + dx;
		y2 = y1 + dy;
		
		update_mag();
		update_angle();
	}
	
	//Transform the vector by the four given scalars. Like multiplying by a 2x2 matrix.
	
	static transform = function(a1, a2, b1, b2)
	{
		xx = dx * a1 + dy * a2;
		yy = dx * b1 + dy * b2;
		dx = xx;
		dy = yy;
		x2 = x1 + dx;
		y2 = y1 + dy;
	
		update_mag();
		update_angle();
	}
	
	//Multiply by a 2x2 matrix. Equivalent to matrix_transform_vertex.
	
	static matrix_transform = function(m)
	{
		xx = dx * m[0][0] + dy * m[0][1];
		yy = dx * m[1][0] + dy * m[1][1];
		dx = xx;
		dy = yy;
		
		update_mag();
		update_angle();
	}
	
	//Shear in the x direction by c.
	
	static shear_x = function(c)
	{
		dx += dy * c;
	}
	
	//Shear in the y direction by c.
	
	static shear_y = function(c)
	{
		dy += dx * c;
	}
	
	//Return the dot product of the vector and vec2.
	
	static dot = function(vec2)
	{
		return dx * vec2.dx + dy * vec2.dy; 
	}
	
	//Return the cross product of the vector and vec2.
	//Result is based at vector start point by default.
	
	static cross = function(vec2, _x1 = x1, _y1 = y1)
	{
		m = (dx * vec2.dy) - (dy * vec2.dx);
		
		return new Vector3(_x1, _y1, m, _x1, _y1, 0);
	}
	
	//Return the magnitude of the cross product of the vector and vec2.
	
	static cross_magnitude = function(vec2)
	{
		return (dx * vec2.dy) - (dy * vec2.dx);
	}
	
	//Rotate the vector about the origin by theta, in radians.
	
	static rotate = function(theta)
	{
		cos0 = cos(theta);
		sin0 = sin(theta);
		
		
		//This is the result of multiplying the vector by a rotation matrix
		xx = cos0 * dx - sin0 * dy;
		yy = sin0 * dx + cos0 * dy;
		dx = xx;
		dy = yy;
		x2 = x1 + dx;
		y2 = y1 + dy;
		
		update_angle();
	}
	
	//Rotate the vector about the origin by theta, in degrees.
	
	static rotate_deg = function(theta)
	{
		rotate(degtorad(theta));
	}
	
	//Get the angle between this vector and vec2, in radians.
	
	static get_angle = function(vec2)
	{
		theta = max(angle, vec2.angle) - min(angle, vec2.angle);
		
		if (theta > pi)
		{
			return TPI - theta;
		}
		else return theta;
	}
	
	//Get the angle between this vector and vec2, in degrees.
	
	static get_angle_deg = function(vec2)
	{
		return radtodeg(get_angle(vec2));
	}
	
	//Determine the distance between the vector and a point.
	
	static dist_vec_to_point = function(_x, _y)
	{
		v = new Vector2(_x, _y, x1, y1);
		d = v.get_magnitude() * sin(get_angle(v));
		
		delete v;
		return abs(d);
	}
	
	//Get the projection of the vector onto vec2. Optionally, choose whether it should
	//be able to have a magnitude greater than vec2.
	
	static projection = function(vec2, overextend = true)
	{
		//projection = v*cos0 times unit vector in vec2.
		b = vec2.copy();
		c = dot(b) / b.magnitude2;
		b.scale(c);
		
		if (!overextend && b.magnitude2 > vec2.magnitude2)
		{
			b.scale(sqrt(vec2.magnitude2 / b.magnitude2));
		}
		
		return b;
	}
	
	//Get the rejection of the vector from vec2. Optionally, choose whether it should be
	//locked to its related projection and whether it should overextend its basis vector.
	
	static rejection = function(vec2, lock_to_proj = false, overextend = true)
	{
		a1 = copy();
		a2 = projection(vec2, overextend);
		
		if (!overextend)
		{
			//If the hypotenuse breaches a right angle triangle, we scale it down so that
			//the rejection thinks it is at the furthest boundary of the projection.
			
			//cos0 = a1.dot(a2) / (a1.magnitude * a2.magnitude);
			
			if (a1.dot(a2) > a2.magnitude2) //If cos0 * a1.mag > a2.mag
			{
				a1.scale(a2.magnitude2 / a1.dot(a2)); //Scale by a1.magnitude / a2.magnitude * cos0
			}
		}
		
		if (lock_to_proj)
		{
			//Translate to the endpoint of the projection.
			a1.translate(a2.x2 - a1.x1, a2.y2 - a1.y1);
		}
		
		a1.sub(a2);
		
		delete a2;
		return a1;
	}
	
	
	//Translate the vector by the given offsets.
	
	static translate = function(_dx, _dy)
	{
		x1 += _dx;
		x2 += _dx;
		y1 += _dy;
		y2 += _dy;
	}
	
	//Rotate the vector around a given point, in radians
	
	static rotate_around_point = function(_x, _y, theta)
	{
		rx = x1 - _x;
		ry = y1 - _y;
		ncos0 = cos(theta) - 1;
		sin0 = sin(theta);
		
		xx = ncos0 * rx - sin0 * ry;
		yy = sin0 * rx + ncos0 * ry; 
		
		translate(xx, yy);
		rotate(theta);
	}
	
	//Rotate the vector around a given point, in degrees.
	
	static rotate_around_point_deg = function(_x, _y, theta)
	{
		rotate_around_point(_x, _y, degtorad(theta));
	}
	
	//Rotate the vector around a point on the line, in radians.
	//c is the proportion of how far up the vector will serve as the rotation point.
	//c cannot be greater than 1 or less than 0.
	
	static rotate_on_line = function(c, theta)
	{
		c = clamp(c, 0, 1);
		
		//Get the point interpolated along the line
		xx = x1 + dx * c;
		yy = y1 + dy * c;
		
		rotate_around_point(xx, yy, theta);
	}
	
	//Rotate the vector around a point on the line, in degrees.
	
	static rotate_on_line_deg = function(c, theta)
	{
		rotate_on_line(c, degtorad(theta));
	}
	
	//Reflect the vector about the given line
	
	static reflect = function (_x1, _y1, _x2, _y2)
	{
		//Reflection line, and line going from the line to start of the vector
		l = new Vector2(_x2, _y2, _x1, _y1);
		v = new Vector2(x1, y1, _x1, _y1);
		
		//Get the net difference between the start point and the equivalent point on the
		//opposite side of the reflection line by getting the rejection from l and then
		//doubling the deltas of the rejection.
		r = v.rejection(l);
		xx1 = 2 * r.dx;
		yy1 = 2 * r.dy;
		
		v.repoint(x2, y2);
		r = v.rejection(l);
		xx2 = 2 * r.dx;
		yy2 = 2 * r.dy;
		
		//Relocate the vector to the new positions indicated.
		redefine(x2 - xx2, y2 - yy2, x1 - xx1, y1 - yy1);
		
		delete l;
		delete v;
		delete r;
	}
	
	//Checks whether the given point is on the vector within the given tolerance.
	
	static is_on_line = function(_x, _y, tolerance)
	{	
		var xa = _x - x1;
		var xb = x2 - _x;
		var ya = _y - y1;
		var yb = y2 - _y;
		
		//Check the difference between [point A to (_x, _y)] + [(_x, _y) to point B], and 
		//the magnitude of the calling vector.
		
		var diff = sqrt( sqr(xa) + sqr(ya) ) + sqrt( sqr(xb) + sqr(yb) ) - get_magnitude();
		
		return (diff <= tolerance);
	}
	
	//Checks whether the given vector intersects with the calling vector.
	//Optionally, select whether the calling vector should be treated as infinite.
	
	static intersects = function(vec2, infinite)
	{
		
		//This function returns -1, 0, or 1 depending on the relative orientation of
		//the vector with respect to the given point.
		var orientation = function(cx, cy)
		{
			return sign(dy * (cx - x2) - dx * (cy - y2))
		}
		
		op1 = orientation(vec2.x1, vec2.y1);
		op2 = orientation(vec2.x2, vec2.y2);
		
		//If the two endpoints of vec2 have different orientation (intersect)
		//or either are 0 (collinear)
		if !(abs(op1 + op2) == 2) //Takes in all cases except (1, 1) and (-1, -1)
		{
			if (!infinite)
			{
				//If we treat vec2 as finite, we have to make sure that its points are
				//on either side of the calling vector.
				v = new Vector2(x2, y2, x1, y1);
				
				if (!vec2.intersects(v, true))
				{
					delete v;
					return false;
				}
				
				delete v;
			}
			
			return true;
		}
		else
		{
			return false;
		}
	}
	
	
	//Get the x value interpolated along the vector by c. c must be between 0 and 1
	
	static interp_x = function(c)
	{
		c = clamp(c, 0, 1);
		return x1 + dx * c;
	}
	
	//Get the y value interpolated along the vector by c. c must be between 0 and 1
	
	static interp_y = function(c)
	{
		c = clamp(c, 0, 1);
		return y1 + dy * c;
	}
	
	//Draw the vector as a simple line. Can optionally add thickness and colour.
	
	static draw = function(t = 1, c1 = c_black, c2 = c1)
	{
			draw_line_width_color(x1, y1, x2, y2, t, c1, c2);
	}
}
