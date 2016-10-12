angular.module('blogAdmin').factory("dataService", ["$http", "$q", function ($http, $q) { 
    return {
        getItems: function (url, p) {
            return $http.get(webRoot(url), {
                // query string like { userId: user.id } -> ?userId=value
                params: p,
                // for sub-blogs with URL rewrite
                headers: { 'x-blog-instance': SiteVars.BlogInstanceId }
            });
        },
        addItem: function (url, item) {
            return $http({
                url: webRoot(url),
                method: 'POST',
                data: item,
                headers: { 'x-blog-instance': SiteVars.BlogInstanceId }
            });
        },
        deleteItem: function (url, item) {
            if (item.Id) {
                return $http({
                    url: webRoot(url) + "/" + item.Id,
                    method: 'DELETE',
                    headers: { 'x-blog-instance': SiteVars.BlogInstanceId }
                });
            }
            else {
                return $http({
                    url: webRoot(url),
                    method: 'DELETE',
                    data: item,
                    headers: { 'Content-Type': 'application/json', 'x-blog-instance': SiteVars.BlogInstanceId }
                });
            }
        },
        // when item does not have "Id" field
        // we can pass name etc. as id here
        deleteById: function (url, id) {
            return $http({
                url: webRoot(url) + "/" + id,
                method: 'DELETE',
                headers: { 'x-blog-instance': SiteVars.BlogInstanceId }
            });
        },
        // delete selected items
        deleteChecked: function (url, items) {
            return $http({
                url: webRoot(url) + url,
                method: 'DELETE',
                data: items,
                headers: { 'x-blog-instance': SiteVars.BlogInstanceId }
            });
        },
        updateItem: function (url, item) {
            return $http({
                url: webRoot(url),
                method: 'PUT',
                data: item,
                headers: { 'x-blog-instance': SiteVars.BlogInstanceId }
            });
        },
        // pass list to process all in one go
        processChecked: function (url, items) {
            return $http({
                url: webRoot(url),
                method: 'PUT',
                data: items,
                headers: { 'x-blog-instance': SiteVars.BlogInstanceId }
            });
        },
        // file upload
        uploadFile: function (url, file) {
            return $http({
                url: webRoot(url),
                method: 'POST',
                data: file,
                withCredentials: true,
                headers: { 'Content-Type': undefined, 'x-blog-instance': SiteVars.BlogInstanceId },
                transformRequest: angular.identity
            });
        }
    };
}]);