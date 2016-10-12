$(document).ready(function () {
    var root = BlogEngineRes.applicationWebRoot + 'scripts/syntaxhighlighter/scripts/';
    SyntaxHighlighter.autoloader(
        'applescript            ' + root + 'shBrushAppleScript.js',
        'actionscript3 as3      ' + root + 'shBrushAS3.js',
        'bash shell             ' + root + 'shBrushBash.js',
        'coldfusion cf          ' + root + 'shBrushColdFusion.js',
        'cpp c                  ' + root + 'shBrushCpp.js',
        'c# c-sharp csharp      ' + root + 'shBrushCSharp.js',
        'css                    ' + root + 'shBrushCss.js',
        'delphi pascal          ' + root + 'shBrushDelphi.js',
        'diff patch pas         ' + root + 'shBrushDiff.js',
        'erl erlang             ' + root + 'shBrushErlang.js',
        'groovy                 ' + root + 'shBrushGroovy.js',
        'haxe                   ' + root + 'shBrushHaxe.js',
        'java                   ' + root + 'shBrushJava.js',
        'jfx javafx             ' + root + 'shBrushJavaFX.js',
        'js jscript javascript  ' + root + 'shBrushJScript.js',
        'perl pl                ' + root + 'shBrushPerl.js',
        'php                    ' + root + 'shBrushPhp.js',
        'text plain             ' + root + 'shBrushPlain.js',
        'ps powershell          ' + root + 'shBrushPowerShell.js',
        'py python              ' + root + 'shBrushPython.js',
        'ruby rails ror rb      ' + root + 'shBrushRuby.js',
        'sass scss              ' + root + 'shBrushSass.js',
        'scala                  ' + root + 'shBrushScala.js',
        'sql                    ' + root + 'shBrushSql.js',
        'vb vbnet               ' + root + 'shBrushVb.js',
        'xml xhtml xslt html    ' + root + 'shBrushXml.js'
    );
    SyntaxHighlighter.all();
});