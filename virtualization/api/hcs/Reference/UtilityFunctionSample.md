# Utility Functions Sample Code

<a name = "CreateFilesGrantAccess"></a>
## Create the file and grant vm access to them

```cpp
// This assumes "Sample" has been used as the id for a compute system when created through HcsCreateComputeSystem
THROW_IF_FAILED(::HcsGrantVmAccess(L"Sample"), L"filepath.vmrs");
```
