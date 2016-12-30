# zero-disk
.Synopsis
   Zero fills a drive to deflate virtual disk
   
.DESCRIPTION
   Creates a file containing zeros the size of 10% less than the total freesize of the specified drive letter.
   
.EXAMPLE
   zero-drive -driveletter c:
   
.INPUTS
   -driveletter "Specify the driveletter in c: format"
   
.OUTPUTS
   Array of strings representing created linked clones.
   
.NOTES
   All inputs are mandatory.
   Does not work for NTFS folder mounts (junctions).
   Assumes write permissions exist for <driveletter>:\ to create temp folder, or temp folder already exists.
   Goal of code is to be a faster solution to sdelete.exe -z
   
.Link
	https://github.com/good-paste/zero-drive
        
.COMPONENT
   The component this cmdlet belongs to nothing.
   
.ROLE
   The role this cmdlet belongs to nothing.
   
.FUNCTIONALITY
   Creates a file containing zeros the size of 10% less than the total freesize of the specified drive letter.
