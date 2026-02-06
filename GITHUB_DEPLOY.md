# GitHub Pages 部署指南

## 🎯 为什么选择 GitHub Pages？

✅ **完全免费** - 无需任何费用
✅ **永久在线** - 只要 GitHub 在，您的网站就在
✅ **自定义域名** - 支持绑定自己的域名
✅ **HTTPS 支持** - 自动配置 SSL 证书
✅ **GitHub 集成** - 与 Git 仓库完美结合

## 📋 前置准备

1. GitHub 账号（免费注册：https://github.com）
2. Git 工具
3. 项目代码

## 🚀 部署步骤

### 方法一：使用 GitHub 网页端部署（推荐新手）

#### 步骤 1：创建 GitHub 仓库

1. 登录 GitHub（https://github.com）
2. 点击右上角 "+" 号，选择 "New repository"
3. 填写仓库信息：
   - **Repository name**: `spring-blessing-generator`（或你喜欢的名字）
   - **Description**: `福满人间 - 春节祝福语生成器`
   - **Public** 选择 ✅ 公开（GitHub Pages 必须是公开仓库）
   - **Add a README file** ❌ 不勾选（我们已有 README）
   - **Add .gitignore** ❌ 不勾选（我们已有 .gitignore）
4. 点击 "Create repository"

#### 步骤 2：上传代码

在项目根目录执行以下命令：

```bash
# 进入项目目录
cd E:\testAi\test1\spring-blessing-generator

# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 提交更改
git commit -m "初始提交：福满人间 - 春节祝福语生成器"

# 关联远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/spring-blessing-generator.git

# 推送代码
git push -u origin main
```

#### 步骤 3：配置 GitHub Pages

1. 进入 GitHub 仓库页面
2. 点击顶部的 "Settings" 标签
3. 在左侧菜单找到 "Pages"（在 "Code and automation" 部分）
4. 在 "Build and deployment" 部分：
   - **Source**: 选择 "Deploy from a branch"
   - **Branch**: 选择 `main` 分支
   - **Folder**: 选择 `/ (root)`
5. 点击 "Save"

#### 步骤 4：等待部署

- 部署通常需要 1-3 分钟
- 状态会从 "Deploying..." 变为 "Deployed"
- 部署成功后会显示访问地址

#### 步骤 5：访问网站

你的网站地址格式为：
```
https://YOUR_USERNAME.github.io/spring-blessing-generator/
```

---

### 方法二：使用 GitHub Actions 自动部署（推荐）

#### 步骤 1：创建工作流文件

创建 `.github/workflows/deploy.yml` 文件：

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: './dist'

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

#### 步骤 2：推送代码

```bash
git add .
git commit -m "添加 GitHub Actions 自动部署"
git push
```

#### 步骤 3：启用 GitHub Pages

1. 进入仓库 Settings → Pages
2. 在 "Build and deployment" 中选择 "GitHub Actions"
3. 点击 "Save"

#### 步骤 4：自动部署

- 每次推送代码到 `main` 分支，GitHub Actions 会自动构建并部署
- 可以在 "Actions" 标签查看部署状态

---

## 🎨 自定义域名（可选）

### 步骤 1：购买域名

- 推荐域名服务商：阿里云、腾讯云、Namecheap 等
- 购买一个域名（如 `yourdomain.com`）

### 步骤 2：配置 DNS

在域名服务商处添加 DNS 记录：

```
类型：CNAME
主机记录：www
记录值：YOUR_USERNAME.github.io
```

### 步骤 3：在 GitHub 配置域名

1. 进入仓库 Settings → Pages
2. 在 "Custom domain" 中输入你的域名
3. 点击 "Save"

### 步骤 4：配置 HTTPS

1. 在 Custom domain 下方点击 "Enforce HTTPS"
2. 等待几分钟，HTTPS 会自动启用

---

## 📝 重要配置

### 1. 确保 Vite 配置正确

检查 `vite.config.js`：

```javascript
export default defineConfig({
  base: '/spring-blessing-generator/', // 重要：与仓库名一致
  // ... 其他配置
})
```

如果仓库名是 `YOUR_USERNAME.github.io`，则 `base: '/'`

### 2. 确保 index.html 路径正确

```html
<link rel="icon" href="/favicon.ico">
```

### 3. 构建检查

```bash
npm run build
```

检查 `dist` 目录是否正确生成。

---

## 🔄 更新网站

### 本地修改后更新：

```bash
# 修改代码...

# 提交更改
git add .
git commit -m "更新祝福语模板"
git push
```

### 使用 GitHub Actions（方法二）：
- 代码推送后自动部署
- 1-3 分钟后即可访问更新后的网站

### 手动触发（方法一）：
1. 重新构建：`npm run build`
2. 提交并推送
3. GitHub Pages 会自动更新

---

## 🐛 常见问题

### Q1: 部署后页面空白？

**解决方案：**
1. 检查 `vite.config.js` 中的 `base` 配置
2. 确保路径与仓库名一致
3. 检查浏览器控制台是否有错误

### Q2: 部署失败？

**解决方案：**
1. 检查 Actions 标签查看错误日志
2. 确保依赖都正确安装：`npm install`
3. 尝试重新构建：`npm run build`

### Q3: 如何删除网站？

**解决方案：**
1. 进入仓库 Settings → Pages
2. 点击 "Delete this site"

### Q4: 如何查看部署日志？

**解决方案：**
1. 进入仓库
2. 点击 "Actions" 标签
3. 查看最近的 workflow 运行记录

### Q5: 更新后访问还是旧版本？

**解决方案：**
1. 清除浏览器缓存
2. 强制刷新：Ctrl + F5
3. 等待几分钟让 CDN 缓存更新

---

## 📊 优势对比

| 特性 | GitHub Pages | 其他平台 |
|------|-------------|---------|
| 费用 | 完全免费 | 部分收费 |
| 流量限制 | 100GB/月 | 各不相同 |
| 自定义域名 | 支持 | 支持 |
| HTTPS | 自动配置 | 可能需要额外配置 |
| CI/CD | GitHub Actions | 需要额外配置 |
| 构建时间 | 有限制 | 有限制 |

---

## 🎉 部署成功！

现在你的网站已经免费部署到 GitHub Pages 上了！

访问地址：
```
https://YOUR_USERNAME.github.io/spring-blessing-generator/
```

**分享给朋友，让他们也体验一下你的春节祝福语生成器吧！** 🧧✨

---

## 📚 相关资源

- [GitHub Pages 官方文档](https://docs.github.com/en/pages)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Vite 部署指南](https://vitejs.dev/guide/static-deploy.html#github-pages)
- [Vue 3 官方文档](https://vuejs.org/)

---

如有问题，请提交 Issue 或参考项目 README。