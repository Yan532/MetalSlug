import Felgo 3.0
import QtQuick 2.0

GameWindow {
  id: gameWindow
  property bool gameWon
  property bool splashFinished: false
  onSplashScreenFinished: { splashFinished = true}
  property int monstersDestroyed
  onMonstersDestroyedChanged: {
    if(monstersDestroyed > 5) {
      // you won the game, shot at 5 monsters
      changeToGameOverScene(true)
    }
  }
  // You get free licenseKeys from https://felgo.com/licenseKey
  // With a licenseKey you can:
  //  * Publish your games & apps for the app stores
  //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
  //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
  //licenseKey: "<generate one from https://felgo.com/licenseKey>"

  activeScene: gameScene

  // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
  // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
  // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
  // this resolution is for iPhone 4 & iPhone 4S
  screenWidth: 960
  screenHeight: 640

  GameScene {
    id: gameScene
    visible: false
  }
  Scene {
    id: gameOverScene
    visible: false
    BackgroundImage
    {
        anchors.fill:parent
        source: "/合金弹头/MetalSlug/assets/background/background.png"
    }
    Text {
      anchors.centerIn: parent
      text: gameWon ? "You won " : "You lost"
    }

    onVisibleChanged: {
      if(visible) {
        returnToGameSceneTimer.start()  // make the scene invisible after 3 seconds, after it got visible
      }
    }

    Timer {
      id: returnToGameSceneTimer
      interval: 3000
      onTriggered: {
        gameScene.visible = true
        gameOverScene.visible = false
      }
    }
  }// GameOverScene
  Scene
  {
     id:startScene
     visible:true
     BackgroundImage
     {
         anchors.fill:parent
         source: "/合金弹头/MetalSlug/assets/background/background.png"
     }

     Text {
       anchors.centerIn: parent
       text: "Start"
     }
     onVisibleChanged: {
       if(visible) {
        gotoToGameSceneTimer.start()
       }
     }

     Timer {
       id:gotoToGameSceneTimer
       interval: 3000
       onTriggered: {
         startScene.visible = false
         gameScene.visible = true
         gameOverScene.visible = false

       }
     }
  }//GameStar
  function changeToGameOverScene(won) {
    gameWon = won
    gameOverScene.visible = true
    gameScene.visible = false
    monstersDestroyed = 0
    entityManager.removeEntitiesByFilter(["projectile", "monster","player"])

  }

}

