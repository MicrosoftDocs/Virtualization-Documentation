/**
 * @author Ove Andersen
 * @version 1.0 April 2011
 */

(function() {
	// Load plugin specific language pack
	tinymce.PluginManager.requireLangPack('syntaxhighlighter');

	tinymce.create('tinymce.plugins.syntaxhighlighter', {
		/**
		 * Initializes the plugin, this will be executed after the plugin has been created.
		 * This call is done before the editor instance has finished it's initialization so use the onInit event
		 * of the editor instance to intercept that event.
		 *
		 * @param {tinymce.Editor} ed Editor instance that the plugin is initialized in.
		 * @param {string} url Absolute URL to where the plugin is located.
		 */
		init : function(ed, url) {
			// Register the command so that it can be invoked by using tinyMCE.activeEditor.execCommand('mceSyntaxHighlighter');
			ed.addCommand('mceSyntaxHighlighter', function() {
				ed.windowManager.open({
					file : url + '/syntaxhighlighter.htm',
					width : 570 + ed.getLang('syntaxhighlighter.delta_width', 0),
					height : 500 + ed.getLang('syntaxhighlighter.delta_height', 0),
					inline : 1
				}, 
				{
					plugin_url : url // Plugin absolute URL
				});
			});

			// Register button
			ed.addButton('syntaxhighlighter', {
				title : 'syntaxhighlighter.syntaxhighlighter_button_desc',
				cmd : 'mceSyntaxHighlighter',
				image : url + '/images/syntaxhighlighter.gif'
			});

			// Add a node change handler, selects the button in the UI when a image is selected
			ed.onNodeChange.add(function(ed, cm, n) {
				cm.setActive('syntaxhighlighter', n.nodeName == 'syntaxhighlighter');
			});
		},
		
		/**
		 * Creates control instances based in the incomming name. This method is normally not
		 * needed since the addButton method of the tinymce.Editor class is a more easy way of adding buttons
		 * but you sometimes need to create more complex controls like listboxes, split buttons etc then this
		 * method can be used to create those.
		 *
		 * @param {String} n Name of the control to create.
		 * @param {tinymce.ControlManager} cm Control manager to use inorder to create new control.
		 * @return {tinymce.ui.Control} New control instance or null if no control was created.
		 */
		createControl : function(n, cm) {
			return null;
		},
		
		/**
		 * @return {Object} Name/value array containing information about the plugin.
		 */
		getInfo : function() {
			return {
				longname : 'Syntax Highlighter Plugin',
				author : 'Ove Andersen',
				authorurl : 'http://www.eyecatch.no/',
				infourl : 'http://www.eyecatch.no/projects/syntaxhighlighter',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('syntaxhighlighter', tinymce.plugins.syntaxhighlighter);
})();