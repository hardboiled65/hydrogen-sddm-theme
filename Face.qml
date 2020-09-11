import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
  id: root

  property string source: ''

  Rectangle {
    id: background

    anchors.fill: parent
    width: 256
    height: 256

    color: "#e3e2df" // "#ebf0f3"
    radius: 256

    layer.enabled: true
    layer.effect: Glow {
      color: background.color
      radius: 32
      spread: 0.5
      samples: 24
      transparentBorder: true
    }
  }

  Rectangle {
    id: dropShadowSource

    anchors.fill: parent
    anchors.margins: 8

    radius: background.radius
    color: background.color
    clip: true

    Image {
      anchors.fill: parent
      anchors.margins: 5

      source: root.source

      layer.enabled: true
      layer.effect: OpacityMask {
        maskSource: Rectangle {
          id: mask

          width: 100
          height: 100
          radius: 256
        }
      }
    }
  }

  DropShadow {
    id: topLeftShadow

    anchors.fill: dropShadowSource
    horizontalOffset: -6
    verticalOffset: -6
    radius: 12
    samples: 16
    color: '#ffffff'
    source: dropShadowSource
  }

  DropShadow {
    id: bottomRightShadow

    anchors.fill: dropShadowSource
    horizontalOffset: 6
    verticalOffset: 6
    radius: 12
    samples: 16
    color: '#aa3d3d3d'
    source: dropShadowSource
  }
}
