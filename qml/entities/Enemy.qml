import QtQuick 2.15
import Felgo 3.0

EntityBase {
       id: enemy
       entityType: "enemy"
       width: 148
       height: 87

        TapHandler
        {
            onTapped: anim.start()
        }
       SequentialAnimation
       {
           id:anim
           ScriptAction
           {

               script: {sequence.goalSprite="";sequence.jumpTo(("touxiang"))
               }
           }
           NumberAnimation  { target: sequence;property: "x"; to:240;duration: 12000 }
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
              name:"touxiang"
              source: "/合金弹头/MetalSlug/assets/touxiang/touxiang.png"
              frameCount:5;
              frameWidth: 148
              frameHeight: 87
              duration:200
              frameX: 0
              frameY:0

         }

    }
    }


