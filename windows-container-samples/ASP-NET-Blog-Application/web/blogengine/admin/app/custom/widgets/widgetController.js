angular.module('blogAdmin').controller('CustomWidgetsController', ["$rootScope", "$scope", "$location", "$filter", "DragDropHandler", "dataService", function ($rootScope, $scope, $location, $filter, DragDropHandler, dataService) {
    $scope.widgetZones = {};
    $scope.vm = {};
    $scope.editSrc = {};
    $scope.editId = {};
    $scope.editTitle = {};
    $scope.editZone = {};
    $scope.package = {};
    $scope.selectedRating = 0;
    $scope.author = UserVars.Name;
    $scope.IsPrimary = $rootScope.SiteVars.IsPrimary == "True";

    $scope.load = function () {
        spinOn();
        $scope.widgetZones = {
            titles: [],
            list1: [], list2: [], list3: []
        };
        $scope.vm = {};

        $("#txtWidgetTitle").parent().removeClass("has-error");
       

        dataService.getItems('/api/widgets', { })
        .success(function (data) {
            angular.copy(data, $scope.vm);
            var zones = $scope.vm.WidgetZones;
            for (i = 0; i < zones.length; i++) {
                $scope.widgetZones.titles.push(zones[i].Id);
            }
            if (zones.length > 0) { $scope.widgetZones.list1 = zones[0].Widgets; }
            if (zones.length > 1) { $scope.widgetZones.list2 = zones[1].Widgets; }
            if (zones.length > 2) { $scope.widgetZones.list3 = zones[2].Widgets; }

            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingPackages);
            spinOff();
        });
    }

    $scope.loadEditForm = function (id, name, title, zone) {
        var sharedSrc = SiteVars.RelativeWebRoot + "Custom/Widgets/common.cshtml?id=" + id + "&zone=" + zone;
        var customSrc = SiteVars.RelativeWebRoot + "Custom/Widgets/" + name + "/edit.cshtml?id=" + id + "&zone=" + zone;

        $scope.editId = id;
        $scope.editTitle = title;
        $scope.editZone = zone;

        $("#txtWidgetTitle").parent().removeClass("has-error");
        $("#txtWidgetTitle").val(title);
        $("#settingsFrame").contents().find('.field-validation-error').hide();

        $.ajax({
            type: 'HEAD',
            url: customSrc,
            async: false,
            success: function () {
                $scope.editSrc = customSrc;
            },
            error: function () {
                $scope.editSrc = sharedSrc;
            }
        });
        // show modal and add the name of widget for class. and we will use in the CSS for the height of modal.
        $("#edit-widget").modal().addClass(name);
    }

    $scope.loadInfoForm = function (id, name, title, zone) {
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

    $scope.closeEditForm = function () {
        $("#edit-widget").modal("hide");
    }

    // reset to default classes when modal will close
    $('#edit-widget').on('hidden.bs.modal', function (e) {
        document.getElementById("edit-widget").className = 'modal fade';
    });

    $scope.moveObject = function (from, to, fromList, toList) {
        var item = $scope.widgetZones[fromList][from];
        DragDropHandler.addObject(item, $scope.widgetZones[toList], to);
        $scope.widgetZones[fromList].splice(from, 1);
    }

    $scope.createObject = function (object, to, list) {
        var newItem = angular.copy(object);
        newItem.Id = Math.ceil(Math.random() * 1000);
        DragDropHandler.addObject(newItem, $scope.widgetZones[list], to);
    };

    $scope.deleteItem = function (itemId, zones, zoneId) {
        for (var i = zones.length - 1; i >= 0; i--) {
            if (zones[i].Id === itemId) {
                zones.splice(i, 1);
            }
        }
    };

    $scope.save = function () {
        dataService.updateItem("/api/widgets/update/item", $scope.vm.WidgetZones)
        .success(function (data) {
            toastr.success($rootScope.lbl.completed);
            $scope.load();
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.updateFailed);
            spinOff();
        });
    }

    $scope.updateTitle = function () {
        if ($("#txtWidgetTitle").val().length > 0) {
            if ($scope.editTitle != $("#txtWidgetTitle").val()) {
                for (var i = 0; i < $scope.vm.WidgetZones.length; i++) {
                    for (var j = 0; j < $scope.vm.WidgetZones[i].Widgets.length; j++) {
                        if ($scope.vm.WidgetZones[i].Widgets[j].Id === $scope.editId) {
                            $scope.vm.WidgetZones[i].Widgets[j].Title = $("#txtWidgetTitle").val();
                        }
                    }
                }
                $scope.save();
                return true;
            }
            return false;
        }
        else {
            $("#txtWidgetTitle").parent().addClass("has-error");
            $("#txtWidgetTitle").focus();
            return false;
        }
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

    $scope.setRating = function (rating) {
        $scope.selectedRating = rating;
    }

    $scope.submitRating = function () {
        var author = $("#txtAuthor").val().length > 0 ? $("#txtAuthor").val() : $scope.author;
        var review = { "Name": author, "Rating": $scope.selectedRating, "Body": $("#txtReview").val() };

        dataService.updateItem("/api/packages/rate/" + $scope.package.Extra.Id, review)
        .success(function (data) {
            if (data.length === 0) {
                toastr.success($rootScope.lbl.completed);
            }
            else {
                toastr.error(data);
            }
            $("#modal-info").modal("hide");
        })
        .error(function () {
            toastr.error($rootScope.lbl.failed);
            $("#modal-info").modal("hide");
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

    $scope.load();

    $(document).ready(function () {
        bindCommon();
    });
}]);

var updateTitle = function () {
    return angular.element($('#edit-widget')).scope().updateTitle();
}
