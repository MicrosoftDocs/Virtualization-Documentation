/*
* syntaxhighlighter TinyMCE plugin
* Released under LGPL License.
* 
* by Robin Calmejane
* http://nomadonweb.com
* 
* Plugin page :
* http://lab.nomadonweb/sh4tinymce
* 
*/
tinymce.PluginManager.requireLangPack('sh4tinymce');
tinymce.PluginManager.add('sh4tinymce', function(editor,url) {
	function showDialog() {
		/* Var declaration */
		var win, dom = editor.dom, selection = editor.selection, data = {}, Elmt;
		var shDefault = {}, defaultLanguage = 'html', selected = false, selectedCode, selectionNode = selection.getNode(), settings;
		
		/* Set default settings for SH and plugin */
		/***** DON'T CHANGE DEFAULTS *****/
		/* shDefault : Default SyntaxHighlighter settings */
		shDefault.autolinks		= true;
		shDefault.collapse		= false;
		shDefault.firstline		= '1';
		shDefault.gutter		= true;
		shDefault.highlight		= '';
		shDefault.htmlscript	= false;
		shDefault.tabsize		= '4';
		shDefault.toolbar		= true;
		
		/* data : plugin settings */
		data.language 		= '';
		data.autolinks		= shDefault.autolinks;
		data.collapse		= shDefault.collapse;
		data.firstline		= shDefault.firstline;
		data.gutter			= shDefault.gutter;
		data.highlight		= shDefault.highlight;
		data.htmlscript		= shDefault.htmlscript;
		data.tabsize		= shDefault.tabsize;
		data.toolbar		= shDefault.toolbar;
		/* End default settings */
		
		// List languages
		var languageItems = [
				{text: 'Language',		value: ''},
				{text: 'ActionScript3',	value: 'as3'},
				{text: 'Bash/shell',	value: 'bash'},
				{text: 'ColdFusion',	value: 'cf'},
				{text: 'C#',			value: 'csharp'},
				{text: 'C++',			value: 'cpp'},
				{text: 'CSS',			value: 'css'},
				{text: 'Delphi',		value: 'delphi'},
				{text: 'Diff',			value: 'diff'},
				{text: 'Erlang',		value: 'erl'},
				{text: 'Groovy',		value: 'groovy'},
				{text: 'HTML',			value: 'html'},
				{text: 'Java',			value: 'java'},
				{text: 'JavaFX',		value: 'jfx'},
				{text: 'JavaScript',	value: 'js'},
				{text: 'Perl',			value: 'perl'},
				{text: 'PHP',			value: 'php'},
				{text: 'PowerShell',	value: 'ps'},
				{text: 'Python',		value: 'py'},
				{text: 'Ruby',			value: 'ruby'},
				{text: 'Scala',			value: 'scala'},
				{text: 'SQL',			value: 'sql'},
				{text: 'Text',			value: 'plain'},
				{text: 'Visual Basic',	value: 'vb'},
				{text: 'XML',			value: 'xml'}
		];
		
		// Get settings of SH existing code
		function getSHSettings(settings) {
			var s = settings.split(';');
			var settingsObj= {};
			for(var i=0; i<s.length; i++)
			{
				var o = s[i].split(':');
				settingsObj[o[0].replace(/\-/g,'')] = o[1];
			}
			tinymce.each(settingsObj, function(value, setting) {
				if (setting == 'brush') {
					if (data.language != value)
						data.language = value;
				} else {
					value = value == 'true' ? true : (value == 'false' ? false : value);
					if(setting=='highlight')value=value.replace(/\[/g,"").replace(/\]/g,"");
					data[setting] = value;
				}
			});
		}
		
		// Check code/text selection in tinyMCE editor
		if(selectionNode.nodeName.toLowerCase() == 'pre'
			&& selectionNode.className.indexOf('brush:') != -1) {
			// This is an SH code
			selected = true;
			selectedCode = $(selectionNode).html();
			selectedCode = selectedCode.replace(/\&lt\;/gi,"<").replace(/\&gt\;/gi,">");
			/* We have to get SH settings from classname */
			settings = selectionNode.className;
			settings = settings.replace(/ /g,'');
			getSHSettings(settings);
		}else{
			// This is a simple selection
			selectedCode = selection.getContent({format : 'text'});
			data.autolinks = false;
			data.toolbar = false;
		}
		
		// Select language item list
		for(var i=0; i<languageItems.length; i++){
			if(languageItems[i].value == data.language){
				languageItems[i].selected = true;
			}
		}
		
		data.code = selectedCode;
		if (data.code == '&nbsp;')
			data.code = '';
		
		function onSubmitFunction(e) {
			var code = e.data.code;
			code = code.replace(/\</g,"&lt;").replace(/\>/g,"&gt;");
			/* Convert settings into strings for classname */
			var language	= e.data.language ? e.data.language : defaultLanguage;
			var collapse	= e.data.collapse != shDefault.collapse ? ';collapse:' + e.data.collapse : '';
			var autolinks	= e.data.autolinks != shDefault.autolinks ? ';auto-links:' + e.data.autolinks : '';
			var gutter		= e.data.gutter != shDefault.gutter ? ';gutter:' + e.data.gutter : '';
			var htmlscript	= e.data.htmlscript != shDefault.htmlscript ? ';html-script:' + e.data.htmlscript : '';
			var toolbar		= e.data.toolbar != shDefault.toolbar ? ';toolbar:' + e.data.toolbar : '';
			var firstline	= e.data.firstline != shDefault.firstline ? ';first-line:' + e.data.firstline : '';
			var hlstart=e.data.highlight.indexOf(",")!=-1?"[":"",
				hlend=e.data.highlight.indexOf(",")!=-1?"]":"";
			var highlight	= e.data.highlight.replace(/ /g,"").replace(/\[/g,"").replace(/\]/g,"") != shDefault.highlight ? ';highlight:' + hlstart + e.data.highlight.replace(/ /g,"").replace(/\[/g,"").replace(/\]/g,"").replace(/,$/g,"") + hlend : '';
			var tabsize		= e.data.tabsize != shDefault.tabsize ? ';tab-size:' + e.data.tabsize : '';
			
			// Create SH element with string settings
			Elmt = editor.dom.create('pre',
						{class: 'brush:' + language + collapse + autolinks + gutter + htmlscript + toolbar + firstline + highlight + tabsize,
						 contenteditable: 'false'},
						 code);
			
			if(selected)
				editor.dom.replace(Elmt, selectionNode);
			else
				editor.insertContent(editor.dom.getOuterHTML(Elmt)+'<br>');
		}
		
		win = editor.windowManager.open({
			title: 'SH4TinyMCE - Code Editor',
			data: data,
			minWidth: 450,
			body: [
					{name: 'language',	type: 'listbox',	values: languageItems},
					{name: 'code',		type: 'textbox',	minHeight: 200,		multiline: true},
					{
						type: 'container',
						layout: 'flex',
						direction: 'row',
						align: 'center',
						spacing: 7,
						items: [
								{name: 'collapse',		type: 'checkbox',	text: 'Collapse',	checked: data.collapse},
								{name: 'autolinks',		type: 'checkbox',	text: 'Autolinks',		checked: data.autolinks},
								{name: 'gutter',		type: 'checkbox',	text: 'Gutter',			checked: data.gutter},
								{name: 'htmlscript',	type: 'checkbox',	text: 'Html script',	checked: data.htmlscript},
								{name: 'toolbar',		type: 'checkbox',	text: 'Toolbar',		checked: data.toolbar}
						]
					},
					{
						type: 'form',
						padding: 0,
						labelGap: 5,
						spacing: 5,
						direction: 'row',
						items: [
								{name: 'firstline',		type: 'textbox',	label: 'First Line', 	size: 3,	value: data.firstline},
								{name: 'highlight',		type: 'textbox',	label: 'Highlight', 	size: 10,	value: data.highlight},
								{name: 'tabsize',		type: 'textbox',	label: 'Tab size',		size: 3,	value: data.tabsize},
						]
					}
			],
			onsubmit: onSubmitFunction
		});
	}
	tinymce.DOM.loadCSS(url+'/style/style.css');
	editor.addButton('sh4tinymce', {
		icon: 'sh4tinymce',
		tooltip: 'Insert/Edit Code',
		onclick: showDialog
	});
    editor.addMenuItem('sh4tinymce', {
        text: 'SH4TinyMCE',
		icon: 'sh4tinymce',
        context: 'insert',
        onclick: showDialog
    });
});