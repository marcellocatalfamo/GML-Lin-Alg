This linear algebra library for GML is free for use so long as you credit me.

Some functions call a "print" function. Any variadic script function with that name should be fine, but here's the basic one written out in the official GML manual:

```gml
function print()
{
    var _str = "";
    
    for (var i = 0; i < argument_count; i ++)
    {
        _str += string(argument[i]);
    }

    show_debug_message(_str);
}
```
