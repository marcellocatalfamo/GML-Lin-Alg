function Shape(_verts, _closed) constructor
{
	num_verts = array_length(_verts);
	edges = [];
	closed = _closed;
 
	draw_shape = function(_verts)
	{
		//If closed, start with the closing edge. If not, then we skip that one.
		if (closed)
		{
			prev = _verts[num_verts - 1];
			i = 0;
		}
		else
		{
			prev = _verts[0];
			i = 1;
		}
	
		var draw_next_vector = function(element, index)
		{
			//Subtract 0 or 1 from the index, depending on if we need to realign the indices.
			v = new Vector2(element[0], element[1], prev[0], prev[1]);
			edges[index - i] = v;
			prev = element;
		}
		
		array_foreach(_verts, draw_next_vector, i);
	}
	
	draw_shape(_verts);
}