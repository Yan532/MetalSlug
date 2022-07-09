import QtQuick 2.15
import Felgo 3.0

EntityBase {
     entityType: "enemy"

    MultiResolutionImage {
      id: enemyImage
      visible: false
      source: "../../assets/touxiang/enemy.png"
      scale: 0.5
      mirror: true
    }
    x:10
    y:240

    NumberAnimation on x {
      from: player.x - 300
      to: player.x
      duration:6000
    }

    BoxCollider {
        height:242/5
        width: 42
      collisionTestingOnlyMode: true
      fixture.onBeginContact: {
        var collidedEntity = other.getBody().target
        console.debug("collided with entity", collidedEntity.entityType)
        if(collidedEntity.entityType === "pistolbullet") {
          collidedEntity.removeEntity()
          deadsound.play()
          sodliersDestroyed++
          removeEntity()
        }
        if(collidedEntity.entityType === "player")
        {
            if(!player.invincible){
                collidedEntity.x = 20;
                collidedEntity.y = 100;
                deadsound.play()
                player.life--;
                player.invincible = true;
                if(player.life == 0)
                {
                    changeToGameOverScene(false)
                }
            }
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
             scale: 0.5
             anchors.horizontalCenter: parent.horizontalAlignment
             width: 242/5
             height: 72
             goalSprite:""

          Sprite
          {
              name:"enemy"
              source: enemyImage.source
              frameWidth: 242/5
              frameHeight: 72
              duration:1000
              frameX:0
              frameY:0
              frameCount: 5

         }

    }

    }




