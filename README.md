Presentation: https://docs.google.com/presentation/d/1zzcCbEYrDiBCWtw_o1lc28PmNVYwxb6gffj2qNaPJKU/edit?usp=sharing


Steps for WIN-ACME set up with binding script injection. [![Watch the demo](https://github.com/user-attachments/assets/4032e556-3542-4d8b-bc6c-fb0ff8360fe5)](https://github.com/user-attachments/assets/4032e556-3542-4d8b-bc6c-fb0ff8360fe5)


*Note*: As this was an investigation, the demo uses `localhost`, which Let's Encrypt cannot validate. A real public domain is required for successful certificate issuance. The configuration steps and script remain identical in a production environment; only domain validation differs.
Steps demonstrated:

1. Launch win-acme (wacs.exe), select M: Create certificate (full options)
2. Choose domain source — Manual input → enter domain name
3. Choose certificate scope — Single certificate
4. Choose validation method (HTTP-01 in production; Manual selected here since localhost can't be validated)
5. Choose private key type — RSA
6. Choose certificate storage — Windows Certificate Store (Local Computer) → store: My
7. Configure installation step — Start external script or program
8. Specify script path and parameters:

```
-NewThumbprint {CertThumbprint} -OldThumbprint {OldCertThumbprint}
```

*Result*: Configuration completed successfully up to the validation step, confirming the script hook and parameter substitution were correctly set up. In production with a real domain, validation would succeed automatically and trigger the script exactly as configured here
