<h1 align="center">
  <img src=".dev/logo_text-300.png"> 
</h1>
<h3 align="center">
 A Haxe-based language with more features including built in compute shaders, a large standard library, shader libraries(yes, shader libraries), etc.
<h3>

## Why Haxel?
Haxel was made to provide ease of use when dealing with compute shaders in Haxe. This is done by coding in my own shading language(hxlsl) based on Haxe. It's similar to glsl and hlsl in nature, but the syntax is haxel-based. You can make shader libraries, import those shader libraries in shaders, easily run a compite shader and set and get SSBO's without dealing with bytes, etc.

<br>

## Is it any different from Haxe syntactically?
Haxel's syntax is also a bit different from Haxe, mainly when it comes to defining variables.
| Haxe | Haxel |
|----------|----------|
| `var coolFloat:Float = 0;` | `float coolFloat = 0;` |
| `var coolVar:{coolInt:Int, coolFloat:Float};` | `obj{int coolInt; float coolFloat} coolVar;` |
| `var coolVar = coolFunction({testing: 1, testing2: {testing: 2, testing2: {testing: 3, testing2: 4}}});` | `auto coolVar = coolFunction({testing: 1, testing2: {testing: 2, testing2: {testing: 3, testing2: 4}}});` |
| `var coolCall:Void->Float = ():Float = { return 0; };` | `auto coolCall = ():Float = { return 0; }; // TODO: support variables defined like this` |

### Default types
Some default types start with a lowercase. These types are: *float, int, string, bool, array, void,* and *dynamic*. There are also two new types: *obj* and *auto*.
Haxel also adds two new keywords:
- **obj**: for defining anonymous structures.  
- **auto** : for variables with inferred types.  

<br>

## How does a Haxel project compile?
The Haxel compiler essentially converts Haxel to Haxe and runs it through the Haxe compiler to give you your final result. Basically just `haxel -D build -D path/to/project/file.hxlp`(not working currently, look [here](https://github.com/ZSolarDev/Haxel/tree/dev#how-to-use-haxeltests).).

<br>

## What about graphics(optional)?
Haxel has two built-in graphics API's: Flixel and Haxel Graphics Framework. You can make your own too, you just won't have the ability to create a custom project layout unless you modify the Haxel compiler.

### Flixel
Flixel integrates nicely with Haxel, it's basically the same as normal Haxe. Project.xml, Main, states, etc. The only catches are that the folders copied stated in the hxlp have to be the same as the Project.xml, and your souce folder in the Project.xml MUST be source, but keep your hxlp source folder the same(e.g. if my source folder was src, my hxlp would be src but my Project.xml would have to be source).

### Haxel Graphics Framework
TODO: make this.

<br>

## How to use haxelTests?
For using the tests, inside of this folder(the root folder), run one of these 8 commands with powershell():

### Build Scripts: Build
`./haxelTests/buildFlixel.ps1`

`./haxelTests/buildHaxe.ps1`

<br>

`./haxelTests/buildFlixelVerbose.ps1`

`./haxelTests/buildHaxeVerbose.ps1`

<br>

`./haxelTests/buildFlixelVerbosePlus.ps1`

`./haxelTests/buildHaxeVerbosePlus.ps1`

<br>

### Test Scripts: Build + Run output
`./haxelTests/testFlixel.ps1`

`./haxelTests/testHaxe.ps1`

<br>

`./haxelTests/testFlixelVerbose.ps1`

`./haxelTests/testHaxeVerbose.ps1`

<br>

`./haxelTests/testFlixelVerbosePlus.ps1`

`./haxelTests/testHaxeVerbosePlus.ps1`



<br>
<br>

# TODO: add Haxel demos showcasing compite shader flexibility, hxlstd, etc.

# TODO: add Haxel docs as a Wiki section and add a simple demo here.
