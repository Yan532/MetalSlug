import Felgo 3.0
import QtQuick 2.0

Item {
  width: gameScene.gridSize
  height: gameScene.gridSize
  property alias image: sprite.source
  property string pos: "mid" // can be either "mid","left" or "right"
  // 可以是 "mid","left" 或 "right"

  MultiResolutionImage {
    id: sprite
    // the anchoring is needed because the start and end tile are actually bigger than the gridSize, because they have some grass hanging from the edge, which we will (for the sake of simplicity) ignore when it comes to collision detection
    // 需要锚定，因为开始和结束图块实际上比 gridSize 大，因为它们的边缘挂着一些草，我们将（为了简单起见）在碰撞检测时忽略它们
    anchors.left: pos == "right" ? parent.left : undefined
    anchors.right: pos == "left" ? parent.right : undefined
  }
}

