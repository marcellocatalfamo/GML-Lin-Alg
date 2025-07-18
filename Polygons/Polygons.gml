function Shape(_verts, _closed) constructor
{
	num_verts = array_length(_verts);
	edges = [];
	closed = _closed;
	convex = closed; //If the shape isn't closed, we consider it non-convex by default
 
	//Checks to see if the polygon is convex
 
	check_convex = function(_verts)
	{
		if (!closed) return;
		
		var prev, cur;
		prev = _verts[num_verts - 1];
		cur = _verts[0];
	
		for (i = 0; i < num_verts; i++)
		{	
			//Check if this is a convex turn or not by cross product
			if (prev[0] * cur[1] - cur[0] * prev[1] < 0)
			{
				convex = false;
				break;
			}
			else
			{
				prev = _verts[i];
				cur = _verts[i + 1];
			}
		}
	}
	
	//Checks for point collision of a convex polygon
	
	check_collision = function(_x, _y)
	{
		var vec, dx, dy;
		
		for (i = 0; i < array_length(edges); i++)
		{
			vec = edges[i];
			dx = _x - vec.x1;
			dy = _y - vec.y1;
			
			//Check that the cross product is always non-negative
			if (vec.dx * dy - dx * vec.dy < 0)
				return false;
		}
		
		return true;
	}
	
	//Draws the form of the polygon
 
	make_edges = function(_verts)
	{
		var prev, offset;
		
		//If closed, start with the closing edge. If not, then we skip that one.
		if (closed)
		{
			prev = _verts[num_verts - 1];
			offset = 0;
		}
		else
		{
			prev = _verts[0];
			offset = 1;
		}
	
		for (i = 0; i < num_verts; i++)
		{
			var vert = _verts[i + offset];
			v = new Vector2(vert[0], vert[1], prev[0], prev[1]);
			edges[index] = v;
			prev = vert;
		}
		
	}
	
	//Draws the polygon
	
	draw_shape = function(t = 1, c = c_black)
	{
		for (i = 0; i < array_length(edges); i++)
		{
			edges[i].draw(t, c);	
		}
	}	
	
	check_convex(_verts);
	make_edges(_verts);
}
