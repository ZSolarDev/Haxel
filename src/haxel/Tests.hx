package src.haxel;

import src.haxel.parser.ToHaxe;

class Tests {

        static function main() {
                Sys.println('haxel: float uno = 1.0;');
                Sys.println('haxe: ${ToHaxe.convertVariable('float uno = 1.0;')}');
        }
}
