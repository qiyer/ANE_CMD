rd "ui" /s /q
del "android.swf"
del "load.swf"

xcopy "..\..\..\..\XiaWu\XiaWuAndroid\bin-debug\ui_TW" "ui\" /s
copy "..\android.swf" android.swf
copy "..\load.swf" load.swf

"C:\AIRSDK\bin\adt"  -package -target apk-captive-runtime -storetype pkcs12 -keystore air.p12 -storepass 1234 Œ‰œ¿ Æ∞À¿±_Google.apk android-app.xml gameConfig.xml android.swf load.swf main.swf ui 29.png 36.png 48.png 50.png 57.png 58.png 72.png 76.png 100.png 114.png 144.png 120.png 152.png 512.png -extdir ane

rd "ui" /s /q
del "android.swf"
del "load.swf"

pause