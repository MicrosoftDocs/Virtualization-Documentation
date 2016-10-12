// global object
BlogEngine = {
    $: function (id) {
        return document.getElementById(id);
    }
	,
    setFlag: function (iso) {
        if (iso.length > 0)
            BlogEngine.comments.flagImage.src = BlogEngineRes.webRoot + "Content/images/blog/flags/" + iso + ".png";
        else
            BlogEngine.comments.flagImage.src = BlogEngineRes.webRoot + "Content/images/blog/pixel.gif";
    }
	,

    // Shows the preview of the comment
    showCommentPreview: function () {
        var oPreview = this.$('preview');
        var oCompose = this.$('compose');

        if (oPreview) oPreview.className = 'selected';
        if (oCompose) oCompose.className = '';
        this.$('commentCompose').style.display = 'none';
        this.$('commentPreview').style.display = 'block';
        this.$('commentPreview').innerHTML = '<img src="' + BlogEngineRes.webRoot + 'Content/images/blog/ajax-loader.gif" width="24" height="24" alt="Loading" />';
        var argument = this.$('commentPreview').innerHTML;
        this.addComment(true);
        return false;
    }
	,
    composeComment: function () {
        var oPreview = this.$('preview');
        var oCompose = this.$('compose');

        if (oPreview) oPreview.className = '';
        if (oCompose) oCompose.className = 'selected';
        if (this.$('commentPreview')) {
            this.$('commentPreview').style.display = 'none';
        }
        if (this.$('commentCompose')) {
            this.$('commentCompose').style.display = 'block';
        }
        return false;
    }
	,
    endShowPreview: function (arg, context) {
        if (BlogEngine.$('commentPreview')) {
            BlogEngine.$('commentPreview').innerHTML = arg;
        }
    }
	,
    toggleCommentSavingIndicators: function (bSaving) {
        BlogEngine.$("btnSaveAjax").disabled = bSaving;
        BlogEngine.$("ajaxLoader").style.display = bSaving ? "inline" : "none";
        BlogEngine.$("status").className = "";
        BlogEngine.$("status").innerHTML = "";
        if (!bSaving) {
            if (BlogEngine.$('commentPreview')) {
                BlogEngine.$('commentPreview').innerHTML = "";
            }
            BlogEngine.composeComment();
        }
    }
    ,
    onCommentError: function (error, context) {
        BlogEngine.toggleCommentSavingIndicators(false);
        error = error || "Unknown error occurred.";
        var iDelimiterPos = error.indexOf("|");
        if (iDelimiterPos > 0) {
            error = error.substr(0, iDelimiterPos);
            // Remove numbers from end of error message.
            while (error.length > 0 && error.substr(error.length - 1, 1).match(/\d/)) {
                error = error.substr(0, error.length - 1);
            }
        }

        if (document.getElementById('recaptcha_response_field')) {
            Recaptcha.reload();
        }
        if (document.getElementById("spnSimpleCaptchaIncorrect")) document.getElementById("spnSimpleCaptchaIncorrect").style.display = "none";

        alert("Sorry, the following error occurred while processing your comment:\n\n" + error);
    }
	,
    addComment: function (preview) {
        var isPreview = preview == true;
        if (!isPreview) {
            BlogEngine.toggleCommentSavingIndicators(true);
            this.$("status").innerHTML = BlogEngineRes.i18n.savingTheComment;
        }
        var author = BlogEngine.comments.nameBox.value;
        var email = BlogEngine.comments.emailBox.value;
        var content = BlogEngine.comments.contentBox.value;
        var captcha = BlogEngine.comments.captchaField.value;

        var website = BlogEngine.comments.websiteBox ? BlogEngine.comments.websiteBox.value : "";
        var country = BlogEngine.comments.countryDropDown ? BlogEngine.comments.countryDropDown.value : "";
        var notify = BlogEngine.$("cbNotify") ? BlogEngine.$("cbNotify").checked : false;
        var replyToId = BlogEngine.comments.replyToId ? BlogEngine.comments.replyToId.value : "";

        var recaptchaResponseField = document.getElementById('recaptcha_response_field');
        var recaptchaResponse = recaptchaResponseField ? recaptchaResponseField.value : "";

        var recaptchaChallengeField = document.getElementById('recaptcha_challenge_field');
        var recaptchaChallenge = recaptchaChallengeField ? recaptchaChallengeField.value : "";

        var simpleCaptchaChallengeField = document.getElementById('simpleCaptchaValue');
        var simpleCaptchaChallenge = simpleCaptchaChallengeField ? simpleCaptchaChallengeField.value : "";

        var avatarInput = BlogEngine.$("avatarImgSrc");
        var avatar = (avatarInput && avatarInput.value) ? avatarInput.value : "";

        var callback = isPreview ? BlogEngine.endShowPreview : BlogEngine.appendComment;
        var argument = author + "-|-" + email + "-|-" + website + "-|-" + country + "-|-" + content + "-|-" + notify + "-|-" + isPreview + "-|-" + captcha + "-|-" + replyToId + "-|-" + avatar + "-|-" + recaptchaResponse + "-|-" + recaptchaChallenge + "-|-" + simpleCaptchaChallenge;

        WebForm_DoCallback(BlogEngine.comments.controlId, argument, callback, 'comment', BlogEngine.onCommentError, false);

        if (!isPreview && typeof (OnComment) != "undefined")
            OnComment(author, email, website, country, content);
    }
    ,
    cancelReply: function () {
        this.replyToComment('');
    }
	,
    replyToComment: function (id) {

        // set hidden value
        BlogEngine.comments.replyToId.value = id;

        // move comment form into position
        var commentForm = BlogEngine.$('comment-form');
        if (!id || id == '' || id == null || id == '00000000-0000-0000-0000-000000000000') {
            // move to after comment list
            var base = BlogEngine.$("commentlist");
            base.appendChild(commentForm);
            // hide cancel button
            BlogEngine.$('cancelReply').style.display = 'none';
        } else {
            // show cancel
            BlogEngine.$('cancelReply').style.display = '';

            // move to nested position
            var parentComment = BlogEngine.$('id_' + id);
            var replies = BlogEngine.$('replies_' + id);

            // add if necessary
            if (replies == null) {
                replies = document.createElement('div');
                replies.className = 'comment-replies';
                replies.id = 'replies_' + id;
                parentComment.appendChild(replies);
            }
            replies.style.display = '';
            replies.appendChild(commentForm);
        }

        BlogEngine.comments.nameBox.focus();
    }
	,
    appendComment: function (args, context) {
        if (context == "comment") {

            if (document.getElementById('recaptcha_response_field')) {
                Recaptcha.reload();
            }
            if (document.getElementById("spnSimpleCaptchaIncorrect")) document.getElementById("spnSimpleCaptchaIncorrect").style.display = "none";

            if (args == "RecaptchaIncorrect" || args == "SimpleCaptchaIncorrect") {
                if (document.getElementById("spnCaptchaIncorrect")) document.getElementById("spnCaptchaIncorrect").style.display = "";
                if (document.getElementById("spnSimpleCaptchaIncorrect")) document.getElementById("spnSimpleCaptchaIncorrect").style.display = "";
                BlogEngine.toggleCommentSavingIndicators(false);
            }
            else {


                if (document.getElementById("spnCaptchaIncorrect")) document.getElementById("spnCaptchaIncorrect").style.display = "none";
                if (document.getElementById("spnSimpleCaptchaIncorrect")) document.getElementById("spnSimpleCaptchaIncorrect").style.display = "none";

                var commentList = BlogEngine.$("commentlist");
                if (commentList.innerHTML.length < 10)
                    commentList.innerHTML = "<h1 id='comment'>" + BlogEngineRes.i18n.comments + "</h1>"

                // add comment html to the right place
                var id = BlogEngine.comments.replyToId ? BlogEngine.comments.replyToId.value : '';

                if (id != '') {
                    var replies = BlogEngine.$('replies_' + id);
                    replies.innerHTML += args;
                } else {
                    commentList.innerHTML += args;
                    commentList.style.display = 'block';
                }

                // reset form values
                BlogEngine.comments.contentBox.value = "";
                BlogEngine.comments.contentBox = BlogEngine.$(BlogEngine.comments.contentBox.id);
                BlogEngine.toggleCommentSavingIndicators(false);
                BlogEngine.$("status").className = "success";

                if (!BlogEngine.comments.moderation)
                    BlogEngine.$("status").innerHTML = BlogEngineRes.i18n.commentWasSaved;
                else
                    BlogEngine.$("status").innerHTML = BlogEngineRes.i18n.commentWaitingModeration;

                // move form back to bottom
                var commentForm = BlogEngine.$('comment-form');
                commentList.appendChild(commentForm);
                // reset reply to
                if (BlogEngine.comments.replyToId) BlogEngine.comments.replyToId.value = '';
                if (BlogEngine.$('cancelReply')) BlogEngine.$('cancelReply').style.display = 'none';

            }
        }

        BlogEngine.$("btnSaveAjax").disabled = false;
    }
	,
    validateAndSubmitCommentForm: function () {

        if (BlogEngine.comments.nameBox.value.length < 1) {
            BlogEngine.$("status").innerHTML = "Required";
            BlogEngine.$("status").className = "warning";
            BlogEngine.$("txtName").focus();
            return false;
        }
        if (BlogEngine.comments.emailBox.value.length < 1) {
            BlogEngine.$("status").innerHTML = "Required";
            BlogEngine.$("txtEmail").focus();
            return false;
        }
        if (BlogEngine.comments.contentBox.value.length < 1) {
            BlogEngine.$("status").innerHTML = "Required";
            BlogEngine.$("txtContent").focus();
            return false;
        }

        //var bBuiltInValidationPasses = Page_ClientValidate('AddComment');
        //var bNameIsValid = BlogEngine.comments.nameBox.value.length > 0;

        //document.getElementById('spnNameRequired').style.display = bNameIsValid ? 'none' : '';
        //var bAuthorNameIsValid = true;
        //if (BlogEngine.comments.checkName) {
        //    var author = BlogEngine.comments.postAuthor;
        //    var visitor = BlogEngine.comments.nameBox.value;
        //    bAuthorNameIsValid = !this.equal(author, visitor);
        //}

        //document.getElementById('spnChooseOtherName').style.display = bAuthorNameIsValid ? 'none' : '';
        //if (bBuiltInValidationPasses && bNameIsValid && bAuthorNameIsValid) {
        //    BlogEngine.addComment();
        //    return true;
        //}

        BlogEngine.addComment();
        return true;
    }

	 ,

    addBbCode: function (v) {
        try {
            var contentBox = BlogEngine.comments.contentBox;
            if (contentBox.selectionStart) // firefox
            {
                var pretxt = contentBox.value.substring(0, contentBox.selectionStart);
                var therest = contentBox.value.substr(contentBox.selectionEnd);
                var sel = contentBox.value.substring(contentBox.selectionStart, contentBox.selectionEnd);
                contentBox.value = pretxt + "[" + v + "]" + sel + "[/" + v + "]" + therest;
                contentBox.focus();
            }
            else if (document.selection && document.selection.createRange) // IE
            {
                var str = document.selection.createRange().text;
                contentBox.focus();
                var sel = document.selection.createRange();
                sel.text = "[" + v + "]" + str + "[/" + v + "]";
            }
        }
        catch (ex) { }

        return;
    }
	,
    // Searches the blog based on the entered text and
    // searches comments as well if chosen.
    search: function (root, searchfield) {
        if (!searchfield) {
            searchfield = 'searchfield';
        }
        var input = this.$(searchfield);
        var check = this.$("searchcomments");

        var searchPageExtension = typeof BlogEngineRes.fileExtension === "undefined" ? ".aspx" : BlogEngineRes.fileExtension;
        var search = "search" + searchPageExtension + "?q=" + encodeURIComponent(input.value);
        if (check != null && check.checked)
            search += "&comment=true";

        top.location.href = root + search;

        return false;
    }
	,
    // Clears the search fields on focus.
    searchClear: function (defaultText, searchfield) {
        if (!searchfield) {
            searchfield = 'searchfield';
        }
        var input = this.$(searchfield);
        if (input.value == defaultText)
            input.value = "";
        else if (input.value == "")
            input.value = defaultText;
    }
	,
    rate: function (blogId, id, rating) {
        this.createCallback("rating.axd?id=" + id + "&rating=" + rating, BlogEngine.ratingCallback, blogId);
    }
	,
    ratingCallback: function (response) {
        var rating = response.substring(0, 1);
        var status = response.substring(1);

        if (status == "OK") {
            if (typeof OnRating != "undefined")
                OnRating(rating);

            alert(BlogEngineRes.i18n.ratingHasBeenRegistered);
        }
        else if (status == "HASRATED") {
            alert(BlogEngineRes.i18n.hasRated);
        }
        else {
            alert("An error occured while registering your rating. Please try again");
        }
    }
	,
    /// <summary>
    /// Creates a client callback back to the requesting page
    /// and calls the callback method with the response as parameter.
    /// </summary>
    createCallback: function (url, callback, blogId) {
        var http = BlogEngine.getHttpObject();
        http.open("GET", url, true);

        if (blogId && http.setRequestHeader) {
            http.setRequestHeader('x-blog-instance', blogId.toString());
        }

        http.onreadystatechange = function () {
            if (http.readyState == 4) {
                if (http.responseText.length > 0 && callback != null)
                    callback(http.responseText);
            }
        };

        http.send(null);
    }
	,
    /// <summary>
    /// Creates a XmlHttpRequest object.
    /// </summary>
    getHttpObject: function () {
        if (typeof XMLHttpRequest != 'undefined')
            return new XMLHttpRequest();

        try {
            return new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) {
            try {
                return new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e) { }
        }

        return false;
    }
	,
    // Updates the calendar from client-callback
    updateCalendar: function (args, context) {
        var cal = BlogEngine.$('calendarContainer');
        cal.innerHTML = args;
        BlogEngine.Calendar.months[context] = args;
    }
	,
    toggleMonth: function (year) {
        var monthList = BlogEngine.$("monthList");
        var years = monthList.getElementsByTagName("ul");
        for (i = 0; i < years.length; i++) {
            if (years[i].id == year) {
                var state = years[i].className == "open" ? "" : "open";
                years[i].className = state;
                break;
            }
        }
    }
	,
    // Adds a trim method to all strings.
    equal: function (first, second) {
        var f = first.toLowerCase().replace(new RegExp(' ', 'gi'), '');
        var s = second.toLowerCase().replace(new RegExp(' ', 'gi'), '');
        return f == s;
    }
	,
    /*-----------------------------------------------------------------------------
    XFN HIGHLIGHTER
    -----------------------------------------------------------------------------*/
    xfnRelationships: ['friend', 'acquaintance', 'contact', 'met'
										, 'co-worker', 'colleague', 'co-resident'
										, 'neighbor', 'child', 'parent', 'sibling'
										, 'spouse', 'kin', 'muse', 'crush', 'date'
										, 'sweetheart', 'me']
	,
    // Applies the XFN tags of a link to the title tag
    hightLightXfn: function () {
        var content = BlogEngine.$('content');
        if (content == null)
            return;

        var links = content.getElementsByTagName('a');
        for (i = 0; i < links.length; i++) {
            var link = links[i];
            var rel = link.getAttribute('rel');
            if (rel && rel != "nofollow") {
                for (j = 0; j < BlogEngine.xfnRelationships.length; j++) {
                    if (rel.indexOf(BlogEngine.xfnRelationships[j]) > -1) {
                        link.title = 'XFN relationship: ' + rel;
                        break;
                    }
                }
            }
        }
    }
	,

    showRating: function (container, id, raters, rating, blogId) {
        var div = document.createElement('div');
        div.className = 'rating';

        var p = document.createElement('p');
        div.appendChild(p);
        if (raters == 0) {
            p.innerHTML = BlogEngineRes.i18n.beTheFirstToRate;
        }
        else {
            p.innerHTML = BlogEngineRes.i18n.currentlyRated.replace('{0}', new Number(rating).toFixed(1)).replace('{1}', raters);
        }

        var ul = document.createElement('ul');
        ul.className = 'star-rating small-star';
        div.appendChild(ul);

        var li = document.createElement('li');
        li.className = 'current-rating';
        li.style.width = Math.round(rating * 20) + '%';
        li.innerHTML = 'Currently ' + rating + '/5 Stars.';
        ul.appendChild(li);

        for (var i = 1; i <= 5; i++) {
            var l = document.createElement('li');
            var a = document.createElement('a');
            a.innerHTML = i;
            a.href = 'rate/' + i;
            a.className = this.englishNumber(i);
            a.title = BlogEngineRes.i18n.rateThisXStars.replace('{0}', i.toString()).replace('{1}', i == 1 ? '' : 's');
            a.rel = "nofollow";
            a.onclick = function () {
                BlogEngine.rate(blogId, id, this.innerHTML);
                return false;
            };

            l.appendChild(a);
            ul.appendChild(l);
        }

        container.innerHTML = '';
        container.appendChild(div);
        container.style.visibility = 'visible';
    }
	,

    applyRatings: function () {
        var divs = document.getElementsByTagName('div');
        for (var i = 0; i < divs.length; i++) {
            if (divs[i].className == 'ratingcontainer') {
                var args = divs[i].innerHTML.split('|');
                BlogEngine.showRating(divs[i], args[0], args[1], args[2], args[3]);
            }
        }
    },

    englishNumber: function (number) {
        if (number == 1)
            return 'one-star';

        if (number == 2)
            return 'two-stars';

        if (number == 3)
            return 'three-stars';

        if (number == 4)
            return 'four-stars';

        return 'five-stars';
    }
	,
    // Adds event to window.onload without overwriting currently assigned onload functions.
    // Function found at Simon Willison's weblog - http://simon.incutio.com/
    addLoadEvent: function (func) {
        var oldonload = window.onload;
        if (typeof window.onload != 'function') {
            window.onload = func;
        }
        else {
            window.onload = function () {
                oldonload();
                func();
            }
        }
    }
	,
    filterByAPML: function () {
        var width = document.documentElement.clientWidth + document.documentElement.scrollLeft;
        var height = document.documentElement.clientHeight + document.documentElement.scrollTop;
        document.body.style.position = 'static';

        var layer = document.createElement('div');
        layer.style.zIndex = 2;
        layer.id = 'layer';
        layer.style.position = 'absolute';
        layer.style.top = '0px';
        layer.style.left = '0px';
        layer.style.height = document.documentElement.scrollHeight + 'px';
        layer.style.width = width + 'px';
        layer.style.backgroundColor = 'black';
        layer.style.opacity = '.6';
        layer.style.filter += ("progid:DXImageTransform.Microsoft.Alpha(opacity=60)");
        document.body.appendChild(layer);

        var div = document.createElement('div');
        div.style.zIndex = 3;
        div.id = 'apmlfilter';
        div.style.position = (navigator.userAgent.indexOf('MSIE 6') > -1) ? 'absolute' : 'fixed';
        div.style.top = '200px';
        div.style.left = (width / 2) - (400 / 2) + 'px';
        div.style.height = '50px';
        div.style.width = '400px';
        div.style.backgroundColor = 'white';
        div.style.border = '2px solid silver';
        div.style.padding = '20px';
        document.body.appendChild(div);

        var p = document.createElement('p');
        p.innerHTML = BlogEngineRes.i18n.apmlDescription;
        p.style.margin = '0px';
        div.appendChild(p);

        var form = document.createElement('form');
        form.method = 'get';
        form.style.display = 'inline';
        form.action = BlogEngineRes.webRoot;
        div.appendChild(form);

        var textbox = document.createElement('input');
        textbox.type = 'text';
        textbox.value = BlogEngine.getCookieValue('url') || 'http://';
        textbox.style.width = '320px';
        textbox.id = 'txtapml';
        textbox.name = 'apml';
        textbox.style.background = 'url(' + BlogEngineRes.webRoot + 'Content/images/blog/apml.png) no-repeat 2px center';
        textbox.style.paddingLeft = '16px';
        form.appendChild(textbox);
        textbox.focus();

        var button = document.createElement('input');
        button.type = 'submit';
        button.value = BlogEngineRes.i18n.filter;
        button.onclick = function () { location.href = BlogEngineRes.webRoot + '?apml=' + encodeURIComponent(BlogEngine.$('txtapml').value); };
        form.appendChild(button);

        var br = document.createElement('br');
        div.appendChild(br);

        var a = document.createElement('a');
        a.innerHTML = BlogEngineRes.i18n.cancel;
        a.href = 'javascript:void(0)';
        a.onclick = function () { document.body.removeChild(BlogEngine.$('layer')); document.body.removeChild(BlogEngine.$('apmlfilter')); document.body.style.position = ''; };
        div.appendChild(a);
    }
	,
    getCookieValue: function (name) {
        var cookie = new String(document.cookie);

        if (cookie != null && cookie.indexOf('comment=') > -1) {
            var start = cookie.indexOf(name + '=') + name.length + 1;
            var end = cookie.indexOf('&', start);
            if (end > start && start > -1)
                return cookie.substring(start, end);
        }

        return null;
    }
    ,
    test: function () {
        alert('test');
    }
	,
    comments: {
        flagImage: null,
        contentBox: null,
        moderation: null,
        checkName: null,
        postAuthor: null,
        nameBox: null,
        emailBox: null,
        websiteBox: null,
        countryDropDown: null,
        captchaField: null,
        controlId: null,
        replyToId: null
    }
};

BlogEngine.addLoadEvent(BlogEngine.hightLightXfn);

// add this to global if it doesn't exist yet
if (typeof ($) == 'undefined')
    window.$ = BlogEngine.$;

// apply ratings after registerVariables.
BlogEngine.addLoadEvent(BlogEngine.applyRatings);
