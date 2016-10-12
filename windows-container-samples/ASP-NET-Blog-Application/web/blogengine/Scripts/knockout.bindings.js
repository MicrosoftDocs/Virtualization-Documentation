ko.bindingHandlers.fileUpload = {
    init: function (element, valueAccessor) {
        $(element).after('<div class="progress"><div class="bar"></div><div class="percent">0%</div></div><div class="progressError"></div>');
    },
    update: function (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
        var options = ko.utils.unwrapObservable(valueAccessor()),
            property = ko.utils.unwrapObservable(options.property),
            url = ko.utils.unwrapObservable(options.url);

        if (property && url) {
            $(element).closest("form").submit(function () {
                if (element.files.length) {
                    var $this = $(this),
                        fileName = $this.val();

                    // jquery.form.js plugin
                    $(element.form).ajaxSubmit({
                        url: url,
                        type: "POST",
                        dataType: "text",
                        headers: { "Content-Disposition": "attachment; filename=" + fileName },
                        beforeSubmit: function () {
                            $(".progress").show();
                            $(".progressError").hide();
                            $(".bar").width("0%")
                            $(".percent").html("0%");
                        },
                        uploadProgress: function (event, position, total, percentComplete) {
                            var percentVal = percentComplete + "%";
                            $(".bar").width(percentVal)
                            $(".percent").html(percentVal);
                        },
                        success: function (data) {
                            $(".progress").hide();
                            $(".progressError").hide();
                            toastr.info('Upload completed');
                            bindingContext.$data[property](data);
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            $(".progress").hide();
                            $("div.progressError").html(jqXHR.responseText);
                            toastr.error('Upload failed');
                        }
                    });
                }
            });
        }
    }
}
