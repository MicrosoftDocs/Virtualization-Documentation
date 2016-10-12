angular.module('blogAdmin').controller('CustomWidgetGalleryController', ["$rootScope", "$scope", "$location", "$filter", "dataService", function ($rootScope, $scope, $location, $filter, dataService) {
    $scope.items = [];
    $scope.customFields = [];
    $scope.editId = "";
    $scope.package = {};
    $scope.activeTheme = ActiveTheme;
    $scope.IsPrimary = $rootScope.SiteVars.IsPrimary == "True";
    $scope.fltr = 'all';
    $scope.order = 'DownloadCount desc';
    $scope.sortingOrder = 'DownloadCount';
    $scope.reverse = true;
    $scope.selectedRating = 0;
    $scope.author = UserVars.Name;

    $scope.load = function () {
        spinOn();
        dataService.getItems('/api/packages', { take: 0, skip: 0, filter: $scope.fltr, order: 'LastUpdated desc' })
        .success(function (data) {
            angular.copy(data, $scope.items);
            gridInit($scope, $filter);
            $scope.gridFilter('PackageType', 'Widget', 'pub');
            var pkgId = getFromQueryString('pkgId');
            if (pkgId != null) {
                $scope.query = pkgId;
                $scope.search();
            }
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingPackages);
            spinOff();
        });
    }

    $scope.showInfo = function (id) {
        dataService.getItems('/api/packages/' + id)
        .success(function (data) {
            angular.copy(data, $scope.package);
            $scope.selectedRating = $scope.package.Rating;
            $scope.removeEmptyReviews();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingPackages);
        });
        $("#modal-info").modal();
    }

    $scope.removeEmptyReviews = function () {
        if ($scope.package.Extra != null && $scope.package.Extra.Reviews != null) {
            var reviews = [];
            for (var i = 0; i < $scope.package.Extra.Reviews.length; i++) {
                var review = $scope.package.Extra.Reviews[i];
                if (review.Body.length > 0) {
                    reviews.push(review);
                }
            }
            $scope.package.Extra.Reviews = reviews;
        }
    }

    $scope.installPackage = function (pkgId) {
        spinOn();
        dataService.updateItem("/api/packages/install/" + pkgId, pkgId)
        .success(function (data) {
            toastr.success($rootScope.lbl.completed);
            $scope.load();
        })
        .error(function () {
            toastr.error($rootScope.lbl.failed);
            spinOff();
        });
    }

    $scope.uninstallPackage = function (pkgId) {
        spinOn();
        dataService.updateItem("/api/packages/uninstall/" + pkgId, pkgId)
        .success(function (data) {
            toastr.success($rootScope.lbl.completed);
            $scope.load();
        })
        .error(function () {
            toastr.error($rootScope.lbl.failed);
            spinOff();
        });
    }

    $scope.upgradePackage = function (pkgId) {
        spinOn();
        dataService.updateItem("/api/packages/uninstall/" + pkgId, pkgId)
        .success(function (data) {
            $scope.installPackage(pkgId);
        })
        .error(function () {
            toastr.error($rootScope.lbl.failed);
            spinOff();
        });
    }

    $scope.setRating = function (rating) {
        $scope.selectedRating = rating;
    }

    $scope.checkStar = function (item, rating) {
        if (item === rating) {
            return true;
        }
        return false;
    }

    $scope.load();

    $(document).ready(function () {
        bindCommon();
    });
}]);