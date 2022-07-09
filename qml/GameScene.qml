import Felgo 3.0
import QtQuick 2.15
import "entities"
import "levels"

Scene {
  id: gameScene
  width: 480
  height: 320
  gridSize: 32

  property int offsetBeforeScrollingStarts: 200

  EntityManager {
    id: entityManager
    entityContainer: viewPort
  }

  Rectangle {
    anchors.fill: gameScene.gameWindowAnchorItem
    color: "#74d6f7"
  }

  ParallaxScrollingBackground {
    sourceImage: "../assets/background/image271.jpg"
    anchors.fill: gameScene.gameWindowAnchorItem
    movementVelocity: player.x > offsetBeforeScrollingStarts ? Qt.point(-player.horizontalVelocity,0) : Qt.point(0,0)
    ratio: Qt.point(0.3,0)
  }

  Item {
    id: viewPort
    height: level.height
    width: level.width
    anchors.bottom: gameScene.gameWindowAnchorItem.bottom
    x: player.x > offsetBeforeScrollingStarts ? offsetBeforeScrollingStarts - player.x : 0

    PhysicsWorld {
      id: physicsWorld
      gravity.y: 20
      debugDrawVisible: false
      z: 1000

      onPreSolve: {
        var entityA = contact.fixtureA.getBody().target
        var entityB = contact.fixtureB.getBody().target
        if(entityB.entityType === "platform" && entityA.entityType === "player" &&
            entityA.y + entityA.height > entityB.y) {
          contact.enabled = false
        }
      }
    }

    Level1 {
      id: level
    }

    Player {
      id: player
      x: 50
      y: 100
    }



    Component{
        id:soldierfromright
        Enemy{
        }
    }

    Component{
        id:soldierfromleft
        LeftEnemy{
        }
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
      onContact: {
        player.x = 20
        player.y = 100
      }
    }
    ResetSensor{
        id:startline
        height:gameScene.gameWindowAnchorItem.height
        width: 1
        x: player.x - 400
    }

    ResetSensor{
        id:endline
        height:gameScene.gameWindowAnchorItem.height
        width: 1
        x:player.x + 400
     }

    ResetSensor{
        id:topline
        width: player.width +50
        height: 10
        x: player.x - 20
        anchors.bottom: gameScene.top
    }
 }

  Timer {                                               //敌人生成
    running: viewPort.visible
    repeat: true
    interval: 1000
    onTriggered: addTargetright()
  }
  Timer {                                               //敌人生成
    running: viewPort.visible
    repeat: true
    interval: 3000
    onTriggered: addTargetright()
  }
  Timer{
      running: viewPort.visible
      repeat: true
      interval: 3000
      onTriggered: addTargetleft()
  }

  SoundEffect{
      id: firesound
      source:"../assets/sound/fire.wav"
  }

  SoundEffect{
      id:deadsound
      source: "../assets/sound/dead.wav"
  }

  function addTargetright() {
    console.debug("create a new soldier fromright")
    entityManager.createEntityFromComponent(soldierfromright)
  }
  function addTargetleft() {
    console.debug("create a new soldier fromleft")
    entityManager.createEntityFromComponent(soldierfromleft)
  }
  Keys.forwardTo: controller
  TwoAxisController{
      id: controller
      inputActionsToKeyCode: {
          "jump": Qt.Key_Space,
          "up": Qt.Key_W,
          "down": Qt.Key_S,
          "left": Qt.Key_A,
          "right": Qt.Key_D,
          "fire": Qt.Key_J
      }
      onInputActionPressed: {
      console.debug("key pressed actionName " + actionName)     //根据操作键位进行相应的行动
          if(actionName == "up")
          {
              player.anim.jumpTo("up")
              player.body.rotation = 270
              player.anim.running = true

          }
          if(actionName == "right")
          {
              player.anim.jumpTo("right")
              player.body.rotation = 0
              player.anim.running = true
              player.leftoright = 0
          }
          if(actionName == "left")
          {
              player.anim.jumpTo("left");
              player.body.rotation = 180
              player.anim.running = true
              player.leftoright = 1
          }
          if(actionName == "down")
          {
              player.anim.jumpTo("down");
              player.body.rotation = 180
              player.anim.running = true
          }
          if(actionName == "down")
          {
              if(player.state == "jumping")
              {
                  player.body.rotation = 90
              }
          }

          if(actionName == "jump")
          {
              player.jump()
          }
          if(actionName == "fire")
          {
              fire()
              firesound.play()
          }

      }
      onInputActionReleased: {
          if(actionName == "up")
          {
              if(player.leftoright == 0)
              {
                  player.anim.jumpTo("right")
                  player.body.rotation = 0
                  player.anim.running = true
              }
              else{
                  player.anim.jumpTo("left")
                  player.body.rotation = 180
                  player.anim.running = true
              }
            }
   }

  function fire(){
      var speed = 500                                                                               //子弹的基础速度

      var rotation = player.body.rotation

      var xDirection = Math.cos(rotation * Math.PI / 180.0) * speed
      var yDirection = Math.sin(rotation * Math.PI / 180.0) * speed                                 //子弹射出时的速度

      var startX= (16 * Math.cos((rotation) * Math.PI / 180)) + player.x  + player.width / 2
      var startY= (16 * Math.sin((rotation) * Math.PI / 180)) + player.y + player.height / 2        //子弹射出的起始位置

      entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("../qml/entities/Pistolbullet.qml"), {
                                                        "start" : Qt.point(startX, startY),
                                                        "velocity" : Qt.point(xDirection, yDirection),
                                                        "rotation" : player.body.rotation});
        }
  }
}

