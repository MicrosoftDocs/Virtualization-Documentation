angular.module('blogAdmin').controller('FileManagerController', ["$rootScope", "$scope", "$location", "$filter", "$log", "dataService", function ($rootScope, $scope, $location, $filter, $log, dataService) {
    $scope.data = dataService;
    $scope.items = [];
    $scope.itemsPerPage = 45; // page size - pass into grid on init
    $scope.sortingOrder = 'SortOrder';
    $scope.reverse = false;
    $scope.id = {};
    $scope.file = {};
    $scope.dirName = '';    
    $scope.root = $rootScope.SiteVars.ApplicationRelativeWebRoot;
    $scope.rootStorage = SiteVars.BlogStorageLocation + SiteVars.BlogFilesFolder;
    $scope.currentPath = '/';
    $scope.focusInput = false;

    $scope.load = function (path) {
        var p = path ? { take: 0, skip: 0, path: path } : { take: 0, skip: 0 };
        dataService.getItems('/api/filemanager', p)
        .success(function (data) {
            angular.copy(data, $scope.items);
            gridInit($scope, $filter);
            $scope.currentPath = path ? path : $scope.rootStorage;
            $('#file-spinner').hide();
        })
        .error(function (data) {
            toastr.error($rootScope.lbl.Error);
            $('#file-spinner').hide();
        });
    }

    $scope.processChecked = function (action) {
        var i = $scope.items.length;
        var checked = [];
        while (i--) {
            var item = $scope.items[i];
            if (item.IsChecked === true) {
                checked.push(item);
            }
        }
        if (checked.length < 1) {
            return false;
        }

        if (action === "append") {
            var j = checked.length;
            while (j--) {
                var item = checked[j];
                var editorHtml = editorGetHtml();
                if (item.FileType === 1) {
                    var fileTag = "<p><a href='" + SiteVars.RelativeWebRoot + "file.axd?file=" + item.FullPath + "' target='_blank'>" + item.Name + " (" + item.FileSize + ")</a></p>";
                    editorSetHtml(editorHtml + fileTag);
                }
                if (item.FileType === 2) {
                    editorSetHtml(editorHtml + "<img src='" + SiteVars.RelativeWebRoot + "image.axd?picture=" + item.FullPath + "' />");
                }
            }
            toastr.success($rootScope.lbl.completed);
            $("#modal-file-manager").modal('hide');
        }
        if (action === "delete") {
            spinOn();
            dataService.processChecked("/api/filemanager/processchecked/delete", checked)
            .success(function (data) {
                $scope.load($scope.currentPath);
                gridInit($scope, $filter);
                toastr.success($rootScope.lbl.completed);
                if ($('#chkAll')) {
                    $('#chkAll').prop('checked', false);
                }
                spinOff();
            })
            .error(function () {
                toastr.error($rootScope.lbl.failed);
                spinOff();
            });
        }
    }

    $scope.uploadFile = function (files) {
        var fd = new FormData();
        fd.append("file", files[0]);
        $('#file-spinner').show();

        dataService.uploadFile("/api/upload?action=filemgr&dirPath=" + $scope.currentPath, fd)
        .success(function (data) {
            $scope.load($scope.currentPath);
            gridInit($scope, $filter);
            toastr.success($rootScope.lbl.completed);
            $('#file-spinner').hide();
        })
        .error(function () {
            toastr.error($rootScope.lbl.failed);
            $('#file-spinner').hide();
        });
    }

    $scope.addFolder = function () {
        $("#modal-form").modal();
        $scope.focusInput = true;
    }

    $scope.createFolder = function () {
        if (!$('#form').valid()) {
            return false;
        }
        spinOn();
        dataService.updateItem("/api/filemanager/addfolder/add", { Name: $scope.dirName, FullPath: $scope.currentPath })
        .success(function (data) {
            $scope.load($scope.currentPath);
            gridInit($scope, $filter);
            toastr.success($rootScope.lbl.completed);
            spinOff();
            $("#modal-form").modal('hide');
        })
        .error(function () {
            toastr.error($rootScope.lbl.failed);
            spinOff();
        });
    }

    $(document).ready(function () {
        $('#form').validate({
            rules: {
                txtFolder: { required: true }
            }
        });
    });

    $scope.hasChecked = function () {
        var i = $scope.items.length;
        var checked = [];
        while (i--) {
            var item = $scope.items[i];
            if (item.IsChecked === true) {
                return true;
            }
        }
        return false;
    }

    $scope.insertFile = function (file) {
        var s = "<img src='" + SiteVars.RelativeWebRoot + "image.axd?picture=" + file.FullPath + "' />";
        if (file.FileType != 2) {
            // not a picture, insert as attachement
            s = "<p><a class=\"download\" href=\"" + SiteVars.RelativeWebRoot + "file.axd?file=" +
                file.FullPath + "\" alt=\"" + file.Name + "\">" + file.Name + " (" + file.FileSize + ")</a></p>";
        }
        // get hold on TinyMce editor and inject link
        var wm = top.tinymce.activeEditor.windowManager;
        wm.getParams().ed.insertContent(s);
        wm.getWindows()[0].close();
    }

    $scope.load('');
}]);