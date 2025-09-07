/**
 * @fileName : InfiniteViewModel.ets
 * @author : @cxy
 * @date : 2025/9/5
 * @description : 无限滚动数据管理
 */

import { RefreshController, RefreshDataSource } from "@cxy/refreshlist"
import { ItemModel } from "../../models/ItemModel"

export class InfiniteViewModel {
  @Track dataSource: RefreshDataSource = new RefreshDataSource()
  @Track controller: RefreshController = new RefreshController()
  @Track currentPage: number = 1
  @Track isLoading: boolean = false
  @Track loadedCount: number = 0 //已加载数量
  @Track totalPages: number = 20 // 模拟总共20页数据
  @Track hasMoreData: boolean = true // 是否还有更多数据
  @Track preloadThreshold: number = 3 // 预加载阈值：距离底部3个item时开始加载
  @Track loadError: string = '' // 加载错误信息
  @Track isPreloadVisible: boolean = false // 是否显示预加载指示器
  @Track isPreloading: boolean = false // 防止重复预加载
  private retryCount: number = 0 // 重试次数
  private maxRetries: number = 3 // 最大重试次数
  private pageSize: number = 15

  refresh(): void {
    this.hasMoreData = true
    this.isPreloading = false
    this.loadError = ''
    this.retryCount = 0
    this.isPreloadVisible = false
    this.requestData(1)
  }

  loadMore(): void {
    if (this.hasMoreData && !this.isLoading && !this.isPreloading) {
      this.requestData(this.currentPage + 1)
    }
  }

  // 预加载方法 - 无感知加载的核心
  preloadMore(): void {
    if (this.hasMoreData && !this.isLoading && !this.isPreloading) {
      this.isPreloading = true
      this.isPreloadVisible = true
      this.requestData(this.currentPage + 1, true)
    }
  }

  // 检查是否需要预加载
  checkPreload(currentIndex: number): void {
    const totalCount = this.dataSource.totalCount()
    const remainingItems = totalCount - currentIndex - 1

    // 当剩余item数量小于等于预加载阈值时，触发预加载
    if (remainingItems <= this.preloadThreshold) {
      this.preloadMore()
    }
  }

  // 重试加载
  retryLoad(): void {
    if (this.retryCount < this.maxRetries) {
      this.retryCount++
      this.loadError = ''
      this.requestData(this.currentPage + 1)
    }
  }

  // 动态调整预加载阈值
  adjustPreloadThreshold(): void {
    // 根据加载速度动态调整预加载阈值
    if (this.retryCount > 0) {
      // 网络较慢时，提前更多预加载
      this.preloadThreshold = Math.min(6, this.preloadThreshold + 1)
    } else {
      // 网络良好时，可以适当减少预加载阈值
      this.preloadThreshold = Math.max(3, this.preloadThreshold - 0.5)
    }
  }

  // 获取加载状态描述
  getLoadingStatus(): string {
    if (this.isLoading) {
      return '加载中'
    }
    if (this.isPreloading) {
      return '智能预加载'
    }
    if (this.loadError) {
      return '加载失败'
    }
    if (!this.hasMoreData) {
      return '已加载全部'
    }
    return '就绪'
  }

  // 获取状态颜色
  getStatusColor(): string {
    if (this.isLoading) {
      return '#ff9800'
    }
    if (this.isPreloading) {
      return '#2196F3'
    }
    if (this.loadError) {
      return '#ff4444'
    }
    if (!this.hasMoreData) {
      return '#666'
    }
    return '#4caf50'
  }

  // 格式化数字显示
  formatNumber(num: number): string {
    if (num >= 10000) {
      return `${Math.floor(num / 1000)}k`
    } else if (num >= 1000) {
      return `${(num / 1000).toFixed(1)}k`
    }
    return num.toString()
  }

  private async requestData(page: number, isPreload: boolean = false): Promise<void> {
    if (this.isLoading) {
      return
    }

    // 预加载时不显示loading状态，保持无感知
    if (!isPreload) {
      this.isLoading = true
    }

    // 模拟网络请求延迟和可能的错误
    setTimeout(() => {
      try {
        // 模拟偶尔的网络错误（5%概率）
        if (Math.random() < 0.05 && page > 1) {
          throw new Error('网络连接异常，请稍后重试')
        }

        this.currentPage = page
        const data = this.generateInfiniteData(this.pageSize)

        if (page === 1) {
          this.dataSource.deleteAll()
        }
        this.dataSource.pushDataArray(data)

        // 更新是否还有更多数据
        this.hasMoreData = page < this.totalPages
        this.controller.setHasmore(this.hasMoreData)

        if (!isPreload) {
          this.controller.finishRefresh()
          this.isLoading = false
        }

        // 重置状态
        this.isPreloading = false
        this.isPreloadVisible = false
        this.loadError = ''
        this.retryCount = 0

        this.loadedCount = this.dataSource.totalCount()

        console.log(`${isPreload ? '预加载' : '加载'}完成 - 页面: ${page}, 总数据: ${this.dataSource.totalCount()}`)
      } catch (error) {
        // 错误处理
        this.loadError = error.message || '加载失败'
        this.isLoading = false
        this.isPreloading = false
        this.isPreloadVisible = false

        if (!isPreload) {
          this.controller.finishRefresh()
        }

        console.error(`加载失败: ${error.message}`)
      }
    }, isPreload ? 200 : (page === 1 ? 800 : 500)) // 预加载更快，提升体验
  }

  private generateInfiniteData(count: number): ItemModel[] {
    const newsCategories = [
      '科技前沿', '人工智能', '移动开发', '云计算', '大数据',
      '区块链', '物联网', '网络安全', '开源项目', '编程语言'
    ]

    const newsTitles = [
      'HarmonyOS NEXT 发布重大更新',
      'AI 技术在移动端的最新应用',
      '跨平台开发框架性能对比',
      '云原生架构设计最佳实践',
      '大数据处理技术新突破',
      '区块链技术在金融领域的应用',
      '5G 时代的物联网发展趋势',
      '网络安全防护策略升级',
      '开源社区贡献指南',
      '新一代编程语言特性解析'
    ]

    const descriptions = [
      '深入解析最新技术动态，为开发者提供前沿资讯和实用指南。',
      '探索创新应用场景，分享实战经验和最佳实践案例。',
      '全面对比分析，帮助开发者做出明智的技术选择。',
      '详细介绍核心概念和实现方法，提升开发效率。',
      '分享行业洞察和趋势预测，把握技术发展方向。'
    ]

    const colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
      '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
    ]

    const result: ItemModel[] = []
    for (let i = 0; i < count; i++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + i
      const categoryIndex = globalIndex % newsCategories.length
      const titleIndex = globalIndex % newsTitles.length

      const item = new ItemModel(`infinite_${globalIndex}`, newsTitles[titleIndex])
      item.description = descriptions[globalIndex % descriptions.length]
      item.category = newsCategories[categoryIndex]
      item.avatarColor = colors[categoryIndex]
      item.initial = newsCategories[categoryIndex].charAt(0)
      item.time = this.getTimeAgo(globalIndex)
      item.views = Math.floor(Math.random() * 10000) + 100
      item.likes = Math.floor(Math.random() * 500) + 10
      item.comments = Math.floor(Math.random() * 100) + 5
      item.isHot = globalIndex % 7 === 0 // 每7个标记为热门
      item.author = this.getRandomAuthor()
      item.index = globalIndex + 1

      result.push(item)
    }
    return result
  }

  private getTimeAgo(index: number): string {
    const minutes = index * 3 + Math.floor(Math.random() * 10)

    if (minutes < 60) {
      return `${minutes}分钟前`
    } else if (minutes < 1440) { // 24小时
      const hours = Math.floor(minutes / 60)
      return `${hours}小时前`
    } else {
      const days = Math.floor(minutes / 1440)
      return `${days}天前`
    }
  }

  private getRandomAuthor(): string {
    const authors = [
      '技术小编', '开发者社区', '科技观察员', '代码工匠', '架构师',
      '产品经理', '设计师', 'AI研究员', '数据分析师', '安全专家'
    ]
    return authors[Math.floor(Math.random() * authors.length)]
  }
}