<template>
  <div class="app-container">
    <div class="header">
      <div class="header-content">
        <h1 class="title">🧧 福满人间</h1>
        <p class="subtitle">春节祝福语生成器</p>
      </div>
    </div>

    <div class="main-content">
      <el-card class="generator-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <span class="card-title">✨ 定制您的专属祝福</span>
          </div>
        </template>

        <div class="form-section">
          <el-form :model="form" label-position="top">
            <el-form-item label="选择祝福类型">
              <el-select v-model="form.type" placeholder="请选择祝福类型" style="width: 100%">
                <el-option label="🎊 普通祝福" value="general"></el-option>
                <el-option label="👨‍👩‍👧‍👦 家人祝福" value="family"></el-option>
                <el-option label="💼 商务祝福" value="business"></el-option>
                <el-option label="💑 情人祝福" value="love"></el-option>
                <el-option label="👋 朋友祝福" value="friend"></el-option>
                <el-option label="🌸 温馨祝福" value="warm"></el-option>
              </el-select>
            </el-form-item>

            <el-form-item label="对方称呼（可选）">
              <el-input v-model="form.name" placeholder="例如：张总、爸爸、亲爱的"></el-input>
            </el-form-item>

            <el-form-item label="自定义关键词（可选）">
              <el-input v-model="form.keywords" placeholder="例如：健康、财富、幸福"></el-input>
            </el-form-item>

            <el-form-item label="祝福风格">
              <el-radio-group v-model="form.style">
                <el-radio value="traditional">传统典雅</el-radio>
                <el-radio value="modern">现代时尚</el-radio>
                <el-radio value="humorous">幽默风趣</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-form>

          <div class="button-group">
            <el-button type="primary" size="large" @click="generateBlessing" :loading="loading">
              <el-icon><MagicStick /></el-icon>
              生成祝福语
            </el-button>
            <el-button size="large" @click="resetForm">
              <el-icon><Refresh /></el-icon>
              重置
            </el-button>
          </div>
        </div>
      </el-card>

      <el-card v-if="generatedBlessing" class="result-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <span class="card-title">🎁 您的专属祝福</span>
          </div>
        </template>

        <div class="blessing-content">
          <div class="blessing-text">{{ generatedBlessing }}</div>
          <div class="blessing-footer">
            <span v-if="form.name" class="blessing-recipient">致：{{ form.name }}</span>
            <span class="blessing-signature">—— 福满人间 敬上</span>
            <span class="blessing-date">{{ currentDate }}</span>
          </div>
        </div>

        <div class="action-buttons">
          <el-button type="success" @click="copyBlessing">
            <el-icon><DocumentCopy /></el-icon>
            复制
          </el-button>
          <el-button type="warning" @click="saveAsImage">
            <el-icon><Download /></el-icon>
            保存图片
          </el-button>
          <el-button type="danger" @click="shareBlessing">
            <el-icon><Share /></el-icon>
            分享
          </el-button>
          <el-button @click="regenerate">
            <el-icon><RefreshRight /></el-icon>
            换一条
          </el-button>
        </div>
      </el-card>
    </div>

    <div class="footer">
      <p>© 2026 福满人间 - 春节祝福语生成器 | 愿您新年快乐，万事如意！</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'

const form = ref({
  type: 'general',
  name: '',
  keywords: '',
  style: 'traditional'
})

const loading = ref(false)
const generatedBlessing = ref('')

const currentDate = computed(() => {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
})

const blessings = {
  general: [
    '新春佳节，万象更新。愿您在新的一年里，身体健康，工作顺利，家庭幸福，万事如意！',
    '瑞雪兆丰年，春风送祝福。祝您新年快乐，财源广进，福星高照，心想事成！',
    '爆竹声中一岁除，春风送暖入屠苏。愿您新年新气象，好运连连，笑口常开！',
    '金龙献瑞，福满人间。祝您新春大吉，阖家欢乐，平安喜乐，福星高照！'
  ],
  family: [
    '爸爸妈妈，新春快乐！感谢你们一年来的辛劳付出，愿你们在新的一年里身体健康，笑口常开！',
    '亲爱的家人们，新年好！愿我们全家团团圆圆，和和美美，幸福美满，万事如意！',
    '爷爷奶奶，新年快乐！祝您福如东海，寿比南山，身体健康，笑口常开！',
    '家是最小国，国是千万家。愿我们全家新年快乐，幸福安康，团团圆圆！'
  ],
  business: [
    '尊敬的{name}，新春佳节之际，祝您事业蒸蒸日上，财源广进，前程似锦，万事如意！',
    '{name}，新年好！感谢您过去一年的支持与合作，愿我们携手共进，共创辉煌！',
    '祝{name}及全体同仁新春快乐，生意兴隆，财源滚滚，大展宏图！',
    '{name}，新年伊始，万象更新。祝您在新的一年里事业有成，步步高升！'
  ],
  love: [
    '亲爱的{name}，新春快乐！愿你如春风般温暖，如夏花般绚烂，如秋月般皎洁，如冬雪般纯洁！',
    '{name}，新年好！愿我们的爱情如美酒般醇厚，如蜜糖般甜蜜，永远幸福美满！',
    '亲爱的{name}，愿我们携手走过每一个春夏秋冬，共同迎接美好的未来！',
    '{name}，新春佳节，愿我们的爱情长长久久，甜甜蜜蜜，幸福美满！'
  ],
  friend: [
    '亲爱的朋友{name}，新年快乐！愿我们的友谊如美酒般醇厚，如星辰般永恒！',
    '{name}，新年好！愿你在新的一年里心想事成，好运连连，笑口常开！',
    '老友{name}，新春佳节，愿我们友谊长存，共同进步，共创美好未来！',
    '{name}，新年快乐！愿我们的友谊如春风般温暖，如夏花般绚烂！'
  ],
  warm: [
    '新年到，福气到。愿您在新的一年里，身体健康，心情愉快，家庭幸福，万事如意！',
    '春风送暖，福满人间。祝您新年快乐，平安喜乐，幸福美满，心想事成！',
    '新年新气象，好运从天降。愿您在新的一年里，财源广进，福星高照，笑口常开！',
    '爆竹声中辞旧岁，春风送暖迎新春。愿您新年快乐，万事如意，平安喜乐！'
  ]
}

const generateBlessing = () => {
  loading.value = true
  setTimeout(() => {
    const typeBlessings = blessings[form.value.type] || blessings.general
    let blessing = typeBlessings[Math.floor(Math.random() * typeBlessings.length)]

    // 替换占位符
    if (form.value.name) {
      blessing = blessing.replace(/{name}/g, form.value.name)
    }

    // 添加关键词
    if (form.value.keywords) {
      blessing += `\n\n特别祝福您：${form.value.keywords}常伴左右！`
    }

    // 根据风格调整
    if (form.value.style === 'modern') {
      blessing = `🎉 ${blessing} 🎉`
    } else if (form.value.style === 'humorous') {
      blessing = `😄 ${blessing} 😄`
    }

    generatedBlessing.value = blessing
    loading.value = false
    ElMessage.success('祝福语生成成功！')
  }, 500)
}

const copyBlessing = () => {
  navigator.clipboard.writeText(generatedBlessing.value).then(() => {
    ElMessage.success('复制成功！')
  }).catch(() => {
    ElMessage.error('复制失败，请手动复制')
  })
}

const saveAsImage = () => {
  ElMessage.info('图片保存功能开发中...')
}

const shareBlessing = () => {
  if (navigator.share) {
    navigator.share({
      title: '福满人间 - 春节祝福',
      text: generatedBlessing.value
    }).catch(() => {})
  } else {
    ElMessage.info('您的浏览器不支持原生分享功能')
  }
}

const regenerate = () => {
  generateBlessing()
}

const resetForm = () => {
  form.value = {
    type: 'general',
    name: '',
    keywords: '',
    style: 'traditional'
  }
  generatedBlessing.value = ''
}
</script>

<style scoped>
.app-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.header {
  text-align: center;
  padding: 40px 20px;
  color: white;
}

.header-content {
  max-width: 800px;
  margin: 0 auto;
}

.title {
  font-size: 48px;
  font-weight: bold;
  margin-bottom: 10px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.subtitle {
  font-size: 20px;
  opacity: 0.9;
}

.main-content {
  max-width: 900px;
  margin: 0 auto 40px;
}

.generator-card {
  margin-bottom: 30px;
  border-radius: 16px;
  overflow: hidden;
}

.result-card {
  border-radius: 16px;
  overflow: hidden;
  background: linear-gradient(135deg, #fff5f5 0%, #ffe3e3 100%);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-title {
  font-size: 20px;
  font-weight: bold;
}

.form-section {
  padding: 20px 0;
}

.button-group {
  display: flex;
  gap: 15px;
  margin-top: 30px;
  justify-content: center;
}

.blessing-content {
  background: white;
  padding: 30px;
  border-radius: 12px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.blessing-text {
  font-size: 18px;
  line-height: 2;
  color: #333;
  white-space: pre-wrap;
  text-align: center;
  margin-bottom: 20px;
}

.blessing-footer {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8px;
  color: #666;
  font-size: 14px;
  margin-top: 30px;
}

.blessing-recipient {
  color: #e74c3c;
  font-weight: 500;
}

.blessing-signature {
  color: #333;
  font-weight: 500;
}

.blessing-date {
  color: #999;
}

.action-buttons {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  justify-content: center;
}

.footer {
  text-align: center;
  color: white;
  padding: 30px 20px;
  opacity: 0.8;
}

.footer p {
  margin: 0;
  font-size: 14px;
}

@media (max-width: 768px) {
  .title {
    font-size: 32px;
  }

  .subtitle {
    font-size: 16px;
  }

  .button-group {
    flex-direction: column;
  }

  .button-group .el-button {
    width: 100%;
  }

  .action-buttons {
    flex-direction: column;
  }

  .action-buttons .el-button {
    width: 100%;
  }
}
</style>