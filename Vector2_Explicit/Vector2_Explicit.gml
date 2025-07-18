///Vector 2 Explicit


/// @func					v2_copy(vec2)
/// @desc					Return a copy of vec2. Creates a new vector using its end points.
/// @param {Struct.Vector2}	vec2 The vector being copied.
/// @return {Struct.Vector2}
	
function v2_copy(vec2)
{
	return new Vector2(vec2.x2, vec2.y2, vec2.x1, vec2.y1);
}

/// @func					v2_repoint(vec2, _x, _y)
/// @desc					Change the location of the end point.
/// @param {Struct.Vector2}	vec2 The vector being repointed.

function v2_repoint(vec2, _x, _y)
	{
		vec2.x2 = _x;
		vec2.y2 = _y;
		vec2.dx = vec2.x2 - x1;
		vec2.dy = vec2.y2 - y1;
		
		vec2.update_angle();
		vec2.update_mag();
	}
	
/// @func					v2_rebase(vec2, _x, _y)
/// @desc					Set the start point of the vector to the given coordinates.
/// @param {Struct.Vector2}	vec2 The vector being rebased.
/// @param {Real}			_x The new x value of the start point.
/// @param {Real}			_y The new y value of the start point.

function v2_rebase(vec2, _x, _y)
{
	vec2.x1 = _x;
	vec2.y1 = _y;
	vec2.dx = vec2.x2 - vec2.x1;
	vec2.dy = vec2.y2 - vec2.y1;
	vec2.magnitude = sqrt( sqr(vec2.dx) + sqr(vec2.dy) );
	
	vec2.update_mag();
	vec2.update_angle();
}
	
/// @func					v2_rebase_from_vector(vec1, vec2, c)
/// @desc					Set the start point of the vector at a certain point along vec2.
/// @param {Struct.Vector2}	vec1 The vector being rebased.
/// @param {Struct.Vector2}	vec2 The vector being used as a reference for the new start point.
/// @param {Real}			c (Optional) How far along the new start point will be, as a proportion.
	
function v2_rebase_from_vector(vec1, vec2, c = 1)
{
	if (c >= 1)
	{
		v_rebase(vec1, vec2.x2, vec2.y2);
	}
	else
	{
		xx = vec2.x1 + vec2.dx * c;
		yy = vec2.y1 + vec2.dy * c;
		v2_rebase(vec1, xx, yy);
	}
}

/// @func					v2_lock_vase(vec1, vec2)
/// @desc					Lock the two vectors' bases together.
/// @param {Struct.Vector2}	vec1 The vector being moved.
/// @param {Struct.Vector2}	vec2 The vector being moved to.

function v2_lock_base(vec1, vec2)
{
	vec1.rebase(vec2.x1, vec2.y1);
}
	
/// @func					v2_redefine
/// @desc					Completely reorient the vector.
/// @param {Struct.Vector2}	vec2 The vector being affected.
/// @param {Real}			_x2 The endpoint x value.
/// @param {Real}			_y2 The endpoint y value.
/// @param {Real}			_x1 (Optional) The start point x value.
/// @param {Real}			_y1 (Optional) The start point y value.

function v2_redefine(vec2, _x2, _y2, _x1 = 0, _y1 = 0)
{
	vec2.x1 = _x1;
	vec2.y1 = _y1;
	vec2.x2 = _x2;
	vec2.y2 = _y2;
	
	vec2.dx = _x2 - _x1;
	vec2.dy = _y2 - _y1;
		
	vec2.update_angle();
	vec2.update_mag();
}
	
/// @func					v2_manhattan(vec2)
/// @desc					Return the Manhattan distance.
/// @param {Struct.Vector2}	vec2 The vector whose length is being measured.

function v2_manhattan(vec2)
{
	return vec2.dx + vec2.dy;
}
	
/// @func					v2_add(vec1, vec2)
/// @desc					Add the second Struct.Vector2 to the first.
/// @param {Struct.Vector2}	vec1 The vector being added to.
/// @param {Struct.Vector2}	vec2 The vector being added.	
	
function v2_add(vec1, vec2)
{
	vec1.x2 += vec2.dx;
	vec1.y2 += vec2.dy;
	vec1.dx = vec1.x2 - vec1.x1;
	vec1.dy = vec1.y2 - vec1.y1;
	
	update_mag();
	update_angle();
}
	
/// @func					v2_sub(vec1, vec2)
/// @desc					Subtract the second Struct.Vector2 from the first one.
/// @param {Struct.Vector2}	vec1 The vector being subtracted from.
/// @param {Struct.Vector2}	vec2 The vector being subtracted.
	
function v2_sub(vec1, vec2)
{
	vec1.x2 -= vec2.dx;
	vec1.y2 -= vec2.dy;	
	vec1.dx = vec1.x2 - vec1.x1;
	vec1.dy = vec1.y2 - vec1.y1;
	
	update_mag();
	update_angle();
}
	
/// @func					v2_scale(vec2, c)
/// @desc					Scale the vector by the given constant.
/// @param {Struct.Vector2}	vec2 The vector being scaled.
/// @param {Real}			c The scale factor to be applied. 
	
function v2_scale(vec2, c)
{
	vec2.dx *= c;
	vec2.dy *= c;
	vec2.x2 = vec2.x1 + vec2.dx;
	vec2.y2 = vec2.y1 + vec2.dy;
	
	update_mag();
}

/// @func					v2_invert(vec2)
/// @desc					Reverse the vector. This is equivalent to scaling it by -1.
/// @param {Struct.Vector2}	vec2 The vector inverted.

function v2_invert(vec2)
{
	vec2.dx *= -1;
	vec2.dy *= -1;
	vec2.x2 += 2 * vec2.dx;
	vec2.y2 += 2 * vec2.dy;
	
	vec2.update_angle();
}

/// @func					v2_divide(vec2, c)
/// @desc					Divide the vector by c.
/// @param {Struct.Vector2}	vec2 The vector being divided.
/// @param {Real}			c The scaling factor.

function v2_divide(vec2, c)
{
	vec2.scale(1 / c);
}

/// @func					v2_two_scale(vec2, c1, c2)
/// @desc					Transform the vector by the given values.
/// @param {Struct.Vector2}	vec2 The vector being transformed.
/// @param {Real}			c1 The x scalar.
/// @param {Real}			c2 The y scalar.

function v2_two_scale(vec2, c1, c2)
{
	vec2.dx *= c1;
	vec2.dy *= c2;
	vec2.x2 = vec2.x1 + vec2.dx;
	vec2.y2 = vec2.y1 + vec2.dy;
		
	vec2.update_mag();
	vec2.update_angle();
}

/// @func					v2_transform(vec2, a1, a2, b1, b2)
/// @desc					Transform the vector. Like mulitplying by a 2x2 matrix.
/// @param {Struct.Vector2}	vec2 The vector being transformed.
/// @param {Real}			a1 Entry (1,1)
/// @param {Real}			a2 Entry (1,2)
/// @param {Real}			b1 Entry (2,1)
/// @param {Real}			b2 Entry (2,2)

function v2_transform(vec2, a1, a2, b1, b2)
{
	xx = vec2.dx * a1 + vec2.dy * a2;
	yy = vec2.dx * b1 + vec2.dy * b2;
	vec2.dx = xx;
	vec2.dy = yy;
	vec2.x2 = vec2.x1 + xx;
	vec2.y2 = vec2.y1 + yy;

	vec2.update_mag();
	vec2.update_angle();
}

/// @func					v2_matrix_transform(vec2, m)
/// @desc					Transform the vector using a 2D matrix.
/// @param {Struct.Vector2}	vec2 The vector being transformed.
/// @param {Array<Real>}	m The transformation matrix.

function v2_matrix_transform(vec2, m)
{
	xx = vec2.dx * m[0][0] + vec2.dy * m[0][1];
	yy = vec2.dx * m[1][0] + vec2.dy * m[1][1];
	vec2.dx = xx;
	vec2.dy = yy;
		
	vec2.update_mag();
	vec2.update_angle();
}

/// @func					v2_shear_x(vec2, c)
/// @desc					Shear in the x direction by c.
/// @param {Struct.Vector2}	vec2 The vector being shorn.
/// @param {Real}			c The proportion of the shear.

function v2_shear_x(vec2, c)
{
	vec2.dx += vec2.dy * c;
}
	
/// @func					v2_shear_y(vec2, c)
/// @desc					Shear in the y direction by c.
/// @param {Struct.Vector2}	vec2 The vector being shorn.
/// @param {Real}			c The proportion of the shear.
	
function v2_shear_y(vec2, c)
{
	vec2.dy += vec2.dx * c;
}

/// @func					v2_dot(vec1, vec2)
/// @desc					Returns the dot product of vec1 and vec2.
/// @param {Struct.Vector2}	vec1 The first vector being used to calculate the dot product.
/// @param {Struct.Vector2}	vec2 The second vector being used to calculate the dot product.
/// @return {Real}

function v2_dot(vec1, vec2)
{
	return vec1.dx * vec2.dx + vec1.dy * vec2.dy; 
}

/// @func					v2_cross(vec1, vec2)
/// @desc					Returns the cross product of the two vectors. Implicit z value of 1.
/// @param {Struct.Vector2}	vec1 The first vector being used to calculate the cross product.
/// @param {Struct.Vector2}	vec2 The second vector being used to calculate the cross product.
/// @return {Struct.Vector2}

function v2_cross(vec1, vec2)
{
	xx = vec1.dy - vec2.dy;
	yy = vec1.dx = vec2.dx;
	
	return new Vector2(xx, yy);
}

/// @func					v2_cross_magnitude(vec1, vec2)
/// @desc					Returns the magnitude of the cross product.
/// @param {Struct.Vector2} vec1 The first vector being crossed.
/// @param {Struct.Vector2} vec2 The second vector being crossed.
/// @return {Real}

function v2_cross_magnitude(vec1, vec2)
{
	return (vec1.dx * vec2.dy) - (vec1.dy * vec2.dx);
}

/// @func					v2_rotate(vec1, theta)
/// @desc					Rotate the vector by the given angle in radians.
/// @param {Struct.Vector2}	vec2 The vector being rotated.
/// @param {Real}			theta The angle of rotation, in radians.

function v2_rotate(vec2, theta)	
{
	xx = cos(theta) * vec2.dx - sin(theta) * vec2.dy;
	yy = sin(theta) * vec2.dx + cos(theta) * vec2.dy;
	vec2.dx = xx;
	vec2.dy = yy;
	vec2.x2 = vec2.x1 + vec2.dx;
	vec2.y2 = vec2.y1 - vec2.dy;
	
	vec2.update_angle();
}

/// @func					v_rotate_deg(vec2, theta)
/// @desc					Rotate the vector by the given angle in degrees.
/// @param {Struct.Vector2}	vec2 The vector being rotated.
/// @param {Real}			theta The angle of rotation, in degrees.

function v2_rotate_deg(vec2, theta)
{
	v2_rotate(vec2, degtorad(theta));
}



/// @func					v2_interp_x(vec2, c)
/// @desc					Get the x value interpolated along the vector by c, between 0 and 1.
/// @param {Struct.Vector2}	vec2 The vector to interpolate along.
/// @param {Real}			c How far along the vector we interpolate, as a proportion.
/// @return {Real}

function v2_interp_x(vec2, c)
{
	c = clamp(c, 0, 1);
	return vec2.x1 + vec2.dx * c;
}
	
/// @func				v2_interp_y(vec2, c)
/// @desc				Get the y value interpolated along the vector by c, between 0 and 1.
/// @param {Struct.Vector2}	vec2 The vector to interpolate along.
/// @param {Real}		c How far along the vector we interpolate, as a proportion.
/// @return {Real}

function v2_interp_y(vec2, c)
{
	c = clamp(c, 0, 1);
	return vec2.y1 + vec2.dy * c;
}
