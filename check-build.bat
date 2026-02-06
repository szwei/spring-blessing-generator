@echo off
echo ====================================
echo   构建并检查输出
echo ====================================
echo.

echo [1/3] 清理旧的构建文件...
if exist "dist" (
    rmdir /s /q dist
    echo ✓ 已清理 dist 目录
) else (
    echo ✓ dist 目录不存在，跳过清理
)

echo.
echo [2/3] 构建项目...
call npm run build
if errorlevel 1 (
    echo ✗ 构建失败！请检查错误信息。
    pause
    exit /b 1
)
echo ✓ 构建成功

echo.
echo [3/3] 检查构建结果...
echo.
echo ====================================
echo   dist 目录内容：
echo ====================================
dir dist
echo.

echo ====================================
echo   index.html 内容（前 50 行）：
echo ====================================
type dist\index.html | more +0 | findstr /N /V /C:"" /C:"<!DOCTYPE" /C:"<html" /C:"<head" /C:"<body" /C:"<div" /C:"</div>" /C:"</body>" /C:"</html>" /C:"<meta" /C:"<title" | more /E +0 /P -50
echo.

echo ====================================
echo   检查完成！
echo ====================================
echo.
echo 请检查上面的输出：
echo 1. dist 目录是否包含 index.html 和 assets 文件夹
echo 2. index.html 中的 script 标签是否指向正确的路径
echo    (应该指向 ./assets/index-xxxxx.js 而不是 /src/main.js)
echo.
echo 如果看到 /src/main.js，说明 Vite 没有正确处理 HTML
echo.
pause