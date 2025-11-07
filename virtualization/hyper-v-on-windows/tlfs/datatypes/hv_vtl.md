# HV_VTL

The HV_VTL data type represents a Virtual Trust Level (VTL) identifier used in the hypervisor's security model. VTLs provide different levels of trust and isolation within a partition, enabling secure execution environments.

## Syntax

```c
typedef UINT8 HV_VTL;
```

The HV_VTL is an 8-bit unsigned integer that identifies a Virtual Trust Level. Valid VTL values range from 0 to 15.

Higher numbered VTLs have greater privilege and can access resources from lower numbered VTLs, but not vice versa.

## See also

* [HvCallEnableVpVtl](../hypercalls/HvCallEnableVpVtl.md)
* [HV_VP_INDEX](hv_vp_index.md)
* [HV_PARTITION_ID](hv_partition_id.md)
