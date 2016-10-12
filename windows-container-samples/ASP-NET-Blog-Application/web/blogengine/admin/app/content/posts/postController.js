angular.module('blogAdmin').controller('PostsController', ["$rootScope", "$scope", "$location", "$http", "$filter", "dataService", function ($rootScope, $scope, $location, $http, $filter, dataService) {
    $scope.items = [];
    $scope.filter = ($location.search()).fltr;
    $scope.sortingOrder = 'DateCreated';
    $scope.reverse = true;

    $scope.load = function () {
        var url = '/api/posts';
        var p = { take: 0, skip: 0 }

        spinOn();
        dataService.getItems(url, p)
        .success(function (data) {
            angular.copy(data, $scope.items);
            gridInit($scope, $filter);
            if ($scope.filter) {
                $scope.setFilter($scope.filter);
            }
            spinOff();
        })
        .error(function () {
            toastr.error($rootScope.lbl.errorLoadingPosts);
            spinOff();
        });
    }

    $scope.load();
	
    $scope.processChecked = function (action) {
        processChecked("/api/posts/processchecked/", action, $scope, dataService);
    }

	$scope.setFilter = function (filter) {
	    if ($scope.filter === 'pub') {
	        $scope.gridFilter('IsPublished', true, 'pub');
	    }
	    if ($scope.filter === 'dft') {
	        $scope.gridFilter('IsPublished', false, 'dft');
	    }
	}

	$(document).ready(function () {
	    bindCommon();
	});

}]);