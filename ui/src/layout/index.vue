<template>
  <div class="layout">
    <!-- 侧边栏 -->
    <Sidebar v-if="!isMobile || !sidebarCollapse"/>

    <!-- 主内容区域 -->
    <div :class="{ 'is-mobile': isMobile, 'collapsed': sidebarCollapse }" class="main-container">
      <!-- 顶部导航栏 -->
      <Navbar/>

      <!-- 标签页 -->
      <TagsView v-if="settings.showTagsView"/>

      <!-- 主内容 -->
      <AppMain/>
    </div>
  </div>
</template>

<script lang="ts" name="Layout" setup>
import {computed} from 'vue'
import {useAppStore} from '@/stores/app'
import {useSettingsStore} from '@/stores/settings'
import Sidebar from './components/Sidebar/index.vue'
import Navbar from './components/Navbar/index.vue'
import TagsView from './components/TagsView/index.vue'
import AppMain from './components/AppMain.vue'

const appStore = useAppStore()
const settingsStore = useSettingsStore()

const sidebarCollapse = computed(() => appStore.sidebar.collapse)
const isMobile = computed(() => appStore.device === 'mobile')
const settings = computed(() => settingsStore.settings)
</script>

<style lang="scss" scoped>
.layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

.main-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
  transition: margin-left 0.28s;

  &.collapsed {
    margin-left: 64px;
  }

  &:not(.collapsed) {
    margin-left: 210px;
  }

  &.is-mobile {
    margin-left: 0 !important;
  }
}
</style>