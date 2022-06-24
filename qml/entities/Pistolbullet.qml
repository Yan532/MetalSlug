import QtQuick 2.0
import Felgo 3.0

EntityBase {
    id: pistolbullet
    entityType: "pistolbullet"
    width: 23
    height: 7

    MultiResolutionImage {
        id: image
        source: "../../assets/Arms/pistol.png"
    }

    BoxCollider {
      id: collider
      height: parent.height
      width: parent.width
      anchors.fill: image
      collisionTestingOnlyMode: true
      // this collider must be dynamic because we are moving it by applying forces and impulsesd
      bullet: true // for super accurate collision detection, use this sparingly, because it's quite performance greedy
      sleepingAllowed: false
      // apply the horizontal value of the TwoAxisController as force to move the player left and right
      force: Qt.point(0,0)
      onLinearVelocityChanged: {
          if(linearVelocity.y !== 0) linearVelocity.y = 0
      }
    }
}
