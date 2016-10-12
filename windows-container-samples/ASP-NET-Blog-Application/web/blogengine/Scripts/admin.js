var newPost = {
    "Id": "",
    "Title": "Unpublished",
    "Author": "Admin",
    "Content": "<p>Type here...</p>",
    "DateCreated": moment().format("MM/DD/YYYY HH:MM"),
    "Slug": "unpublished",
    "Categories": "",
    "Tags": "",
    "Comments": "",
    "IsPublished": true,
    "CanUserDelete": true,
    "CanUserEdit": true
}

function postVM(data) {
    var self = this;
    self.id = editVars.id;
    self.title = ko.observable(data.Title);
    self.author = ko.observable(data.Author);
    self.content = ko.observable(data.Content);
    self.dateCreated = ko.observable(data.DateCreated);
    self.slug = ko.observable(data.slug);
    self.isDeleted = ko.observable(data.IsDeleted);
    self.categories = ko.observable(data.Categories);
    self.tags = ko.observable(data.Tags);
    self.comments = ko.observable(data.Comments);
    self.isPublished = ko.observable(data.IsPublished);
    self.canUserDelete = ko.observable(data.CanUserDelete);
    self.canUserEdit = ko.observable(data.CanUserEdit);

    self.save = function () {
        self.content($('#editor').html());
        $.ajax({
            url: SiteVars.ApplicationRelativeWebRoot + "api/posts/" + editVars.id,
            data: ko.toJSON(self),
            type: "PUT",
            contentType: "application/json",
            beforeSend: onAjaxBeforeSend,
            success: function (data) {
                success('Data saved');
            }
        });
    };

    self.unpublish = function () {
        self.content($('#editor').html());
        self.isPublished('False');
        $.ajax({
            url: SiteVars.ApplicationRelativeWebRoot + "api/posts/" + editVars.id,
            data: ko.toJSON(self),
            type: "PUT",
            contentType: "application/json",
            beforeSend: onAjaxBeforeSend,
            success: function (data) {
                success('Post unpublished');
            }
        });
    };

    self.remove = function () {
        self.content($('#editor').html());
        $.ajax({
            url: SiteVars.ApplicationRelativeWebRoot + "api/posts?id=" + editVars.id,
            type: "DELETE",
            contentType: "application/json",
            beforeSend: onAjaxBeforeSend,
            success: function (data) {
                success('Post removed');
                location.reload();
            }
        });
    };
};

if (editVars.id) {
    $.ajax({
        url: SiteVars.ApplicationRelativeWebRoot + "api/posts/" + editVars.id,
        type: "GET",
        contentType: "application/json",
        beforeSend: onAjaxBeforeSend,
        success: function (data) {
            ko.applyBindings(new postVM(data));
        }
    });
}
else {
    ko.applyBindings(new postVM(newPost));
}

function success(msg) {
    toastr.options.positionClass = 'toast-bottom-right';
    toastr.success(msg, 'Success.');
}

function onAjaxBeforeSend(jqXHR, settings) {
    // AJAX calls need to be made directly to the real physical location of the
    // web service/page method.  For this, SiteVars.ApplicationRelativeWebRoot is used.
    // If an AJAX call is made to a virtual URL (for a blog instance), although
    // the URL rewriter will rewrite these URLs, we end up with a "405 Method Not Allowed"
    // error by the web service.  Here we set a request header so the call to the server
    // is done under the correct blog instance ID.

    jqXHR.setRequestHeader('x-blog-instance', SiteVars.BlogInstanceId);
}