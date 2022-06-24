import QtQuick 2.15
import Felgo 3.0
import "entities"
import "levels"


// EMPTY SCENE

Scene {
    id: gameScene

        width: 580
        height: 410
        gridSize: 36

        property int offsetBeforeScrollingStarts: 290

        ParallaxScrollingBackground {
          sourceImage: "../assets/im1.jpg"
          anchors.fill: parent
          mirrorSecondImage : true

          movementVelocity: player.x > offsetBeforeScrollingStarts ? Qt.point(-player.horizontalVelocity,0) : Qt.point(0,0)
//          movementVelocity: Qt.point(-10,0)   //背景图移动
        }

//        TapHandler {
//            onTapped: anim.start();
//        }
//        //动画
//        SequentialAnimation {
//            id: anim
//            ScriptAction { script: squaby.goalSprite = "falling"; }
//            NumberAnimation { target: squaby; property: "y"; to: 480; duration: 12000; }
//            ScriptAction { script: {squaby.goalSprite = ""; squaby.jumpTo("still");} }
//            PropertyAction { target: squaby; property: "y"; value: 0 }
//        }

//        SpriteSequence {
//          id: squaby

//          defaultSource: "../assets/player/player-die1.png"

//          width: 64//*11
//          height: 58//*11

//          anchors.horizontalCenter: parent.horizontalCenter
//          anchors.bottom: parent.bottom

//          Sprite {
//            name: "jump"
//            frameWidth: 64        //帧宽
//            frameHeight: 58       //帧高
//            frameCount: 11        //要使用的帧的数量
//            startFrameRow: 1   //从一行的第几帧开始
//            frameRate: 9          //帧率
//          }

//        }

        Item {
          id: viewPort
          height: level.height
          width: level.width
          anchors.bottom: gameScene.gameWindowAnchorItem.bottom
          x: player.x > offsetBeforeScrollingStarts ? offsetBeforeScrollingStarts-player.x : 0

          PhysicsWorld {
            id: physicsWorld
            gravity: Qt.point(0, 25)
            debugDrawVisible: true // enable this for physics debugging
            z: 1000

//            onPreSolve: {
//              //this is called before the Box2DWorld handles contact events
//              var entityA = contact.fixtureA.getBody().target
//              var entityB = contact.fixtureB.getBody().target
//              if(entityB.entityType === "platform" && entityA.entityType === "player" &&
//                  entityA.y + entityA.height > entityB.y) {
//                contact.enabled = false
//              }
//            }
          }

          Level1 {
            id: level
          }

          Player {
            id: player
            x: 20
            y: 100
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
            Rectangle {
              anchors.fill: parent
              color: "yellow"
              opacity: 0.5
            }
          }
        }

        Keys.forwardTo: controller
        TwoAxisController {
          id: controller
          onInputActionPressed: {
            console.debug("key pressed actionName " + actionName)
            if(actionName == "up") {
              player.jump()
            }
          }
        }


        Component {
          id: bullet

          EntityBase {
            entityType: "bullet"

            MultiResolutionImage {
              id: monsterImage
              source: "../assets/bullet/bullet.png"
            }

            property point destination
            property int moveDuration

            PropertyAnimation on x {
              from: player.x
              to: destination.x
              duration: 2000
            }

            PropertyAnimation on y {
              from: player.y
              to: destination.y
              duration: 2000
            }

            BoxCollider {
              anchors.fill: monsterImage
              collisionTestingOnlyMode: true
            }
          }// EntityBase
        }// Component

//        Component {
//          id: monster

//          EntityBase {
//            entityType: "monster"

//            MultiResolutionImage {
//              id: monsterImage
//              source: "../assets/enemy/ememy.png"
//            }

//            y: utils.generateRandomValueBetween(0, scene.height)

//            NumberAnimation on x {
//              from: gameScene.width // start at the right side
//              to: -monsterImage.width // move the monster to the left side of the screen///////////////////////////////////
//              duration: utils.generateRandomValueBetween(2000, 4000) // vary animation duration between 2-4 seconds for the 480 px scene width
//              onStopped: {
//                console.debug("monster reached base - change to gameover scene because the player lost")
//                changeToGameOverScene(false)
//              }
//            }

//            BoxCollider {
//              anchors.fill: monsterImage // make the collider as big as the image
//              collisionTestingOnlyMode: true // use Box2D only for collision detection, move the entity with the NumberAnimation above
//              fixture.onBeginContact: {

//                // if the collided type was a projectile, both can be destroyed and the player gets a point
//                var collidedEntity = other.getBody().target
//                console.debug("collided with entity", collidedEntity.entityType)
//                // monsters could also collide with other monsters because they have a random speed - alternatively, collider categories could be used
//                if(collidedEntity.entityType === "projectile") {
//                  monstersDestroyed++
//                  // remove the projectile entity
//                  collidedEntity.removeEntity()
//                  // remove the monster
//                  removeEntity()
//                }
//              }
//            }// BoxCollider
//          }// EntityBase
//        }// Component

        MouseArea {
          anchors.fill: parent
          onReleased: {
            // Determinie offset of player to touch location
            var offset = Qt.point(
                  mouseX - player.x,
                  mouseY - player.y
                  );

            // Determine where we wish to shoot the projectile to
            var realX = gameScene.gameWindowAnchorItem.width
            var ratio = offset.y / offset.x
            var realY = (realX * ratio) + player.y
            var destination = Qt.point(realX, realY)

            // Determine the length of how far we're shooting
            var offReal = Qt.point(realX - player.x, realY - player.y)
            var length = 1000
            var velocity = 480 // speed of the projectile should be 480pt per second
            var realMoveDuration = length / velocity * 1000 // multiply by 1000 because duration of projectile is in milliseconds

            entityManager.createEntityFromComponentWithProperties(bullet, {"destination": destination, "moveDuration": realMoveDuration})

        }// onReleased
      }// MouseArea

//        Timer {
//          running: gameScene.visible == true
//          repeat: true
//          interval: 1000 // a new target(=monster) is spawned every second
//          onTriggered: addTarget()
//        }

//        function addTarget() {
//          console.debug("create a new monster")
//          entityManager.createEntityFromComponent(monster)
//        }

        function fire(){
            entityManager.createEntityFromComponentWithProperties(bullet)
        }


}
