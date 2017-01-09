define("ace/mode/gcode_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"],function(require,exports){"use strict";var oop=require("../lib/oop"),TextHighlightRules=require("./text_highlight_rules").TextHighlightRules,GcodeHighlightRules=function(){var keywords="IF|DO|WHILE|ENDWHILE|CALL|ENDIF|SUB|ENDSUB|GOTO|REPEAT|ENDREPEAT|CALL",builtinConstants="PI",builtinFunctions="ATAN|ABS|ACOS|ASIN|SIN|COS|EXP|FIX|FUP|ROUND|LN|TAN",keywordMapper=this.createKeywordMapper({"support.function":builtinFunctions,keyword:keywords,"constant.language":builtinConstants},"identifier",!0);this.$rules={start:[{token:"comment",regex:"\\(.*\\)"},{token:"comment",regex:"([N])([0-9]+)"},{token:"string",regex:"([G])([0-9]+\\.?[0-9]?)"},{token:"string",regex:"([M])([0-9]+\\.?[0-9]?)"},{token:"constant.numeric",regex:"([-+]?([0-9]*\\.?[0-9]+\\.?))|(\\b0[xX][a-fA-F0-9]+|(\\b\\d+(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)"},{token:keywordMapper,regex:"[A-Z]"},{token:"keyword.operator",regex:"EQ|LT|GT|NE|GE|LE|OR|XOR"},{token:"paren.lparen",regex:"[\\[]"},{token:"paren.rparen",regex:"[\\]]"},{token:"text",regex:"\\s+"}]}};oop.inherits(GcodeHighlightRules,TextHighlightRules),exports.GcodeHighlightRules=GcodeHighlightRules}),define("ace/mode/gcode",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/gcode_highlight_rules","ace/range"],function(require,exports){"use strict";var oop=require("../lib/oop"),TextMode=require("./text").Mode,GcodeHighlightRules=require("./gcode_highlight_rules").GcodeHighlightRules,Mode=(require("../range").Range,function(){this.HighlightRules=GcodeHighlightRules});oop.inherits(Mode,TextMode),function(){this.$id="ace/mode/gcode"}.call(Mode.prototype),exports.Mode=Mode});