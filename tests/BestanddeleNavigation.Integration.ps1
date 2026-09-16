$ErrorActionPreference = 'Stop'

Add-Type @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;

public static class PatUi
{
    public delegate bool EnumWindowProc(IntPtr window, IntPtr parameter);

    [StructLayout(LayoutKind.Sequential)]
    private struct Rectangle
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [DllImport("user32.dll")]
    private static extern bool EnumWindows(EnumWindowProc callback, IntPtr parameter);

    [DllImport("user32.dll")]
    private static extern bool EnumChildWindows(IntPtr parent, EnumWindowProc callback, IntPtr parameter);

    [DllImport("user32.dll")]
    private static extern uint GetWindowThreadProcessId(IntPtr window, out uint processId);

    [DllImport("kernel32.dll")]
    private static extern uint GetCurrentThreadId();

    [DllImport("user32.dll")]
    private static extern bool AttachThreadInput(uint firstThread, uint secondThread, bool attach);

    [DllImport("user32.dll")]
    private static extern IntPtr SetFocus(IntPtr window);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    private static extern int GetClassName(IntPtr window, StringBuilder className, int maximumLength);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    private static extern bool SetWindowText(IntPtr window, string text);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    private static extern int GetWindowText(IntPtr window, StringBuilder text, int maximumLength);

    [DllImport("user32.dll")]
    private static extern IntPtr SendMessage(IntPtr window, uint message, IntPtr wordParameter, IntPtr longParameter);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    private static extern IntPtr SendMessage(IntPtr window, uint message, IntPtr wordParameter, string longParameter);

    [DllImport("user32.dll", SetLastError = true)]
    private static extern IntPtr SendMessageTimeout(
        IntPtr window,
        uint message,
        IntPtr wordParameter,
        IntPtr longParameter,
        uint flags,
        uint timeout,
        out IntPtr result);

    [DllImport("user32.dll")]
    private static extern bool PostMessage(IntPtr window, uint message, IntPtr wordParameter, IntPtr longParameter);

    [DllImport("user32.dll")]
    private static extern bool IsWindowVisible(IntPtr window);

    [DllImport("user32.dll")]
    private static extern bool IsWindowEnabled(IntPtr window);

    [DllImport("user32.dll")]
    private static extern bool GetWindowRect(IntPtr window, out Rectangle rectangle);

    [DllImport("user32.dll")]
    private static extern bool SetForegroundWindow(IntPtr window);

    [DllImport("user32.dll")]
    private static extern bool SetCursorPos(int x, int y);

    [DllImport("user32.dll")]
    private static extern void mouse_event(uint flags, uint x, uint y, uint data, UIntPtr extraInfo);

    [DllImport("user32.dll")]
    private static extern short VkKeyScan(char character);

    [DllImport("user32.dll")]
    private static extern void keybd_event(byte virtualKey, byte scanCode, uint flags, UIntPtr extraInfo);

    private const uint ButtonClick = 0x00F5;
    private const uint Command = 0x0111;
    private const uint AbortIfHung = 0x0002;
    private const uint LeftButtonDown = 0x0002;
    private const uint LeftButtonUp = 0x0004;
    private const uint KeyUp = 0x0002;

    private static void ReplaceText(IntPtr control, string text)
    {
        SendMessage(control, 0x00B1, IntPtr.Zero, new IntPtr(-1));
        SendMessage(control, 0x00C2, new IntPtr(1), text);
    }

    private static void ClickWindow(IntPtr window)
    {
        Rectangle rectangle;
        GetWindowRect(window, out rectangle);
        SetCursorPos(
            rectangle.Left + (rectangle.Right - rectangle.Left) / 2,
            rectangle.Top + (rectangle.Bottom - rectangle.Top) / 2);
        mouse_event(LeftButtonDown, 0, 0, 0, UIntPtr.Zero);
        mouse_event(LeftButtonUp, 0, 0, 0, UIntPtr.Zero);
    }

    private static void FocusWindow(IntPtr topWindow, IntPtr control)
    {
        uint processId;
        uint targetThread = GetWindowThreadProcessId(topWindow, out processId);
        uint currentThread = GetCurrentThreadId();
        AttachThreadInput(currentThread, targetThread, true);
        try
        {
            SetForegroundWindow(topWindow);
            SetFocus(control);
        }
        finally
        {
            AttachThreadInput(currentThread, targetThread, false);
        }
    }

    private static void TypeText(IntPtr control, string text)
    {
        foreach (char character in text)
        {
            SendMessage(control, 0x0102, new IntPtr(character), IntPtr.Zero);
        }
    }

    private static string WindowClass(IntPtr window)
    {
        StringBuilder className = new StringBuilder(128);
        GetClassName(window, className, className.Capacity);
        return className.ToString();
    }

    private static string WindowText(IntPtr window)
    {
        StringBuilder text = new StringBuilder(256);
        GetWindowText(window, text, text.Capacity);
        return text.ToString();
    }

    private static List<Tuple<IntPtr, int, int>> FindVisibleChildren(
        IntPtr parent,
        string className)
    {
        List<Tuple<IntPtr, int, int>> children = new List<Tuple<IntPtr, int, int>>();
        EnumChildWindows(parent, delegate(IntPtr child, IntPtr parameter)
        {
            if (WindowClass(child) == className && IsWindowVisible(child))
            {
                Rectangle rectangle;
                GetWindowRect(child, out rectangle);
                children.Add(Tuple.Create(child, rectangle.Top, rectangle.Left));
            }
            return true;
        }, IntPtr.Zero);
        children.Sort(delegate(Tuple<IntPtr, int, int> first, Tuple<IntPtr, int, int> second)
        {
            int topResult = first.Item2.CompareTo(second.Item2);
            if (topResult != 0)
                return topResult;
            return first.Item3.CompareTo(second.Item3);
        });
        return children;
    }

    public static IntPtr FindWindow(uint processId, string className, bool visibleOnly)
    {
        IntPtr result = IntPtr.Zero;
        EnumWindows(delegate(IntPtr window, IntPtr parameter)
        {
            uint windowProcessId;
            GetWindowThreadProcessId(window, out windowProcessId);
            if (windowProcessId == processId &&
                WindowClass(window) == className &&
                (!visibleOnly || IsWindowVisible(window)))
            {
                result = window;
                return false;
            }

            return true;
        }, IntPtr.Zero);
        return result;
    }

    public static string DescribeVisibleWindows(uint processId)
    {
        StringBuilder description = new StringBuilder();
        EnumWindows(delegate(IntPtr window, IntPtr parameter)
        {
            uint windowProcessId;
            GetWindowThreadProcessId(window, out windowProcessId);
            if (windowProcessId == processId && IsWindowVisible(window))
            {
                StringBuilder title = new StringBuilder(256);
                GetWindowText(window, title, title.Capacity);
                description.AppendLine(WindowClass(window) + ": " + title);
                EnumChildWindows(window, delegate(IntPtr child, IntPtr childParameter)
                {
                    StringBuilder childText = new StringBuilder(256);
                    GetWindowText(child, childText, childText.Capacity);
                    if (childText.Length > 0)
                        description.AppendLine("  " + WindowClass(child) + ": " + childText);
                    return true;
                }, IntPtr.Zero);
            }
            return true;
        }, IntPtr.Zero);
        return description.ToString();
    }

    public static void Login(IntPtr loginWindow, string username, string password)
    {
        List<Tuple<IntPtr, int, int>> edits = FindVisibleChildren(loginWindow, "TEdit");
        IntPtr button = IntPtr.Zero;

        EnumChildWindows(loginWindow, delegate(IntPtr child, IntPtr parameter)
        {
            if (WindowClass(child) == "TButton" && IsWindowVisible(child) &&
                String.Equals(WindowText(child), "TEKEN IN", StringComparison.OrdinalIgnoreCase))
                button = child;
            return true;
        }, IntPtr.Zero);

        if (edits.Count != 2 || button == IntPtr.Zero)
            throw new InvalidOperationException("Die aanmeldkontroles kon nie gevind word nie.");

        SetWindowText(edits[0].Item1, username);
        SetWindowText(edits[1].Item1, password);
        Thread.Sleep(100);
        ReplaceText(edits[0].Item1, username);
        ReplaceText(edits[1].Item1, password);
        Thread.Sleep(750);

        StringBuilder usernameText = new StringBuilder(128);
        StringBuilder passwordText = new StringBuilder(128);
        GetWindowText(edits[0].Item1, usernameText, usernameText.Capacity);
        GetWindowText(edits[1].Item1, passwordText, passwordText.Capacity);
        if (usernameText.ToString() != username || passwordText.ToString() != password)
            throw new InvalidOperationException("Die aanmeldvelde het nie die toetswaardes behou nie.");
        Thread clickThread = new Thread(delegate()
        {
            SendMessage(button, ButtonClick, IntPtr.Zero, IntPtr.Zero);
        });
        clickThread.IsBackground = true;
        clickThread.Start();
    }

    public static void ChooseMenuItem(IntPtr window, int menuId)
    {
        PostMessage(window, Command, new IntPtr(menuId), IntPtr.Zero);
    }

    public static void CloseWindow(IntPtr window)
    {
        PostMessage(window, 0x0010, IntPtr.Zero, IntPtr.Zero);
    }

    public static void SetEditText(IntPtr window, int index, string text)
    {
        List<Tuple<IntPtr, int, int>> edits = FindVisibleChildren(window, "TEdit");
        if (index < 0 || index >= edits.Count)
            throw new InvalidOperationException("TEdit-indeks is buite bereik.");
        SetWindowText(edits[index].Item1, text);
        Thread.Sleep(50);
        ReplaceText(edits[index].Item1, text);
        Thread.Sleep(100);
    }

    public static void SetFirstStandardEditText(IntPtr window, string text)
    {
        List<Tuple<IntPtr, int, int>> edits = FindVisibleChildren(window, "Edit");
        if (edits.Count == 0)
            throw new InvalidOperationException("Die standaard Windows-invoerveld is nie gevind nie.");
        SetWindowText(edits[0].Item1, text);
        Thread.Sleep(50);
        ReplaceText(edits[0].Item1, text);
    }

    public static void ClickButton(IntPtr window, string caption)
    {
        IntPtr button = IntPtr.Zero;
        EnumChildWindows(window, delegate(IntPtr child, IntPtr parameter)
        {
            if (WindowClass(child) == "TButton" &&
                String.Equals(WindowText(child), caption, StringComparison.OrdinalIgnoreCase))
            {
                button = child;
                return false;
            }
            return true;
        }, IntPtr.Zero);
        if (button == IntPtr.Zero)
            throw new InvalidOperationException("Knoppie nie gevind nie: " + caption);
        PostMessage(button, ButtonClick, IntPtr.Zero, IntPtr.Zero);
    }

    public static bool IsButtonEnabled(IntPtr window, string caption)
    {
        bool found = false;
        bool enabled = false;
        EnumChildWindows(window, delegate(IntPtr child, IntPtr parameter)
        {
            if (WindowClass(child) == "TButton" && IsWindowVisible(child) &&
                String.Equals(WindowText(child), caption, StringComparison.OrdinalIgnoreCase))
            {
                found = true;
                enabled = IsWindowEnabled(child);
                return false;
            }
            return true;
        }, IntPtr.Zero);
        if (!found)
            throw new InvalidOperationException("Knoppie nie gevind nie: " + caption);
        return enabled;
    }

    public static void ClickGridRow(IntPtr window, int gridIndex, int row)
    {
        List<Tuple<IntPtr, int, int>> grids = FindVisibleChildren(window, "TStringGrid");
        if (gridIndex < 0 || gridIndex >= grids.Count)
            throw new InvalidOperationException("TStringGrid-indeks is buite bereik.");
        int x = 40;
        int y = 12 + (row * 24);
        IntPtr coordinates = new IntPtr((y << 16) | (x & 0xFFFF));
        PostMessage(grids[gridIndex].Item1, 0x0201, new IntPtr(1), coordinates);
        PostMessage(grids[gridIndex].Item1, 0x0202, IntPtr.Zero, coordinates);
        Thread.Sleep(150);
    }

    public static void SetComboIndex(IntPtr window, int comboIndex, int itemIndex)
    {
        List<Tuple<IntPtr, int, int>> combos = FindVisibleChildren(window, "TComboBox");
        if (comboIndex < 0 || comboIndex >= combos.Count)
            throw new InvalidOperationException("TComboBox-indeks is buite bereik.");
        SendMessage(combos[comboIndex].Item1, 0x014E, new IntPtr(itemIndex), IntPtr.Zero);
        Thread.Sleep(100);
    }

    public static void ChooseDialogResult(IntPtr dialog, int resultId)
    {
        string expectedText = resultId == 6 ? "Yes" : resultId == 7 ? "No" : "OK";
        IntPtr button = IntPtr.Zero;
        EnumChildWindows(dialog, delegate(IntPtr child, IntPtr parameter)
        {
            string text = WindowText(child).Replace("&", "");
            if (WindowClass(child) == "Button" &&
                String.Equals(text, expectedText, StringComparison.OrdinalIgnoreCase))
            {
                button = child;
                return false;
            }
            return true;
        }, IntPtr.Zero);
        if (button != IntPtr.Zero)
            PostMessage(button, ButtonClick, IntPtr.Zero, IntPtr.Zero);
        else
            PostMessage(dialog, Command, new IntPtr(resultId), IntPtr.Zero);
    }
}
'@

function Wait-ForWindow {
    param(
        [uint32]$ProcessId,
        [string]$ClassName,
        [int]$TimeoutSeconds = 5
    )

    $endTime = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        $window = [PatUi]::FindWindow($ProcessId, $ClassName, $true)
        if ($window -ne [IntPtr]::Zero) {
            return $window
        }
        Start-Sleep -Milliseconds 100
    } while ((Get-Date) -lt $endTime)

    throw "Die sigbare $ClassName-venster het nie binne $TimeoutSeconds sekondes oopgemaak nie."
}

function Wait-ForWindowToClose {
    param(
        [uint32]$ProcessId,
        [string]$ClassName,
        [int]$TimeoutSeconds = 5
    )

    $endTime = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        $window = [PatUi]::FindWindow($ProcessId, $ClassName, $true)
        if ($window -eq [IntPtr]::Zero) {
            return
        }
        Start-Sleep -Milliseconds 100
    } while ((Get-Date) -lt $endTime)

    throw "Die $ClassName-venster het nie binne $TimeoutSeconds sekondes toegemaak nie."
}

function Complete-Dialog {
    param(
        [uint32]$ProcessId,
        [int]$ResultId = 1
    )

    $dialog = Wait-ForWindow -ProcessId $ProcessId -ClassName '#32770'
    [PatUi]::ChooseDialogResult($dialog, $ResultId)
    Wait-ForWindowToClose -ProcessId $ProcessId -ClassName '#32770'
}

function Assert-ButtonAccess {
    param(
        [IntPtr]$Window,
        [string]$Caption,
        [bool]$Expected
    )

    $actual = [PatUi]::IsButtonEnabled($Window, $Caption)
    if ($actual -ne $Expected) {
        throw "Toegang vir '$Caption' was $actual maar moes $Expected wees."
    }
}

$projectDirectory = Split-Path -Parent $PSScriptRoot
$programPath = Join-Path $projectDirectory 'Win32\Debug\PAT_p.exe'
$sourceDatabasePath = Join-Path $projectDirectory 'Database.mdb'
$testDatabasePath = Join-Path (Split-Path -Parent $programPath) 'Database.mdb'
$databaseBackupPath = Join-Path $PSScriptRoot 'artifacts\debug-database-before-test.mdb'
$testDatabaseAlreadyExisted = Test-Path -LiteralPath $testDatabasePath
$artifactDirectory = Split-Path -Parent $databaseBackupPath
if (-not (Test-Path -LiteralPath $artifactDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $artifactDirectory -Force | Out-Null
}
$runningPrograms = Get-Process -Name 'PAT_p' -ErrorAction SilentlyContinue

if ($runningPrograms) {
    $runningPrograms | Stop-Process -Force
    $runningPrograms | Wait-Process -Timeout 10 -ErrorAction SilentlyContinue
}

if (Get-Process -Name 'PAT_p' -ErrorAction SilentlyContinue) {
    throw 'Nie alle bestaande PAT_p-prosesse kon toegemaak word nie.'
}

if ($testDatabaseAlreadyExisted) {
    Copy-Item -LiteralPath $testDatabasePath -Destination $databaseBackupPath -Force
}
Copy-Item -LiteralPath $sourceDatabasePath -Destination $testDatabasePath -Force

$program = Start-Process -FilePath $programPath -WorkingDirectory $projectDirectory -PassThru
$reportOutputPath = Join-Path $artifactDirectory ("integration-report-" + $program.Id + '.txt')

try {
    $loginWindow = Wait-ForWindow -ProcessId $program.Id -ClassName 'TfrmLogin'
    Start-Sleep -Seconds 3

    [PatUi]::ChooseMenuItem($loginWindow, 3)
    Start-Sleep -Milliseconds 300
    $roleUsers = @(
        @{ Username = 'integrasie_sjef'; RoleIndex = 1; Role = 'Sjef'; Button = 'Bestanddele en voorraad'; Form = 'TfrmInventory' },
        @{ Username = 'integrasie_kelner'; RoleIndex = 2; Role = 'Kelner'; Button = 'Verkope'; Form = 'TfrmSuppliers' },
        @{ Username = 'integrasie_eienaar'; RoleIndex = 3; Role = 'Eienaar'; Button = 'Verslae'; Form = 'TfrmReports' }
    )
    foreach ($roleUser in $roleUsers) {
        [PatUi]::ChooseMenuItem($loginWindow, 3)
        Start-Sleep -Milliseconds 200
        [PatUi]::SetEditText($loginWindow, 0, $roleUser.Username)
        [PatUi]::SetEditText($loginWindow, 1, 'Welkom2')
        [PatUi]::SetEditText($loginWindow, 2, 'Welkom2')
        [PatUi]::SetComboIndex($loginWindow, 0, $roleUser.RoleIndex)
        [PatUi]::ClickButton($loginWindow, 'SKEP REKENING')
        Complete-Dialog -ProcessId $program.Id
    }
    [PatUi]::ChooseMenuItem($loginWindow, 2)
    Start-Sleep -Milliseconds 300
    [PatUi]::Login($loginWindow, 'bestuurder', 'Welkom1')

    $menuWindow = Wait-ForWindow -ProcessId $program.Id -ClassName 'TfrmMenu'
    Assert-ButtonAccess $menuWindow 'Bestanddele en voorraad' $true
    Assert-ButtonAccess $menuWindow 'Geregte en resepte' $true
    Assert-ButtonAccess $menuWindow 'Verkope' $true
    Assert-ButtonAccess $menuWindow 'Verslae' $true
    $screens = @(
        @{ MenuId = 11; ClassName = 'TfrmInventory'; Name = 'bestanddele-en-voorraad' },
        @{ MenuId = 12; ClassName = 'TfrmProducts'; Name = 'geregte-en-resepte' },
        @{ MenuId = 13; ClassName = 'TfrmSuppliers'; Name = 'verkope' },
        @{ MenuId = 14; ClassName = 'TfrmReports'; Name = 'verslae' }
    )

    foreach ($screen in $screens) {
        [PatUi]::ChooseMenuItem($menuWindow, $screen.MenuId)
        $screenWindow = Wait-ForWindow `
            -ProcessId $program.Id `
            -ClassName $screen.ClassName

        switch ($screen.Name) {
            'bestanddele-en-voorraad' {
                [PatUi]::ClickButton($screenWindow, 'Voeg by')
                Complete-Dialog -ProcessId $program.Id

                [PatUi]::SetEditText($screenWindow, 1, 'Integrasie Kaneel')
                [PatUi]::SetEditText($screenWindow, 2, 'kg')
                [PatUi]::SetEditText($screenWindow, 3, '15')
                [PatUi]::SetEditText($screenWindow, 4, '3.50')
                [PatUi]::SetEditText($screenWindow, 5, '2')
                [PatUi]::ClickButton($screenWindow, 'Voeg by')
                Complete-Dialog -ProcessId $program.Id

                [PatUi]::SetEditText($screenWindow, 0, 'Integrasie Kaneel')
                [PatUi]::ClickGridRow($screenWindow, 0, 1)
                [PatUi]::SetEditText($screenWindow, 4, '4.25')
                [PatUi]::ClickButton($screenWindow, 'Wysig')
                Complete-Dialog -ProcessId $program.Id

                [PatUi]::ClickGridRow($screenWindow, 0, 1)
                [PatUi]::ClickButton($screenWindow, 'Deaktiveer')
                Complete-Dialog -ProcessId $program.Id -ResultId 6
            }
            'geregte-en-resepte' {
                [PatUi]::ClickButton($screenWindow, 'Voeg gereg by')
                Complete-Dialog -ProcessId $program.Id

                [PatUi]::SetEditText($screenWindow, 1, 'Integrasie Broodjie')
                [PatUi]::SetEditText($screenWindow, 2, '45')
                [PatUi]::ClickButton($screenWindow, 'Voeg gereg by')
                Complete-Dialog -ProcessId $program.Id

                [PatUi]::SetComboIndex($screenWindow, 0, 0)
                [PatUi]::SetEditText($screenWindow, 0, '0.5')
                [PatUi]::ClickButton($screenWindow, 'Voeg/werk by')
                Start-Sleep -Milliseconds 300

                [PatUi]::ClickGridRow($screenWindow, 1, 1)
                [PatUi]::ClickButton($screenWindow, 'Verwyder uit resep')
                Start-Sleep -Milliseconds 300

                [PatUi]::SetEditText($screenWindow, 0, '0.5')
                [PatUi]::ClickButton($screenWindow, 'Voeg/werk by')
                Start-Sleep -Milliseconds 300
            }
            'verkope' {
                [PatUi]::ClickButton($screenWindow, 'Teken verkoop aan')
                Complete-Dialog -ProcessId $program.Id

                [PatUi]::ClickGridRow($screenWindow, 0, 1)
                [PatUi]::SetEditText($screenWindow, 0, '2')
                [PatUi]::ClickButton($screenWindow, 'Teken verkoop aan')
                Complete-Dialog -ProcessId $program.Id
            }
            'verslae' {
                for ($reportIndex = 0; $reportIndex -lt 3; $reportIndex++) {
                    [PatUi]::SetComboIndex($screenWindow, 0, $reportIndex)
                    [PatUi]::ClickButton($screenWindow, 'Genereer verslag')
                    Start-Sleep -Milliseconds 250
                }
                [PatUi]::ClickButton($screenWindow, 'Laai verslag af na teksdokument')
                $saveDialog = Wait-ForWindow -ProcessId $program.Id -ClassName '#32770'
                [PatUi]::SetFirstStandardEditText($saveDialog, $reportOutputPath)
                [PatUi]::ChooseDialogResult($saveDialog, 1)
                Start-Sleep -Milliseconds 500
                Complete-Dialog -ProcessId $program.Id
                if (-not (Test-Path -LiteralPath $reportOutputPath -PathType Leaf)) {
                    throw 'Die verslagteksdokument is nie geskep nie.'
                }
            }
        }

        & (Join-Path $PSScriptRoot 'NeemVensterSkermgreep.ps1') `
            -ProcessId $program.Id `
            -UitvoerPad (Join-Path $PSScriptRoot ("artifacts\" + $screen.Name + '.png'))
        [PatUi]::CloseWindow($screenWindow)
        Wait-ForWindowToClose -ProcessId $program.Id -ClassName $screen.ClassName
        Write-Output ("PASS: " + $screen.Name + ' maak oop en toe.')
    }

    [PatUi]::ChooseMenuItem($menuWindow, 12)
    $productsWindow = Wait-ForWindow -ProcessId $program.Id -ClassName 'TfrmProducts'
    [PatUi]::ClickGridRow($productsWindow, 0, 1)
    [PatUi]::ClickButton($productsWindow, 'Deaktiveer gekose gereg')
    Complete-Dialog -ProcessId $program.Id -ResultId 6
    [PatUi]::CloseWindow($productsWindow)
    Wait-ForWindowToClose -ProcessId $program.Id -ClassName 'TfrmProducts'
    Write-Output 'PASS: Toetsgereg is gedeaktiveer.'

    [PatUi]::ChooseMenuItem($menuWindow, 7)
    Wait-ForWindowToClose -ProcessId $program.Id -ClassName 'TfrmMenu'
    $loginWindow = Wait-ForWindow -ProcessId $program.Id -ClassName 'TfrmLogin'

    foreach ($roleUser in $roleUsers) {
        [PatUi]::Login($loginWindow, $roleUser.Username, 'Welkom2')
        $roleMenu = Wait-ForWindow -ProcessId $program.Id -ClassName 'TfrmMenu'
        Assert-ButtonAccess $roleMenu 'Bestanddele en voorraad' ($roleUser.Role -eq 'Sjef')
        Assert-ButtonAccess $roleMenu 'Geregte en resepte' ($roleUser.Role -eq 'Sjef')
        Assert-ButtonAccess $roleMenu 'Verkope' ($roleUser.Role -eq 'Kelner')
        Assert-ButtonAccess $roleMenu 'Verslae' ($roleUser.Role -eq 'Eienaar')

        [PatUi]::ClickButton($roleMenu, $roleUser.Button)
        $roleForm = Wait-ForWindow -ProcessId $program.Id -ClassName $roleUser.Form
        [PatUi]::CloseWindow($roleForm)
        Wait-ForWindowToClose -ProcessId $program.Id -ClassName $roleUser.Form
        [PatUi]::ChooseMenuItem($roleMenu, 7)
        Wait-ForWindowToClose -ProcessId $program.Id -ClassName 'TfrmMenu'
        $loginWindow = Wait-ForWindow -ProcessId $program.Id -ClassName 'TfrmLogin'
        Write-Output ("PASS: " + $roleUser.Role + ' se roltoegang werk.')
    }
}
catch {
    Write-Output ([PatUi]::DescribeVisibleWindows([uint32]$program.Id))
    $program.Refresh()
    if ($program.Responding) {
        & (Join-Path $PSScriptRoot 'NeemVensterSkermgreep.ps1') `
            -ProcessId $program.Id `
            -UitvoerPad (Join-Path $PSScriptRoot 'artifacts\bestanddele-navigation-failure.png')
    }
    else {
        Write-Output 'Skermgreep oorgeslaan omdat die program reeds gevries het.'
    }
    throw
}
finally {
    $currentProgram = Get-Process -Id $program.Id -ErrorAction SilentlyContinue
    if ($currentProgram) {
        $currentProgram | Stop-Process -Force
        $currentProgram | Wait-Process -Timeout 10 -ErrorAction SilentlyContinue
    }
    if ($testDatabaseAlreadyExisted) {
        Copy-Item -LiteralPath $databaseBackupPath -Destination $testDatabasePath -Force
        Remove-Item -LiteralPath $databaseBackupPath -Force
    }
    elseif (Test-Path -LiteralPath $testDatabasePath) {
        for ($attempt = 1; $attempt -le 20; $attempt++) {
            try {
                Remove-Item -LiteralPath $testDatabasePath -Force
                break
            }
            catch {
                if ($attempt -eq 20) {
                    throw
                }
                Start-Sleep -Milliseconds 250
            }
        }
    }
}
