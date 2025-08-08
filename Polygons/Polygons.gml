function Point(_x, _y) constructor
{
	x = _x;
	y = _y;
	
	//Make a Vector2 from the point
	static to_vec2 = function()
	{
		return new Vector2(x, y);
	}
}

function Shape(_verts, _closed) constructor
{
	verts = _verts;
	num_verts = array_length(_verts);
	edges = [];
	colours = [];
	closed = _closed;
	convex = closed; //If the shape isn't closed, we consider it non-convex by default
	x_center = 0;
	y_center = 0;
 
	for (i = 0; i < num_verts; i++)
	{
		if (!is_numeric(verts[i].x) || !is_numeric(verts[i].y))
		{
			print("Vertices must be a numeric value");
			return;
		}
	}
	
	//By default, set the center to be the arithmetic mean of all the vertices
	
	for (i = 0; i < num_verts; i++)
	{
		x_center += verts[i].x;
		y_center += verts[i].y;
	}
	
	x_center /= num_verts;
	y_center /= num_verts;
 
	//Checks to see if the polygon is convex
 
	static check_convex = function()
	{
		if (!closed || num_verts = 0) return;
		
		var prev, cur;
		prev = verts[num_verts - 1];
		cur = verts[0];
	
		for (i = 0; i < num_verts; i++)
		{	
			//Check if this is a convex turn or not by cross product
			if (prev.x * cur.y - cur.x * prev.y < 0)
			{
				convex = false;
				return false;
			}
			else if (i != num_verts - 1)
			{
				prev = verts[i];
				cur = verts[i + 1];
			}
		}
		
		convex = true;
		return true;
	}
	
	//Checks for point collision of a convex polygon
	
	static check_collision = function(_x, _y)
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
 
	static make_edges = function()
	{
		if (num_verts < 2) return;
		
		var vert, next;
		var vs = num_verts - 1;
		vert = verts[0];
		
		for (i = 0; i < vs; i++)
		{
			next = verts[i + 1];
			v = new Vector2(next.x, next.y, vert.x, vert.y);
			edges[i] = v;
			vert = next;
		}
		
		//If closed, make an edge between the last and first vertices
		if (closed)
		{
			vert = verts[vs];
			next = verts[0];
			v = new Vector2(next.x, next.y, vert.x, vert.y);
			edges[vs] = v;
		}
	}
	
	//Sets the vertex colours
	
	static set_vert_colours = function(_colours)
	{
		if (array_length(_colours) != num_verts)
		{
				print("Incorrect number of vertex colours provided");
				return;
		}
		
		for (i = 0 ; i < num_verts; i++)
		{
			colours[i] = _colours[i];
		}
	}
	
	//Redefine the center of the polygon
	
	static set_center = function(xx, yy)
	{
		x_center = xx;
		y_center = yy;
	}
	
	static get_center = function()
	{
		return new Point(x_center, y_center);
	}
	
	//Change a single vertex
	
	static change_vertex = function(index, _x, _y)
	{
		if (index >= num_verts || index < 0)
		{
			print("Invalid vertex index");
			return;
		}
		
		if (!is_numeric(_x) || !is_numeric(_y))
		{
			print("Vertex must have numeric coordinates");
			return;
		}
		
		verts[i].x = _x;
		verts[i].y = _y;
	}
	
	//Replace the polygon's vertices
	
	static redefine_vertices = function(new_verts)
	{
		for (i = 0; i < array_length(verts); i++)
		{
			if (!is_numeric(verts[i].x) || !is_numeric(verts[i].y))
			{
				print("Vertices must be have numeric coordinates");
				return;
			}
		}
		
		verts = new_verts;
		check_convex();
		make_edges();
	}
	
	//Move the whole polygon
	
	static move = function(vec2)
	{
		for (i = 0; i < num_verts; i++)
		{
			verts[i].x += vec2.dx;
			verts[i].y += vec2.dy;
		}
		
		make_edges();
	}
	
	static move = function(dx, dy)
	{
		for (i = 0; i < num_verts; i++)
		{
			verts[i].x += dx;
			verts[i].y += dy;
		}
		
		make_edges();
	}
	
	
	//Draws the polygon as one colour
	
	static draw_shape = function(t = 1, c = c_black)
	{
		for (i = 0; i < array_length(edges); i++)
		{
			edges[i].draw(t, c);	
		}
	}
	
	//Draws the shape per its vertex colours
	
	static draw_shape_vert_cols = function(t = 1)
	{
		var es = array_length(edges) - 1;
		
		for (i = 0; i < es; i++)
		{	
			edges[i].draw(t, colours[i], colours[i + 1]);
		}
		
		if (closed)
			edges[i].draw(t, colours[es], colours[0]);
		else
			edges[i].draw(t, colours[es - 1], colours[es]);
	}
	
	check_convex();
	make_edges();
}
