BodyShadow 1.3
===========

<h3>Introduction:</h3>

BodyShadow creates a particle system which explains Merdian-collateral theory of Traditional Chinese Medicine in your 3d-scan body model. You can produce new kind of tattoo images by using this system.
BodyShadow is programed with vvvv and Bullet Physics.


<h3>Installation：</h3>

1.About <b>vvvv</b>（http://vvvv.org ）：
vvvv is a hybrid visual/textual live-programming environment for easy prototyping and development. It is designed to facilitate the handling of large media environments with physical interfaces, real-time motion graphics, audio and video that can interact with many users simultaneously. Responsible for its development is the vvvv group.

2.To run BodyShadow you need to download vvvv from here (http://vvvv.org/downloads), and install the environment(32bit version is recommended). Addons is also needed.

3.BodyShadow use google <b>NotoSansCJKsc-Medium</b> font, so you can download from https://www.google.com/get/noto/#/family/noto-sans-hans , or you can find the font file in the Fonts folder.


<h3>Use BodyShadow:</h3>

1.Run main.v4p to start the sofetware.

2.You will find that there is already a leg which belongs to chinese median artist aaajiao.You can choose different modes to check the details of this leg.
<img src="https://raw.githubusercontent.com/aaajiao/body-shadow/master/images/interface_1.jpg" style="max-width:100%;">

3.Click "create particles" to simulate the system. There will be five more particles everytime you click the button.

4.Click "on tracking" button you will find that it blinks. Software will keep a record of one particle's position and produce a path of the particle.You can choose next particle to track, what the path looks like and the length of path by clicking buttons.
<img src="https://raw.githubusercontent.com/aaajiao/body-shadow/master/images/interface_2.jpg" style="max-width:100%;">

5.Once you create a nice path, turn off the "on tracking" button, and click "create tattoo". After the tattoo image rendering, you can click "tattoo result" to check the result. You can also find the tattoo picture in folder "OutputImage". Click "reset partices" you can start whole process again.
<img src="https://raw.githubusercontent.com/aaajiao/body-shadow/master/images/interface_3.jpg" style="max-width:100%;">


<h3>Create tattoo based on your own body!</h3>

1.Scan your body!
I Use the kinect and KScan3D(http://www.kscan3d.com) to scan the leg. You can use other software to do the job.

2.Cylindrical map your 3d model into UV coordinates (http://en.wikipedia.org/wiki/UV_mapping). You can do this in 3d softwares like MAYA or 3dmax. 

3.Import your model into this software and add acupuncture points based on Meridian theory (http://en.wikipedia.org/wiki/Meridian_(Chinese_medicine)).