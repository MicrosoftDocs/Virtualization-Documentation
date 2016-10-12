$(function () {
    function initToolbarBootstrapBindings() {
        var fonts = ['Serif', 'Sans', 'Arial', 'Arial Black', 'Courier',
              'Courier New', 'Comic Sans MS', 'Helvetica', 'Impact', 'Lucida Grande', 'Lucida Sans', 'Tahoma', 'Times',
              'Times New Roman', 'Verdana'],
              fontTarget = $('[title=' + BlogAdmin.i18n.font + ']').siblings('.dropdown-menu');
        $.each(fonts, function (idx, fontName) {
            fontTarget.append($('<li><a data-edit="fontName ' + fontName + '" style="font-family:\'' + fontName + '\'">' + fontName + '</a></li>'));
        });
        $('a[title]').tooltip({ container: 'body' });
        $('.dropdown-menu input').click(function () { return false; })
            .change(function () { $(this).parent('.dropdown-menu').siblings('.dropdown-toggle').dropdown('toggle'); })
            .keydown('esc', function () {
            this.value = ''; $(this).change();
        });
        if ("onwebkitspeechchange" in document.createElement("input")) {
            var editorOffset = $('#editor').offset();
            $('#voiceBtn').css('position', 'absolute').offset({ top: editorOffset.top, left: editorOffset.left + $('#editor').innerWidth() - 35 });
        } else {
            $('#voiceBtn').hide();
        }
    };
    function showErrorAlert(reason, detail) {
        var msg = '';
        if (reason === 'unsupported-file-type') { msg = "Unsupported format " + detail; }
        else {
            console.log("error uploading file", reason, detail);
        }
        $('<div class="alert"> <button type="button" class="close" data-dismiss="alert">&times;</button>' +
         '<strong>File upload error</strong> ' + msg + ' </div>').prependTo('#alerts');
    };
    $("#beVersion").html(SiteVars.Version);
    initToolbarBootstrapBindings();
    $('#editor').wysiwyg({ fileUploadError: showErrorAlert });
});

var editorGetHtml = function () {
    return $("#editor").html();
}

var editorSetHtml = function (html) {
    $("#editor").html(html);
}

var sourceShow = function () {
    $("#modal-source").modal();
    var html = $('#editor').html();
    $("#editor-source").val($("#editor").html());
}

var sourceHide = function () {
    editorSetHtml($("#editor-source").val());
    $("#modal-source").modal('hide');
}

var fullScreen = false;

function toggleFullScreen() {
    if (fullScreen === false) {
        $('#overlay-editor').addClass('overlay-editor');
        $('#editor').addClass('full-editor');
        $('#btn-source').attr("disabled", "disabled");
        fullScreen = true;
    } else {
        $('#overlay-editor').removeClass('overlay-editor');
        $('#editor').removeClass('full-editor');
        $('#btn-source').removeAttr("disabled");
        fullScreen = false;
    }
}
