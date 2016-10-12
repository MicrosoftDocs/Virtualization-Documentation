function Save_Button_onclick() {
	var lang = document.getElementById("programminglanguages").value;	
	var options = GetOptions();
	
	var code = "<pre class=\"brush: " + lang + "; " + ToOptionString(options) + "\">"; 
	code += EscapeHtml(document.getElementById("codearea").value);
	code += "</pre>";
	
	var scripts = "";
	
	if (document.getElementById("codearea").value == '')
	{
		tinyMCEPopup.close();
		return false;
	}
	
	tinyMCEPopup.execCommand('mceInsertContent', false, code);
	tinyMCEPopup.close();
	return false;
}

function GetOptions() {
	var options = {
		autolinks: true,
		classname: '',
		collapse: false,
		firstline: 1,
		gutter: true,
		highlight: '',
		htmlscript: false,
		smarttabs: true,
		tabsize: 4,
		toolbar: true
	};
	
	if (document.getElementById("autolinks").checked == false) {
		options.autolinks = false;
	}

	if (document.getElementById("classname").value != "") {
		options.classname = document.getElementById("collapse").value;
	}
		  
	if (document.getElementById("collapse").checked == true) {
		options.collapse = true;
	}
		  
	if (document.getElementById("firstline").value != "") {
		options.firstline = document.getElementById("firstline").value;
	}
	
	if (document.getElementById("gutter").checked == false) {
		options.gutter = false;
	}
	
	if (document.getElementById("highlight").value != "") {
		options.highlight = document.getElementById("highlight").value;
	}
	
	if (document.getElementById("htmlscript").checked == true) {
		options.htmlscript = true;
	}
	
	if (document.getElementById("smarttabs").checked == false) {
		options.smarttabs = false; 
	}
	
	if (document.getElementById("tabsize").value != "") {
		options.tabsize = document.getElementById("tabsize").value;
	}
	
	if (document.getElementById("toolbar").checked == false) {
		options.toolbar = false;
	}
   
	return options;
}

function ToOptionString(options) {
	var optionstring = "";
	
	if (options.autolinks == false) {
		optionstring += "auto-links: false; ";
	}

	if (options.classname != "") {
		optionstring += "class-name: " + options.classname + "; ";
	}
		  
	if (options.collapse == true) {
		optionstring += "collapse: true; ";
	}
		  
	if (options.firstline != "") {
		optionstring += "first-line: " + options.firstline + "; ";
	}
	
	if (options.gutter == false) {
		optionstring += "gutter: false; ";
	}
	
	if (options.highlight != "") {
		optionstring += "highlight: " + options.highlight + "; ";
	}
	
	if (options.htmlscript == true) {
		optionstring += "html-script: true; ";
	}
	
	if (options.smarttabs == false) {
		optionstring += "smart-tabs: false; ";
	}
	
	if (options.tabsize != "") {
		optionstring += "tab-size: " + options.tabsize + "; ";
	}
	
	if (options.toolbar == false) {
		optionstring += "toolbar: false; ";
	}
   
	return optionstring;
}

function Cancel_Button_onclick()
{
	tinyMCEPopup.close();
	return false;
}

function EscapeHtml(html) {
	return html.replace(/&/gm,'&amp;').replace(/</gm,'&lt;').replace(/>/gm,'&gt;').replace(/"/gm,'&quot;');
}