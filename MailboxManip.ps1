
# Mailbox manipulation functions
#--------------------------------
# Manage forwarding rules.
function mailfoward {
	Write-Output ""
	Write-Output "Mail Fowarding"
	Write-Output ""
}
# Manage Mailbox Alias/Identity.
function mailname {
	Write-Output ""
	Write-Output "Mail Name"
	Write-Output ""
}
# Manage Mailbox Type.
function mailtype {
	Write-Output ""
	Write-Output "What would you like this mailbox to be?"
	Write-Output ""
	Write-Output "| [1] User | [2] Shared | [0] Exit |"
	Write-Output ""
	switch(readline){
		1 {$typeReturn = "Regular"; break}
		2 {$typeReturn = "Shared"; break}
		0 {break}
	}
	return $typeReturn
}
# Mailbox Menu.
# The menu function also runs getuser to return the $unReturn varilable containing the user mailbox array /
# and uses it to get the mail type independantly.
# This allows the getuser function to be used elseware since the specific info required is added on to the results /
# from the getuser function.
function modmailbox {
	Write-Output ""
	getuser
	Write-Output ""
	Write-Output ("User mailbox is type: " + $unReturn.RecipientTypeDetails)
	Write-Output ""
	Write-Output "| [1] Name | [2] Type | [3] Delegation | [4] Forwarding | [0] Exit |"
	Write-Output ""
	switch(readline){
		1 {mailname}
		2 {mailtype; Set-Mailbox -Identity $unReturn.Identity -Type $typeReturn; Write-Output ("Mailbox of " + $unReturn.DisplayName + " has been set to " + $typeReturn + ".")}
		4 {mailforward}
	}
}

# Misc functions
#----------------
# This function allows the script to have a '->' on inputs rather than ':'.
function readline {
	Write-Host "-> " -NoNewLine
	$input = $Host.UI.ReadLine()
	return $input
}
# Get all mailboxes and display DisplayName and PrimarySMTPAddress objects in Table format.
# Format-Table used here to prevent select input hang (Removed select and just used Format-Table).
function getmail {
	$mailbox = Get-Mailbox -Identity "*" 
	$mailbox | Format-Table DisplayName, PrimarySMTPAddress -wrap -autosize
	Menu
}
# Grabs specified user details.
# Script returns $unReturn to allow other scripts to utilise retreived array for more specific use cases.
function getuser {
	$targuser = Read-Host "Select user"
	$unReturn = Get-Mailbox -Identity $targuser
	Write-Output ""
	Write-Output ("Display Name: " + $unReturn.DisplayName + " | Email: " + $unReturn.PrimarySMTPAddress)
	Write-Output ""
	return $unReturn
}

# Main functions
#----------------
# Disconnects from Exchange Online upon exit.
# Should probably make this a catch exit code.
# Too work on.
function exitexch {
	Disconnect-ExchangeOnline
}
# Connects to Exchange Online.
# Runs on script start before entering menu.
# Possible optimisations to be made regarding stack.
function initialize {
	Connect-ExchangeOnline
	Menu
}
# Main menu for script.
# Current system is bad. Too look into and optimise / improve.
function Menu {
	Write-Output "Please select your choice"
	Write-Output "| [1] Get Users | [2] Modify Mailbox | [0] Exit |"
	Write-Output ""
	switch(readline){
		1 {getmail}
		2 {modmailbox}
		0 {exitexch}
	}
}

initialize
