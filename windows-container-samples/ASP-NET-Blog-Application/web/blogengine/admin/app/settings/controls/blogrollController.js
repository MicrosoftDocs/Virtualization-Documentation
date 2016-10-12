
angular.module('blogAdmin').controller('BlogRollController', ["$rootScope", "$scope", "$filter", "dataService", function ($rootScope, $scope, $filter, dataService) {
    $scope.items = [];
    $scope.editItem = {};
    $scope.modalTitle = $rootScope.lbl.add;
    $scope.focusInput = false;
    $scope.xfn = $scope.xfnEmpty;

    $scope.modalNew = function () {
        $scope.modalTitle = $rootScope.lbl.add;
        $scope.editItem = {};
        $scope.xfnReset();
        $("#modal-edit").modal();
        $scope.focusInput = true;
    }

    $scope.modalEdit = function (id) {
        $scope.modalTitle = $rootScope.lbl.edit;
        $scope.xfnReset();
        spinOn();
        dataService.getItems('/api/blogroll/' + id)
        .success(function (data) {
            angular.copy(data, $scope.editItem);
            var x = $scope.editItem.Xfn.split(" ");
            for (var i = 0, len = x.length; i < len; i++) {
                if (x[i] == "contact") $scope.xfn.contact = true;
                if (x[i] == "acquaintance") $scope.xfn.acquaintance = true;
                if (x[i] == "friend") $scope.xfn.friend = true;
                if (x[i] == "met") $scope.xfn.met = true;
                if (x[i] == "co-worker") $scope.xfn.coworker = true;
                if (x[i] == "colleague") $scope.xfn.colleague = true;
                if (x[i] == "co-resident") $scope.xfn.coresident = true;
                if (x[i] == "neighbor") $scope.xfn.neighbor = true;
                if (x[i] == "child") $scope.xfn.child = true;
                if (x[i] == "parent") $scope.xfn.parent = true;
                if (x[i] == "sibling") $scope.xfn.sibling = true;
                if (x[i] == "spouse") $scope.xfn.spouse = true;
                if (x[i] == "kin") $scope.xfn.kin = true;
                if (x[i] == "muse") $scope.xfn.muse = true;
                if (x[i] == "crush") $scope.xfn.crush = true;
                if (x[i] == "date") $scope.xfn.date = true;
                if (x[i] == "sweetheart") $scope.xfn.sweetheart = true;
                if (x[i] == "me") $scope.xfn.me = true;
            }
            $("#modal-edit").modal();
            $scope.focusInput = true;
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.failed);
            spinOff();
        });
    }

    $scope.load = function (callback) {
        dataService.getItems('/api/blogroll', { })
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
        $scope.setEditXfn();
        spinOn();
        if ($scope.editItem.Id) {
            $scope.saveOld();
        }
        else {
            $scope.saveNew();
        }
    }

    $scope.saveOld = function () {
        dataService.updateItem("/api/blogroll/update/item", $scope.editItem)
        .success(function (data) {
            toastr.success($rootScope.lbl.completed);
            $scope.load();
            spinOff();
            $("#modal-edit").modal('hide');
            $scope.focusInput = true;
        })
        .error(function () {
            toastr.error($rootScope.lbl.failed);
            spinOff();
            $("#modal-edit").modal('hide');
            $scope.focusInput = true;
        });
    }

    $scope.saveNew = function () {
        dataService.addItem("/api/blogroll", $scope.editItem)
        .success(function (data) {
            toastr.success($rootScope.lbl.completed);
            $scope.editItem = {};
            $scope.load();
            spinOff();
            $("#modal-edit").modal('hide');
            $scope.focusInput = false;
        })
        .error(function (data) {
            toastr.error(data);
            spinOff();
            $("#modal-edit").modal('hide');
            $scope.focusInput = false;
        });
    }

    $scope.processChecked = function (action) {
        processChecked("/api/blogroll/processchecked/", "delete", $scope, dataService);
    }

    $scope.load();

    $(document).ready(function () {
        $('#form').validate({
            rules: {
                txtTitle: { required: true },
                txtDescription: { required: true },
                txtWebsite: { required: true, url: true },
                txtFeedUrl: { required: true, url: true }
            }
        });
    });

    $scope.xfnReset = function () {
        if ($scope.xfn) { } else { $scope.xfn = $scope.xfnEmpty; }
        $scope.xfn.contact = false;
        $scope.xfn.acquaintance = false;
        $scope.xfn.friend = false;
        $scope.xfn.met = false;
        $scope.xfn.coworker = false;
        $scope.xfn.colleague = false;
        $scope.xfn.coresident = false;
        $scope.xfn.neighbor = false;
        $scope.xfn.child = false;
        $scope.xfn.parent = false;
        $scope.xfn.sibling = false;
        $scope.xfn.spouse = false;
        $scope.xfn.kin = false;
        $scope.xfn.muse = false;
        $scope.xfn.crush = false;
        $scope.xfn.date = false;
        $scope.xfn.sweetheart = false;
        $scope.xfn.me = false;
    }

    $scope.setEditXfn = function () {
        $scope.editItem.Xfn = "";
        if ($scope.xfn.contact == true) $scope.editItem.Xfn += "contact ";
        if ($scope.xfn.acquaintance == true) $scope.editItem.Xfn += "acquaintance ";
        if ($scope.xfn.friend == true) $scope.editItem.Xfn += "friend ";
        if ($scope.xfn.met == true) $scope.editItem.Xfn += "met ";
        if ($scope.xfn.coworker == true) $scope.editItem.Xfn += "co-worker ";
        if ($scope.xfn.colleague == true) $scope.editItem.Xfn += "colleague ";
        if ($scope.xfn.coresident == true) $scope.editItem.Xfn += "co-resident ";
        if ($scope.xfn.neighbor == true) $scope.editItem.Xfn += "neighbor ";
        if ($scope.xfn.child == true) $scope.editItem.Xfn += "child ";
        if ($scope.xfn.parent == true) $scope.editItem.Xfn += "parent ";
        if ($scope.xfn.sibling == true) $scope.editItem.Xfn += "sibling ";
        if ($scope.xfn.spouse == true) $scope.editItem.Xfn += "spouse ";
        if ($scope.xfn.kin == true) $scope.editItem.Xfn += "kin ";
        if ($scope.xfn.muse == true) $scope.editItem.Xfn += "muse ";
        if ($scope.xfn.crush == true) $scope.editItem.Xfn += "crush ";
        if ($scope.xfn.date == true) $scope.editItem.Xfn += "date ";
        if ($scope.xfn.sweetheart == true) $scope.editItem.Xfn += "sweetheart ";
        if ($scope.xfn.me == true) $scope.editItem.Xfn += "me ";
    }

    $scope.xfnEmpty = {
        "contact": true,
        "acquaintance": false,
        "friend": false,
        "met": false,
        "coworker": false,
        "colleague": false,
        "coresident": false,
        "neighbor": false,
        "child": false,
        "parent": false,
        "sibling": false,
        "spouse": false,
        "kin": false,
        "muse": false,
        "crush": false,
        "date": false,
        "sweetheart": false,
        "me": false
    };
}]);