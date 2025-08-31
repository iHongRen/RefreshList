/**
 * @fileName : SearchViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 搜索功能数据管理
 */

import { RefreshDataSource, RefreshController } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'

export class SearchViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentKeyword: string = ''
  private currentPage: number = 1
  private pageSize: number = 20
  private hotTags: string[] = [
    'HarmonyOS', 'ArkTS', 'RefreshList', '鸿蒙开发',
    '移动应用', 'UI组件', '性能优化', '用户体验'
  ]

  refresh(keyword: string = ''): void {
    this.currentKeyword = keyword
    this.currentPage = 1

    if (!keyword.trim()) {
      this.dataSource.deleteAll()
      this.controller.finishRefresh()
      return
    }

    // 模拟搜索API调用
    setTimeout(() => {
      this.dataSource.deleteAll()
      const results = this.performSearch(keyword, this.pageSize)
      this.dataSource.pushDataArray(results)
      this.controller.finishRefresh()
      this.controller.setHasmore(results.length >= this.pageSize)
    }, 800)
  }

  search(keyword: string) {
    this.refresh(keyword)
  }

  loadMore(): void {
    if (!this.currentKeyword) {
      return
    }

    this.currentPage++

    setTimeout(() => {
      const results = this.performSearch(this.currentKeyword, this.pageSize)
      this.dataSource.pushDataArray(results)

      // 模拟搜索结果有限
      if (this.currentPage >= 5 || results.length < this.pageSize) {
        this.controller.setHasmore(false)
      }

      this.controller.finishRefresh()
    }, 600)
  }

  getHotSearchTags(): string[] {
    return this.hotTags
  }

  private performSearch(keyword: string, count: number): ItemModel[] {
    // 模拟搜索数据库
    const mockDatabase = this.generateMockDatabase()

    // 简单的搜索算法
    const results = mockDatabase.filter(item =>
    item.title.toLowerCase().includes(keyword.toLowerCase()) ||
      (item.description && item.description.toLowerCase().includes(keyword.toLowerCase())) ||
      (item.category && item.category.toLowerCase().includes(keyword.toLowerCase()))
    )

    // 计算匹配度并排序
    const scoredResults = results.map(item => {
      let score = 0
      const lowerKeyword = keyword.toLowerCase()
      const lowerTitle = item.title.toLowerCase()
      const lowerDesc = (item.description || '').toLowerCase()

      // 标题完全匹配
      if (lowerTitle === lowerKeyword) {
        score += 100
      }
      // 标题开头匹配
      else if (lowerTitle.startsWith(lowerKeyword)) {
        score += 80
      }
      // 标题包含
      else if (lowerTitle.includes(lowerKeyword)) {
        score += 60
      }

      // 描述匹配
      if (lowerDesc.includes(lowerKeyword)) {
        score += 30
      }

      // 分类匹配
      if (item.category && item.category.toLowerCase().includes(lowerKeyword)) {
        score += 20
      }

      const scoredItem = new ItemModel(item.id, item.title)
      // 复制所有属性
      // Object.assign(scoredItem, item)
      // 设置新的属性
      scoredItem.score = Math.min(100, score)
      scoredItem.id = `search_${item.id}_${this.currentPage}`
      return scoredItem
    })

    // 按匹配度排序
    scoredResults.sort((a, b) => (b.score || 0) - (a.score || 0))

    // 分页返回结果
    const startIndex = (this.currentPage - 1) * count
    return scoredResults.slice(startIndex, startIndex + count)
  }

  private generateMockDatabase(): ItemModel[] {
    const categories = [
      'HarmonyOS开发', 'ArkTS教程', 'UI组件', '性能优化', '用户体验',
      '移动应用', '前端技术', '后端开发', '数据库', '网络编程'
    ]

    const titles = [
      'HarmonyOS NEXT 开发指南', 'ArkTS 语言特性详解', 'RefreshList 组件使用教程',
      '鸿蒙应用性能优化技巧', '移动端UI设计原则', 'List组件最佳实践',
      '数据绑定与状态管理', '网络请求处理方案', '本地存储使用指南',
      '动画效果实现方法', '自定义组件开发', '应用架构设计模式',
      '调试技巧与工具', '发布流程详解', '用户体验优化',
      '响应式布局实现', '多媒体处理', '设备适配方案',
      '安全开发规范', '测试策略与方法'
    ]

    const descriptions = [
      '详细介绍HarmonyOS NEXT的核心特性和开发流程，帮助开发者快速上手。',
      '深入解析ArkTS语言的语法特性，包括装饰器、状态管理等高级用法。',
      '全面讲解RefreshList组件的使用方法，包含各种自定义场景。',
      '分享鸿蒙应用性能优化的实用技巧，提升应用运行效率。',
      '探讨移动端UI设计的核心原则，创造优秀的用户体验。'
    ]

    const result: ItemModel[] = []
    for (let index = 0; index < 200; index++) {
      const item = new ItemModel(`mock_${index}`, titles[index % titles.length])
      item.description = descriptions[index % descriptions.length]
      item.category = categories[index % categories.length]
      item.views = Math.floor(Math.random() * 10000) + 100
      item.likes = Math.floor(Math.random() * 1000) + 10
      item.time = this.getRandomTime()
      item.image = `https://picsum.photos/100/100?random=${index}`

      result.push(item)
    }
    return result
  }

  private getRandomTime(): string {
    const times = [
      '刚刚', '5分钟前', '10分钟前', '30分钟前', '1小时前',
      '2小时前', '今天', '昨天', '2天前', '1周前'
    ]
    return times[Math.floor(Math.random() * times.length)]
  }
}