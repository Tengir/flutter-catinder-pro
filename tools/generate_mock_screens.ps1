Add-Type -AssemblyName System.Drawing

function New-MockScreen {
    param(
        [string]$Path,
        [string]$title
    )

    $bitmap = New-Object System.Drawing.Bitmap -ArgumentList 720, 1280
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $background = [System.Drawing.Color]::FromArgb(255, 246, 241, 235)
    $graphics.Clear($background)

    $headerBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 185, 104, 74))
    $graphics.FillRectangle($headerBrush, 0, 0, 720, 120)

    $tabBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
    $graphics.FillRectangle($tabBrush, 40, 140, 640, 80)

    $shapePath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $rect = New-Object System.Drawing.Rectangle 60, 240, 600, 720
    $radius = 48
    $shapePath.AddArc($rect.X, $rect.Y, $radius, $radius, 180, 90)
    $shapePath.AddArc($rect.Right - $radius, $rect.Y, $radius, $radius, 270, 90)
    $shapePath.AddArc($rect.Right - $radius, $rect.Bottom - $radius, $radius, $radius, 0, 90)
    $shapePath.AddArc($rect.X, $rect.Bottom - $radius, $radius, $radius, 90, 90)
    $shapePath.CloseFigure()

    $cardBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
    $graphics.FillPath($cardBrush, $shapePath)
    $shapePath.Dispose()

    $btnBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 245, 214, 200))
    $graphics.FillEllipse($btnBrush, 120, 1000, 200, 100)
    $graphics.FillEllipse($btnBrush, 400, 1000, 200, 100)

    $textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 60, 60, 60))
    $titleFont = New-Object System.Drawing.Font("Segoe UI", 36, [System.Drawing.FontStyle]::Bold)
    $bodyFont = New-Object System.Drawing.Font("Segoe UI", 30)
    $graphics.DrawString($title, $titleFont, $textBrush, 150, 40)
    $graphics.DrawString("Cat of the day", $bodyFont, $textBrush, 140, 180)
    $graphics.DrawString("Like  •  Nope", $bodyFont, $textBrush, 200, 1120)

    $fullPath = Join-Path (Get-Location) $Path
    $dir = [System.IO.Path]::GetDirectoryName($fullPath)
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $bitmap.Save($fullPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $titleFont.Dispose()
    $bodyFont.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
}

New-MockScreen -Path "screenshots/tinder_mock.png" -title "Catinder"
New-MockScreen -Path "screenshots/breeds_mock.png" -title "Breeds"
