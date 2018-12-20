# HTTPS in development

## Understanding why
In order to integrate with DfE Sign-in's Open ID Connect service we are required to communicate over https instead of http in all environments.

https://github.com/DFE-Digital/login.dfe.oidc

## Getting set up for development

You will need 4 files for this task. Ask the dev team for a copy of them or generate them yourself :

- RootCA.pem
- RootCA.key
- local.key
- local.crt

1. Open Keychain Access on your Mac and go to the Certificates category in your System keychain. Once there, import the `rootCA.pem`  `File > Import Items`. Double click the imported certificate and change the “When using this certificate:” dropdown to Always Trust in the Trust section.

## Repeating the process
This guide was used to create the required components and configure a development machine properly of which only the local.crt and local.key have been committed to source control: https://medium.freecodecamp.org/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec

Should the Root CA pem and key files be lost or need replacing, follow this guide and replace the local.crt and local.key in this repository and redistribute to all developers.
