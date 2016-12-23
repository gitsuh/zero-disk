function zero-drive {
<#
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
.Link
	https://github.com/good-paste/zero-drive
.COMPONENT
   The component this cmdlet belongs to nothing.
.ROLE
   The role this cmdlet belongs to nothing.
.FUNCTIONALITY
   Creates a file containing zeros the size of 10% less than the total freesize of the specified drive letter.
#>
	[CmdletBinding()]  
	Param(
		[Parameter(Mandatory=$true)]
		[string]$driveletter
		)
	Begin {  
		Write-Verbose "Preparing environment." 
		Write-Host "Input drive letter (example: C: D: F:)"
		$starttime = get-date
		$drive = ($driveletter).ToUpper()
		$folder = "\temp\"
		$filename = "tempzerofill"
		$tempfile = $drive + $folder + $filename
		New-Item -ItemType Directory -Force -Path ($drive + $folder)
		if(Test-Path $tempfile) {
			Remove-Item $tempfile -Force
		}
		$freespace = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$drive'").freespace/1024/1024/1024
		$freespace = $freespace - ($freespace * .1)
		$arraysize= 1mb
		$append = "GB"
		$fileSize= [string]$freespace + $append
		$buffer = new-object byte[]($arraysize)
		$stream = [io.File]::OpenWrite($tempfile)
	}
	Process {
		Write-Host "Creating $filesize zero fill temp file"
		try {
			$size = 0
			while($size -lt $fileSize) {
				$stream.Write($buffer, 0, $buffer.Length);
				$size += $buffer.Length;
			}
		} Catch {
			write-host "failure"
			Write-host $_
		}
		finally {
			if($stream) {
				$stream.Close();
			}
			$elapsedtime = New-TimeSpan -Start $starttime -End (Get-Date)
			$elapsedtime | select TotalMinutes
		}
	}
	End {
	
		read-host
		Remove-Item $tempfile
	}
}