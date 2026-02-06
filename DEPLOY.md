# 部署指南

## 📋 前置准备

1. Gitee 账号
2. 已完成项目构建
3. Git 工具

## 🚀 Gitee Pages 部署步骤

### 1. 创建 Gitee 仓库

1. 登录 Gitee (https://gitee.com)
2. 点击右上角 "+" 号，选择"新建仓库"
3. 填写仓库信息：
   - 仓库名称：`spring-blessing-generator`
   - 仓库介绍：`福满人间 - 春节祝福语生成器`
   - 是否开源：✅ 公开
   - 初始化仓库：❌ 不初始化
4. 点击"创建"按钮

### 2. 推送代码到 Gitee

在项目根目录执行以下命令：

```bash
# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 提交更改
git commit -m "初始提交：福满人间 - 春节祝福语生成器"

# 关联远程仓库
git remote add origin https://gitee.com/你的用户名/spring-blessing-generator.git

# 推送代码
git push -u origin main
```

### 3. 构建项目

```bash
npm install
npm run build
```

构建完成后，`dist` 目录包含所有需要部署的文件。

### 4. 开启 Gitee Pages

1. 进入 Gitee 仓库页面
2. 点击顶部菜单 "服务" -> "Gitee Pages"
3. 首次使用需要实名认证
4. 部署设置：
   - **部署分支**：`main`
   - **部署目录**：`dist`
5. 点击"启动"按钮
6. 等待部署完成（通常需要 1-3 分钟）

### 5. 访问网站

部署成功后，会显示访问地址，格式为：
```
https://你的用户名.gitee.io/spring-blessing-generator
```

## 🔄 自动化部署（可选）

### 使用 GitHub Actions

创建 `.github/workflows/deploy.yml` 文件：

```yaml
name: Deploy to Gitee Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'

    - name: Install dependencies
      run: npm install

    - name: Build
      run: npm run build

    - name: Deploy to Gitee Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./dist
```

## 🌐 其他部署方式

### Vercel 部署

1. 安装 Vercel CLI：
```bash
npm install -g vercel
```

2. 部署：
```bash
vercel
```

### Netlify 部署

1. 登录 Netlify
2. 拖拽 `dist` 文件夹到部署区域
3. 等待部署完成

### 服务器部署

1. 构建：
```bash
npm run build
```

2. 将 `dist` 目录上传到服务器
3. 使用 Nginx 配置静态网站：

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /path/to/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

## 📝 域名绑定（可选）

### Gitee Pages 自定义域名

1. 在域名服务商处添加 CNAME 记录：
   - 主机记录：`www`
   - 记录类型：`CNAME`
   - 记录值：`你的用户名.gitee.io`

2. 在 Gitee Pages 设置中添加自定义域名

3. 等待 DNS 生效（通常 1-24 小时）

## 🔍 常见问题

### Q: 部署后页面空白？
A: 检查 `vite.config.js` 中的 `base` 配置，确保路径正确。

### Q: Gitee Pages 更新慢？
A: Gitee Pages 更新需要手动点击"更新"按钮，且有一定延迟。

### Q: 如何配置 HTTPS？
A: Gitee Pages 默认支持 HTTPS，无需额外配置。

### Q: 部署后访问 404？
A: 检查部署目录是否设置为 `dist`，并确认构建成功。

## 📚 相关资源

- [Gitee Pages 官方文档](https://gitee.com/help/articles/4136)
- [Vite 官方文档](https://vitejs.dev/)
- [Vue 3 官方文档](https://vuejs.org/)
- [Element Plus 官方文档](https://element-plus.org/)

---

如有其他问题，请参考项目 README 或提交 Issue。