angular.module('blogAdmin').controller('NavController', ["$scope", "$location", "$rootScope", function ($scope, $location, $rootScope) {
    $scope.IsPrimary = $rootScope.SiteVars.IsPrimary;
    $scope.security = $rootScope.security;
    $scope.UserVars = UserVars;

    $scope.isActive = function (viewLocation) {
        return viewLocation === $location.path() || $location.path().startsWith(viewLocation + "/");
    };
    $(".nav-sidebar > ul > li").removeClass("active");

    if ($location.path().indexOf("content") > -1) {
        $("#mu-content").addClass("active");
    }
    else if ($location.path().indexOf("custom") > -1) {
        $("#mu-custom").addClass("active");
    }
    else if ($location.path().indexOf("security") > -1) {
        $("#mu-users").addClass("active");
    }
    else if ($location.path().indexOf("settings") > -1) {
        $("#mu-settings").addClass("active");
    }
    else if ($location.path().indexOf("gallery") > -1) {
        $("#mu-gallery").addClass("active");
    }
    else {
        $("#mu-dashboard").addClass("active");
    }

    $(".nav-sidebar > ul > li > a").click(function () {
        $(".nav-sidebar > ul > li").removeClass("active");
        $(this).parent().addClass("active");
    });

    if ($location.$$absUrl.indexOf("editpost.cshtml") > -1) {
        $(".nav-sidebar > ul > li").removeClass("active");
        $("#mu-content").addClass("active");
        $("#mu-posts").addClass("active");
    }
    if ($location.$$absUrl.indexOf("editpage.cshtml") > -1) {
        $(".nav-sidebar > ul > li").removeClass("active");
        $("#mu-content").addClass("active");
        $("#mu-pages").addClass("active");
    }
    if ($location.$$absUrl.indexOf("admin/about") > -1) {
        $(".nav-sidebar > ul > li").removeClass("active");
        $("#mu-about").addClass("active");
    }
}]);

if (typeof String.prototype.startsWith != 'function') {
    String.prototype.startsWith = function (str) {
        return this.slice(0, str.length) == str;
    };
}

function spinOn() {
    $("#ng-view").hide();
    $("#global-loading").show();
}

function spinOff() {
    $("#ng-view").show();
    $("#global-loading").hide();
}

function loading(id) {
    $("#" + id + "-spinner").removeClass("loaded");
    $("#" + id + "-spinner").addClass("loading");
}

function loaded(id) {
    $("#" + id + "-spinner").removeClass("loading");
    $("#" + id + "-spinner").addClass("loaded");
}

function rowSpinOff(items) {
    if (items.length > 0) {
        $('#tr-spinner').hide();
    }
    else {
        $('#div-spinner').html(BlogAdmin.i18n.empty);
    }
}

function selectedOption(arr, val) {
    for (var i = 0; i < arr.length; i++) {
        if (typeof val === 'number') {
            if (arr[i].OptionValue == val) return arr[i];
        }
        else {
            if (arr[i].OptionValue.toUpperCase() == val.toUpperCase()) return arr[i];
        }
    }
}

function findInArray(arr, name, value) {
    for (var i = 0, len = arr.length; i < len; i++) {
        if (name in arr[i] && arr[i][name] == value) return arr[i];
    };
    return false;
}

function webRoot(url) {
    var result = SiteVars.ApplicationRelativeWebRoot;
    if (url.substring(0, 1) === "/") {
        return result + url.substring(1);
    }
    else {
        return result + url;
    }
}

function processChecked(url, action, scope, dataService) {
    spinOn();
    var i = scope.items.length;
    var checked = [];
    while (i--) {
        var item = scope.items[i];
        if (item.IsChecked === true) {
            checked.push(item);
        }
    }
    if (checked.length < 1) {
        return false;
    }
    dataService.processChecked(url + action, checked)
    .success(function (data) {
        scope.load();
        toastr.success(BlogAdmin.i18n.completed);
        if ($('#chkAll')) {
            $('#chkAll').prop('checked', false);
        }
        spinOff();
    })
    .error(function (data) {
        toastr.error(BlogAdmin.i18n.failed);
        spinOff();
    });
}

function getFromQueryString(param) {
    var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < url.length; i++) {
        var urlparam = url[i].split('=');
        if (urlparam[0] == param) {
            return urlparam[1];
        }
    }
}

function bindCommon() {
  
    //
    $(".dropdown-menu-filter li a").click(function () {
        $(this).parents(".dropdown").find('.btn').html('<span class="show-label"></span> ' + $(this).text() + ' <i class="fa fa-angle-down"></i>');
        $(this).parents(".dropdown").find('.btn').val($(this).data('value'));
    });

    //
    $(".search input").focus(function () {
        $(".search").addClass("active");
    });
    $('.search input').blur(function () {
        if ($(this).val().length == 0) {
            $(".search").removeClass("active");
        }
    });

    //
    $(".btn-input-file.prev").click(function () {
        $(this).prev('input').click();
    });
    $(".btn-input-file.next").click(function () {
        $(this).next('input').click();
    });

    //
    $(".main-header .btn").tooltip({
        placement: "bottom",
        container: '.main-header',
    });

    //
    $(".right-side-toggle").click(function () {
        $(".right-side").toggleClass("active");
    });

    $(window).resize(function () {
        if ($(window).width() > 640) {
            $(".right-side").removeClass("active");
        }
    });
}