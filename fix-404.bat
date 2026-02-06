@echo off
echo ====================================
echo   修复 GitHub Pages 404 错误
echo ====================================
echo.

echo [1/4] 清理旧的构建文件...
if exist "dist" (
    rmdir /s /q dist
    echo ✓ 已清理 dist 目录
) else (
    echo ✓ dist 目录不存在，跳过清理
)

echo.
echo [2/4] 重新构建项目...
call npm run build
if errorlevel 1 (
    echo ✗ 构建失败！请检查错误信息。
    pause
    exit /b 1
)
echo ✓ 构建成功

echo.
echo [3/4] 检查构建结果...
if not exist "dist\index.html" (
    echo ✗ 错误：dist\index.html 不存在！
    pause
    exit /b 1
)
echo ✓ 构建文件已生成

echo.
echo [4/4] 提交更改到 Git...
git add .
git commit -m "修复 404 错误：使用相对路径重新构建"
if errorlevel 1 (
    echo 没有需要提交的更改，或提交失败
) else (
    echo ✓ 已提交更改
    echo.
    echo 是否立即推送到 GitHub？(Y/N)
    choice /c YN /n /m "请选择: "
    if errorlevel 2 goto :skip_push
    if errorlevel 1 goto :do_push

    :do_push
    echo.
    echo 正在推送到 GitHub...
    git push
    if errorlevel 1 (
        echo ✗ 推送失败！请检查网络连接和 Git 配置。
    ) else (
        echo ✓ 推送成功
    )
    goto :end

    :skip_push
    echo ✓ 已跳过推送
)

:end
echo.
echo ====================================
echo   修复完成！
echo ====================================
echo.
echo 下一步操作：
echo 1. 等待 1-3 分钟让 GitHub Pages 更新
echo 2. 刷新浏览器访问您的网站
echo 3. 打开开发者工具（F12）检查是否还有 404 错误
echo.
echo 如果问题仍未解决，请查看 fix-404.md 获取更多帮助。
echo.
pause