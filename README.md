<h1 align="center">
  <img src=".dev/logo_text-300.png"> 
</h1>
<h3 align="center">
 A haxe-based language with more features including built in compute shaders(built on vulkan), shader libraries, interpreter mode, etc.
<h3>

## Why Haxel?
Haxel was made to provide ease of use when dealing with compute shaders in haxe. I plan to achive this by making my own flexible shading language(hxlsl) based on glsl. You can make shader libraries, import those shader libraries, easily run a compite shader and set and get buffers, etc.

## Is it any different from Haxe syntactically?
Haxel's syntax is also a bit different from haxe, only in a subtle way. instead of doing something like `var coolFloat:Float = 0;`, Haxel uses `float coolFloat = 0;`. Also instead of `trace`, Haxel uses `print`. These changes were made because I find it simpler defining the variable type to make a variable instead of typing var to state variable declarations.

## How doea a Haxel project compile?
The Haxel compiler essentially converts Haxel to Haxe and runs it through the Haxe compiler to give you your final result.

# TODO: add Haxel demos showcasing compite shader flexibility.
