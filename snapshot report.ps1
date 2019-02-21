<# Script was put up together from couple of solutions provided (Like MAD MAX Interceptor - "Piece from here, piece from there.."
 Run this script from any server which have access to vCenter ( or multiple vCenters)
 Scrip to check snapshot in vCenter and send report vie Email
 Results will be dispalyed in HTML table#>

add-pssnapin VMware.VimAutomation.Core
$vCenter = 'vCenter'
#you can add here as many vCeneters as you like, only condition is that it can be accessed by credentials provided below
Connect-VIServer -Server $vCenter -User 'domain\user' -Password 'password'
# example: Connect-VIServer -Server vCenterName -User domain/admin -Password password1

# HTML definition
$a = "<style>"
$a = $a + "BODY{background-color:white;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;foreground-color: black;background-color: LightBlue}"
$a = $a + "TD{border-width: 1px;padding: 5px;border-style: solid;border-color: black;foreground-color: black;background-color: white}"
$a = $a + "</style>"

# Main section of check
Write-Host "Checking VMs for for snapshots"
$date = get-date
$datefile = get-date -uformat '%m-%d-%Y-%H%M%S'
$filename = "x:\dir\Snaps_" + $datefile + ".htm"

# Get list of VMs with snapshots
# Note:  It may take some time for the  Get-VM cmdlet to enumerate VMs in larger environments
$ss = Get-vm | Get-Snapshot
Write-Host "   Complete" -ForegroundColor Green
Write-Host "Generating VM snapshot report"
#$ss | Select-Object vm, name, description, powerstate | ConvertTo-HTML -head $a -body "<H2>VM Snapshot Report</H2>"| Out-File $filename
$ss | Select-Object vm, name, description | ConvertTo-HTML -head $a -body "<H2>VM Snapshot Report</H2>"| Out-File $filename
Write-Host "   Complete" -ForegroundColor Green
Write-Host "Your snapshot report has been saved to:" $filename

# Create mail message
$server = "smtp.domain.com"
$port = 25
$to      = "user@domain.com"
$from    = "user@domain.com"
$subject = "VM Snapshot Report for" + $vCenter
$body = Get-Content $filename

$message = New-Object system.net.mail.MailMessage $from, $to, $subject, $body

# Create SMTP client
$client = New-Object system.Net.Mail.SmtpClient $server, $port
# Credentials are necessary if the server requires the client # to authenticate before it will send e-mail on the client's behalf.
$client.Credentials = [system.Net.CredentialCache]::DefaultNetworkCredentials

# Try to send the message

try {
   
# Convert body to HTML
    $message.IsBodyHTML = $true
# Uncomment these lines if you want to attach the html file to the email message
#   $attachment = new-object Net.Mail.Attachment($filename)
#   $message.attachments.add($attachment)
   
# Send message
    $client.Send($message)
    "Message sent successfully"

}

#Catch error

catch {

    "Exception caught in CreateTestMessage1(): "

}