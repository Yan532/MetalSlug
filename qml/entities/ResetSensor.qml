import Felgo 3.0
import QtQuick 2.0

EntityBase {
  id: resetSensor
  entityType: "resetSensor"

  signal contact

  Text {
    anchors.centerIn: parent
    text: "reset sensor"
    color: "white"
    font.pixelSize: 9
  }

  BoxCollider {
    anchors.fill: parent
    collisionTestingOnlyMode: true
    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      // if the player hits the sensor, we emit a signal which will be used to reset the player
      // 如果玩家碰到传感器，我们会发出一个信号，用于重置玩家
      if(otherEntity.entityType === "player") {
        // we could also directly modify the player position here, but the signal approach is a bit cleaner and helps separating the components
        // 我们也可以在这里直接修改玩家位置，但是信号方式更简洁一些，有助于分离组件
        resetSensor.contact()
      }
    }
  }
}

