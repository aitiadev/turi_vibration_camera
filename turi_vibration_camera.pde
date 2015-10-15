import processing.serial.*;
import processing.video.*;
Serial port;
Capture camera;
Capture camera2;
final int LAW_FRAME = 1;
final int HIGH_FRAME = 30;

int x;
int count = 0;
boolean state = false;
boolean menu = false;


void setup(){

  size(480, 320*2);
  String[] cameras = Capture.list();
   for (int i=0; i<cameras.length; i++){
     print("camera " + i + ": ");
     println(cameras[i]);
   }

  cameraEvent(state);
  
  printArray(Serial.list());
  String portName = Serial.list()[2];
  port=new Serial(this, portName,9600);
  port.bufferUntil(10);
  
}


void draw(){
  
  image(camera, 0, 0);
  image(camera2, 0, 320);
  
  println("val = " + x + " || " + "count = " + count);
  
  if(x >= 200 && !state){
    count = 0;
    state = true;
    cameraEvent(state);
  }
  
  if(x >= 200){
    count = 0;
  }
  
  if(count >= 800 && state){
    state = false;
    cameraEvent(state);
  }
  count++;
  
  if(menu){
    textSize(30);
    text("Camera1", 10, 310);
    text("Camera2", 10, 630);
    textSize(24);
    text("Enter: REC", 10, 30);
  }
}


void keyPressed(){
  if(key == 'm' && !menu){
    menu = true;
  }else if(key == 'm' && menu){
    menu = false;
  }

}



void cameraEvent(boolean state){
  
  if(!state){
    camera = new Capture(this, width, height/2, "USB_Camera", LAW_FRAME);
    camera.start();
    camera2 = new Capture(this, width, height/2, "USB_Camera #2", LAW_FRAME);
    camera2.start();
  }else if(state){
    camera = new Capture(this, width, height/2, "USB_Camera", HIGH_FRAME);
    camera.start();
    camera2 = new Capture(this, width, height/2, "USB_Camera #2", HIGH_FRAME);
    camera2.start();
  }

}




void captureEvent(Capture camera) {
  camera.read();
}


void serialEvent(Serial p){

  String stringData = p.readStringUntil('\n');
  
  if(stringData != null){
    x = int(trim(stringData));
  }
}


void dispose(){
  port.clear();
  port.stop();
  println("Safety stopped!");
}
