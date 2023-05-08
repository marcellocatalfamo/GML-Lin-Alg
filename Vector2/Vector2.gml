///2D vector functions

/// @func			Vector2(_x2, _y2, _x1, _y1)
/// @desc			Creates a 2D vector using the given coordinates.
/// @param {float}	_x2 The x value for the end point of the vector. 
/// @param {float}	_y2 The y value for the end point of the vector. 
/// @param {float}	_x1 (Optional) The x value for the start point of the vector. 
/// @param {float}	_y1 (Optional) The y value for the start point of the vector. 
/// @return {Vector2}

function Vector2(_x2, _y2, _x1 = 0, _y1 = 0) constructor
{
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	
	dx = x2 - x1;
	dy = y2 - y1;
	magnitude = sqrt( sqr(dx) + sqr(dy) );
	
	angle = arctan2(-dy, dx);
	
	if (angle < 0)
	{
		angle += 2 * pi;
	}
	
	dangle = radtodeg(angle);
	
	//Update the angle, making sure it varies from 0 to 2*pi / 0 to 360
	
	static update_angle = function()
	{
		angle = arctan2(-dy, dx);
	
		if (angle < 0)
		{
			angle += 2 * pi;
		}
	
		dangle = radtodeg(angle);
	}
	
	//Copy constructor
	
	static copy = function(_vec2)
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
		magnitude = sqrt( sqr(dx) + sqr(dy) );
		
		update_angle();
	}
	
	//Set a new starting point for the vector
	
	static rebase = function(_x, _y)
	{
		x1 = _x;
		y1 = _y;
		dx = x2 - x1;
		dy = y2 - y1;
		magnitude = sqrt( sqr(dx) + sqr(dy) );
		
		update_angle();
	}
	
	//Set a new starting point for the vector based on _vec2.
	//Optionally, get the point by interpolation along _vec2 by c.
	//By default, c = 1 (i.e., the endpoint of _vec2). c must be between 0 and 1.
	
	static rebase_from_vector = function(_vec2, c = 1)
	{
		clamp(c, 0, 1);
		
		if (c == 1)
		{
			rebase(_vec2.x2, _vec2.y2);
		}
		else
		{
			xx = interp_x_vec2(_vec2, c);
			yy = interp_y_vec2(_vec2, c);
			rebase(xx, yy);
		}
	}
	
	//Join the base of the vector to that of _vec2.
	
	static lock_base = function(_vec2)
	{
		rebase(_vec2.x1, _vec2.y1);
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
		magnitude = sqrt( sqr(dx) + sqr(dy) );
	
		update_angle();
	}
	
	//Add _vec2 to the vector
	
	static add = function(_vec2)
	{
		x2 += _vec2.dx;
		y2 += _vec2.dy;
		dx = x2 - x1;
		dy = y2 - y1;
		magnitude = sqrt( sqr(dx) + sqr(dy) );
		
		update_angle();
	}
	
	//Subtract (Add inverse) _vec2 to the vector
	
	static sub = function(_vec2)
	{
		x2 -= _vec2.dx;
		y2 -= _vec2.dy;
		dx = x2 - x1;
		dy = y2 - y1;
		magnitude = sqrt( sqr(dx) + sqr(dy) );
		
		update_angle();
	}
	
	//Scale the vector by c
	
	static scale = function(c)
	{
		dx *= c;
		dy *= c;
		x2 = x1 + dx;
		y2 = y1 + dy;
		magnitude *= c;
	}
	
	//Invert the vector (scale by -1)
	
	static invert = function()
	{
		dx *= -1;
		dy *= -1;
		x2 += 2 * dx;
		y2 += 2 * dy;
		
		angle = (angle + pi) % (2 * pi);
		dangle = radtodeg(angle);
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
		magnitude = sqrt( sqr(dx) + sqr(dy) );
		
		update_angle();
	}
	
	//Transform the vector by the two given scalars. Like multiplying by a 2x2 matrix.
	
	static transform = function(a1, a2, b1, b2)
	{
		xx = dx * a1 + dy * a2;
		yy = dx * b1 + dy * b2;
		dx = xx;
		dy = yy;
		x2 = x1 + dx;
		y2 = y1 + dy;
		magnitude = sqrt( sqr(dx) + sqr(dy) );
		
		update_angle();
	}
	
	//Multiply by a 2x2 matrix. Equivalent to matrix_transform_vertex.
	
	static matrix_transform = function(m)
	{
		xx = dx * m[0][0] + dy * m[0][1];
		yy = dx * m[1][0] + dy * m[1][1];
		dx = xx;
		dy = yy;
		magnitude = sqrt( sqr(dx) + sqr(dy) );
		
		update_angle();
	}
	
	//Shear in the x direction by c.
	
	static shear_x = function(c)
	{
		transform(1, c, 0, 1);
	}
	
	//Shear in the y direction by c.
	
	static shear_y = function(c)
	{
		transform(1, 0, c, 1);
	}
	
	//Return the dot product of the vector and _vec2.
	
	static dot = function(_vec2)
	{
		return dx * _vec2.dx + dy * _vec2.dy; 
	}
	
	//Return the cross product of the vector and _vec2.
	//Result is based at vector start point by default.
	
	static cross = function(_vec2, _x1 = x1, _y1 = y1)
	{
		m = (dx * _vec2.dy) - (dy * _vec2.dx);
		
		return new Vector3(_x1, _y1, m, _x1, _y1, 0);
	}
	
	//Return the magnitude of the cross product of the vector and _vec2.
	
	static cross_magnitude = function(_vec2)
	{
		return (dx * _vec2.dy) - (dy * _vec2.dx);
	}
	
	//Rotate the vector about the origin by theta, in radians.
	
	static rotate = function(theta)
	{
		//This is the result of multiplying the vector by a rotation matrix
		xx = cos(theta) * dx - sin(theta) * dy;
		yy = sin(theta) * dx + cos(theta) * dy;
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
	
	//REFERENCE-FREE FUNCTIONS DONE UP TO HERE
	
	//Get the angle between this vector and _vec2, in radians.
	
	static get_angle = function(_vec2)
	{
		a = angle - _vec2.angle;
		
		if (a < 0)
		{
			a += 2 * pi;
		}
		
		b = _vec2.angle - angle;
		
		if (b < 0)
		{
			b += 2 * pi;
		}
		
		return min(a, b);
		//Follows from A.B = |A|*|B|*cos(theta)
		//return arccos(dot(_vec2) / (magnitude * _vec2.magnitude));
	}
	
	//Get the angle between this vector and _vec2, in degrees.
	
	static get_angle_deg = function(_vec2)
	{
		return radtodeg(get_angle(_vec2));
	}
	
	//Determine the distance between the vector and a point.
	
	static dist_vec_to_point = function(_x, _y)
	{
		v = new Vector2(_x, _y, x1, y1);
		theta = get_angle(v);
		d = v.magnitude * sin(theta);
		
		delete v;
		return abs(d);
	}
	
	//Get the projection of the vector onto _vec2. Optionally, choose whether it should
	//be able to have a magnitude greater than _vec2.
	
	static projection = function(_vec2, overextend = true)
	{
		//projection = v*cos0 times unit vector in _vec2.
		b = copy_vec2(_vec2);
		c = dot(b) / sqr(b.magnitude);
		b.scale(c); //Same as scaling b.divide(b.magnitude) by dot(b) / b.magnitude
		
		if (!overextend)
		{
			if (b.magnitude > _vec2.magnitude)
			{
				b.scale(_vec2.magnitude / b.magnitude);
			}
		}
		
		return b;
	}
	
	//Get the rejection of the vector from _vec2. Optionally, choose whether it should be
	//locked to its related projection and whether it should overextend its basis vector.
	
	static rejection = function(_vec2, lock_to_proj = false, overextend = true)
	{
		a1 = copy();
		a2 = projection(_vec2, overextend);
		
		if (!overextend)
		{
			//If the hypotenuse breaches a right angle triangle, we scale it down so that
			//the rejection thinks it is at the furthest boundary of the projection.
			cos0 = a1.dot(a2) / (a1.magnitude * a2.magnitude);
			
			if (a1.magnitude * cos0 > a2.magnitude)
			{
				a1.scale(a2.magnitude / (a1.magnitude * cos0));
			}
		}
		
		if (lock_to_proj)
		{
			//Translate to the endpoint of the projection.
			a1.translate(a2.x2 - a1.x1, a2.y2 - a1.y1);;
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
		
		//This is an abbreviation of the math in the Rotate method, without the overhead of
		//instantiating a new vector or the required consideration of updating its fields.
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
	
	//Checks whether the given point is on the vector.
	
	static is_on_line = function(_x, _y)
	{
		return (dy * _x - dx * _y == 0);
	}
	
	//Checks whether the given vector intersects with the calling vector.
	//Optionally, select whether the calling vector should be treated as infinite.
	
	static intersects = function(_vec2, extend)
	{
		p1 = dy * _vec2.x1 - dx * _vec2.y1;
		p2 = dy * _vec2.x2 - dx * _vec2.y2;
		
		if (-1 * sign(p1) == sign(p2))
		{
			if (!extend)
			{
				
			}
			
			return true;
		}
		
		return false;
	}
	
	
	//Get the x value interpolated along the vector by c. c must be between 0 and 1
	
	static interp_x = function(_c)
	{
		c = clamp(_c, 0, 1);
		return x1 + dx * c;
	}
	
	//Get the y value interpolated along the vector by c. c must be between 0 and 1
	
	static interp_y = function(_c)
	{
		c = clamp(_c, 0, 1);
		return y1 + dy * c;
	}
	
	//Draw the vector as a simple line. Can optionally add thickness and colour.
	
	static draw = function(t = 1, c1 = c_black, c2 = c1)
	{
			draw_line_width_color(x1, y1, x2, y2, t, c1, c2);
	}
}
	
	
/// @func				copy_vec2(_vec2)
/// @desc				Return a copy of _vec2. Creates a new vector using its end points.
/// @param {Vector2}	_vec2 The vector being copied.
/// @return {Vector2}
	
function copy_vec2(_vec2)
{
	return new Vector2(_vec2.x2, _vec2.y2, _vec2.x1, _vec2.y1);
}
	
/// @func				v_add(_vec1, _vec2)
/// @desc				Add the second Vector2 to the first.
/// @param {Vector2}	_vec1 The vector being added to.
/// @param {Vector2}	_vec2 The vector being added.
	
function v_add(_vec1, _vec2)
{
	_vec1.x2 += _vec2.dx;
	_vec1.y2 += _vec2.dy;
	_vec1.dx = _vec1.x2 - _vec1.x1;
	_vec1.dy = _vec1.y2 - _vec1.y1;
	_vec1.magnitude = sqrt( sqr(_vec1.dx) + sqr(_vec1.dy) );
		
	_vec1.angle = arctan2(-dy, dx);
	dangle = radtodeg(angle);
}
	
/// @func				v_sub(_vec1, _vec2)
/// @desc				Subtract the second Vector2 from the first one.
/// @param {Vector2}	_vec1 The vector being subtracted from.
/// @param {Vector2}	_vec2 The vector being subtracted.
	
function v_sub(_vec1, _vec2)
{
	_vec1.x2 -= _vec2.dx;
	_vec1.y2 -= _vec2.dy;	
	_vec1.dx = _vec1.x2 - _vec1.x1;
	_vec1.dy = _vec1.y2 - _vec1.y1;
	_vec1.magnitude = sqrt( sqr(_vec1.dx) + sqr(_vec1.dy) );
		
	_vec1.angle = arctan2(-_vec1.dy, _vec1.dx);
	_vec1.dangle = radtodeg(_vec1.angle);
}
	
/// @func				v_scale(_vec2, c)
/// @desc				Scale the vector by the given constant.
/// @param {Vector2}	_vec2 The vector being scaled.
/// @param {float}		c The scale factor to be applied. 
	
function v_scale(_vec2, c)
{
	_vec2.dx *= c;
	_vec2.dy *= c;
	_vec2.x2 = _vec2.x1 + _vec2.dx;
	_vec2.y2 = _vec2.y1 + _vec2.dy;
	_vec2.magnitude *= c;
}

/// @func				v_invert(_vec2)
/// @desc				Reverse the vector. This is equivalent to scaling it by -1.
/// @param {Vector2}	_vec2 The vector inverted.

function v_invert(_vec2)
{
	_vec2.dx *= -1;
	_vec2.dy *= -1;
	_vec2.x2 += 2 * _vec2.dx;
	_vec2.y2 += 2 * _vec2.dy;
	
	_vec2.angle = (_vec2.angle + pi) % (2 * pi);
	_vec2.dangle = radtodeg(_vec2.angle);
}

/// @func				v_rebase(_vec2, _x, _y)
/// @desc				Set the start point of the vector to the given coordinates.
/// @param {Vector2}	_vec2 The vector being rebased.
/// @param {float}		_x The new x value of the start point.
/// @param {float}		_y The new y value of the start point.

function v_rebase(_vec2, _x, _y)
{
	_vec2.x1 = _x;
	_vec2.y1 = _y;
	_vec2.dx = _vec2.x2 - _vec2.x1;
	_vec2.dy = _vec2.y2 - _vec2.y1;
	_vec2.magnitude = sqrt( sqr(_vec2.dx) + sqr(_vec2.dy) );
	
	_vec2.angle = arctan2(-_vec2.dy, _vec2.dx);
	_vec2.dangle = radtodeg(_vec2.angle);
}
	
/// @func				v_rebase_from_vector(_vec1, _vec2, c)
/// @desc				Set the start point of the vector at a certain point along _vec2.
/// @param {Vector2}	_vec1 The vector being rebased.
/// @param {Vector2}	_vec2 The vector being used as a reference for the new start point.
/// @param {float}		c (Optional) How far along the new start point will be, as a proportion.
	
function v_rebase_from_vector(_vec1, _vec2, c = 1)
{
	if (c >= 1)
	{
		v_rebase(_vec1, _vec2.x2, _vec2.y2);
	}
	else
	{
		xx = _vec2.x1 + _vec2.dx * c;
		yy = _vec2.y1 + _vec2.dy * c;
		v_rebase(_vec1, xx, yy);
	}
}

/// @func				v_dot(_vec1, _vec2)
/// @desc				Returns the dot product of _vec1 and _vec2.
/// @param {Vector2}	_vec1 The first vector being used to calculate the dot product.
/// @param {Vector2}	_vec2 The second vector being used to calculate the dot product.
/// @return {float}

function v_dot(_vec1, _vec2)
{
	return abs(_vec1.dx * _vec2.dx + _vec1.dy * _vec2.dy); 
}

/// @func				v_cross(_vec1, _vec2)
/// @desc				Returns the cross product of the two vectors. Implicit z value of 1.
/// @param {Vector2}	_vec1 The first vector being used to calculate the cross product.
/// @param {Vector2}	_vec2 The second vector being used to calculate the cross product.
/// @return {Vector2}

function v_cross(_vec1, _vec2)
{
	xx = _vec1.dy - _vec2.dy;
	yy = _vec1.dx = _vec2.dx;
	
	return new Vector2(xx, yy);
}

/// @func				v_rotate(_vec1, theta)
/// @desc				Rotate the vector by the given angle in radians.
/// @param {Vector2}	_vec2 The vector being rotated.
/// @param {float}		theta The angle of rotation, in radians.

function v_rotate(_vec2, theta)	
{
	xx = cos(theta) * _vec2.dx - sin(theta) * _vec2.dy;
	yy = sin(theta) * _vec2.dx + cos(theta) * _vec2.dy;
	_vec2.dx = xx;
	_vec2.dy = yy;
	_vec2.x2 = _vec2.x1 + _vec2.dx;
	_vec2.y2 = _vec2.y1 - _vec2.dy;
	
	_vec2.angle = (_vec2.angle - theta) % (2 * pi);
	
	if (_vec2.angle < 0)
	{
		_vec2.angle = 2 * pi;
	}
	
	_vec2.dangle = radtodeg(theta);
}

/// @func				v_rotate_deg(_vec2, theta)
/// @desc				Rotate the vector by the given angle in degrees.
/// @param {Vector2}	_vec2 The vector being rotated.
/// @param {float}		theta The angle of rotation, in degrees.

function v_rotate_deg(_vec2, theta)
{
	v_rotate(_vec2, degtorad(theta));
}

/// @func				interp_x_vec2(_vec2, c)
/// @desc				Get the x value interpolated along the vector by c, between 0 and 1.
/// @param {Vector2}	_vec2 The vector to interpolate along.
/// @param {float}		c How far along the vector we interpolate, as a proportion.
/// @return {float}

	
function interp_x_vec2(_vec2, c)
{
	clamp(c, 0, 1);
	return _vec2.x1 + _vec2.dx * c;
}
	
/// @func				interp_y_vec2(_vec2, c)
/// @desc				Get the y value interpolated along the vector by c, between 0 and 1.
/// @param {Vector2}	_vec2 The vector to interpolate along.
/// @param {float}		c How far along the vector we interpolate, as a proportion.
/// @return {float}

function interp_y_vec2 (_vec2, c)
{
	clamp(c, 0, 1);
	return _vec2.y1 + _vec2.dy * c;
}