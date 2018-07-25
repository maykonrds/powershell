<#PSScriptInfo
.VERSION 1.0
.AUTHOR Maykon Rodrigues dos Santos
.DATA July 2018
#>

<#
    .SYNOPSIS
    Install Solr
    .DESCRIPTION
    Install Solr 6.6.2
    .EXAMPLE
     .\Install-solr 
     
#>
Param(
    [Parameter(Mandatory=$true)]
    [string]$Project,
    [Parameter(Mandatory=$true)]
    [int]$Port,
    [string]$SourceBin="C:\Solr\Solr6.6.2\bin",
    [string]$SourceServer="C:\Solr\Solr6.6.2\server",
    [string]$Destination="C:\Solr\",
    [string]$Java="C:\Program Files\Java\jre1.8.0_151\bin\keytool.exe",
    [string]$Nssm="C:\Util\nssm-2.24\win64\nssm.exe"    
)
if(-not($Project)) { Throw "You must supply a value for -Project" }
if(-not($Port)) { Throw "You must supply a value for -Port" }

Write-Host "Your Project Name is:" $Project " and your Port is" $Port
$PortString = $Port
$Folder = $Destination+$PortString+"_"+$Project
$ServiceName = "$PortString"+"_"+"$Project"
Write-host $Folder

function CreateDirCopy {

Write-Host "Creating a directory..."
# Create a Directory
New-Item -ItemType directory -Path $Folder
#Copy a Directory to new folder
Copy-Item $SourceBin,$SourceServer -Destination $Folder -Recurse
}

function CreateJavaCert {

cd "$Folder\server\etc\"
Write-Host "creating the certificate...."
& $Java -genkeypair -alias "$Project-solrssl" -keyalg RSA -keysize 2048 -keypass MyPassword -storepass MyPassword -validity 9999 -keystore $Project-solrssl.keystore.jks -ext SAN=DNS:$Project-solr.linear.local -dname "CN=$Project, OU=DevOps, O=Valtech, L=Ottawa, ST=Ontario, C=CA"
& $Java -importkeystore -srckeystore $Project-solrssl.keystore.jks -destkeystore $Project-solrssl.keystore.p12 -srcstoretype jks -deststoretype pkcs12 -keystore "$Project.p12" -deststorepass MyPassword -srcstorepass MyPassword
}

function UpdateFileSolr {

cd "$Folder\bin"
Write-Host "Update the solr.in.cmd file..."
Add-Content solr.in.cmd "set SOLR_SSL_KEY_STORE=etc/$Project-solrssl.keystore.jks"
Add-Content solr.in.cmd "set SOLR_SSL_KEY_STORE=etc/$Project-solrssl.keystore.jks"
Add-Content solr.in.cmd "set SOLR_SSL_KEY_STORE_PASSWORD=MyPassword"
Add-Content solr.in.cmd "set SOLR_SSL_TRUST_STORE=etc/$Project-solrssl.keystore.jks"
Add-Content solr.in.cmd "set SOLR_SSL_TRUST_STORE_PASSWORD=Mypassword"
Add-Content solr.in.cmd "set SOLR_SSL_NEED_CLIENT_AUTH=false"
Add-Content solr.in.cmd "set SOLR_SSL_WANT_CLIENT_AUTH=false"
}

function ImportCertWindows {

cd "$Folder\server\etc\"
Write-Host "Import the Certificate the certificate...."
$Password="MyPassword"
$SecurePassword = ConvertTo-SecureString –String $Password -AsPlainText -Force
Import-PfxCertificate -FilePath "$Project.p12" -CertStoreLocation cert:\LocalMachine\AuthRoot -Password $SecurePassword

}

function CreateService {

Write-Host "Creating the Service...."
$SolrCMD="$Folder\bin\solr.cmd"
& $Nssm install $ServiceName $SolrCMD
& $Nssm set $ServiceName AppParameters start -f -p $Port
& $Nssm set $ServiceName Start SERVICE_AUTO_START
& $Nssm set $ServiceName Description "Solr 6.6.2 ($Project)"
& $Nssm set $ServiceName AppDirectory "$Folder\bin"
& $Nssm set $ServiceName DisplayName "Solr 6.6.2 ($Project)"

Write-Host "Starting the Service..."
Get-Service $ServiceName | Start-Service
}

CreateDirCopy
CreateJavaCert
UpdateFileSolr
ImportCertWindows
CreateService 
