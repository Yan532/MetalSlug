import Felgo 3.0
import QtQuick 2.15
import "entities"
import "levels"

Scene {
  id: gameScene
  // the "logical size" - the scene content is auto-scaled to match the GameWindow size
  width: 480
  height: 320
  gridSize: 32

  property int offsetBeforeScrollingStarts: 200

  EntityManager {
    id: entityManager
    entityContainer: viewPort
  }

  // the whole screen is filled with an incredibly beautiful blue ...
  Rectangle {
    anchors.fill: gameScene.gameWindowAnchorItem
    color: "#74d6f7"
  }

  // ... followed by 2 parallax layers with trees and grass
  ParallaxScrollingBackground {
    sourceImage: "../assets/background/layer1.jpg"
    anchors.fill: gameScene.gameWindowAnchorItem
    // we move the parallax layers at the same speed as the player
    movementVelocity: player.x > offsetBeforeScrollingStarts ? Qt.point(-player.horizontalVelocity,0) : Qt.point(0,0)
    // the speed then gets multiplied by this ratio to create the parallax effect
    ratio: Qt.point(0.3,0)
  }
//  ParallaxScrollingBackground {
//    sourceImage: "../assets/background/layer1.jpg"
//    anchors.fill: parent
//    anchors.horizontalCenter: gameScene.gameWindowAnchorItem.horizontalCenter
//    movementVelocity: player.x > offsetBeforeScrollingStarts ? Qt.point(-player.horizontalVelocity,0) : Qt.point(0,0)
//    ratio: Qt.point(0.6,0)
//  }

  // this is the moving item containing the level and player


  Item {
    id: viewPort
    height: level.height
    width: level.width
    anchors.bottom: gameScene.gameWindowAnchorItem.bottom
    x: player.x > offsetBeforeScrollingStarts ? offsetBeforeScrollingStarts - player.x : 0

    PhysicsWorld {
      id: physicsWorld
      gravity.y: 20
      debugDrawVisible: true // enable this for physics debugging
      z: 1000

      onPreSolve: {
        //this is called before the Box2DWorld handles contact events
        var entityA = contact.fixtureA.getBody().target
        var entityB = contact.fixtureB.getBody().target
        if(entityB.entityType === "platform" && entityA.entityType === "player" &&
            entityA.y + entityA.height > entityB.y) {
          //by setting enabled to false, they can be filtered out completely
          //-> disable cloud platform collisions when the player is below the platform
          contact.enabled = false
        }
      }
    }

    // you could load your levels Dynamically with a Loader component here
    Level1 {
      id: level
    }

    Player {
      id: player
      x: 50
      y: 100
    }


    Component{
        id:bullet
        Pistolbullet{
            id:pistolbullet
        }
    }

    ResetSensor {
      width: player.width
      height: 10
      x: player.x
      anchors.bottom: viewPort.bottom
      // if the player collides with the reset sensor, he goes back to the start
      onContact: {
        player.x = 20
        player.y = 100
      }
      // this is just for you to see how the sensor moves, in your real game, you should position it lower, outside of the visible area
    }
    ResetSensor{
        id:startline
        height:gameScene.gameWindowAnchorItem.height
        width: 1
        anchors.left: viewPort
    }

    ResetSensor{
        id:endline
        height:gameScene.gameWindowAnchorItem.height
        width: 1
        x:15000
        anchors.right: viewPort
     }

    ResetSensor{
        id:topline
        width: gameScene.gameWindowAnchorItem.width
        height: 1
        anchors.top: viewPort.top
    }
 }

//  Rectangle {
//    // you should hide those input controls on desktops, not only because they are really ugly in this demo, but because you can move the player with the arrow keys there
//    //visible: !system.desktopPlatform
//    //enabled: visible
//    anchors.right: parent.right
//    anchors.bottom: parent.bottom
//    height: 50
//    width: 150
//    color: "blue"
//    opacity: 0.4

//    Rectangle {
//      anchors.centerIn: parent
//      width: 1
//      height: parent.height
//      color: "white"
//    }
//    MultiPointTouchArea {
//      anchors.fill: parent
//      onPressed: {
//        if(touchPoints[0].x < width/2)
//          controller.xAxis = -1
//        else
//          controller.xAxis = 1
//      }
//      onUpdated: {
//        if(touchPoints[0].x < width/2)
//          controller.xAxis = -1
//        else
//          controller.xAxis = 1
//      }
//      onReleased: controller.xAxis = 0
//    }
//  }

//  Rectangle {
//    // same as the above input control
//    //visible: !system.desktopPlatform
//    //enabled: visible
//    anchors.left: parent.left
//    anchors.bottom: parent.bottom
//    height: 100
//    width: 100
//    color: "green"
//    opacity: 0.4

//    Text {
//      anchors.centerIn: parent
//      text: "jump"
//      color: "white"
//      font.pixelSize: 9
//    }
//    TapHandler{
//        onTapped: {
//            player.jump()
//        }
//    }
//  }

  // on desktops, you can move the player with the arrow keys, on mobiles we are using our custom inputs above to modify the controller axis values. With this approach, we only need one actual logic for the movement, always referring to the axis values of the controller
  Keys.forwardTo: controller
  TwoAxisController{
      id: controller
      inputActionsToKeyCode: {
          "jump": Qt.Key_Space,
          "up": Qt.Key_W,
          "down": Qt.Key_S,
          "left": Qt.Key_A,
          "right": Qt.Key_D,
          "fire": Qt.Key_K
      }
      onInputActionPressed: {
      console.debug("key pressed actionName " + actionName)
          if(actionName == "up")
          {
              player.body.rotation = 270
          }
          if(actionName == "right")
          {
              player.body.rotation = 0
          }
          if(actionName == "left")
          {
              player.body.rotation = 180
          }
          if(actionName == "down")
          {
              if(player.state == "jumping")
              {
                  player.body.rotation = 90
              }
              else{
                  player.body.height -= 20
              }
          }

          if(actionName == "jump")
          {
              player.jump()
          }
          if(actionName == "fire")
          {
              fire()
          }
      }
   }

  function fire(){
      var speed = 500

      var rotation = player.body.rotation

      // calculate a bullet movement vector with the rotation and the speed
      var xDirection = Math.cos(rotation * Math.PI / 180.0) * speed
      var yDirection = Math.sin(rotation * Math.PI / 180.0) * speed

      // calculate the bullet spawn point: start at the center of the tank translate it outside of the body towards the final direction
      var startX= (16 * Math.cos((rotation) * Math.PI / 180)) + player.x + player.width / 2
      var startY= (16 * Math.sin((rotation) * Math.PI / 180)) + player.y + player.height / 2

      // create and remove bullet entities at runtime
      entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("../qml/entities/Pistolbullet.qml"), {
                                                        "start" : Qt.point(startX, startY),
                                                        "velocity" : Qt.point(xDirection, yDirection),
                                                        "rotation" : player.body.rotation});
  }
}

