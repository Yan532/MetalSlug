import QtQuick 2.0
import Felgo 3.0

EntityBase {
    id: pistolbullet
    entityType: "pistolbullet"
    width: 23
    height: 7

    poolingEnabled: true

    property alias collider: collider
    property alias horizontalVelocity: collider.linearVelocity.x

    MultiResolutionImage {
      source: "../../assets/Arms/pistol.png"
    }

    BoxCollider {
      id: collider
      height: parent.height
      width: parent.width
      anchors.horizontalCenter: parent.horizontalCenter
      // this collider must be dynamic because we are moving it by applying forces and impulses
      bodyType: Body.Dynamic // this is the default value but I wanted to mention it ;)
      fixedRotation: true // we are running, not rolling...
      bullet: true // for super accurate collision detection, use this sparingly, because it's quite performance greedy
      sleepingAllowed: false
      // apply the horizontal value of the TwoAxisController as force to move the player left and right
      force: Qt.point(10000,0)
      // limit the horizontal velocity
      onLinearVelocityChanged: {
        if(linearVelocity.x > 300) linearVelocity.x = 100
        if(linearVelocity.x < -300) linearVelocity.x = -100
        if(linearVelocity.y > 0.1) linearVelocity.y = -10
        if(linearVelocity.y < -0.1) linearVelocity.y = -10
      }
    }
    onEntityCreated: {
        console.debug("entity created with id",entityId)
    }

}
