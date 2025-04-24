# 1. 檢查 nvm-windows 安裝
if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    Write-Host "nvm-windows 未安裝" -ForegroundColor Red
    exit 1
} else {
    Write-Host "nvm-windows 已安裝" -ForegroundColor Green
}

# 保存初始 Node.js 版本
$initialNodeVersion = $null
try {
    $initialNodeVersion = node -v
    Write-Host "初始 Node.js 版本：$initialNodeVersion" -ForegroundColor Cyan
} catch {
    Write-Host "未檢測到初始 Node.js 版本" -ForegroundColor Yellow
}

# 2. 取得並解析 Node.js 版本
try {
    $currentVersion = node -v
    if ($currentVersion -match "^v(\d+)\.\d+\.\d+$") {
        $major = $matches[1]
        Write-Host "當前 Node.js 版本：$currentVersion（主要版本：$major）" 

        if ($major -ne "16") {
            Write-Host "當前不是 Node.js 16.x，將安裝 16.20.2..." -ForegroundColor Yellow
            nvm install 16.20.2 | Write-Host
            nvm use 16.20.2   | Write-Host 
        } else {
            Write-Host "當前已經是 Node.js 16.x，無需更動" -ForegroundColor Green
        }
    } else {
        throw "無法解析當前 Node.js 版本格式"
    } 
}  catch {
    Write-Host "未檢測到 Node.js，將安裝 16.20.2..." -ForegroundColor Yellow
    nvm install 16.20.2 | Write-Host
    nvm use 16.20.2   | Write-Host 
}

# 3. 檢查 squoosh-cli 安裝
if (-not (Get-Command squoosh-cli -ErrorAction SilentlyContinue)) {
    Write-Host "squoosh-cli 未安裝" -ForegroundColor Red
    Write-Host "安裝 squoosh-cli..." -ForegroundColor Yellow
    npm install -g @squoosh/cli | Write-Host 
} else {
    Write-Host "squoosh-cli 已安裝" -ForegroundColor Green
}

# 4. 選擇壓縮方式
Write-Host ""
Write-Host "請選擇壓縮方式：" -ForegroundColor Cyan
Write-Host "1. 壓縮成 WebP"
Write-Host "2. 壓縮成 MozJPEG"
Write-Host "3. 壓縮成 OxiPNG"
$choice = Read-Host "輸入 1 或 2 或 3"

# 5. 選擇壓縮品質  
$quality = Read-Host "請輸入壓縮品質（0-100）"

# 6. 選擇壓縮目標和儲存位置
Write-Host ""
Write-Host "請選擇壓縮目標和儲存位置：" -ForegroundColor Cyan
$targetPath = Read-Host "請輸入壓縮目標資料夾路徑（例如：C:\Users\User\squoosh\images）"
$filePattern = Read-Host "請輸入檔案類型（例如：*.jpg 或 *.png，多種類型請用逗號分隔，如：*.jpg,*.png）"
$output = Read-Host "請輸入儲存位置（例如：C:\Users\User\squoosh\output）"

# 確保輸出目錄存在
if (-not (Test-Path $output)) {
    New-Item -ItemType Directory -Path $output -Force | Out-Null
    Write-Host "已創建輸出目錄：$output" -ForegroundColor Green
}

# 7. 執行壓縮指令
Write-Host ""
Write-Host "執行壓縮指令..." -ForegroundColor Cyan

# 處理檔案模式
$filePatterns = $filePattern.Split(',') | ForEach-Object { $_.Trim() }
$filesToProcess = @()

foreach ($pattern in $filePatterns) {
    $matchedFiles = Get-ChildItem -Path $targetPath -Filter $pattern
    $filesToProcess += $matchedFiles.FullName
}

if ($filesToProcess.Count -eq 0) {
    Write-Host "未找到符合條件的檔案！" -ForegroundColor Red
    exit
}

Write-Host "找到 $($filesToProcess.Count) 個檔案需要處理" -ForegroundColor Green

switch ($choice) {
    1 {
        # 壓縮成 WebP
        foreach ($file in $filesToProcess) {
            Write-Host "處理檔案: $file" -ForegroundColor Yellow
            squoosh-cli --webp "{quality:$quality}" "$file" --output-dir "$output" | Write-Host 
        }
    } 
    2 {
        # 壓縮成 MozJPEG
        foreach ($file in $filesToProcess) {
            Write-Host "處理檔案: $file" -ForegroundColor Yellow
            squoosh-cli --mozjpeg "{quality:$quality}" "$file" --output-dir "$output" | Write-Host 
        }
    }
    3 {
        # 壓縮成 OxiPNG
        foreach ($file in $filesToProcess) {
            Write-Host "處理檔案: $file" -ForegroundColor Yellow
            squoosh-cli --oxipng "{quality:$quality}" "$file" --output-dir "$output" | Write-Host
        }
    }
}

# 8. 顯示壓縮結果
Write-Host ""
Write-Host "壓縮完成！" -ForegroundColor Green
Write-Host "壓縮目標資料夾：$targetPath"
Write-Host "檔案類型：$filePattern"
Write-Host "儲存位置：$output"
Write-Host "壓縮方式：$choice"
Write-Host "壓縮品質：$quality"
Write-Host "處理檔案數量：$($filesToProcess.Count)"

# 9. 恢復初始 Node.js 版本
if ($initialNodeVersion -and $initialNodeVersion -ne (node -v)) {
    Write-Host ""
    Write-Host "正在恢復初始 Node.js 版本: $initialNodeVersion..." -ForegroundColor Cyan
    
    if ($initialNodeVersion -match "^v(\d+\.\d+\.\d+)$") {
        $versionToRestore = $matches[1]
        nvm use $versionToRestore | Write-Host
        Write-Host "已恢復至初始 Node.js 版本: $(node -v)" -ForegroundColor Green
    } else {
        Write-Host "無法解析初始版本格式，無法恢復" -ForegroundColor Red
    }
}

# 10. 按任意鍵退出
Write-Host ""
Write-Host "按任意鍵退出..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey(
    [System.Management.Automation.Host.ReadKeyOptions]::NoEcho -bor `
    [System.Management.Automation.Host.ReadKeyOptions]::IncludeKeyDown
)