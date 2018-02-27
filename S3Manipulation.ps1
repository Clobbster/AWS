#################################################################################################
# This script checks for local backups of Jira and then moves them to an appropriate S3 bucket
# In order for this script to be utilized, you must have first installed the AWS Tools located at:
# https://aws.amazon.com/powershell/
#
# You will also have to ensure that this script is run on a scheduled task if you want it to run
# more than once.
#################################################################################################


$s3Bucket   = "" 
$secretKey  = "" 
$accessKey  = "" 
$awsRegion  = ""
$localFiles = ""

#Modify this variable to extend the range of files to be uploaded based on date
$dateRange   = (Get-Date).AddDays(-1)


#Test connectivity to S3 bucket
If (Get-S3Bucket -BucketName $s3Bucket -AccessKey $accessKey -SecretKey $secretKey -Region $awsRegion){
    Write-Host -ForegroundColor Green "Successfully connected to S3 Bucket"
}else{
    Write-Host -ForegroundColor Red "Could not connect to S3 bucket specified"
} 

#Check folder daily for new files at path D:\Program Files\Atlassian\Application Data\JIRA\export
Get-childItem -Path $localFiles | ? {$_.Name -like "*--1900.zip" -and $_.CreationTime -ge $dateRange} | % {

    #Move files to S3 bucket if file is new 
    Write-Host -ForegroundColor Green "Moving ***" $_.Name.ToUpper() "*** to S3 bucket named" $s3Bucket.ToUpper()
    #Write-S3Object -BucketName $s3Bucket -AccessKey $accessKey -SecretKey $secretKey -Region $awsRegion -File $_.FullName

}



#Lists all file names in S3 Bucket name alkami-jira-backups
$fileNames = (Get-S3Object -BucketName $s3Bucket -AccessKey $accessKey -SecretKey $secretKey -Region $awsRegion).key
echo $fileNames
