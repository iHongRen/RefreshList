/**
 * @fileName : RefreshGroupDataSource.ets
 * @author : @cxy
 * @date : 2024/9/20
 * @description : 分组数据源
 */
import { RefreshDataSource } from './RefreshDataSource'
import { RefreshGroupModel } from './RefreshGroupModel'

export class RefreshGroupDataSource extends RefreshDataSource {
  public isEmpty(): boolean {
    return this.totalItemCount() === 0
  }

  // 如果是Group，则计算所有的GroupItem之和
  public totalItemCount(): number {
    const count = this.list.length
    if (count === 0) {
      return 0
    }
    let itemCount = 0
    for (let index = 0; index < count; index++) {
      const e = this.list[index]
      if (e instanceof RefreshGroupModel) {
        itemCount += e.dataSource.totalCount()
      }
    }
    return itemCount
  }

  public getGroupDataAll(): Object[] {
    const all: Object[] = []
    this.list.forEach((e: Object) => {
      if (e instanceof RefreshGroupModel) {
        all.push(...e.dataSource.getDataAll())
      }
    })
    return all
  }


  public addListToGroup(list: Object[], getTitle: (e: ESObject) => string) {
    if (list.length === 0) {
      return
    }
    const lastData = this.getLastData()
    let prevTitle: string | undefined = lastData instanceof RefreshGroupModel ? lastData.title : undefined

    let items: Object[] = []
    for (const e of list) {
      const title = getTitle(e as ESObject)
      if (title === prevTitle) {
        items.push(e)
      } else {
        if (items.length > 0 && prevTitle) {
          const last = this.getLastData()
          if (last instanceof RefreshGroupModel) {
            last.dataSource.pushDataArray(items)
          }
        }
        const dataSource = new RefreshDataSource()
        const group = new RefreshGroupModel(title, dataSource)
        this.pushData(group)

        prevTitle = title
        items = [e]
      }
    }

    if (items.length > 0 && prevTitle) {
      const last = this.getLastData()
      if (last instanceof RefreshGroupModel && last.title === prevTitle) {
        last.dataSource.pushDataArray(items)
      }
    }
  }

  public setGroupData(index: number, data: Object): void {
    if (index < 0 || index >= this.list.length) {
      return
    }
    const item = this.list[index]
    if (item instanceof RefreshGroupModel) {
      item.data = data
      this.reloadIndex(index)
    }
  }

  public setLastGroupData(data: Object): void {
    const lastItem = this.getLastData()
    if (lastItem instanceof RefreshGroupModel) {
      lastItem.data = data
      this.reloadIndex(this.list.length - 1)
    }
  }
}

