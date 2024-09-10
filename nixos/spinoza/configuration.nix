{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.templates

    # Or modules from other flakes (such as nixos-hardware):
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./pkgs.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  fonts.enableDefaultPackages = true;

  networking.hostName = "spinoza";
  networking.hostId = "4c0902ca";

  templates = {
    apps = {
      modernUnix.enable = true;
      monitoring.enable = true;
    };
    hardware.nvidia.enable = true;
    services = {
      docker.enable = true;
      nvidiaDocker.enable = true;
      podman = {
        enable = true;
        user = "annie";
      };
      printer.enable = true;
      smartdWebui.enable = true;
    };
    system = {
      grub.enable = true;
      desktop = {
        enable = true;
        waydroid.enable = true;
        sddm.enable = true;
        portals = with pkgs; [
          xdg-desktop-portal-wlr
          kdePackages.xdg-desktop-portal-kde
        ];
        users = ["annie"];
      };
    };
  };

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIC7TCCApSgAwIBAgIRAIWisNznNkvOupRUcPslXscwCgYIKoZIzj0EAwIwgbkx
      CzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNU2FuIEZyYW5jaXNj
      bzEaMBgGA1UECRMRMTAxIFNlY29uZCBTdHJlZXQxDjAMBgNVBBETBTk0MTA1MRcw
      FQYDVQQKEw5IYXNoaUNvcnAgSW5jLjFAMD4GA1UEAxM3Q29uc3VsIEFnZW50IENB
      IDE3NzYzMjA2MjczNjMxOTEyNjI1ODEyNzAyMzYwODc2NjQ4ODI2MzAeFw0yNDA5
      MDYwMjEyNDhaFw0yOTA5MDUwMjEyNDhaMIG5MQswCQYDVQQGEwJVUzELMAkGA1UE
      CBMCQ0ExFjAUBgNVBAcTDVNhbiBGcmFuY2lzY28xGjAYBgNVBAkTETEwMSBTZWNv
      bmQgU3RyZWV0MQ4wDAYDVQQREwU5NDEwNTEXMBUGA1UEChMOSGFzaGlDb3JwIElu
      Yy4xQDA+BgNVBAMTN0NvbnN1bCBBZ2VudCBDQSAxNzc2MzIwNjI3MzYzMTkxMjYy
      NTgxMjcwMjM2MDg3NjY0ODgyNjMwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARI
      9MxsIM6OymC0JyGImNguABaNRpX64RRSppwGHrDmZy5lgqJ68A0Nqoj0fo3uz+61
      oFtnI9A/KQfmm/4TsVBao3sweTAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUw
      AwEB/zApBgNVHQ4EIgQgI+5itqkQn2m90pYah5qVoNUqziWEku4jYWS6ilRGdeww
      KwYDVR0jBCQwIoAgI+5itqkQn2m90pYah5qVoNUqziWEku4jYWS6ilRGdewwCgYI
      KoZIzj0EAwIDRwAwRAIgRsLkNo1D6xinqAE7+EeXO3UCEhs/TPSGUaJOSYQxWzIC
      IGHtUk5EwGADsf2EeMBXDCczidePNvxXd/RvQBr4jOtM
      -----END CERTIFICATE-----
    ''

    ''
      -----BEGIN CERTIFICATE-----
      MIIEODCCAyCgAwIBAgIUb9KIf40Xkalh7159oXXFCwqjmZUwDQYJKoZIhvcNAQEL
      BQAwGzEZMBcGA1UEAxMQaXBhYy5jYWx0ZWNoLmVkdTAeFw0yNDA5MDkyMzA3MDFa
      Fw0yOTA5MDgyMzA3MzFaMEQxQjBABgNVBAMTOWlwYWMuY2FsdGVjaC5lZHUgRXVj
      bGlkIEludGVybWVkaWF0ZSBBdXRob3JpdHkgZm9yIENvbnN1bDCCASIwDQYJKoZI
      hvcNAQEBBQADggEPADCCAQoCggEBAPR/lC2dY/5SuxSCU/ZCfuleexlhOvB0NEi1
      mMCPCUJ+I5BXlKEuPzC5NzvhFQC3ZAJE2BzRum5293vroK7Tlv3N8t4WciUA2O5g
      U31FIIZGyKeZDJ24jBUp2tj8pLoQVvGeM7xnQoSQUXtdQPdXFKzQzMyklhbo4mmj
      EySgS9M87d9LoTC5+tMWaLvIra3gPiNwa01HheUiYUnXSgjNibu/3iwjV8PVUD4B
      mKPQ6zbwBmZVt4NTHl3X7YqXC4DKNcIvwtlqgRuNnVLcQxsp/h43EbIxxyWFnXI0
      0axl241YxmbdJ9ZOdIRSAAh/5NewAaiWFygfouDgDigfeXpPZ/UCAwEAAaOCAUkw
      ggFFMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBR9
      TP5RRHrMwVIQnR8W9HqBp17yHTAfBgNVHSMEGDAWgBTPxqBBLMEja6osN9CdakxI
      GgWWgzCBmAYIKwYBBQUHAQEEgYswgYgwQwYIKwYBBQUHMAGGN2h0dHBzOi8vZXVj
      bGlkdm10ZXN0OC5pcGFjLmNhbHRlY2guZWR1OjgyMDAvdjEvcGtpL29jc3AwQQYI
      KwYBBQUHMAKGNWh0dHBzOi8vZXVjbGlkdm10ZXN0OC5pcGFjLmNhbHRlY2guZWR1
      OjgyMDAvdjEvcGtpL2NhMEcGA1UdHwRAMD4wPKA6oDiGNmh0dHBzOi8vZXVjbGlk
      dm10ZXN0OC5pcGFjLmNhbHRlY2guZWR1OjgyMDAvdjEvcGtpL2NybDANBgkqhkiG
      9w0BAQsFAAOCAQEAW6pKw7jCkZc7JOS928njQR9kmbdfYWnpMhS78FU4As7zE/O7
      iYQsxZWqXPuBrbK8HjVbDc8T0YGvFqdmIERaY0HH6Bsnf/DYkfB4jcp+iHyH3IFq
      KSuFFnKHIeV1nAhwcG9ds6bj8wuzdhjnaJPawXdsZ+FDBHnC7RYY24gLr2LzlvD0
      eD4NT9rsFJwgCLtHB+h8Kjoh23W0vtDFa7ZlaDBHvqHLV1ezil2RFAxhS4kg3aib
      iKuj7GvTDUAvlmJN4RZl9g3Q3KOr7eNoZwNGZracx/7UbNOA3KFjXqkPTr6bckKq
      GzOQp6thxav+FjXw+pSpM1qsLy8R4QPkYYx/LA==
      -----END CERTIFICATE-----
      -----BEGIN CERTIFICATE-----
      MIIELDCCAxSgAwIBAgIUZgWfckbbOoKCsmnvmA7ogasXx4kwDQYJKoZIhvcNAQEL
      BQAwGzEZMBcGA1UEAxMQaXBhYy5jYWx0ZWNoLmVkdTAeFw0yNDA5MDkyMzAyMjJa
      Fw0zNDA5MDcyMzAyNTJaMBsxGTAXBgNVBAMTEGlwYWMuY2FsdGVjaC5lZHUwggEi
      MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDEZx2FzGCaRWHmsEEP7ElyJvdG
      zMoZg34XGSB+u1wzTP5TRU2HW9VdW5jszqqi4XSDYst/8G5v30HKprXdGcTuPgcB
      l+9zEcstK0JT05d+48I6zfvAvhnpgQwtw9yg7LGbceRoYck5TOC1xgQwmIsgfCcW
      fAOkvLm+WbCxOq3JmL3BzuJGu+MmvPYv2wo5Et4jMT+hu3+RAs9cxfFAYVLIn39D
      ZKwHX+fW/J2drrYwdmtEtMOj2I1SaDmHrYkla+mJu1K6G0qSmZTIrQqxFvthCKdt
      dqCpbXzinPhnvip89GjA+K4em2Lqj/ElNgcssaF0dB9FQlhjjJ+eANwVsiTDAgMB
      AAGjggFmMIIBYjAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNV
      HQ4EFgQUz8agQSzBI2uqLDfQnWpMSBoFloMwHwYDVR0jBBgwFoAUz8agQSzBI2uq
      LDfQnWpMSBoFloMwgZgGCCsGAQUFBwEBBIGLMIGIMEMGCCsGAQUFBzABhjdodHRw
      czovL2V1Y2xpZHZtdGVzdDguaXBhYy5jYWx0ZWNoLmVkdTo4MjAwL3YxL3BraS9v
      Y3NwMEEGCCsGAQUFBzAChjVodHRwczovL2V1Y2xpZHZtdGVzdDguaXBhYy5jYWx0
      ZWNoLmVkdTo4MjAwL3YxL3BraS9jYTAbBgNVHREEFDASghBpcGFjLmNhbHRlY2gu
      ZWR1MEcGA1UdHwRAMD4wPKA6oDiGNmh0dHBzOi8vZXVjbGlkdm10ZXN0OC5pcGFj
      LmNhbHRlY2guZWR1OjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsFAAOCAQEA
      W9FzI+AnVpM4dzwAr1F+2839ML2QiKItIM8wqwBVdLmSPlPCXmJMtk6ikelyisZi
      6nCGZ/OlDak0z3579socsI/icUOc8BjgMZwwpoVzpOn0NMVfc4P/Bdh8psfE2vjv
      XoOKqqInd0p+VMODeVtF6ID+ZVaZwSxKHJ3sHThYjqIJywHhgIUv9kDC9W/VRdDa
      mSVNFRUYV2cAY5dlwX2ka3dDab2YlrSja+VYzM2NBZselmCsydTXM+qrPIg2KYDt
      l9s1KkRDFuAHDy2ipHoXOQth7/nDv3P1tay73Nmv54+rNczHEsZivutTY129zhHv
      OMCfffM+OIX/p9k7qjMqig==
      -----END CERTIFICATE-----
    ''
  ];
}
