import QtQuick 2.0
import Felgo 3.0

EntityBase {
    id: pistolbullet
    entityType: "pistolbullet"
    width: 50
    height: 10


    Image{
        id: image
        width: 23
        height: 7
        source: "../../assets/Arms/bullet2.png"
        anchors.centerIn: parent
    }

    BoxCollider {
      id: collider
      height: 30
      width: 10
      anchors.fill: parent
      collisionTestingOnlyMode: true
    }
}
