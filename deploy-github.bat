@echo off
echo ====================================
echo   GitHub Pages 部署助手
echo ====================================
echo.

REM 检查是否已初始化 Git
if not exist ".git" (
    echo [1/5] 初始化 Git 仓库...
    git init
    if errorlevel 1 (
        echo 错误：Git 初始化失败！请确保已安装 Git。
        pause
        exit /b 1
    )
    echo ✓ Git 仓库初始化成功
) else (
    echo [1/5] Git 仓库已存在
)

echo.
echo [2/5] 添加所有文件到暂存区...
git add .
if errorlevel 1 (
    echo 错误：添加文件失败！
    pause
    exit /b 1
)
echo ✓ 文件添加成功

echo.
echo [3/5] 提交更改...
git commit -m "部署：福满人间 - 春节祝福语生成器"
if errorlevel 1 (
    echo 错误：提交失败！
    pause
    exit /b 1
)
echo ✓ 提交成功

echo.
echo [4/5] 请输入您的 GitHub 仓库地址
echo 格式：https://github.com/YOUR_USERNAME/spring-blessing-generator.git
echo.
set /p REPO_URL="仓库地址："

if "%REPO_URL%"=="" (
    echo 错误：仓库地址不能为空！
    pause
    exit /b 1
)

echo.
echo [5/5] 推送代码到 GitHub...
git remote add origin %REPO_URL% 2>nul
git push -u origin main
if errorlevel 1 (
    echo.
    echo 错误：推送失败！
    echo.
    echo 可能的原因：
    echo 1. 仓库地址不正确
    echo 2. 需要身份验证
    echo 3. 网络连接问题
    echo.
    echo 解决方案：
    echo 1. 检查仓库地址是否正确
    echo 2. 配置 Git 用户信息：
    echo    git config user.name "Your Name"
    echo    git config user.email "your.email@example.com"
    echo 3. 如果需要身份验证，GitHub 支持使用 Personal Access Token
    echo.
    pause
    exit /b 1
)

echo.
echo ====================================
echo   ✓ 部署成功！
echo ====================================
echo.
echo 下一步操作：
echo 1. 访问您的 GitHub 仓库
echo 2. 进入 Settings → Pages
echo 3. 在 "Build and deployment" 中选择：
echo    - Source: Deploy from a branch
echo    - Branch: main
echo    - Folder: / (root)
echo 4. 点击 Save
echo 5. 等待 1-3 分钟
echo 6. 访问您的网站！
echo.
echo 网站地址格式：
echo https://YOUR_USERNAME.github.io/spring-blessing-generator/
echo.
pause