# Where to Begin with the HCS

## Prepare include section

```cpp

#include <windows.h>
#include <winerror.h>
#include <wil\resource.h>

// HCS API header file
#include <computecore.h>
#include <computedefs.h>
#include <computenetwork.h>
#include <computestorage.h>

#include <hypervdevicevirtualization.h>

#pragma comment(lib, "computecore.lib")

```