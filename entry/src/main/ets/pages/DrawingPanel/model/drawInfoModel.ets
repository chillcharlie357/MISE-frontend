/**
 * 绘制信息
 * @param lineColor 线颜色
 * @param lineWidth 线宽度
 * @param listCoord 坐标点集合
 */
export class DrawInfoModel {
  // 是否为画笔，是：画笔，否：橡皮擦
  // 根据此字段设置绘制属性：合成操作globalCompositeOperation
  isPen: boolean;
  // 线颜色
  lineColor: string;
  // 线宽度
  lineWidth: number;
  // 坐标点集合
  listCoord: Array<Coord>;
  constructor(isPen: boolean, lineColor: string, lineWidth: number, listCoord: Array<Coord>) {
    this.isPen = isPen;
    this.lineColor = lineColor;
    this.lineWidth = lineWidth;
    this.listCoord = listCoord;
  }
}
/**
 * 坐标点
 * @param x 坐标点x
 * @param y 坐标点y
 */
export class Coord {
  // 坐标点x
  x: number;
  // 坐标点y
  y: number;
  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}