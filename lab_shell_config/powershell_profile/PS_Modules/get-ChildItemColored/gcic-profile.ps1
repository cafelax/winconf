# in case you don't know where your profile is:
#  c:\users\your_username\Documents\WindowsPowerShell\profile.ps1 - current user all hosts
#  c:\users\your_username\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 - current user current host
# so you could just save this as its own file in that directory and dot-source it into one of the above.

################
## ls - configuration

#first, import it:
Import-Module ($PSScriptRoot + "\get-ChildItemColored.psm1")

# user-defined colors. 'write-host -?' gives all of your choices.
# it's an array of hashes.
# you can override defaults or add new ones - these are processed first.

# 'ls variable:' will show these to you ; changing the values on the fly
# will let you override any color for the duration of your session:
#
# PS > $lscolor_dir = "black"
#
# what directories? ;)
#
# add one on the fly:
#
# $lscolor_userdef += @{'regex' = '\.iso$'; 'color' = 'DarkRed'}

$global:lscolor_userdef = @(
    @{
        "regex" = '\.(cfg|conf|ini|log)$';
        "color" = "Blue";
    },
    @{
        "regex" = '\.(htm|html|xml|csv)$';
        "color" = "Cyan";
    },
    @{ #compressed
        "regex" = '\.(zip|tar|gz|rar|7z|bz2|tgz|tcz)$';
        "color" = "Blue";
    }
    # ,
    # @{
    #   "regex" = '\.(xls|doc|ppt|xlsx|docx|odt|rtf|pdf)$';
    #   "color" = "DarkGreen";
    # }
)

#color of directories (this is the default)
# $global:lscolor_dir = "DarkCyan"
$global:lscolor_dir = "Yellow"

#color of hidden files' foreground/background when you do 'ls -force' (this -eq default)
$global:lscolor_hidden = "DarkRed"
$global:lscolor_hidden_bg = "DarkGray"

#set 'ls' and 'la' as aliases to g-cic
function gcic-Force { Get-ChildItemColored -Force }
set-alias ls Get-ChildItemColored -force -option allscope
set-alias la gcic-Force -option allscope

#I always set up bash to do this for me; it just prints the contents of a
#directory when you cd into it - save a couple of keystrokes.
#function cd-ls {
#   param($path)
#   try {
#       set-location $path -erroraction 'stop'
#       ls
#   } catch {"$_"}
#}
#set-alias cd cd-ls -force -option allscope
##
##################
