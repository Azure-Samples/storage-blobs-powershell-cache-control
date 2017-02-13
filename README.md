---
services: storage blobs
platforms: powershell
author: msonecode
---

# How to set storage blob cache-control Properties by PowerShell script

## Introduction
Setting **Cache-Control** on [Azure Blobs][1] can help reduce bandwidth and improve the performance by preventing consumers from having to continuously download resources. 

**Cache-Control** allows you to specify a relative amount of time to cache data after it is received. It is strongly recommended if you need the control over the completed cache.

We used to set the cache-control property of blob files through azure portal or windows azure storage explore. However, if you want to set the cache-control property for each file in your blob, such method will be a waste of time. Besides, you may also need to change this property overtimes. A better way to do this is creating a C# program using Azure Storage Client assembly and setting it.

However, this blog considers using PowerShell script to do the same work because it’s more convenient to change the property. This example is to help us set storage blob cache-control properties by PowerShell script. One thing to be noticed is that we still need to use **"Microsoft.WindowsAzure.StorageClient.dll"** to access the blobs.

## Scenario
You need to set storage blob cache-control property or easily check cache-control property through PowerShell script. 

## Requirements
- PowerShell Version > 3.0
- Windows Azure PowerShell > 1.0.0

## Example
```ps1
#set Properties 
$blobRef.Properties.CacheControl = $cacheControlValue 
$blobRef.SetProperties() 
```

## Script
The content of the script is reproduced at below.
- Download and install the latest PowerShell. Then, connect it to your subscription.  
```ps1
Import-AzurePublishSettingsFile -Environment AzureChinaCloud E:\PublishSettings\CIETest03-12-9-2015-credentials.publishsettings 
```
- Set the value of Properties and Metadata  
```ps1
#connection info 
 
$StorageName="your storage account name" 
 
$StorageKey="storage Key” 
 
$ContainerName="containername" 
 
$BlobUri="https://yourstorageaccountname.blob.core.chinacloudapi.cn/"+$ContainerName 
 
  
 
#get all the blob under your container 
 
$StorageCtx = New-AzureStorageContext -StorageAccountName $StorageName -StorageAccountKey $StorageKey 
 
$blobs = Get-AzureStorageBlob -Container $ContainerName -Context $StorageCtx 
 
  
 
#creat CloudBlobClient 
 
Add-Type -Path "C:\Program Files\Microsoft SDKs\Windows Azure\.NET SDK\v2.3\ref\Microsoft.WindowsAzure.StorageClient.dll" 
 
$storageCredentials = New-Object Microsoft.WindowsAzure.StorageCredentialsAccountAndKey -ArgumentList $StorageName,$StorageKey 
 
$blobClient =   New-Object Microsoft.WindowsAzure.StorageClient.CloudBlobClient($BlobUri,$storageCredentials) 
 
  
 
#set Properties and Metadata 
 
$cacheControlValue = "public, max-age=60480" 
 
foreach ($blob in $blobs) 
 
{ 
 
   #set Metadata 
 
   $blobRef = $blobClient.GetBlobReference($blob.Name) 
 
   $blobRef.Metadata.Add("abcd","abcd") 
 
   $blobRef.SetMetadata() 
 
   
 
   #set Properties 
 
   $blobRef.Properties.CacheControl = $cacheControlValue 
 
   $blobRef.SetProperties() 
 
} 
```

- Test result: 
	- Before running the script:  The **Cache Control** is empty and the METADATA is empty too.  
	![][4]
	- Run script:  
    Type Command **Get-AzureAccount**  
	The Command Line will provide you with the AzureAccount infomation.  
    And Then Type Command **E:\TSG\readiness\Cognitive Services Readiness\setcachecontrol.ps1**
    ![][5]

	- Result:  
    The cache Control has been created, And The METADATA 
	![][6]

## See Also
- [Using Azure PowerShell with Azure Storage][2]
- [Set blob Properties][3]

[1]: http://www.windowsazure.com/en-us/develop/net/how-to-guides/blob-storage/?WT.mc_id=A52BDE99C
[2]: https://azure.microsoft.com/en-us/documentation/articles/storage-powershell-guide-full/
[3]: https://msdn.microsoft.com/en-us/library/azure/ee691966.aspx
[4]: images/1.png
[5]: images/2.png
[6]: images/3.png
