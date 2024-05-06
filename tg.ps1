Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "sharf"
$form.Size = New-Object System.Drawing.Size(300, 150)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.MinimizeBox = $false
$form.MaximizeBox = $false
$form.ControlBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Text = "ti lox?"
$label.Location = New-Object System.Drawing.Point(50, 20)
$label.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($label)

$button1 = New-Object System.Windows.Forms.Button
$button1.Text = "daaaa"
$button1.Location = New-Object System.Drawing.Point(50, 60)
$button1.Size = New-Object System.Drawing.Size(75, 23)
$form.Controls.Add($button1)

$button2 = New-Object System.Windows.Forms.Button
$button2.Text = "ne"
$button2.Location = New-Object System.Drawing.Point(150, 60)
$button2.Size = New-Object System.Drawing.Size(75, 23)
$form.Controls.Add($button2)

$button1.Add_Click({
    $label.Text = "ooooooooooooo facti."
    $button1.Visible = $false
    $button2.Visible = $false
    Start-Sleep -Seconds 2
    $form.Close()
})

$button2.Add_Click({
    $label.Text = "gandon."
    Start-Sleep -Seconds 2
    $form.WindowState = 'Minimized'
})

$button2.Add_MouseMove({
    if ($form.WindowState -ne 'Minimized') {
        $random = New-Object System.Random
        $newX = $random.Next(0, [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - $form.Width)
        $newY = $random.Next(0, [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height - $form.Height)
        $form.Location = New-Object System.Drawing.Point($newX, $newY)
    }
})


$form.ShowDialog()
