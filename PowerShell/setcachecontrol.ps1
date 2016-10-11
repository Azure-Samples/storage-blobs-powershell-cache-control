#connection info
$StorageName="your storage account name"
$StorageKey="your storage accout key”
$ContainerName="videofile" 
$BlobUri="https://yourstorageaccountname.blob.core.chinacloudapi.cn/"+$ContainerName

#get all the blob under your container
$StorageCtx = New-AzureStorageContext -StorageAccountName $StorageName -StorageAccountKey $StorageKey
$blobs = Get-AzureStorageBlob -Container $ContainerName -Context $StorageCtx 

#creat CloudBlobClient
Add-Type -Path "C:\Program Files\Microsoft SDKs\Azure\.NET SDK\v2.9\ref\Microsoft.WindowsAzure.StorageClient.dll"
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
