
## Getting Started ##
1. Download Visual Studio
2. Get some work done
3. Submit your app



### Add an image

![](.\media\kanban.jpg)




### Link to a video

[Video: Managing Work in Visual Studio Online](http://channel9.msdn.com/Events/Visual-Studio/Connect-event-2014/212 "Video: Managing Work in Visual Studio Online")



## Using Code Snippets

Add some description about your code snippets and what they do

<!-- BEGINSECTION class="tabbedCodeSnippets" -->

```cs
public static AuthenticationContext _authenticationContext { get; set; } 
private static async Task<string> GetTokenHelperAsync(AuthenticationContext context, string resourceId)
{
    string accessToken = null;
    AuthenticationResult result = null;

    result = await context.AcquireTokenAsync(resourceId, ClientID, _returnUri);

    accessToken = result.AccessToken;
    //Store authority in application data.
    _settings.Values["LastAuthority"] = context.Authority;

    return accessToken;
}
```
```javascript
var authContext;
var authToken; // for use with creating an outlookClient later.
authContext = new O365Auth.Context();
authContext.getIdToken("https://outlook.office365.com/")
   .then((function (token) {
       authToken = token;
	   // The auth token also carries additional information. For example:	
       userName = token.givenName + " " + token.familyName;
   }).bind(this), function (reason) {
       console.log('Failed to login. Error = ' + reason.message);
   });

```
<!-- ENDSECTION -->