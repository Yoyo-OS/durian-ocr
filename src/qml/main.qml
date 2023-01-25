import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.0
import FishUI 1.0 as FishUI
import Yoyo.Ocr 1.0
import "../"
FishUI.Window {
    id: rootWindow
    title: qsTr("Ocr")
    visible: true
    width: 600
    height: 500

    minimumWidth: 600
    minimumHeight: 500

    header.height: 40
    contentTopMargin: 0

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    background.color: FishUI.Theme.secondBackgroundColor

    Ocr {
        id: ocr
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0
        Rectangle {
                color: "transparent"
                Layout.preferredWidth: rootWindow.width - right.width
                Layout.preferredHeight: rootWindow.height
                Item{
                    id: mapItemArea
                    anchors.fill: parent
                    clip: true
                    Image {
                        id: mapImg
                        x: mapItemArea.width/2-mapImg.width/2
                        y: mapItemArea.height/2-mapImg.height/2
                        source: ocr.imgName
                        //图像异步加载，只对本地图像有用
                        asynchronous: true
                    }
                    MouseArea {
                        id: mapDragArea
                        anchors.fill: mapImg
                        drag.target: mapImg
                        //这里使图片不管是比显示框大还是比显示框小都不会被拖拽出显示区域
                        drag.minimumX: (mapImg.width > mapItemArea.width) ? (mapItemArea.width - mapImg.width) : 0
                        drag.minimumY: (mapImg.height > mapItemArea.height) ? (mapItemArea.height - mapImg.height) : 0
                        drag.maximumX: (mapImg.width > mapItemArea.width) ? 0 : (mapItemArea.width - mapImg.width)
                        drag.maximumY: (mapImg.height > mapItemArea.height) ? 0 : (mapItemArea.height - mapImg.height)

                        //使用鼠标滚轮缩放
                        onWheel: {
                            //每次滚动都是120的倍数
                            var datla = wheel.angleDelta.y/120;
                            if(datla > 0)
                            {
                                mapImg.scale = mapImg.scale/0.9
                            }
                            else
                            {
                                mapImg.scale = mapImg.scale*0.9
                            }
                        }
                    }
                }
       }

        Rectangle {
            id: right
            color: "transparent"
            Layout.preferredWidth: rootWindow.width / 3
            Layout.preferredHeight: rootWindow.height
            Column{
                anchors.fill: parent
                anchors.leftMargin: FishUI.Units.largeSpacing
                anchors.rightMargin: FishUI.Units.largeSpacing
                anchors.topMargin: rootWindow.header.height
                anchors.bottomMargin: FishUI.Units.largeSpacing
                spacing: FishUI.Units.smallSpacing
                Row{
                    spacing: 5
                    ComboBox {
                        id:type
                        Layout.fillWidth: true
                        model: ["简体中文","繁体中文","English"]
                        leftPadding: FishUI.Units.largeSpacing
                        rightPadding: FishUI.Units.largeSpacing
                        topInset: 0
                        bottomInset: 0
                        currentIndex: 0
                        onActivated: {
                            ocr.setTextType(currentText)
                        }
                    }
                    Button{
                        icon.source: FishUI.Theme.darkMode ? "qrc:/assets/copy_light.svg" : "qrc:/assets/copy_dark.svg"
                        icon.width: height
                        icon.height: height
                        width: height
                        onClicked: ocr.copy()
                    }
                }
                Flickable{
                    anchors.fill: parent
                    anchors.topMargin: type.height + FishUI.Units.largeSpacing
                    anchors.bottom: FishUI.Units.largeSpacing
                    contentHeight: edit.paintedHeight
                    contentWidth: edit.paintedWidth
                    clip: true
                    TextEdit{
                        id:edit
                        focus: true
                        color: FishUI.Theme.textColor
                        wrapMode: Text.WordWrap
                        selectByMouse: true
                        text: ocr.ocrText
                    }
                }
            }
        }
    }
    function openImage(name){
        ocr.openImage(name)
    }

    onClosing: function(closeevent){
        Qt.exit(0)
    }
}
