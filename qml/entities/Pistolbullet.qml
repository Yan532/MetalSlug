import QtQuick 2.0
import Felgo 3.0

EntityBase {
    id: pistolbullet
    entityType: "pistolbullet"
    width: 30
    height: 10
    x:start.x
    y:start.y

    property point start
    property point velocity
    property int bulletType

    Image{
        id: image
        source: "../../assets/Arms/bullet2.png"
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MovementAnimation {
      target: pistolbullet
      property: "x"
      velocity: pistolbullet.velocity.x
      running: true
    }

    // animate the bullet along its y-axis
    MovementAnimation {
      target: pistolbullet
      property: "y"
      velocity: pistolbullet.velocity.y
      running: true
      onStopped: {
        pistolbullet.destroy()
      }
    }

    BoxCollider {
      id: collider
      height: 30
      width: 10
      anchors.fill: parent
      anchors.horizontalCenter: parent.horizontalCenter
      bodyType: Body.Dynamic // this is the default value but I wanted to mention it ;)
      fixedRotation: true // we are running, not rolling...
      bullet: true // for super accurate collision detection, use this sparingly, because it's quite performance greedy
      sleepingAllowed: false
      // apply the horizontal value of the TwoAxisController as force to move the player left and right
      collisionTestingOnlyMode: true
      force: Qt.point(1000,-20)
      onLinearVelocityChanged: {
            if(linearVelocity.x > 250) linearVelocity.x = 250
            if(linearVelocity.x < -250) linearVelocity.x = -250
      }
    }
}
