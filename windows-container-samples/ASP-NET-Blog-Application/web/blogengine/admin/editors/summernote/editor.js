var editorGetHtml = function () {
    return $('.summernote').code();
}

var editorSetHtml = function (html) {
    $('.summernote').code(html);
}

$(function () {
    $('.summernote').summernote({
        height: 240,
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic', 'underline', 'clear']],
            ['fontname', ['fontname']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            //['height', ['height']],
            ['table', ['table']],
            ['insert', ['link']], // ['insert', ['link', 'picture', 'hr']],
            ['view', ['fullscreen', 'codeview']],
            ['help', ['help']]
        ]
        // language must be added here and in BundleConfig.cs
        // ,lang: 'ru-RU'
    });
});
