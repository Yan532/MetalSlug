import Felgo 3.0
import QtQuick 2.0
import "../entities"
import "." as Levels

Levels.LevelBase {
  id: level
  // we need to specify the width to get correct debug draw for our physics
  // the PhysicsWorld component fills it's parent by default, which is the viewPort Item of the gameScene and this item uses the size of the level
  // NOTE: thy physics will also work without defining the width here, so no worries, you can ignore it untill you want to do some physics debugging
  // 我们需要指定宽度以获得正确的物理调试绘制
  // PhysicsWorld 组件默认填充它的父级，这是 gameScene 的 viewPort 项，此项使用关卡的大小
  // 注意：你的物理在这里不定义宽度也可以工作，所以不用担心，你可以忽略它，直到你想做一些物理调试
  width: 42 * gameScene.gridSize // 42 because our last tile is a size 30 Ground at row 12
  // 42，因为我们的最后一块瓷砖在第 12 行是大小为 30 的地面

  // you could draw your level on a graph paper and then add the tiles here only by defining their row, column and size
  // 您可以在方格纸上绘制您的关卡，然后仅通过定义它们的行、列和大小来在此处添加图块
  Ground {
    row: 0
    column: 0
    size: 1000
  }
}
