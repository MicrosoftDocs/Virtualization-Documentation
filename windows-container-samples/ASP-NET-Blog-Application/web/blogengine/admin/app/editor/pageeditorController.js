angular.module('blogAdmin').controller('PageEditorController', ["$rootScope", "$scope", "$location", "$filter", "$log", "dataService", function ($rootScope, $scope, $location, $filter, $log, dataService) {
    $scope.id = getFromQueryString('id');
    $scope.page = newPage;
    $scope.lookups = [];
    $scope.selectedParent = {};
    $scope.fullScreen = false;
    $scope.security = $rootScope.security;
    $scope.UserVars = UserVars;
    $scope.root = $rootScope.SiteVars.ApplicationRelativeWebRoot;
    $scope.customFields = [];

    $scope.load = function () {
        var lookupsUrl = '/api/lookups';
        dataService.getItems(lookupsUrl)
        .success(function (data) {
            angular.copy(data, $scope.lookups);

            $scope.lookups.PageList.unshift({ OptionName: '-- none --', OptionValue: 'none' });

            if ($scope.id) {
                $scope.loadPage();
            }
            else {
                $scope.page.Parent = { OptionName: '-- none --', OptionValue: 'none' };
                $scope.selectedParent = selectedOption($scope.lookups.PageList, $scope.page.Parent.OptionValue);
            }
        })
        .error(function () {
            toastr.error("Error loading lookups");
        });
    }

    $scope.loadPage = function () {
        spinOn();
        var url = '/api/pages/' + $scope.id;
        dataService.getItems(url)
        .success(function (data) {
            angular.copy(data, $scope.page);
            // add "none" option
            if ($scope.page.Parent == null) {
                $scope.page.Parent = { OptionName: '-- none --', OptionValue: 'none' };
            }
            // remove self to avoid self-parenting
            $scope.removeSelf();

            $scope.selectedParent = selectedOption($scope.lookups.PageList, $scope.page.Parent.OptionValue);
            var x = $scope.selectedParent;

            editorSetHtml($scope.page.Content);
            $scope.loadCustom();
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingPage);
            spinOff();
        });
    }

    $scope.publish = function (doPublish) {
        $scope.page.IsPublished = doPublish;
        $scope.save();
    }

    $scope.save = function () {
        if (!$('#form').valid()) {
            return false;
        }
        spinOn();
        $scope.page.Content = editorGetHtml();
        $scope.page.Parent = $scope.selectedParent;

        if ($scope.page.Slug.length == 0) {
            $scope.page.Slug = toSlug($scope.page.Title);
        }

        if ($scope.page.Id) {
            dataService.updateItem('/api/pages/update/foo', $scope.page)
           .success(function (data) {
               $scope.updateCustom();
               $scope.load();
               toastr.success("Page updated");
               $("#modal-form").modal('hide');
               spinOff();
           })
           .error(function () {
               toastr.error("Update failed");
               spinOff();
           });
        }
        else {
            dataService.addItem('/api/pages', $scope.page)
           .success(function (data) {
               toastr.success("Page added");
               $log.log(data);
               if (data.Id) {
                   angular.copy(data, $scope.page);
                   $scope.id = $scope.page.Id;
                   $scope.updateCustom();
               }
               $("#modal-form").modal('hide');
               spinOff();
           })
           .error(function () {
               toastr.error("Failed adding new page");
               spinOff();
           });
        }
    }

    $scope.uploadFile = function (action, files) {
        var fd = new FormData();
        fd.append("file", files[0]);

        dataService.uploadFile("/api/upload?action=" + action, fd)
        .success(function (data) {
            toastr.success($rootScope.lbl.uploaded);
            var editorHtml = editorGetHtml();
            if (action === "file" && IsImage(data)) {
                editorSetHtml(editorHtml + '<img src=' + data + ' />');
            }
            if (action === "video") {
                editorSetHtml(editorHtml + '<p>[video src=' + data + ']</p>');
            }
            if (action === "file" && IsImage(data) === false) {
                var res = data.split("|");
                if (res.length === 2) {
                    editorSetHtml(editorHtml + '<a href="' + res[0].replace('"', '') + '">' + res[1].replace('"', '') + '</a>');
                }
            }
        })
        .error(function () { toastr.error("Import failed"); });
    }

    $scope.status = function () {
        // 0 - unpublished; 1 - saved; 2 - published;
        if ($scope.page && $scope.page.Id && $scope.page.IsPublished) {
            return 2;
        }
        if ($scope.page && $scope.page.Id && !$scope.page.IsPublished) {
            return 1;
        }
        return 0;
    };

    $scope.load();

    $(document).ready(function () {
        $.validator.addMethod(
            "dateFormatted",
            function (value, element) {
                var re = /^\d{4}-\d{1,2}-\d{1,2}\s([0-9]|[0-1][0-9]|[2][0-3]):([0-5][0-9])$/;
                return (this.optional(element) && value == "") || re.test(value);
            },
            "yyyy-mm-dd hh:mm"
        );
        $('#form').validate({
            rules: {
                txtTitle: { required: true }
            }
        });
    });

    $scope.removeSelf = function () {
        for (var i = 0; i < $scope.lookups.PageList.length; i++) {
            if ($scope.lookups.PageList[i].OptionValue === $scope.id) {
                $scope.lookups.PageList.splice(i, 1);
            }
        }
    }

    $scope.saveEditOptions = function () {
        dataService.updateItem('api/lookups/update/foo', $scope.lookups.PageOptions)
           .success(function (data) {
               toastr.success($rootScope.lbl.pageUpdated);
               $("#myModal").modal('hide');
               spinOff();
           })
           .error(function () { toastr.error($rootScope.lbl.updateFailed); });
    }

    /* custom fields */

    $scope.showCustom = function () {
        $("#modal-custom-fields").modal();
        $scope.focusInput = true;
    }

    $scope.loadCustom = function () {
        $scope.customFields = [];

        dataService.getItems('/api/customfields', { filter: 'CustomType == "PAGE" && ObjectId == "' + $scope.page.Id + '"' })
        .success(function (data) {
            angular.copy(data, $scope.customFields);
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingCustomFields);
            spinOff();
        });
    }

    $scope.addCustom = function () {
        var customField = {
            "CustomType": "PAGE",
            "ObjectId": $scope.page.Id,
            "Key": $("#txtKey").val(),
            "Value": $("#txtValue").val()
        };
        if (customField.Key === '') {
            toastr.error("Custom key is required");
            return false;
        }
        $scope.customFields.push(customField);
        $("#modal-custom-fields").modal('hide');
    }

    $scope.deleteCustom = function (key, objId) {
        $.each($scope.customFields, function (index, result) {
            if (result["Key"] == key && result["ObjectId"] == objId) {
                $scope.customFields.splice(index, 1);
            }
        });
    }

    $scope.updateCustom = function () {
        for (var i = 0; i < $scope.customFields.length; i++) {
            $scope.customFields[i].ObjectId = $scope.page.Id;
        }
        dataService.updateItem("/api/customfields", $scope.customFields)
        .success(function (data) {
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.updateFailed);
            spinOff();
        });
    }

    /* end custom fields */

}]);

var newPage = {
    "Id": "",
    "Title": "",
    "Content": "",
    "DateCreated": moment().format("YYYY-MM-DD HH:mm"),
    "Slug": "",
    "ShowInList": true,
    "IsPublished": false
}