
angular.module('blogAdmin').controller('PingSericesController', ["$rootScope", "$scope", "$filter", "dataService", function ($rootScope, $scope, $filter, dataService) {
    $scope.items = [];
    $scope.newItem = {};
    $scope.focusInput = false;

    $scope.modalNew = function () {
        $scope.newItem = {};
        $("#modal-add").modal();
        $scope.focusInput = true;
    }

    $scope.load = function (callback) {
        dataService.getItems('/api/pingservices', { })
        .success(function (data) {
            angular.copy(data, $scope.items);
            gridInit($scope, $filter);
            callback;
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingBlogs);
        });
    }

    $scope.save = function () {
        if (!$('#form').valid()) {
            return false;
        }
        spinOn();
        $scope.newItem.OptionName = $scope.newItem.OptionValue;
        dataService.addItem("/api/pingservices", $scope.newItem)
        .success(function (data) {
            toastr.success($rootScope.lbl.completed);
            $scope.newItem = {};
            $scope.load();
            spinOff();
            $("#modal-add").modal('hide');
            $scope.focusInput = false;
        })
        .error(function (data) {
            toastr.error(data);
            spinOff();
            $("#modal-add").modal('hide');
            $scope.focusInput = false;
        });
    }

    $scope.processChecked = function (action) {
        processChecked("/api/pingservices/processchecked/", action, $scope, dataService);
    }

    $scope.load();

    $(document).ready(function () {
        $('#form').validate({
            rules: {
                txtNewUrl: { required: true, url: true }
            }
        });
    });
}]);