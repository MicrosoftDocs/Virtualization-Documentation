
angular.module('blogAdmin').controller('BlogListController', ["$rootScope", "$scope", "$filter", "dataService", function ($rootScope, $scope, $filter, dataService) {
    $scope.items = [];
    $scope.editItem = {};
    $scope.newItem = {};
    $scope.modalTitle = $rootScope.lbl.addNewBlog;
    $scope.focusInput = false;
    $scope.blogsPage = true;

    $scope.modalNew = function () {
        $scope.modalTitle = $rootScope.lbl.addNewBlog;
        $scope.editItem = {};
        $("#modal-add").modal();
        $scope.focusInput = true;
    }

    $scope.modalEdit = function (id) {
        $scope.modalTitle = $rootScope.lbl.editExistingBlog;
        spinOn();
        dataService.getItems('/api/blogs/' + id)
        .success(function (data) {
            angular.copy(data, $scope.editItem);
            $("#modal-edit").modal();
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingBlog);
            spinOff();
        });
    }

    $scope.load = function (callback) {
        dataService.getItems('/api/blogs', { take: 0, skip: 0, filter: "1 == 1", order: "Name" })
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
        spinOn();
        dataService.updateItem("/api/blogs/update/item", $scope.editItem)
        .success(function (data) {
            toastr.success($rootScope.lbl.blogSaved);
            $scope.load();
            spinOff();
            $("#modal-edit").modal('hide');
        })
        .error(function () {
            toastr.error($rootScope.lbl.failedAddingNewRole);
            spinOff();
            $("#modal-edit").modal('hide');
        });
    }

    $scope.saveNew = function () {
        if (!$('#form').valid()) {
            return false;
        }
        spinOn();
        dataService.addItem("/api/blogs", $scope.newItem)
        .success(function (data) {
            toastr.success($rootScope.lbl.blogAddedShort);
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
        processChecked("/api/blogs/processchecked/", action, $scope, dataService);
    }

    $scope.load();

    $(document).ready(function () {
        $('#form').validate({
            rules: {
                txtBlogName: { required: true },
                txtUserName: { required: true },
                txtEmail: { required: true, email: true },
                txtPassword: { required: true },
                txtConfirmPassword: { required: true, equalTo: '#txtPassword' }
            }
        });
    });


    $(document).ready(function () {
        bindCommon();
    });
}]);