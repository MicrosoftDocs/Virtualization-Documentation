var editorGetHtml = function () {
    return tinymce.activeEditor.getContent();
}

var htmlContent;

var editorSetHtml = function (html) {
    if (tinymce.activeEditor) {
        tinymce.activeEditor.setContent(html);
    }
    else {
        // If not initialized yet, we need to delay it
        htmlContent = html;
    }
}

tinymce.init({
    selector: '#txtContent',
    plugins: [
        "advlist autolink lists link image charmap print preview anchor",
        "searchreplace visualblocks code fullscreen textcolor imagetools",
        "insertdatetime media table contextmenu paste sh4tinymce filemanager"
    ],
    toolbar: "styleselect | bold underline italic | alignleft aligncenter alignright | bullist numlist | forecolor backcolor | link media sh4tinymce | fullscreen code | filemanager",
    autosave_ask_before_unload: false,
    max_height: 1000,
    min_height: 300,
    height: 500,
    menubar: false,
    relative_urls: false,
    browser_spellcheck: true,
    paste_data_images: true,
    setup: function (editor) {
        editor.on('init', function (e) {
            if (htmlContent) {
                editor.setContent(htmlContent);
            }
        });
    }
});
