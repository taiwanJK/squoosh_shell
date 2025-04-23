# Squoosh Shell 圖片壓縮工具

這是一個基於 [Squoosh CLI](https://github.com/GoogleChromeLabs/squoosh) 的 PowerShell 腳本工具，用於批量壓縮圖片檔案。此工具可以將圖片轉換為 WebP、MozJPEG 或 OxiPNG 格式，並且可以自定義壓縮品質。

## 功能特點

- 自動檢查並安裝必要的依賴（nvm-windows、Node.js 16.x、squoosh-cli）
- 支援多種壓縮格式：WebP、MozJPEG、OxiPNG
- 可自定義壓縮品質（0-100）
- 支援批量處理多種檔案類型（如 *.jpg, *.png）
- 自動創建輸出目錄

## 系統需求

- Windows 作業系統
- 網路連接（用於安裝依賴）

## 安裝步驟

1. 首先，請確保已安裝 [nvm-windows](https://github.com/coreybutler/nvm-windows/releases)
2. 下載本專案中的 `squoosh_action.ps1` 檔案
3. 腳本會自動檢查並安裝所需的 Node.js 16.x 和 squoosh-cli

## 使用方法

1. 在 PowerShell 中執行腳本：
   ```powershell
   .\squoosh_action.ps1
   ```

2. 依照提示選擇壓縮方式：

- 1: 壓縮成 WebP
- 2: 壓縮成 MozJPEG
- 3: 壓縮成 OxiPNG

3. 輸入壓縮品質（0-100）

4. 輸入壓縮目標資料夾路徑，例如：

   ```powershell
   C:\Users\User\squoosh\images
   ```

5. 輸入檔案類型，可以使用逗號分隔多種類型，例如：

   ```powershell
   *.jpg,*.png
   ```

6. 輸入儲存位置，例如：

   ```powershell
   C:\Users\User\squoosh\output
   ```

7. 腳本會自動壓縮指定類型的圖片檔案，並將結果儲存到指定位置。

## 注意事項

- 此腳本會自動切換到 Node.js 16.x 版本，因為 squoosh-cli 在較新版本的 Node.js 上可能會有相容性問題
- 如果遇到權限問題，請以管理員身份執行 PowerShell
- 處理大量或大尺寸圖片時可能需要較長時間