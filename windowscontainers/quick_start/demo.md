ms.ContentId: 9dc57a6a-7104-4721-ba5c-3e246ee17f75 
title: Demo file


## Getting Started ##
1. Download Visual Studio
2. Sign-in with your account
3. Get going!

### Learn how to add an image

![](.\media\kanban.jpg)

### Learn how to add a video

[Video: Managing Work in Visual Studio Online](http://channel9.msdn.com/Events/Visual-Studio/Connect-event-2014/212 "Video: Managing Work in Visual Studio Online")

## Code Snippets
Add some some description about how to use tabbed code snippets


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


