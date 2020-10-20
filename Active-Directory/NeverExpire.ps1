

# This PowerShell Command will query Active Directory and return all admin accounts 
# You can easily change the number of days from 30 to any number of your choosing

# Email notification will be sent to email@domain.com

# Note: This script needs to be run with administrator priviledges.
#       If script is not run with administrator priviledges,
#       Get-QADUser function will not return PasswordExpires and PwdLastSetattributes correctly.
#
#       You might need to sign the powershell script so that it can run inbatch mode (as opposed to interactive mode).
#       To do that, you will need to run elevated command prompt, runpowershell (by typing powershell on the command prompt),
#       next, type "set-executionpolicy RemoteSigned" (without the doublequotes) on the powershell prompt.



#####################
# Variables to change
#####################


# SMTP Server to be used
$smtp = "IP"

# "From" address of the email
$from = "email@domain.com"

# Administrator email
$admin = "email@domain.com"

# Web address of your OWA url - tested only with Exchange 2007 SP2
$OWAURL = "email@domain.com"

# First name of administrator
$AdminName = "Name"

# Define font and font size
# ` or \ is an escape character in powershell
$font = "<font size=`"3`" face=`"Calibri`">"



##########################################
# Should require no change below this line
# (Except message body)
##########################################

# AD List for Corp Domain Administrators 
Search-ADAccount -PasswordNeverExpires

# AD Output for Corp Domain Administrators
$string = Search-ADAccount -PasswordNeverExpires | Select-Object  Name, SamAccountName | Sort-Object -property name | ConvertTo-Html -fragment | Out-string


# Send Email to Techops
function Send-Mail{
param($smtpServer,$from,$to,$subject,$body)
$smtp = new-object system.net.mail.smtpClient($SmtpServer)
$mail = new-object System.Net.Mail.MailMessage
$mail.from = $from
$mail.to.add($to)
$mail.subject = $subject
$mail.body = $body
# Send email in HTML format
$mail.IsBodyHtml = $true
$smtp.send($mail)

}

# Newline character
#$newline = [char]13+[char]10
$newline = "<br>"

# Get today's day, date and time
$today = (Get-date)

# Loads the Quest.ActiveRoles.ADManagement snapin required for thescript.
# (Will unload once powershell is exited)
add-pssnapin "Quest.ActiveRoles.ADManagement"

# If there are computers than have not Logged in within $LL
# Email notification to administrator
$to = $admin
$subject = "Users Set to Never Expire $today"

                # Message body is in HTML font          
                $body = $font
                $body += "Dear Administrators,"
				$body += $newline
				$body += $newline
				$body += " The following accounts are set to never expire."
				$body += $newline
				$body += $newline
				$body += " Please contact Info Sec at infosec@ingomoney.com with any questions or concerns"
				$body += $newline
				$body += $newline
				$body += $string
				
				
                # Put a timestamp on the email
                $body += $newline + $newline + $newline + $newline
                $body += "<h5>Message generated on: " + $today + ".</h5>"
                $body += "</font>"

                # Invokes the Send-Mail function to send notification email
                Send-Mail -smtpServer $smtp -from $from -to $to -subject $subject -body $body


# End of script 
