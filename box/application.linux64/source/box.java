import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import processing.serial.*; 
import rocketuc.processing.*; 
import ddf.minim.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class box extends PApplet {

/**
 * This file is part of the BrailleBox Processing project
 * More info visit : braillebox.tuxfamily.org
 *
 * Copyright (C) 2015 Ahmed Mansour <hamada@openmailbox.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

//             microcontoller  MSP430G2553 pins diagram
//                      +-\/-+
//               VCC   1|    |20  GND
//         (A0)  P1.0  2|    |19  XIN
//         (A1)  P1.1  3|    |18  XOUT
//         (A2)  P1.2  4|    |17  TEST
//         (A3)  P1.3  5|    |16  RST#
//         (A4)  P1.4  6|    |15  P1.7  (A7) (SCL) (MISO) depends on chip
//         (A5)  P1.5  7|    |14  P1.6  (A6) (SDA) (MOSI)
//               P2.0  8|    |13  P2.5
//               P2.1  9|    |12  P2.4
//               P2.2 10|    |11  P2.3
//                      +----+
//

/**
 * Braille to pin mapping diagram:
 *PIN_1_0-o o-PIN_1_3
 *PIN_2_1-o o-PIN_1_4
 *PIN_2_2-o o-PIN_1_5
 *find sound-fr/ -iname "*.ogg" -exec sox -V3 {} {}.fr.wav \;
 */





Minim minim;                    //library for playing letter sound file
AudioPlayer lettersound;

Serial ser_port;                // for serial port
PFont fnt;                      // for font
int num_ports;
boolean device_detected = false, deviceready = false;
String[] port_list;
String detected_port = "";

// our instance of the ROCKETuC USB/serial API
ROCKETuC r;
char letter = 'a';
int wait = 200;

/**
 * setup function called by processing on startup
 */
public void setup() {
  size(256, 256);
  // Create the font
  textFont(createFont("Arial", 36));

  try {
 println(Serial.list());

    // get the number of detected serial ports
    num_ports = Serial.list().length;
    // save the current list of serial ports
    port_list = new String[num_ports];
    for (int i = 0; i < num_ports; i++) {
        port_list[i] = Serial.list()[i];
    }
  minim = new Minim (this);

  }
  catch(Exception e) {
    // If something goes wrong while communication with the MCU
    // the catch block will be processed. Here the error handling
    // should be done.
    println(e.getMessage());
	exit();
  }
}

public void resetKey() {
   try {
     //wait 1/2 second before displaying another letter
     delay(500);
    //turn off all pins before displaying letter
    r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.LOW);
    r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.LOW);
    r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.LOW);
    r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.LOW);
    r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.LOW);
    r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.LOW);
   }
    catch(Exception e) {
    // If something goes wrong while communication with the MCU
    // the catch block will be processed. Here the error handling
    // should be done.
    println(e.getMessage());
  exit();
  }
}

public void vibrateKey(char k) {
   try {
     if (deviceready){ //run only when the MCU is ready
     k = Character.toLowerCase(k);
   switch (k) {
     case 'a' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         delay(wait);
      break;
     case 'b' :
            // vibrate only pins that need to vibrate :-)
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
        // wait a little
      delay(wait);
            break;
     case 'c' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'd' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'e' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'f' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'g' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'h' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'i' :
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'j' :
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'k' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'l' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'm' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'n' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'o' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'p' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'r' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'q' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 's' :
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 't' :
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'u' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'v' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'w' :
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'x' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'y' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case 'z' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
  /*    case '#' :
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;*/
      case '0' :
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case '1' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case '2' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case '3' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case '4' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case '5' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         delay(wait);
      break;
      case '6' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         delay(wait);
      break;
        case '7' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         delay(wait);
      break;
        case '8' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         delay(wait);
      break;
        case '9' :
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         delay(wait);
      break;
  /*      case '+' :
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         delay(wait);
      break;
        case '_' :
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         delay(wait);
      break;
        case '*' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         delay(wait);
      break;
        case '/' :
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         delay(wait);
      break;*/
       default :resetKey();
      
   }
     }
   }
    catch(Exception e) {
    // If something goes wrong while communication with the MCU
    // the catch block will be processed. Here the error handling
    // should be done.
    println(e.getMessage());
  exit();
  }
}



/**
 * draw is called cyclic from processing
 */
public void draw() {
  try {
    //moved setup here to be run only once the serial is determined
     // see if Launchpad was plugged in
    if ((Serial.list().length > num_ports) && !device_detected) {
        device_detected = true;
        // determine which port the device was plugge into
        boolean str_match = false;
        if (num_ports == 0) {
            detected_port = Serial.list()[0];
        }
        else {
            for (int i = 0; i < Serial.list().length; i++) {  // go through the current port list
                for (int j = 0; j < num_ports; j++) {             // go through the saved port list
                    if (Serial.list()[i].equals(port_list[j])) {
                        break;
                    }
                    if (j == (num_ports - 1)) {
                        str_match = true;
                        detected_port = Serial.list()[i];
                    }
                }
            }
        }
    }
     

    // calculate and display serial port name
    if (device_detected) {
     
    // connect to MCU
    r = new ROCKETuC(this, detected_port);
   // setup pins
    // configure digital output
    // PIN_1_1 and PIN_1_2 are reserved for serial UART!

    r.pinMode(ROCKETuC.PIN_1_0, ROCKETuC.OUTPUT);
    r.pinMode(ROCKETuC.PIN_2_1, ROCKETuC.OUTPUT);
    r.pinMode(ROCKETuC.PIN_2_2, ROCKETuC.OUTPUT);
    r.pinMode(ROCKETuC.PIN_1_3, ROCKETuC.OUTPUT);
    r.pinMode(ROCKETuC.PIN_1_4, ROCKETuC.OUTPUT);
    r.pinMode(ROCKETuC.PIN_1_5, ROCKETuC.OUTPUT);
    deviceready = true;
    println("Initilized ROCKETuC pins");

       }

   background(0); // Set background to black

  // Draw the pressed keyboard letter to the center of the screen
  textSize(100);
  text(letter, 100, 128);
   vibrateKey(letter);
    } catch(Exception e) {
    // If something goes wrong while communication with the MCU
    // the catch block will be processed. Here the error handling
    // should be done.
    println(e.getMessage());
  exit();
  }
 
  }
 



public void keyPressed() {
  try{
  // The variable "key" always contains the value
  // of the most recent key pressed.
  if( key >= 'A' && key <= 'z' || key >= 0 && key <= 9) {
       letter = key;
     String s ="" + key;
  lettersound = minim.loadFile ("sound-fr/"+s+".wav");
  lettersound.rewind();
  lettersound.play();
 
    }
    // Write the letter to the console for debugging
    println(key);
  } catch(Exception e) {
    // If something goes wrong while communication with the MCU
    // the catch block will be processed. Here the error handling
    // should be done.
    println(e.getMessage());
  exit();
  }

}

//stop is called when you hit stop on processing. Just leave this here
public void stop()
{
  lettersound.close();
  minim.stop();
  resetKey();
  super.stop();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "box" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
