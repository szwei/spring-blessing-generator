import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  // 使用相对路径，避免 GitHub Pages 和其他部署平台的路径问题
  // 这样可以确保在任何环境下都能正常加载资源
  base: './',
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  server: {
    port: 3000,
    open: true
  },
  build: {
    outDir: 'docs',
    assetsDir: 'assets',
    sourcemap: false
  }
})