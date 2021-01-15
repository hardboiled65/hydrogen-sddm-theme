import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
  id: root

  signal keyPressed(var event);

  property string text: text.text
  property int echoMode: TextInput.Normal

  Rectangle {
    id: background

    anchors.fill: parent

    color: "#e3e2df"
    radius: 25
  }

  GaussianBlur {
    anchors.fill: background
    source: background
    radius: 8
    samples: 16
    transparentBorder: true
  }

  Item {
    id: innerShadowSource

    anchors.fill: parent

    Rectangle {
      id: textArea

      anchors.fill: parent
      anchors.margins: 5

      radius: 25
      color: background.color
    }
  }

  InnerShadow {
    id: topLeftShadow

    anchors.fill: innerShadowSource
    horizontalOffset: 2
    verticalOffset: 2
    radius: 4
    samples: 16
    color: '#3d3d3d'
    source: innerShadowSource
  }

  InnerShadow {
    id: bottomRightShadow

    anchors.fill: innerShadowSource
    horizontalOffset: -2
    verticalOffset: -2
    radius: 4
    samples: 16
    color: '#ffffff'
    source: innerShadowSource
  }

  Blend {
    anchors.fill: topLeftShadow
    source: topLeftShadow
    foregroundSource: bottomRightShadow
    mode: 'average'
  }

  TextInput {
    id: text

    anchors.verticalCenter: root.verticalCenter
    x: 16
    width: root.width
    height: 12
    text: ''
    focus: true
    echoMode: root.echoMode

    Keys.onPressed: {
      if (event.key === Qt.Key_Return) {
        root.keyPressed(event.key);
      }
    }
  }
}
