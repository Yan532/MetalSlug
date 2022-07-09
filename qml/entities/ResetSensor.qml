import Felgo 3.0
import QtQuick 2.0

EntityBase {
  id: resetSensor
  entityType: "resetSensor"

  signal contact

  BoxCollider {
    anchors.fill: parent
    collisionTestingOnlyMode: true
    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      if(otherEntity.entityType === "player") {
        resetSensor.contact()
      }
      if(otherEntity.entityType === "pistolbullet")
      {
          otherEntity.removeEntity()                //接触到该触发器时删除子弹对象
      }
    }
  }
}

