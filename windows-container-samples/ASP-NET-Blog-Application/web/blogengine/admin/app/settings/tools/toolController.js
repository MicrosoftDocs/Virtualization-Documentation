angular.module('blogAdmin').controller('ToolsController', ["$rootScope", "$scope", "$filter", "dataService", function ($rootScope, $scope, $filter, dataService) {
    $scope.items = [];
    $scope.security = $rootScope.security;
    $scope.userIdentity = {};

    $scope.load = function () {
        if (!$scope.security.canManageUsers == true) {
            window.location.replace("../Account/Login.aspx");
        }
        spinOn();
        dataService.getItems('/api/tools/check1')
        .success(function (data) {
            $scope.userIdentity = data.replace(/["']/g, "");
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingUsers);
            spinOff();
        });
    }

    $scope.check = function () {
        if (!$scope.security.canManageUsers == true) {
            window.location.replace("../Account/Login.aspx");
        }
        $("#msgList").empty();

        dataService.getItems('/api/tools/trust')
            .success(function (data) { $scope.addMsg(data); })
            .error(function (data) { toastr.error($rootScope.lbl.Error); });

        dataService.getItems('/api/tools/data')
            .success(function (data) { $scope.addMsg(data); })
            .error(function (data) { toastr.error($rootScope.lbl.Error); });

        dataService.getItems('/api/tools/root')
            .success(function (data) { $scope.addMsg(data); })
            .error(function (data) { toastr.error($rootScope.lbl.Error); });

        dataService.getItems('/api/tools/Custom')
            .success(function (data) { $scope.addMsg(data); })
            .error(function () { toastr.error($rootScope.lbl.Error); });
    }

    $scope.addMsg = function (data) {
        if (data.success === true) {
            $("#msgList").append('<div class="alert alert-dismissable alert-success"><span><i class="fa fa-check-circle"></i> ' + data.msg + '</span></div>');
        }
        else {
            $("#msgList").append('<div class="alert alert-dismissable alert-danger"><span><i class="fa fa-exclamation-triangle"></i> ' + data.msg + '</span></div>');
        }
    }

    $scope.load();
}]);