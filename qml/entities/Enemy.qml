import QtQuick 2.15
import Felgo 3.0

EntityBase {
     entityType: "enemy"
    MultiResolutionImage {
      id: enemyImage
      source: "/合金弹头/MetalSlug/assets/图像/image480.png"
      scale: 0.5
    }
//    y: utils.generateRandomValueBetween(0, parent.height)
      y:240

    NumberAnimation on x {
      from: parent.width
      to: -enemyImage.width
//      duration: utils.generateRandomValueBetween(1000, 4000) //随机生成怪物的持续时间
       duration:12000
    }

    BoxCollider {
      anchors.fill: enemyImage
      collisionTestingOnlyMode: true
      fixture.onBeginContact: {
        var collidedEntity = other.getBody().target
        console.debug("collided with entity", collidedEntity.entityType)
        if(collidedEntity.entityType === "projectile") {
          monstersDestroyed++
          collidedEntity.removeEntity()
          removeEntity()
        }
      }
    }
        TapHandler
        {
            onTapped: anim.start()
        }
       SequentialAnimation
       {
           id:anim
           ScriptAction
           {
               script: {sequence.goalSprite="";sequence.jumpTo(("enemy"))
               }
           }
           NumberAnimation  { target: sequence;property: "x"; from:800;to:600;duration: 12000 }
   }
         SpriteSequence {
             id:sequence
             scale:0.25
             anchors.horizontalCenter: parent.horizontalAlignment
             width: 256
             height: 253
             goalSprite:""

          Sprite
          {
              name:"enemy"
              source: enemyImage.source
              frameWidth: 148
              frameHeight: 87
              duration:200
              frameX: 0
              frameY:0

         }

    }
    }


