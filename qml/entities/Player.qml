import Felgo 3.0
import QtQuick 2.15

EntityBase {
  id: player
  entityType: "player"
  width: 50
  height: 50

  property alias collider: collider
  property alias horizontalVelocity: collider.linearVelocity.x
  property alias body: image
  property alias anim: sequence

  property int contacts: 0
  property int leftoright: 0
  property int life: 3                          //主角生命数
  property bool invincible : false               //主角无敌状态
  property int invincibleCounter: 0             //无敌计数


  state: contacts > 0 ? "walking" : "jumping"
  onStateChanged: console.debug("player.state " + state)

  CircleCollider {                              //圆形盒子
    id: collider
    radius: 25
    x:radius/2
    y:radius/2
    density: 0
    linearDamping: 1
    force: Qt.point(controller.xAxis*1000,0)
    onLinearVelocityChanged: {
      if(linearVelocity.x > 100) linearVelocity.x = 100
      if(linearVelocity.x < -100) linearVelocity.x = -100
    }
  }

  Timer{
      id: invincibletimer
      interval: 100;
      running: true;
      repeat: true;
      onTriggered: {
          if(invincible){
              invincibleCounter++;
              sequence.opacity = 0.3;
          }
          if(invincibleCounter == 30)
          {
              invincible = false;
              invincibleCounter = 0;
              sequence.opacity = 1;
          }
      }
  }


  Image {                                       //主角精灵标表
      id:image
      scale: 0.6
      source: "../../assets/player/contral.png"
      visible: false
  }

  MultiResolutionImage {                    //主角动画
      SpriteSequence {
                  id: sequence;
                  width: 85;
                  height: 85;
                  scale: 0.5
                  interpolate: true;
                  running: false;
                  sprites: [
                      Sprite {
                          name: "left";
                          source: image.source;
                          frameCount: 4;
                          frameY: 0;
                          frameWidth: image.width/4;
                          frameHeight: image.height/4;
                          frameRate: 10;
                          duration: 200

                      },
                      Sprite {
                          name: "right";
                          source: image.source;
                          frameCount: 4;
                          frameY: image.height/4;
                          frameWidth: image.width/4;
                          frameHeight: image.height/4;
                          frameRate: 10;
                          duration: 200

                      },
                      Sprite {
                          name: "down";
                          source: image.source;
                          frameCount: 4;
                          frameY: image.height/4*3;
                          frameWidth: image.width/4;
                          frameHeight: image.height/4;
                          frameRate: 10;
                          duration: 200

                      },


                      Sprite {
                          name: "up";
                          source: image.source;
                          frameCount: 4;
                          frameY: image.height/4*2;
                          frameWidth: image.width/4;
                          frameHeight: image.height/4;
                          frameRate: 10;
                          duration: 200

                      }
                  ]
              }
      focus: true;

}

  Timer {
    id: updateTimer
    interval:1
    running: true
    repeat: true
    onTriggered: {
      var xAxis = controller.xAxis;
      if(xAxis == 0) {
        if(Math.abs(player.horizontalVelocity) > 10) player.horizontalVelocity /= 1.5
        else player.horizontalVelocity = 0
        }
    }
  }

  function jump() {                         //跳跃
    console.debug("jump requested at player.state " + state)
    if(player.state == "walking") {
      console.debug("do the jump")
      collider.linearVelocity.y = -300              //起跳速度
         }
   }
}
