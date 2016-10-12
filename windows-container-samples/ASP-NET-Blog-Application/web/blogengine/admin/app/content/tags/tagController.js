angular.module('blogAdmin').controller('TagsController', ["$rootScope", "$scope", "$location", "$filter", "$log", "dataService", function ($rootScope, $scope, $location, $filter, $log, dataService) {
    $scope.data = dataService;
    $scope.items = [];
    $scope.id = {};
    $scope.tag = {};
    $scope.focusInput = false;

    $scope.loadEditForm = function (id) {
        $scope.id = id;
        $scope.tag = id;
        $("#modal-add-tag").modal();
        $scope.focusInput = true;
    }

    $scope.load = function () {
        var p = { take: 0, skip: 0, postId: "" };
        dataService.getItems('/api/tags', p)
        .success(function (data) {
            angular.copy(data, $scope.items);
            gridInit($scope, $filter);
            spinOff();
        })
        .error(function (data) {
            toastr.success($rootScope.lbl.errorGettingTags);
        });
    }

    $scope.load();
	
    $scope.processChecked = function (action) {
        processChecked("/api/tags/processchecked/", action, $scope, dataService);
    }

    $scope.save = function () {
        if ($scope.tag) {
            dataService.updateItem("/api/tags/update/" + $scope.id, { OldTag: $scope.id, NewTag: $scope.tag })
           .success(function (data) {
               toastr.success($rootScope.lbl.tagUpdated);
               $scope.load();
               gridInit($scope, $filter);
           })
           .error(function () { toastr.error($rootScope.lbl.updateFailed); });
        }
        $("#modal-add-tag").modal('hide');
        $scope.focusInput = false;
    }

    $(document).ready(function () {
        bindCommon();
    });
}]);