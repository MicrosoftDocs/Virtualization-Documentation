angular.module('blogAdmin').controller('DashboardController', ["$rootScope", "$scope", "$location", "$log", "$filter", "dataService", function ($rootScope, $scope, $location, $log, $filter, dataService) {
    $scope.vm = {};
    $scope.itemToPurge = {};
    $scope.news = [];
    $scope.security = $rootScope.security;
    $scope.focusInput = false;
    $scope.qd = angular.copy(newDraft);

    $scope.postDraft = function () {
        var draft = {
            "Id": "",
            "Title": $scope.qd.title,
            "Author": "",
            "Content": $scope.qd.text,
            "DateCreated": moment().format("YYYY-MM-DD HH:mm"),
            "Slug": "",
            "Categories": "",
            "Tags": "",
            "Comments": "",
            "HasCommentsEnabled": true,
            "IsPublished": false
        }  
        dataService.addItem('api/posts', draft)
        .success(function (data) {
            $scope.qd = angular.copy(newDraft);
            var dft = {
                "IsChecked": false,
                "Id": data.Id,
                "Title": data.Title,
                "Author": data.Author,
                "DateCreated": data.DateCreated,
                "Slug": data.Slug,
                "RelativeLink": data.RelativeLink,
                "Categories": null,
                "Tags": null,
                "Comments": null,
                "IsPublished": false
            };
            $scope.vm.DraftPosts.push(dft);
            toastr.success($rootScope.lbl.postAdded);
        })
        .error(function () { toastr.error($rootScope.lbl.failedAddingNewPost); });
    }

    $scope.openTrash = function () {
        $("#modal-trash").modal();
        return false;
    }

    $scope.openLogFile = function () {
        $("#modal-log-file").modal();
        return false;
    }
    $scope.purgeLog = function () {
        dataService.updateItem('/api/logs/purgelog/file', $scope.itemToPurge)
        .success(function (data) {
            $scope.vm.Logs = [];
            $("#modal-log-file").modal('hide');
            toastr.success($rootScope.lbl.purged);
            return false;
        })
        .error(function (data) {
            toastr.error($rootScope.lbl.errorPurging);
        });
    }

    $scope.purge = function (id) {
        if (id) {
            $scope.itemToPurge = findInArray($scope.vm.Trash, "Id", id);
        }
        dataService.updateItem('/api/trash/purge/' + id, $scope.itemToPurge)
        .success(function (data) {
            for (var i = 0; i < $scope.vm.Trash.length; i++)
            if ($scope.vm.Trash[i].Id === id) {
                $scope.vm.Trash.splice(i, 1);
                break;
            }
            toastr.success($rootScope.lbl.purged);
            return false;
        })
        .error(function (data) {
            toastr.error($rootScope.lbl.errorPurging);
        });
    }
    $scope.purgeAll = function () {
        dataService.updateItem('/api/trash/purgeall/all')
        .success(function (data) {
            $scope.vm.Trash = [];
            $("#modal-trash").modal('hide');
            toastr.success($rootScope.lbl.purged);
            return false;
        })
        .error(function (data) {
            toastr.error($rootScope.lbl.errorPurging);
        });
    }
    $scope.restore = function (id) {
        if (id) {
            $scope.itemToPurge = findInArray($scope.vm.Trash, "Id", id);
        }
        dataService.updateItem('/api/trash/restore/' + id, $scope.itemToPurge)
        .success(function (data) {
            for (var i = 0; i < $scope.vm.Trash.length; i++)
            if ($scope.vm.Trash[i].Id === id) {
                $scope.vm.Trash.splice(i, 1);
                break;
            }
            toastr.success($rootScope.lbl.restored);
            return false;
        })
        .error(function (data) {
            toastr.error($rootScope.lbl.errorRestoring);
        });
    }

    $scope.load = function () {
        if ($rootScope.security.showTabDashboard === false) {
            window.location = "../Account/Login.aspx";
        }
        $("#versionMsg").hide();
        spinOn();

        $scope.loadPackages();
        $scope.loadNewsFeed();

        dataService.getItems('/api/dashboard')
        .success(function (data) {
            angular.copy(data, $scope.vm);
            spinOff();
        })
        .error(function (data) {
            toastr.success($rootScope.lbl.errorGettingStats);
            spinOff();
        });
    }
    $scope.loadPackages = function () {
        if (!$scope.security.showTabCustom) {
            return;
        }
        dataService.getItems('/api/packages', { take: 5, skip: 0 })
        .success(function (data) {
            $scope.packages = [];
            angular.copy(data, $scope.packages);
            $scope.checkNewVersion();
            $('#gal-spinner').hide();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingPackages);
            $('#gal-spinner').hide();
        });
    }
    $scope.loadNewsFeed = function () {
        dataService.getItems('/api/newsfeed', { take: 5, skip: 0 })
        .success(function (data) {
            angular.copy(data, $scope.news);
            $('#news-spinner').hide();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingPackages);
            $('#news-spinner').hide();
        });
    }
    $scope.checkNewVersion = function () {
        if (!$scope.security.showTabCustom) {
            return;
        }
        var version = SiteVars.Version.substring(15, 22);
        $.ajax({
            url: SiteVars.ApplicationRelativeWebRoot + "api/setup?version=" + version,
            type: "GET",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                if (data && data.length > 0) {
                    $("#vNumber").html(data);
                    $("#versionMsg").show();
                }
            }
        });
    }
    $scope.getGalleryLink = function (tp, id) {
        var lk = "#/custom/themes/gallery";
        if(tp == "Extension"){
            lk = "#/custom/plugins/gallery";
        }
        $(".nav-primary > li").removeClass("active");
        $("#mu-custom").addClass("active");
        window.location.href = lk + "?pkgId=" + id;
    }
    $scope.load();
    $(document).ready(function () {
        bindCommon();
    });
}]);

var newDraft = {
    show: UserVars.Rights.indexOf("CreateNewPosts") > 0,
    title: "",
    text: ""
}