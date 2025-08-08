function Regular_Polygon(_x, _y, _num_verts, _radius) : Shape([], true) constructor
{
	x_center = _x; y_center = _y;
	num_verts = _num_verts;
	radius = _radius;
	apothem = 0;
	
	int_angle = pi * (num_verts - 2) / num_verts;
	angular_diff = pi - int_angle;
	
	//Set the first vertex as being to the immediate right of centre
	verts = [new Point(x_center + radius, y_center)];
	
	//Make all the other vertices at regular intervals around the center
	var dx = radius, dy = 0;
	var theta = angular_diff;
	
	for (i = 1; i < num_verts; i++)
	{
		var tdx = dx * cos(theta) - dy * sin(theta);
		var tdy = dx * sin(theta) + dy * cos(theta);
		
		dx = tdx;
		dy = tdy;
		
		verts[i] = new Point(x_center + dx, y_center + dy);
	}
	
	//Make a new shape with these vertices
	redefine_vertices(verts);
	
	static rotate = function(theta)
	{
		//Rotate each vertex around the origin
		for (i = 0; i < num_verts; i++)
		{
			var vdx = verts[i].x - x_center;
			var vdy = verts[i].y - y_center;
						
			var tdx = vdx * cos(theta) - vdy * sin(theta);
			var tdy = vdx * sin(theta) + vdy * cos(theta);
		
			verts[i] = new Point(x_center + tdx, y_center + tdy);
		}
		
		//Make a new shape with these vertices
		redefine_vertices(verts);
	}
}
