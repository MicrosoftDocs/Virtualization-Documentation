ms.ContentId: 71D00223-0505-4CED-84E4-581351975FED
title: Frequently Asked Questions


# Frequently Asked Questions #

## What is this? ##
This is an answer.

## Why is this? ##
I'm not telling.

## Where am I? ##
You're in a baloon.

ms.TocTitle: Contacts tasks in Visual Studio
Title: Common contacts tasks using the Visual Studio client library
ms.ContentId: cd2f31f7-3bb2-43c5-a320-db20f591f81f
ms.topic: article (how-tos)


# Common contacts tasks using the Office 365 client library

    
 _**Applies to:** Exchange Online | Office 365_

The Office 365 APIs .NET and JavaScript client libraries can make it easier interact with the REST APIs. They help manage authentication tokens, simplify the code needed to query and consume data, and perform discovery.
 You can get the libraries in the latest version of [Office 365 API Tools for Visual Studio](http://aka.ms/clientlibrary). Or you can dive right in and
 [try out a starter project for Windows Store Apps](#http://aka.ms/o365-apis-start-windows).

Alternatively, you can use the [Contacts REST APIs](..\api\contacts-rest-operations.md) to interact with Office 365 contacts data.

## Use the client library with the Contacts API

To access the Contacts API by using the .NET or JavaScript client library, you need to acquire an access token and get the Outlook Services client. Then, you can send async queries
 to interact with contacts data.

[Acquire an access token](#GetAuthToken) | [Get the Outlook Services client](#GetClient) 


[Get contacts](#GetContacts) | [Create contacts](#CreateContacts) | [Update contacts](#UpdateContacts) | [Delete contacts](#DeleteContacts)


[Get contact folders](#GetContactFolders) <!--| [Create contact folders](#CreateContactFolders) | [Update contact folders](#UpdateContactFolders) | [Delete contact folders](#DeleteContactFolders)-->


<a name="GetAuthToken"> </a>
## Acquire an access token

Acquire the access token used for authentication. The client ID and authorization URI are assigned when you register your app with Microsoft Azure Active Directory. 

**Note** In a Windows Store App, values for ClientID and AuthorizationUri are added to your project's App.xaml file when you register your application.
 AuthorizationUri is used as the host name for the CommonAuthority variable.

<!-- BEGINSECTION class="tabbedCodeSnippets" -->

```cs
// Properties of the native client app.
public const string ClientID = "dc180c60-..."; 
public static Uri ReturnUri = "http://redirecturi";

// Properties used to communicate with a Windows Azure AD tenant.  
public const string CommonAuthority = "https://login.windows.net/Common"; 
public const string DiscoveryResourceId = "https://api.office.com/discovery/"; 

public static AuthenticationContext AuthenticationContext { get; set; } 
public static async Task<string> AcquireTokenAsync(AuthenticationContext context, string resourceId)
{
    string accessToken = null;
    try
    {
        // Try to get the AccessToken silently using the resourceId that was passed in
        // and the client ID of the application.
        accessToken = 
           (await context.AcquireTokenSilentAsync(resourceId, ClientID)).AccessToken;
    }
    catch (Exception)
    {
        // If unable to acquire the AccessToken silently, try again with full prompting. 
        accessToken = null;
    }
    if (accessToken == "" || accessToken == null)
    {
        AuthenticationResult result = 
            (await context.AcquireTokenAsync(resourceId, ClientID, ReturnUri));
        accessToken = result.AccessToken;
    }
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