import QtQuick 2.0
import Felgo 3.0

TiledEntityBase {
  id: platform
  entityType: "platform"

  size: 2 // must be >= 2 and even (2,4,6,...), because we got a sprite for the start, one for the end and 2 center sprites that are only repeatable if both are used
  // 必须 >= 2 甚至 (2,4,6,...)，因为我们有一个 sprite 用于开始，一个用于结束和 2 个中心 sprite，只有在两者都使用时才可重复
  Row {
    id: tileRow
    Tile {
      pos: "left"
      image: "../../assets/platform/left.png"
    }
    Repeater {
      model: size-2
      Tile {
        pos: "mid"
        image: "../../assets/platform/mid" + index%2 + ".png"
      }
    }
    Tile {
      pos: "right"
      image: "../../assets/platform/right.png"
    }
  }

  BoxCollider {
    id: collider
    anchors.fill: parent
    bodyType: Body.Static

    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      if(otherEntity.entityType === "player") {
        console.debug("contact platform begin")

        // increase the number of active contacts the player has
        // 增加玩家的活跃联系人数量
        player.contacts++
      }
    }

    fixture.onEndContact: {
      var otherEntity = other.getBody().target
      if(otherEntity.entityType === "player") {
        console.debug("contact platform end")

        // if the player leaves a platform, we decrease its number of active contacts
        // 如果玩家离开平台，我们会减少其活跃联系人的数量
        player.contacts--
      }
    }
  }
}
