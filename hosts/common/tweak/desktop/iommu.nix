{ config, ... }: {
  boot = {
    kernelParams = [
      "intel_iommu=on"
      "amd_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
    ];
  };
}
