angular.module('blogAdmin').controller('PostEditorController', ["$rootScope", "$scope", "$location", "$filter", "$log", "dataService", function ($rootScope, $scope, $location, $filter, $log, dataService) {
    $scope.id = getFromQueryString('id');
    $scope.post = newPost;
    $scope.lookups = [];
    $scope.allTags = [];
    $scope.selectedAuthor = {};
    $scope.typeHere = BlogAdmin.i18n.typeHere;
    $scope.security = $rootScope.security;
    $scope.UserVars = UserVars;
    $scope.root = $rootScope.SiteVars.ApplicationRelativeWebRoot;
    $scope.usageScenario = UsageScenario;

    $scope.focusInput = false;
    $scope.customFields = [];

    $scope.twitterItem = {};
    $scope.facebookItem = {};
    $scope.profileCustomFields = [];

    $scope.load = function () {
        dataService.getItems('/api/lookups')
        .success(function (data) {
            angular.copy(data, $scope.lookups);
            $scope.loadTags();
        })
        .error(function () {
            toastr.error("Error loading lookups");
        });
    }

    $scope.loadTags = function () {
        var tagsUrl = '/api/tags';
        var p = { take: 0, skip: 0 };
        dataService.getItems(tagsUrl, p)
        .success(function (data) {
            $scope.allTags = [];
            for (var i = 0; i < data.length; i++) {
                $scope.allTags[i] = (data[i].TagName);
            }
            if ($scope.id) {
                $scope.loadPost();
            }
            else {
                load_tags([], $scope.allTags);
                $scope.selectedAuthor = selectedOption($scope.lookups.AuthorList, UserVars.Name);
            }
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingTags);
        });
    }

    $scope.loadPost = function () {
        spinOn();
        var url = '/api/posts/' + $scope.id;
        dataService.getItems(url)
        .success(function (data) {
            angular.copy(data, $scope.post);
            // check post categories in the list
            if ($scope.post.Categories != null) {
                for (var i = 0; i < $scope.post.Categories.length; i++) {
                    for (var j = 0; j < $scope.lookups.CategoryList.length; j++) {
                        if ($scope.post.Categories[i].Id === $scope.lookups.CategoryList[j].OptionValue) {
                            $scope.lookups.CategoryList[j].IsSelected = true;
                        }
                    }
                }
            }
            var existingTags = [];
            if ($scope.post.Tags != null) {
                for (var i = 0; i < $scope.post.Tags.length; i++) {
                    existingTags[i] = ($scope.post.Tags[i].TagName);
                }
            }
            $scope.selectedAuthor = selectedOption($scope.lookups.AuthorList, $scope.post.Author);
            load_tags(existingTags, $scope.allTags);
            editorSetHtml($scope.post.Content);
            $scope.loadProfileCustomFields();
            $scope.loadCustom();
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingPosts);
            spinOff();
        });
    }

    $scope.save = function () {
        if (!$('#form').valid()) {
            return false;
        }
        $scope.post.Content = editorGetHtml();
        if ($scope.post.Content.length == 0) {
            toastr.error('Content field is required');
            tinymce.execCommand('mceFocus', false, 'txtContent');
            return false;
        }
        spinOn();       
        $scope.post.Author = $scope.selectedAuthor.OptionValue;
        if ($scope.post.Slug.length == 0) {
            $scope.post.Slug = toSlug($scope.post.Title);
        }
        // get selected categories
        $scope.post.Categories = [];
        if ($scope.lookups.CategoryList != null) {
            for (var i = 0; i < $scope.lookups.CategoryList.length; i++) {
                var cat = $scope.lookups.CategoryList[i];
                if (cat.IsSelected) {
                    var catAdd = { "IsChecked": false, "Id": cat.OptionValue, "Title": cat.OptionName };
                    $scope.post.Categories.push(catAdd);
                }
            }
        }
        $scope.post.Tags = get_tags();

        if ($scope.post.Id) {
            dataService.updateItem('api/posts/update/foo', $scope.post)
           .success(function (data) {
               $scope.refreshPost();
               $scope.updateCustom();
               toastr.success($rootScope.lbl.postUpdated);
               $("#modal-form").modal('hide');
               spinOff();
           })
           .error(function () { toastr.error($rootScope.lbl.updateFailed); spinOff(); });
        }
        else {
            dataService.addItem('api/posts', $scope.post)
           .success(function (data) {
               toastr.success($rootScope.lbl.postAdded);
               if (data.Id) {
                   angular.copy(data, $scope.post);
                   $scope.id = $scope.post.Id;
                   $scope.updateCustom();
               }
               $("#modal-form").modal('hide');
               spinOff();
           })
           .error(function () { toastr.error($rootScope.lbl.failedAddingNewPost); spinOff(); });
        }
    }

    $scope.publish = function (doPublish){
        $scope.post.IsPublished = doPublish;
        $scope.save();
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
        .error(function () { toastr.error($rootScope.lbl.importFailed); });
    }

    $scope.status = function () {
        // 0 - unpublished; 1 - saved; 2 - published;
        if ($scope.post && $scope.post.Id && $scope.post.IsPublished) {
            return 2;
        }
        if ($scope.post && $scope.post.Id && !$scope.post.IsPublished) {
            return 1;
        }
        return 0;
    };

    $scope.refreshPost = function () {
        spinOn();
        var url = '/api/posts/' + $scope.id;
        dataService.getItems(url)
        .success(function (data) {
            angular.copy(data, $scope.post);
            spinOff();
        })
        .error(function () {
            spinOff();
        });
    }
       
    $scope.addCagegory = function () {
        $("#modal-add-cat").modal();
        $scope.focusInput = true;
    }

    $scope.saveCategory = function () {
        if (!$('#cat-form').valid()) {
            return false;
        }
        dataService.addItem("/api/categories", $scope.category)
        .success(function (data) {
            $scope.lookups.CategoryList.push(
                {
                    OptionName: data.Title,
                    OptionValue: data.Id,  
                    IsSelected: false
                }
            );
            toastr.success($rootScope.lbl.categoryAdded);
            $("#modal-add-cat").modal('hide');
        })
        .error(function () {
            toastr.error(data);
        });
    }

    $scope.saveEditOptions = function () {
        dataService.updateItem('api/lookups/update/foo', $scope.lookups.PostOptions)
           .success(function (data) {
               toastr.success($rootScope.lbl.postUpdated);
               $("#myModal").modal('hide');
               spinOff();
           })
           .error(function () { toastr.error($rootScope.lbl.updateFailed); });
    }

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
        $('#cat-form').validate({
            rules: {
                txtCatTitle: { required: true }
            }
        });
    });

    /* custom fields */

    $scope.showCustom = function () {
        $("#modal-custom-fields").modal();
        $scope.focusInput = true;
    }

    $scope.loadCustom = function () {
        $scope.customFields = [];

        dataService.getItems('/api/customfields', { filter: 'CustomType == "POST" && ObjectId == "' + $scope.post.Id + '"' })
        .success(function (data) {
            angular.copy(data, $scope.customFields);
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingCustomFields);
        });
    }

    $scope.addCustom = function () {
        var customField = {
            "CustomType": "POST",
            "ObjectId": $scope.post.Id,
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
            $scope.customFields[i].ObjectId = $scope.post.Id;
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

    $scope.loadProfileCustomFields = function () {
        $scope.profileCustomFields = [];

        dataService.getItems('/api/customfields', { filter: 'CustomType == "PROFILE"' })
        .success(function (data) {
            angular.copy(data, $scope.profileCustomFields);
            $scope.twitterItem = findCustomItem("Twitter");
            $scope.facebookItem = findCustomItem("Facebook");
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingCustomFields);
        });
    }

    function findCustomItem(key) {
        var arr = $scope.profileCustomFields;
        if (arr && arr.length > 0) {
            for (var i = 0, len = arr.length; i < len; i++) {
                if (arr[i].Key == key) {
                    return arr[i];
                }
            };
        }
        return null;
    }

    /* end custom fields */
}]);

var newPost = {
    "Id": "",
    "Title": "",
    "Author": "Admin",
    "Content": "",
    "DateCreated": moment().format("YYYY-MM-DD HH:mm"),
    "Slug": "",
    "Categories": "",
    "Tags": "",
    "Comments": "",
    "HasCommentsEnabled": true,
    "IsPublished": false
}