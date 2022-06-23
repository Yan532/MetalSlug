import QtQuick 2.15
import Felgo 3.0

// EMPTY SCENE

Scene {
    id: gameScene

        width: 560
        height: 418

        ParallaxScrollingBackground {
          sourceImage: "../assets/im1.jpg"
          anchors.fill: gameScene.gameWindowAnchorItem.parent
          mirrorSecondImage : true

          movementVelocity: Qt.point(-10,0)
        }

        TapHandler {
            onTapped: anim.start();
        }
        //动画
        SequentialAnimation {
            id: anim
            ScriptAction { script: squaby.goalSprite = "falling"; }
            NumberAnimation { target: squaby; property: "y"; to: 480; duration: 12000; }
            ScriptAction { script: {squaby.goalSprite = ""; squaby.jumpTo("still");} }
            PropertyAction { target: squaby; property: "y"; value: 0 }
        }

        SpriteSequence {
          id: squaby

          defaultSource: "../assets/player/squafurY.png"

          width: 32//*5
          height: 32//*5

          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom

          Sprite {
            name: "jump"
            frameWidth: 32
            frameHeight: 32
            frameCount: 4
            startFrameColumn: 5
            frameRate: 10
            to: {"walk":1}
          }

        }



}
