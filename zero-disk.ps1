function zero-disk {
<#
.Synopsis
   Zero fills a drive to deflate virtual disk (mostly stolen from an EMC script)
.DESCRIPTION
   Creates a file containing zeros the size of 5% less than the total freesize of the specified drive letter.
.EXAMPLE
   zero-disk -driveletter c:
.INPUTS
   -driveletter "Specify the driveletter in c: format"
.OUTPUTS
   Array of strings representing created linked clones.
.NOTES
   All inputs are mandatory.
   Does not work for NTFS folder mounts (junctions).
   Assumes write permissions exist for <driveletter>:\ to create temp folder, or temp folder already exists.
   Goal of code is to be a faster solution to sdelete.exe -z
.COMPONENT
   The component this cmdlet belongs to nothing.
.FUNCTIONALITY
   Creates a file containing zeros the size of 5% less than the total freesize of the specified drive letter.
#>
	[CmdletBinding()]  
	Param(
		[Parameter(Mandatory=$true)]
		[string]$driveletter
		)
	Begin {  
		$starttime = get-date
		$drive = ($driveletter).ToUpper()
		$folder = "\temp\"
		$filename = "tempzerofill"
		$tempfile = $drive + $folder + $filename
		#assumes permissions to write to the specified root of drive, or "driveletter:\temp\" already exists
		New-Item -ItemType Directory -Force -Path ($drive + $folder)

		if(Test-Path $tempfile) {
			Write-Host "Deleting file $tempfile"
			Remove-Item $tempfile -Force
		}
		$freespace = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$drive'").freespace/1024/1024/1024
		$freespace = $freespace - ($freespace * .05)
		# 1MB for performance reasons VMFS
		$arraysize= 1mb
		$append = "GB"
		$fileSize= [string]$freespace + $append
		$buffer = new-object byte[]($arraysize)
		$stream = [io.File]::OpenWrite($tempfile)
	}
	Process {
		Write-Host "Creating $filesize zero fill temp file"
		Try {
			$size = 0
			while($size -lt $fileSize) {
				$stream.Write($buffer, 0, $buffer.Length);
				$size += $buffer.Length;
			}
		} Catch {
			Write-host "Write failure"
			#Write-host $_
		}
		Finally {
			if($stream) {
				$stream.Close();
			}
			$elapsedtime = New-TimeSpan -Start $starttime -End (Get-Date)
			$elapsedtime | select TotalMinutes
		}
	}
	End {
	
		Write-host "Deleting $tempfile"
		Remove-Item $tempfile
	}
}
