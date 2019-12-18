# Introduction

This extension has 2 tasks:

- Deploy to Azure Analysis Services
- Add member to existing role in Azure Analysis Services database/model

After having build an Analysis Services project, it will have produced an `.asdatabase` file alongside with other XML files for deployment. By using `Microsoft.AnalysisServices.Deployment.exe`, an `XMLA` file can be used. Together those files can be used for deployment and you might want to edit some of them before doing so. This task uses the `Invoke-AsCmd` cmdlet from the `SqlServer` PowerShell module to deploy to Azure Analyis Services using the provided service endpoint.

The 2nd task uses the `Add-RoleMember` cmdlet of the `SqlServer` PowerShell module to add members to existing roles as there are scenarios where this is sometimes not possible as part of the deployment and therefore this tasks adds the members later.
