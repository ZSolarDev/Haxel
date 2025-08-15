<h1 align="center">
  <img src=".dev/logo_text-300.png"> 
</h1>
<h3 align="center">
 A haxe-based language with more features including built in compute shaders, a large standard library, shader libraries(yes, shader libraries), etc.
<h3>

## Why Haxel?
Haxel was made to provide ease of use when dealing with compute shaders in haxe. This is done by coding in my own shading language(hxlsl) based on haxe. It's similar to glsl and hlsl in nature, but the syntax is haxel-based. You can make shader libraries, import those shader libraries in shaders, easily run a compite shader and set and get SSBO's without dealing with bytes, etc.

## Is it any different from Haxe syntactically?
Haxel's syntax is also a bit different from haxe, only in a couple subtle ways. Instead of doing something like `var coolFloat:Float = 0;`, Haxel uses `float coolFloat = 0;`. Instead of `trace`, Haxel uses `print`. Finally, instead of doing `var coolVar:{coolInt:Int, coolFloat:Float};`, you would do `var coolVar:{int coolInt, float coolFloat};`. These changes were made because I find it simpler defining the variable type to make a variable instead of typing var to state variable declarations; I also like this way of defining dynamic structures, and print makes more sense than trace.

## How does a Haxel project compile?
The Haxel compiler essentially converts Haxel to Haxe and runs it through the Haxe compiler to give you your final result. Basically just `haxel -D build -D path/to/project/file.hxlp`(not working currently, look [here](https://github.com/ZSolarDev/Haxel/blob/dev/README.md#how-to-use-haxeltests).).

## What about graphics(optional)?
Haxel has two built-in graphics API's: Flixel and Haxel Graphics Framework. You can make your own too, you just won't have the ability to create a custom project layout unless you modify the Haxel compiler.

### Flixel
Flixel integrates nicely with Haxel, it's basically the same as normal haxe. Project.xml, Main, states, etc. The only catches are that the folders copied stated in the hxlp have to be the same as the Project.xml, and your souce folder in the Project.xml MUST be source, but keep your hxlp source folder the same(e.g. if my source folder was src, my hxlp would be src but my Project.xml would have to be source).

### Haxel Graphics Framework
TODO: make this.

## How to use haxelTests?
For using the tests, inside of this folder(the root folder), run one of these four commands:
`./haxelTests/testFlixel.bat`
`./haxelTests/testHaxe.bat`
`./haxelTests/buildFlixel.bat`
`./haxelTests/buildHaxe.bat`
The tests build and run. The builds only build it.

# TODO: add Haxel demos showcasing compite shader flexibility, hxlstd, etc.

# TODO: add Haxel docs as a Wiki section and add a simple demo here.
