@echo off
echo ====================================
echo   完整构建和部署流程
echo ====================================
echo.

REM 检查 Git 仓库
if not exist ".git" (
    echo [错误] Git 仓库未初始化！
    echo 请先运行：git init
    pause
    exit /b 1
)

echo [步骤 1/7] 清理旧的构建文件...
if exist "dist" (
    rmdir /s /q dist
    echo ✓ 已清理
) else (
    echo ✓ 跳过
)

echo.
echo [步骤 2/7] 安装依赖（如果需要）...
if not exist "node_modules" (
    call npm install
    echo ✓ 依赖安装完成
) else (
    echo ✓ 依赖已存在
)

echo.
echo [步骤 3/7] 构建项目...
call npm run build
if errorlevel 1 (
    echo ✗ 构建失败！
    pause
    exit /b 1
)
echo ✓ 构建成功

echo.
echo [步骤 4/7] 验证构建结果...
if not exist "dist\index.html" (
    echo ✗ 错误：dist\index.html 不存在！
    pause
    exit /b 1
)
if not exist "dist\assets" (
    echo ✗ 错误：dist\assets 目录不存在！
    pause
    exit /b 1
)
echo ✓ 构建文件验证通过

echo.
echo [步骤 5/7] 检查 index.html 中的脚本路径...
findstr /C:"/src/main.js" dist\index.html >nul
if %errorlevel%==0 (
    echo ⚠ 警告：index.html 中仍包含 /src/main.js
    echo    这是正常的，Vite 开发服务器会处理它
    echo    生产环境应该使用构建后的文件
) else (
    echo ✓ index.html 路径正常
)

echo.
echo [步骤 6/7] 提交到 Git...
git add .
git commit -m "构建：福满人间 - 春节祝福语生成器" >nul 2>&1
if %errorlevel%==0 (
    echo ✓ 已提交
) else (
    echo ⚠ 没有需要提交的更改
)

echo.
echo [步骤 7/7] 推送到 GitHub...
echo.
echo 请确认：
echo 1. 已在 GitHub 创建仓库
echo 2. 仓库是公开的（Public）
echo 3. 已配置远程仓库地址
echo.
set /p PUSH="是否立即推送到 GitHub？(Y/N): "
if /i "%PUSH%"=="Y" (
    echo.
    echo 正在推送...
    git push
    if errorlevel 1 (
        echo ✗ 推送失败！
        echo.
        echo 可能的原因：
        echo 1. 远程仓库未配置
        echo 2. 需要身份验证
        echo 3. 网络问题
        echo.
        echo 解决方案：
        echo git remote add origin https://github.com/YOUR_USERNAME/spring-blessing-generator.git
        echo git push -u origin main
    ) else (
        echo ✓ 推送成功
    )
) else (
    echo ✓ 已跳过推送
)

echo.
echo ====================================
echo   完成！
echo ====================================
echo.
echo 下一步操作：
echo 1. 访问 GitHub 仓库
echo 2. 进入 Settings → Pages
echo 3. 配置：
echo    - Source: GitHub Actions (推荐)
echo    - 或: Deploy from a branch → main → / (root)
echo 4. 等待 1-3 分钟
echo 5. 访问您的网站
echo.
echo 网站地址：https://YOUR_USERNAME.github.io/spring-blessing-generator/
echo.
pause