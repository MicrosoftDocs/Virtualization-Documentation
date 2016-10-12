/**
 * jTemplates 0.8.4 (http://jtemplates.tpython.com)
 * Copyright (c) 2007-2013 Tomasz Gloc (http://www.tpython.com)
 * 
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and/or GPL (GPL-LICENSE.txt) licenses.
 *
 * Id: $Id: jquery-jtemplates_uncompressed.js 203 2013-02-03 13:28:34Z tom $
 */

 /**
 * @fileOverview Template engine in JavaScript.
 * @name jTemplates
 * @author Tomasz Gloc
 * @date $Date: 2013-02-03 14:28:34 +0100 (N, 03 lut 2013) $
 */

if (window.jQuery && !window.jQuery.createTemplate) {(function (jQuery) {

	/**
	 * [abstract]
	 * @name BaseNode
	 * @class Abstract node. [abstract]
	 */

	/**
	 * Process node and get the html string. [abstract]
	 * @name get
	 * @function
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String}
	 * @memberOf BaseNode
	 */

	/**
	 * [abstract]
	 * @name BaseArray
	 * @augments BaseNode
	 * @class Abstract array/collection. [abstract]
	 */

	/**
	 * Add node 'e' to array.
	 * @name push
	 * @function
	 * @param {BaseNode} e a node
	 * @memberOf BaseArray
	 */

	/**
	 * See (http://jquery.com/).
	 * @name jQuery
	 * @class jQuery Library (http://jquery.com/)
	 */

	/**
	 * See (http://jquery.com/)
	 * @name fn
	 * @class jQuery Library (http://jquery.com/)
	 * @memberOf jQuery
	 */

	/**
	 * Create new template from string s.
	 * @name Template
	 * @class A template or multitemplate.
	 * @param {string} s A template string (like: "Text: {$T.txt}.").
	 * @param {array} [includes] Array of included templates.
	 * @param {object} [settings] Settings.
	 * @config {boolean} [disallow_functions] Do not allow use function in data (default: true).
	 * @config {boolean} [filter_data] Enable filter data using escapeHTML (default: true).
	 * @config {boolean} [filter_params] Enable filter parameters using escapeHTML (default: false).
	 * @config {boolean} [runnable_functions] Automatically run function (from data) inside {} [default: false].
	 * @config {boolean} [clone_data] Clone input data [default: true]
	 * @config {boolean} [clone_params] Clone input parameters [default: true]
	 * @config {Function} [f_cloneData] Function used to data cloning
	 * @config {Function} [f_escapeString] Function used to escape strings
	 * @config {Function} [f_parseJSON] Function used to parse JSON
	 * @augments BaseNode
	 */
	var Template = function (s, includes, settings) {
		this._tree = [];
		this._param = {};
		this._includes = null;
		this._templates = {};
		this._templates_code = {};
		
		//default parameters
		this.settings = jQuery.extend({
			disallow_functions: false,
			filter_data: true,
			filter_params: false,
			runnable_functions: false,
			clone_data: true,
			clone_params: true
		}, settings);
		
		//set handlers
		this.f_cloneData = (this.settings.f_cloneData !== undefined) ? (this.settings.f_cloneData) : (TemplateUtils.cloneData);
		this.f_escapeString = (this.settings.f_escapeString !== undefined) ? (this.settings.f_escapeString) : (TemplateUtils.escapeHTML);
		this.f_parseJSON = (this.settings.f_parseJSON !== undefined) ? (this.settings.f_parseJSON) : ((this.settings.disallow_functions) ? (jQuery.parseJSON) : (TemplateUtils.parseJSON));
		
		if(s == null) {
			return;
		}
		
		//split multiteplate
		this.splitTemplates(s, includes);
		
		if(s) {
			//set main template
			this.setTemplate(this._templates_code['MAIN'], includes, this.settings);
		}
		
		this._templates_code = null;
	};
	
	/**
	 * jTemplates version
	 * @type string
	 */
	Template.version = '0.8.4';
	
	/**
	 * Debug mode (all errors are on), default: off
	 * @type Boolean
	 */
	Template.DEBUG_MODE = false;
	
	/**
	 * Foreach loop limit (enable only when DEBUG_MODE = true)
	 * @type integer
	 */
	Template.FOREACH_LOOP_LIMIT = 10000;
	
	/**
	 * Global guid
	 * @type integer
	 */
	Template.guid = 0;
	
	/**
	 * Split multitemplate into multiple templates.
	 * @param {string} s A template string (like: "Text: {$T.txt}.").
	 * @param {array} includes Array of included templates.
	 */
	Template.prototype.splitTemplates = function (s, includes) {
		var reg = /\{#template *(\w+) *(.*?) *\}/g, //split multitemplate into subtemplates
			iter, tname, se, lastIndex = null, _template_settings = [], i;
		
		//while find new subtemplate
		while((iter = reg.exec(s)) !== null) {
			lastIndex = reg.lastIndex;
			tname = iter[1];
			se = s.indexOf('{#/template ' + tname + '}', lastIndex);
			if(se === -1) {
				throw new Error('jTemplates: Template "' + tname + '" is not closed.');
			}
			//save a subtemplate and parse options
			this._templates_code[tname] = s.substring(lastIndex, se);
			_template_settings[tname] = TemplateUtils.optionToObject(iter[2]);
		}
		//when no subtemplates, use all as main template
		if(lastIndex === null) {
			this._templates_code['MAIN'] = s;
			return;
		}
		
		//create a new object for every subtemplates
		for(i in this._templates_code) {
			if(i !== 'MAIN') {
				this._templates[i] = new Template();
			}
		}
		for(i in this._templates_code) {
			if(i !== 'MAIN') {
				this._templates[i].setTemplate(this._templates_code[i],
					jQuery.extend({}, includes || {}, this._templates || {}),
					jQuery.extend({}, this.settings, _template_settings[i]));
				this._templates_code[i] = null;
			}
		}
	};
	
	/**
	 * Parse template. (should be template, not multitemplate).
	 * @param {string} s A template string (like: "Text: {$T.txt}.").
	 * @param {array} includes Array of included templates.
	 * @param {object} [settings] Settings.
	 */
	Template.prototype.setTemplate = function (s, includes, settings) {
		if(s == undefined) {
			this._tree.push(new TextNode('', 1, this));
			return;
		}
		s = s.replace(/[\n\r]/g, ''); //remove endlines
		s = s.replace(/\{\*.*?\*\}/g, ''); //remove comments
		this._includes = jQuery.extend({}, this._templates || {}, includes || {});
		this.settings = new Object(settings);
		var node = this._tree,
			op = s.match(/\{#.*?\}/g), //find operators
			ss = 0, se = 0, e, literalMode = 0, i, l;
		
		//loop operators
		for(i=0, l=(op)?(op.length):(0); i<l; ++i) {
			var this_op = op[i];
			
			//when literal mode is on, treat operator like a text
			if(literalMode) {
				se = s.indexOf('{#/literal}', ss); //find end of block
				if(se === -1) {
					throw new Error("jTemplates: No end of literal.");
				}
				if(se > ss) {
					node.push(new TextNode(s.substring(ss, se), 1, this));
				}
				ss = se + 11; //strlen '{#/literal}'
				literalMode = 0;
				while(i < l && op[i] !== '{#/literal}') { //skip all operators until literal end
					i++;
				}
				continue;
			}
			
			se = s.indexOf(this_op, ss);
			if(se > ss) {
				node.push(new TextNode(s.substring(ss, se), literalMode, this));
			}
			this_op.match(/\{#([\w\/]+).*?\}/); //find operator name
			var op_ = RegExp.$1;
			switch(op_) {
				case 'elseif':
					node.addCond(this_op);
					break;
				case 'if':
					e = new opIF(node, this);
					e.addCond(this_op);
					node.push(e);
					node = e;
					break;
				case 'else':
					node.switchToElse();
					break;
				case '/if':
				case '/for':
				case '/foreach':
					node = node.getParent();
					break;
				case 'foreach':
					e = new opFOREACH(this_op, node, this);
					node.push(e);
					node = e;
					break;
				case 'for':
					e = opFORFactory(this_op, node, this);
					node.push(e);
					node = e;
					break;
				case 'continue':
				case 'break':
					node.push(new JTException(op_));
					break;
				case 'include':
					node.push(new Include(this_op, this._includes, this));
					break;
				case 'param':
					node.push(new UserParam(this_op, this));
					break;
				case 'var':
					node.push(new UserVariable(this_op, this));
					break;
				case 'cycle':
					node.push(new Cycle(this_op));
					break;
				case 'ldelim':
					node.push(new TextNode('{', 1, this));
					break;
				case 'rdelim':
					node.push(new TextNode('}', 1, this));
					break;
				case 'literal':
					literalMode = 1;
					break;
				case '/literal':
					if(Template.DEBUG_MODE) {
						throw new Error("jTemplates: Missing begin of literal.");
					}
					break;
				default:
					if(Template.DEBUG_MODE) {
						throw new Error('jTemplates: unknown tag: ' + op_ + '.');
					}
			}
	
			ss = se + this_op.length;
		}
	
		if(s.length > ss) {
			node.push(new TextNode(s.substr(ss), literalMode, this));
		}
	};
	
	/**
	 * Process template and get the html string.
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String}
	 */
	Template.prototype.get = function (d, param, element, deep) {
		++deep;
		
		if (deep == 1 && element != undefined) {
			jQuery.removeData(element, "jTemplatesRef");
		}
		
		var $T = d, $P, ret = '';
		
		//create clone of data
		if(this.settings.clone_data) {
			$T = this.f_cloneData(d, {escapeData: (this.settings.filter_data && deep == 1), noFunc: this.settings.disallow_functions}, this.f_escapeString);
		}
		
		//create clone of parameters
		if(!this.settings.clone_params) {
			$P = jQuery.extend({}, this._param, param);
		} else {
			$P = jQuery.extend({},
				this.f_cloneData(this._param, {escapeData: (this.settings.filter_params), noFunc: false}, this.f_escapeString),
				this.f_cloneData(param, {escapeData: (this.settings.filter_params && deep == 1), noFunc: false}, this.f_escapeString));
		}
		
		for(var i=0, l=this._tree.length; i<l; ++i) {
			ret += this._tree[i].get($T, $P, element, deep);
		}
		
		this.EvalObj = null;
		
		--deep;
		return ret;
	};
	
	/**
	 * Create and return EvalClass object
	 * @return {EvalClass}
	 */
	Template.prototype.getBin = function () {
		if(this.EvalObj == null) {
			this.EvalObj = new EvalClass(this);
		}
		return this.EvalObj;
	};
	
	/**
	 * Set to parameter 'name' value 'value'.
	 * @param {string} name
	 * @param {object} value
	 */
	Template.prototype.setParam = function (name, value) {
		this._param[name] = value;
	};


	/**
	 * Template utilities.
	 * @namespace Template utilities.
	 */
	TemplateUtils = function () {
	};
	
	/**
	 * Replace chars &, >, <, ", ' with html entities.
	 * To disable function set settings: filter_data=false, filter_params=false
	 * @param {string} string
	 * @return {string}
	 * @static
	 * @memberOf TemplateUtils
	 */
	TemplateUtils.escapeHTML = function (txt) {
		return txt.replace(/&/g,'&amp;').replace(/>/g,'&gt;').replace(/</g,'&lt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
	};

	/**
	 * Make a copy od data 'd'. It also filters data (depend on 'filter').
	 * @param {object} d input data
	 * @param {object} filter a filters
	 * @config {boolean} [escapeData] Use escapeHTML on every string.
	 * @config {boolean} [noFunc] Do not allow to use function (throws exception).
	 * @param {Function} f_escapeString function using to filter string (usually: TemplateUtils.escapeHTML)
	 * @return {object} output data (filtered)
	 * @static
	 * @memberOf TemplateUtils
	 */
	TemplateUtils.cloneData = function (d, filter, f_escapeString) {
		if(d == null) {
			return d;
		}
		switch(d.constructor) {
			case Object:
				var o = {};
				for(var i in d) {
					o[i] = TemplateUtils.cloneData(d[i], filter, f_escapeString);
				}
				if(!filter.noFunc) {
					if(d.hasOwnProperty("toString")) {
						o.toString = d.toString;
					}
				}
				return o;
			case Array:
				var a = [];
				for(var i=0,l=d.length; i<l; ++i) {
					a[i] = TemplateUtils.cloneData(d[i], filter, f_escapeString);
				}
				return a;
			case String:
				return (filter.escapeData) ? (f_escapeString(d)) : (d);
			case Function:
				if(filter.noFunc) {
					if(Template.DEBUG_MODE) {
						throw new Error("jTemplates: Functions are not allowed.");
					}
					else {
						return undefined;
					}
				}
		}
		return d;
	};
	
	/**
	 * Convert text-based option string to Object
	 * @param {string} optionText text-based option string
	 * @return {Object}
	 * @static
	 * @memberOf TemplateUtils
	 */
	TemplateUtils.optionToObject = function (optionText) {
		if(optionText === null || optionText === undefined) {
			return {};
		}
		
		var o = optionText.split(/[= ]/);
		if(o[0] === '') {
			o.shift();
		}
		
		var obj = {};
		for(var i=0, l=o.length; i<l; i+=2) {
			obj[o[i]] = o[i+1];
		}
		
		return obj;
	};
	
	/**
	 * Parse JSON string into object
	 * @param {string} data Text JSON
	 * @return {Object}
	 * @static
	 */
	TemplateUtils.parseJSON = function (data) {
		if ( typeof data !== "string" || !data ) {
			return null;
		}
		try {
			return (new Function("return " + jQuery.trim(data)))();
		} catch(e) {
			if(Template.DEBUG_MODE) {
				throw new Error("jTemplates: Invalid JSON");
			}
			return {};
		}
	};
	
	/**
	 * Find parents nodes for a reference value and return it
	 * @param {Element} el html element
	 * @param {int} guid template process unique identificator
	 * @param {int} id index
	 * @return {object}
	 * @static
	 */
	TemplateUtils.ReturnRefValue = function (el, guid, id) {
		//search element with stored data
		while(el != null) {
			var d = jQuery.data(el, 'jTemplatesRef');
			if(d != undefined && d.guid == guid && d.d[id] != undefined) {
				return d.d[id];
			}
			el = el.parentNode;
		}
		return null;
	};
	
	/**
	 * Create a new text node.
	 * @name TextNode
	 * @class All text (block {..}) between control's block "{#..}".
	 * @param {string} val text string
	 * @param {boolean} literalMode When enable (true) template does not process blocks {..}.
	 * @param {Template} Template object
	 * @augments BaseNode
	 */
	var TextNode = function (val, literalMode, template) {
		this._value = val;
		this._literalMode = literalMode;
		this._template = template;
	};
	
	/**
	 * Get the html string for a text node.
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String}
	 */
	TextNode.prototype.get = function (d, param, element, deep) {
		if(this._literalMode) {
			return this._value;
		}
		var s = this._value;
		var result = "";
		var i = -1;
		var nested = 0;
		var sText = -1;
		var sExpr = 0;
		while(true) {
			var lm = s.indexOf("{", i+1);
			var rm = s.indexOf("}", i+1);
			if(lm < 0 && rm < 0) {
				break;
			}
			if((lm != -1 && lm < rm) || (rm == -1)) {
				i = lm;
				if(++nested == 1) {
					sText = lm;
					result += s.substring(sExpr, i);
					sExpr = -1;
				}
			} else {
				i = rm;
				if(--nested === 0) {
					if(sText >= 0) {
						result += this._template.getBin().evaluateContent(d, param, element, s.substring(sText, rm+1));
						sText = -1;
						sExpr = i+1;
					}
				} else if(nested < 0) {
					nested = 0;
				}
			}
		}
		if(sExpr > -1) {
			result += s.substr(sExpr);
		}
		return result;
	};
	
	/**
	 * Virtual context for eval() (internal class)
	 * @name EvalClass
	 * @class Virtual bin for eval() evaluation
	 * @param {Template} t template
	 * @private
	 */
	EvalClass = function (t) {
		this.__templ = t;
	};
	
	/**
	 * Evaluate expression (template content)
	 * @param {object} $T data
	 * @param {object} $P parameters
	 * @param {object} $Q element
	 * @param {String} __value Template content
	 * @return {String}
	 */
	EvalClass.prototype.evaluateContent = function ($T, $P, $Q, __value) {
		try {
			var result = eval(__value);
			
			if(jQuery.isFunction(result)) {
				if(this.__templ.settings.disallow_functions || !this.__templ.settings.runnable_functions) {
					return '';
				}
				result = result($T, $P, $Q);
			}
			return (result === undefined) ? ("") : (String(result));
		} catch(e) {
			if(Template.DEBUG_MODE) {
				if(e instanceof JTException) {
					e.type = "subtemplate";
				}
				throw e;
			}
			return "";
		}
	};
	
	/**
	 * Evaluate expression (simple eval)
	 * @param {object} $T data
	 * @param {object} $P parameters
	 * @param {object} $Q element
	 * @param {String} __value content to evaluate
	 * @return {String}
	 */
	EvalClass.prototype.evaluate = function ($T, $P, $Q, __value) {
		return eval(__value);
	};
	
	/**
	 * Create a new conditional node.
	 * @name opIF
	 * @class A class represent: {#if}.
	 * @param {object} par parent node
	 * @param {Template} templ template
	 * @augments BaseArray
	 */
	var opIF = function (par, templ) {
		this._parent = par;
		this._templ = templ;
		this._cond = []; //conditions
		this._tree = []; //conditions subtree
		this._curr = null; //current subtree
	};
	
	/**
	 * Add node 'e' to array.
	 * @param {BaseNode} e a node
	 */
	opIF.prototype.push = function (e) {
		this._curr.push(e);
	};
	
	/**
	 * Get a parent node.
	 * @return {BaseNode}
	 */
	opIF.prototype.getParent = function () {
		return this._parent;
	};
	
	/**
	 * Add condition
	 * @param {string} oper content of operator {#..}
	 */
	opIF.prototype.addCond = function (oper) {
		oper.match(/\{#(?:else)*if (.*?)\}/);
		this._cond.push(RegExp.$1);
		this._curr = [];
		this._tree.push(this._curr);
	};
	
	/**
	 * Switch to else
	 */
	opIF.prototype.switchToElse = function () {
		this._cond.push(true); //else is the last condition and its always true
		this._curr = [];
		this._tree.push(this._curr);
	};
	
	/**
	 * Process node depend on conditional and get the html string.
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String}
	 */
	opIF.prototype.get = function (d, param, element, deep) {
		var ret = ''; //result
		
		try {
			//foreach condition
			for(var ci=0, cl=this._cond.length; ci<cl; ++ci) {
				//if condition is true
				if(this._templ.getBin().evaluate(d, param, element, this._cond[ci])) {
					//execute and exit
					var t = this._tree[ci];
					for(var i=0, l=t.length; i<l; ++i) {
						ret += t[i].get(d, param, element, deep);
					}
					return ret;
				}
			}
		} catch(e) {
			if(Template.DEBUG_MODE || (e instanceof JTException)) {
				throw e;
			}
		}
		return ret;
	};
	
	/**
	 * Handler for a tag 'FOR'. Create new and return relative opFOREACH object.
	 * @name opFORFactory
	 * @class Handler for a tag 'FOR'. Create new and return relative opFOREACH object.
	 * @param {string} oper content of operator {#..}
	 * @param {object} par parent node
	 * @param {Template} template a pointer to Template object
	 * @return {opFOREACH}
	 */
	opFORFactory = function (oper, par, template) {
		//create operator FOREACH with function as iterator
		if(oper.match(/\{#for (\w+?) *= *(\S+?) +to +(\S+?) *(?:step=(\S+?))*\}/)) {
			var f = new opFOREACH(null, par, template);
			f._name = RegExp.$1;
			f._option = {'begin': (RegExp.$2 || 0), 'end': (RegExp.$3 || -1), 'step': (RegExp.$4 || 1), 'extData': '$T'};
			f._runFunc = (function (i){return i;});
			return f;
		} else {
			throw new Error('jTemplates: Operator failed "find": ' + oper);
		}
	};
	
	/**
	 * Create a new loop node.
	 * @name opFOREACH
	 * @class A class represent: {#foreach}.
	 * @param {string} oper content of operator {#..}
	 * @param {object} par parent node
	 * @param {Template} template a pointer to Template object
	 * @augments BaseArray
	 */
	var opFOREACH = function (oper, par, template) {
		this._parent = par;
		this._template = template;
		if(oper != null) {
			oper.match(/\{#foreach +(.+?) +as +(\w+?)( .+)*\}/);
			this._arg = RegExp.$1;
			this._name = RegExp.$2;
			this._option = RegExp.$3 || null;
			this._option = TemplateUtils.optionToObject(this._option);
		}
		
		this._onTrue = [];
		this._onFalse = [];
		this._currentState = this._onTrue;
		//this._runFunc = null;
	};
	
	/**
	 * Add node 'e' to array.
	 * @param {BaseNode} e
	 */
	opFOREACH.prototype.push = function (e) {
		this._currentState.push(e);
	};
	
	/**
	 * Get a parent node.
	 * @return {BaseNode}
	 */
	opFOREACH.prototype.getParent = function () {
		return this._parent;
	};
	
	/**
	 * Switch from collection onTrue to onFalse.
	 */
	opFOREACH.prototype.switchToElse = function () {
		this._currentState = this._onFalse;
	};
	
	/**
	 * Process loop and get the html string.
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String}
	 */
	opFOREACH.prototype.get = function (d, param, element, deep) {
		try {
			//array of elements in foreach (or function)
			var fcount = (this._runFunc === undefined) ? (this._template.getBin().evaluate(d, param, element, this._arg)) : (this._runFunc);
			if(fcount === $) {
				throw new Error("jTemplate: Variable '$' cannot be used as loop-function");
			}
			var key = [];	//only for objects
			var mode = typeof fcount;
			if(mode == 'object') {
				//transform object to array
				var arr = [];
				jQuery.each(fcount, function (k, v) {
					key.push(k);
					arr.push(v);
				});
				fcount = arr;
			}
			//setup primary iterator, iterator can get data from options (using by operator FOR) or from data "$T"
			var extData = (this._option.extData !== undefined) ? (this._template.getBin().evaluate(d, param, element, this._option.extData)) : ((d != null) ? (d) : ({}));
			if(extData == null) {
				extData = {};
			}
			//start, end and step
			var s = Number(this._template.getBin().evaluate(d, param, element, this._option.begin) || 0), e;	//start, end
			var step = Number(this._template.getBin().evaluate(d, param, element, this._option.step) || 1);
			if(mode != 'function') {
				e = fcount.length;
			} else {
				if(this._option.end === undefined || this._option.end === null) {
					e = Number.MAX_VALUE;
				} else {
					e = Number(this._template.getBin().evaluate(d, param, element, this._option.end)) + ((step>0) ? (1) : (-1));
				}
			}
			var ret = '';	//result string
			var i,l;	//local iterators
			
			if(this._option.count) {
				//limit number of loops
				var tmp = s + Number(this._template.getBin().evaluate(d, param, element, this._option.count));
				e = (tmp > e) ? (e) : (tmp);
			}
			
			if((e>s && step>0) || (e<s && step<0)) {
				var iteration = 0;
				var _total = (mode != 'function') ? (Math.ceil((e-s)/step)) : undefined;
				var ckey, cval;	//current key, current value
				var loopCounter = 0;
				for(; ((step>0) ? (s<e) : (s>e)); s+=step, ++iteration, ++loopCounter) {
					if(Template.DEBUG_MODE && loopCounter > Template.FOREACH_LOOP_LIMIT) {
						throw new Error("jTemplate: Foreach loop limit was exceed");
					}
					ckey = key[s];
					if(mode != 'function') {
						cval = fcount[s];  //get value from array
					} else {
						cval = fcount(s);  //calc function
						//if no result from function then stop foreach
						if(cval === undefined || cval === null) {
							break;
						}
					}
					if((typeof cval == 'function') && (this._template.settings.disallow_functions || !this._template.settings.runnable_functions)) {
						continue;
					}
					if((mode == 'object') && (ckey in Object) && (cval === Object[ckey])) {
						continue;
					}
					//backup on value
					var prevValue = extData[this._name];
					//set iterator properties
					extData[this._name] = cval;
					extData[this._name + '$index'] = s;
					extData[this._name + '$iteration'] = iteration;
					extData[this._name + '$first'] = (iteration === 0);
					extData[this._name + '$last'] = (s+step >= e);
					extData[this._name + '$total'] = _total;
					extData[this._name + '$key'] = (ckey !== undefined && ckey.constructor == String) ? (this._template.f_escapeString(ckey)) : (ckey);
					extData[this._name + '$typeof'] = typeof cval;
					for(i=0, l=this._onTrue.length; i<l; ++i) {
						try {
							ret += this._onTrue[i].get(extData, param, element, deep);
						} catch(ex) {
							if(ex instanceof JTException) {
								switch(ex.type) {
									case 'continue':
										i = l; //force skip to next node
										break;
									case 'break':
										i = l;  //force skip to next node
										s = e;  //force skip outsite foreach
										break;
									default:
										throw ex;
								}
							} else {
								throw ex;
							}
						}
					}
					//restore values
					delete extData[this._name + '$index'];
					delete extData[this._name + '$iteration'];
					delete extData[this._name + '$first'];
					delete extData[this._name + '$last'];
					delete extData[this._name + '$total'];
					delete extData[this._name + '$key'];
					delete extData[this._name + '$typeof'];
					delete extData[this._name];
					extData[this._name] = prevValue;
				}
			} else {
				//no items to loop ("foreach->else")
				for(i=0, l=this._onFalse.length; i<l; ++i) {
					ret += this._onFalse[i].get(d, param, element, deep);
				}
			}
			return ret;
		} catch(e) {
			if(Template.DEBUG_MODE || (e instanceof JTException)) {
				throw e;
			}
			return "";
		}
	};
	
	/**
	 * Template-control exceptions
	 * @name JTException
	 * @class A class used internals for a template-control exceptions
	 * @param type {string} Type of exception
	 * @augments Error
	 * @augments BaseNode
	 */
	var JTException = function (type) {
		this.type = type;
	};
	JTException.prototype = Error;
	
	/**
	 * Throw a template-control exception
	 * @throws It throws itself
	 */
	JTException.prototype.get = function (d) {
		throw this;
	};
	
	/**
	 * Create a new entry for included template.
	 * @name Include
	 * @class A class represent: {#include}.
	 * @param {string} oper content of operator {#..}
	 * @param {array} includes
	 * @param {Template} templ template
	 * @augments BaseNode
	 */
	var Include = function (oper, includes, templ) {
		oper.match(/\{#include (.*?)(?: root=(.*?))?\}/);
		this._template = includes[RegExp.$1];
		if(this._template == undefined) {
			if(Template.DEBUG_MODE) {
				throw new Error('jTemplates: Cannot find include: ' + RegExp.$1);
			}
		}
		this._root = RegExp.$2;
		this._mainTempl = templ;
	};
	
	/**
	 * Run method get on included template.
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String}
	 */
	Include.prototype.get = function (d, param, element, deep) {
		try {
			//run a subtemplates with a new root node
			return this._template.get(this._mainTempl.getBin().evaluate(d, param, element, this._root), param, element, deep);
		} catch(e) {
			if(Template.DEBUG_MODE || (e instanceof JTException)) {
				throw e;
			}
		}
		return '';
	};
	
	/**
	 * Create new node for {#param}.
	 * @name UserParam
	 * @class A class represent: {#param}.
	 * @param {string} oper content of operator {#..}
	 * @param {Template} templ template
	 * @augments BaseNode
	 */
	var UserParam = function (oper, templ) {
		oper.match(/\{#param name=(\w*?) value=(.*?)\}/);
		this._name = RegExp.$1;
		this._value = RegExp.$2;
		this._templ = templ;
	};
	
	/**
	 * Return value of selected parameter.
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String} empty string
	 */
	UserParam.prototype.get = function (d, param, element, deep) {
		try {
			param[this._name] = this._templ.getBin().evaluate(d, param, element, this._value);
		} catch(e) {
			if(Template.DEBUG_MODE || (e instanceof JTException)) {
				throw e;
			}
			param[this._name] = undefined;
		}
		return '';
	};
	
	/**
	 * Create new node for {#var}.
	 * @name UserVariable
	 * @class A class represent: {#var}.
	 * @param {string} oper content of operator {#..}
	 * @param {Template} templ template
	 * @augments BaseNode
	 */
	var UserVariable = function (oper, templ) {
		oper.match(/\{#var (.*?)\}/);
		this._id = RegExp.$1;
		this._templ = templ;
	};
	
	/**
	 * Return value of selected variable.
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String} calling of function ReturnRefValue (as text string)
	 */
	UserVariable.prototype.get = function (d, param, element, deep) {
		try {
			if(element == undefined) {
				return "";
			}
			var obj = this._templ.getBin().evaluate(d, param, element, this._id);
			var refobj = jQuery.data(element, "jTemplatesRef");
			if(refobj == undefined) {
				refobj = {guid:(++Template.guid), d:[]};
			}
			var i = refobj.d.push(obj);
			jQuery.data(element, "jTemplatesRef", refobj);
			return "(TemplateUtils.ReturnRefValue(this," + refobj.guid + "," + (i-1) + "))";
		} catch(e) {
			if(Template.DEBUG_MODE || (e instanceof JTException)) {
				throw e;
			}
			return '';
		}
	};
	
	/**
	 * Create a new cycle node.
	 * @name Cycle
	 * @class A class represent: {#cycle}.
	 * @param {string} oper content of operator {#..}
	 * @augments BaseNode
	 */
	var Cycle = function (oper) {
		oper.match(/\{#cycle values=(.*?)\}/);
		this._values = eval(RegExp.$1);
		this._length = this._values.length;
		if(this._length <= 0) {
			throw new Error('jTemplates: no elements for cycle');
		}
		this._index = 0;
		this._lastSessionID = -1;
	};

	/**
	 * Do a step on cycle and return value.
	 * @param {object} d data
	 * @param {object} param parameters
	 * @param {Element} element a HTML element
	 * @param {Number} deep
	 * @return {String}
	 */
	Cycle.prototype.get = function (d, param, element, deep) {
		var sid = jQuery.data(element, 'jTemplateSID');
		if(sid != this._lastSessionID) {
			this._lastSessionID = sid;
			this._index = 0;
		}
		var i = this._index++ % this._length;
		return this._values[i];
	};
	
	
	/**
	 * Add a Template to HTML Elements.
	 * @param {Template/string} s a Template or a template string
	 * @param {array} [includes] Array of included templates.
	 * @param {object} [settings] Settings (see Template)
	 * @return {jQuery} chainable jQuery class
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.setTemplate = function (s, includes, settings) {
		return jQuery(this).each(function () {
			var t = (s && s.constructor == Template) ? s : new Template(s, includes, settings);
			jQuery.data(this, 'jTemplate', t);
			jQuery.data(this, 'jTemplateSID', 0);
		});
	};
	
	/**
	 * Add a Template (from URL) to HTML Elements.
	 * @param {string} url_ URL to template
	 * @param {array} [includes] Array of included templates.
	 * @param {object} [settings] Settings (see Template)
	 * @return {jQuery} chainable jQuery class
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.setTemplateURL = function (url_, includes, settings) {
		var s = jQuery.ajax({
			url: url_,
			dataType: 'text',
			async: false,
			type: 'GET'
		}).responseText;
		
		return jQuery(this).setTemplate(s, includes, settings);
	};
	
	/**
	 * Create a Template from element's content.
	 * @param {string} elementName an ID of element
	 * @param {array} [includes] Array of included templates.
	 * @param {object} [settings] Settings (see Template)
	 * @return {jQuery} chainable jQuery class
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.setTemplateElement = function (elementName, includes, settings) {
		var s = jQuery('#' + elementName).val();
		if(s == null) {
			s = jQuery('#' + elementName).html();
			s = s.replace(/&lt;/g, "<").replace(/&gt;/g, ">");
		}
		
		s = jQuery.trim(s);
		s = s.replace(/^<\!\[CDATA\[([\s\S]*)\]\]>$/im, '$1');
		s = s.replace(/^<\!--([\s\S]*)-->$/im, '$1');
		
		return jQuery(this).setTemplate(s, includes, settings);
	};
	
	/**
	 * Check it HTML Elements have a template. Return count of templates.
	 * @return {number} Number of templates.
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.hasTemplate = function () {
		var count = 0;
		jQuery(this).each(function () {
			if(jQuery.getTemplate(this)) {
				++count;
			}
		});
		return count;
	};
	
	/**
	 * Remote Template from HTML Element(s)
	 * @return {jQuery} chainable jQuery class
	 */
	jQuery.fn.removeTemplate = function () {
		jQuery(this).processTemplateStop();
		return jQuery(this).each(function () {
			jQuery.removeData(this, 'jTemplate');
		});
	};
	
	/**
	 * Set to parameter 'name' value 'value'.
	 * @param {string} name
	 * @param {object} value
	 * @return {jQuery} chainable jQuery class
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.setParam = function (name, value) {
		return jQuery(this).each(function () {
			var t = jQuery.getTemplate(this);
			if(t != null) {
				t.setParam(name, value);
			} else if(Template.DEBUG_MODE) {
				throw new Error('jTemplates: Template is not defined.');
			}
		});
	};
	
	/**
	 * Process template using data 'd' and parameters 'param'. Update HTML code.
	 * @param {object} d data 
	 * @param {object} [param] parameters
	 * @option {object} [options] internal use only
	 * @return {jQuery} chainable jQuery class
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.processTemplate = function (d, param, options) {
		return jQuery(this).each(function () {
			var t = jQuery.getTemplate(this);
			if(t != null) {
				if(options != undefined && options.StrToJSON) {
					d = t.f_parseJSON(d);
				}
				jQuery.data(this, 'jTemplateSID', jQuery.data(this, 'jTemplateSID') + 1);
				jQuery(this).html(t.get(d, param, this, 0));
			} else if(Template.DEBUG_MODE) {
				throw new Error('jTemplates: Template is not defined.');
			}
		});
	};
	
	/**
	 * Process template using data from URL 'url_' (only format JSON) and parameters 'param'. Update HTML code.
	 * @param {string} url_ URL to data (in JSON)
	 * @param {object} [param] parameters
	 * @param {object} options options (over ajaxSettings) and callbacks
	 * @return {jQuery} chainable jQuery class
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.processTemplateURL = function (url_, param, options) {
		var that = this;
		
		var o = jQuery.extend({cache: false}, jQuery.ajaxSettings);
		o = jQuery.extend(o, options);

		jQuery.ajax({
			url: url_,
			type: o.type,
			data: o.data,
			dataFilter: o.dataFilter,
			async: o.async,
			headers: o.headers,
			cache: o.cache,
			timeout: o.timeout,
			dataType: 'text',
			success: function (d) {
				var r = jQuery(that).processTemplate(d, param, {StrToJSON:true});
				if(o.on_success) {
					o.on_success(r);
				}
			},
			error: o.on_error,
			complete: o.on_complete
		});
		return this;
	};

	/**
	 * Create new Updater.
	 * @name Updater
	 * @class This class is used for 'Live Refresh!'.
	 * @param {string} url A destination URL
	 * @param {object} param Parameters (for template)
	 * @param {number} interval Time refresh interval
	 * @param {object} args Additional URL parameters (in URL alter ?) as assoc array.
	 * @param {array} objs An array of HTMLElement which will be modified by Updater.
	 * @param {object} options options and callbacks
	 */
	var Updater = function (url, param, interval, args, objs, options) {
		this._url = url;
		this._param = param;
		this._interval = interval;
		this._args = args;
		this.objs = objs;
		this.timer = null;
		this._options = options || {};
		
		var that = this;
		jQuery(objs).each(function () {
			jQuery.data(this, 'jTemplateUpdater', that);
		});
		this.run();
	};
	
	/**
	 * Create new HTTP request to server, get data (as JSON) and send it to templates. Also check does HTMLElements still exists in Document.
	 */
	Updater.prototype.run = function () {
		//remove deleted node
		this.objs = jQuery.grep(this.objs, function (elem) {
			return (jQuery.contains(document.body, elem.jquery ? elem[0] : elem));
		});
		//if no node then do nothing
		if(this.objs.length === 0) {
			return;
		}
		//ajax call
		var that = this;
		jQuery.ajax({
			url: this._url,
			dataType: 'text',
			data: this._args,
			cache: false,
			headers: that._options.headers,
			success: function (d) {
				try {
					var r = jQuery(that.objs).processTemplate(d, that._param, {StrToJSON:true});
					if(that._options.on_success) {
						that._options.on_success(r); //callback
					}
				} catch(ex) {}
			}
		});
		//schedule next run
		this.timer = setTimeout(function (){that.run();}, this._interval);
	};
	
	/**
	 * Start 'Live Refresh!'.
	 * @param {string} url A destination URL
	 * @param {object} param Parameters (for template)
	 * @param {number} interval Time refresh interval
	 * @param {object} args Additional URL parameters (in URL alter ?) as assoc array.
	 * @param {object} options options and callbacks
	 * @return {Updater} an Updater object
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.processTemplateStart = function (url, param, interval, args, options) {
		return new Updater(url, param, interval, args, this, options);
	};
	
	/**
	 * Stop 'Live Refresh!'.
	 * @return {jQuery} chainable jQuery class
	 * @memberOf jQuery.fn
	 */
	jQuery.fn.processTemplateStop = function () {
		return jQuery(this).each(function () {
			var updater = jQuery.data(this, 'jTemplateUpdater');
			if(updater == null) {
				return;
			}
			var that = this;
			updater.objs = jQuery.grep(updater.objs, function (o) {
				return o != that;
			});
			jQuery.removeData(this, 'jTemplateUpdater');
		});
	};
	
	jQuery.extend(/** @scope jQuery.prototype */{
		/**
		 * Create new Template.
		 * @param {string} s A template string (like: "Text: {$T.txt}.").
		 * @param {array} includes Array of included templates.
		 * @param {object} settings Settings. (see Template)
		 * @return {Template}
		 */
		createTemplate: function (s, includes, settings) {
			return new Template(s, includes, settings);
		},
		
		/**
		 * Create new Template from URL.
		 * @param {string} url_ URL to template
		 * @param {array} includes Array of included templates.
		 * @param {object} settings Settings. (see Template)
		 * @return {Template}
		 */
		createTemplateURL: function (url_, includes, settings) {
			var s = jQuery.ajax({
				url: url_,
				dataType: 'text',
				async: false,
				type: 'GET'
			}).responseText;
			
			return new Template(s, includes, settings);
		},
		
		/**
		 * Get a Template for HTML node
		 * @param {Element} HTML node
		 * @return {Template} a Template or "undefined"
		 */
		getTemplate: function (element) {
			return jQuery.data(element, 'jTemplate');
		},
		
		/**
		 * Process template and return text content.
		 * @param {Template} template A Template
		 * @param {object} data data
		 * @param {object} param parameters
		 * @return {string} Content of template
		 */
		processTemplateToText: function (template, data, parameter) {
			return template.get(data, parameter, undefined, 0);
		},
		
		/**
		 * Set Debug Mode
		 * @param {Boolean} value
		 */
		jTemplatesDebugMode: function (value) {
			Template.DEBUG_MODE = value;
		}
	});
	
})(jQuery);};
