[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$ProcessId,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$UitvoerPad,

    [string]$VensterTitel = ''
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
using System.Text;

public static class PatVensterVaslegging
{
    public delegate bool VensterTerugroep(IntPtr window, IntPtr parameter);

    [StructLayout(LayoutKind.Sequential)]
    public struct Rectangle
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr window, out Rectangle rectangle);

    [DllImport("user32.dll")]
    public static extern bool PrintWindow(IntPtr window, IntPtr deviceContext, uint flags);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(VensterTerugroep callback, IntPtr parameter);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr window, out uint processId);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr window);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr window, StringBuilder text, int maximumLength);

    public static IntPtr FindWindow(int processId, string titlePart)
    {
        IntPtr bestWindow = IntPtr.Zero;
        long bestArea = -1;
        EnumWindows(delegate(IntPtr window, IntPtr parameter)
        {
            uint candidateProcessId;
            if (!IsWindowVisible(window) ||
                GetWindowThreadProcessId(window, out candidateProcessId) == 0 ||
                candidateProcessId != (uint)processId)
                return true;

            StringBuilder title = new StringBuilder(512);
            GetWindowText(window, title, title.Capacity);
            if (!String.IsNullOrWhiteSpace(titlePart) &&
                title.ToString().IndexOf(titlePart, StringComparison.OrdinalIgnoreCase) < 0)
                return true;

            Rectangle rectangle;
            if (!GetWindowRect(window, out rectangle))
                return true;
            long area = Math.Max(0, rectangle.Right - rectangle.Left) *
                (long)Math.Max(0, rectangle.Bottom - rectangle.Top);
            if (area > bestArea)
            {
                bestWindow = window;
                bestArea = area;
            }
            return true;
        }, IntPtr.Zero);
        return bestWindow;
    }
}
'@

$window = [PatVensterVaslegging]::FindWindow($ProcessId, $VensterTitel)
if ($window -eq [IntPtr]::Zero) {
    throw "Proses $ProcessId het nie 'n vaslegbare venster nie."
}

$rectangle = New-Object PatVensterVaslegging+Rectangle
if (-not [PatVensterVaslegging]::GetWindowRect($window, [ref]$rectangle)) {
    throw "Die venstergrense kon nie gelees word nie."
}

$width = $rectangle.Right - $rectangle.Left
$height = $rectangle.Bottom - $rectangle.Top
if (($width -le 0) -or ($height -le 0)) {
    throw "Die venster het ongeldige afmetings."
}

$fullOutputPath = [IO.Path]::GetFullPath($UitvoerPad)
$outputDirectory = Split-Path -Parent $fullOutputPath
if (-not (Test-Path -LiteralPath $outputDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$bitmap = New-Object Drawing.Bitmap $width, $height
$graphics = [Drawing.Graphics]::FromImage($bitmap)
$deviceContext = $graphics.GetHdc()
try {
    if (-not [PatVensterVaslegging]::PrintWindow($window, $deviceContext, 2)) {
        throw "Windows kon nie die venster vaslê nie."
    }
}
finally {
    $graphics.ReleaseHdc($deviceContext)
    $graphics.Dispose()
}

try {
    $bitmap.Save($fullOutputPath, [Drawing.Imaging.ImageFormat]::Png)
}
finally {
    $bitmap.Dispose()
}

Write-Output "Skermgreep gestoor: $fullOutputPath"
