import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
  id: root

  required property string text
  required property string source

  Rectangle {
    id: background

    anchors.fill: parent
    width: 128
    height: 128

    color: "#e3e2df" // "#ebf0f3"
    radius: 256
  }

  Rectangle {
    id: shadowSource

    anchors.fill: background

    radius: background.radius
    color: background.color
    clip: true

    Image {
      anchors.fill: parent
      anchors.margins: 8

      sourceSize.width: background.width
      sourceSize.height: background.height

      source: root.source

//      layer.enabled: true
//      layer.effect: OpacityMask {
//        maskSource: Rectangle {
//          id: mask

//          width: 60
//          height: 60
//          radius: 60
//        }
//      }
    }
  }

  DropShadow {
    id: topLeftDropShadow

    anchors.fill: shadowSource
    color: '#ffffff'
    source: shadowSource
  }

  DropShadow {
    id: bottomRightDropShadow

    anchors.fill: shadowSource
    color: '#aa3d3d3d'
    source: shadowSource
  }

  Text {
    text: root.text
    visible: root.source === ''
  }
}
