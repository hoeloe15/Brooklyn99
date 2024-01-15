# Set the directory path
$directory = "C:\Users\mark9\OneDrive\Documenten\GitHub\Brooklyn99\attachments"

# Get all files in the directory
$files = Get-ChildItem -Path $directory

# Loop through each file
foreach ($file in $files) {
    # Check if it's a file (not a directory)
    if ($file.PSIsContainer -eq $false) {
        # Replace spaces with underscores in the filename
        $newName = $file.Name -replace ' ', '_'

        # Build the new path
        $newPath = Join-Path -Path $directory -ChildPath $newName

        # Rename the file
        Rename-Item -Path $file.FullName -NewName $newName

        # Print the renaming operation
        Write-Host "Renamed: $($file.Name) -> $newName"
    }
}

Write-Host "All files renamed successfully."