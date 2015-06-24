ms.ContentId: 600CCB5B-AEF0-43FB-A23D-108B81413C23
title: Fix build breaks

# How to fix build breaks #

Here are some examples of build issues and the fixes.

## Transform errors ##


**Error**
```Build FAILED.

       "d:\src\979\VSOnline\MSDN.Hyperv.Working\src\publish.mdproj" (ReBuild;Clean target) (1) ->
       "d:\src\979\VSOnline\MSDN.Hyperv.Working\src\packages\OpenAuthoringPublishingBuild.1.1.11\build\net451\OpenAuthoringPublishing.mdproj" (Rebuild target) (2) ->
       (Transform target) -> 
         Transform : error : 6/22/2015 12:38:38 PM: Error:Transform Errors=[Path=virtualization\internal\contribute_to_the_docs.md; Category=Error; Message=The 'branch' start tag on line 112 position 16 does not match the end tag of 'p'. Line 113, position 15.] [d:\src\979\VSOnline\MSDN.Hyperv.Working\src\packages\OpenAuthoringPublishingBuild.1.1.11\build\net451\OpenAuthoringPublishing.mdproj]

    0 Warning(s)
    1 Error(s)```

**Resolution**

This error was caused by an issue with "code" tags. Markdown pad just uses 5 spaces of indentation to have something appear as code, but it is better to use triple-ticks ( 3 of these: `` ) to mark something as code. In case `` is confusing, it is the lower case character on the tilda (~) key.

