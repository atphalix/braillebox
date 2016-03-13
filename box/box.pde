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

import processing.serial.*;
import rocketuc.processing.*;

//elipse coordinates
int x1 = 50;
int y1 = 50;

int x2 = 50;
int y2 = y1+50;

int x3 = 50;
int y3 = 150;

int x4 = x1+50;
int y4 = 50;

int x5 = x1+50;
int y5 = y1+50;

int x6 = x1+50;
int y6 = 150;

int diameter = 38;

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
byte pin1 = ROCKETuC.PIN_1_0;
byte pin2 =  ROCKETuC.PIN_2_1;
byte pin3 =  ROCKETuC.PIN_2_2;
byte pin4 =   ROCKETuC.PIN_1_3;
byte pin5 =   ROCKETuC.PIN_1_4;
byte pin6 =   ROCKETuC.PIN_1_5;
/**
 * setup function called by processing on startup
 */
void setup() {
  size(256, 256);
  fill(102);
  // Create the font
  textFont(createFont("Arial", 36));

  try {
   // connect to MCU
    r = new ROCKETuC(this, "/dev/ttyACM0");
    
    // configure p1.0 (build in LED) as digital output, initially set HIGH
    r.pinMode(pin1, ROCKETuC.OUTPUT);
    r.pinMode(pin2, ROCKETuC.OUTPUT);
    r.pinMode(pin3, ROCKETuC.OUTPUT);
    r.pinMode(pin4, ROCKETuC.OUTPUT);
    r.pinMode(pin5, ROCKETuC.OUTPUT);
    r.pinMode(pin6, ROCKETuC.OUTPUT);

  }
  catch(Exception e) {
    // If something goes wrong while communication with the MCU
    // the catch block will be processed. Here the error handling
    // should be done.
    println(e.getMessage());
	exit();
  }
}

void resetKey() {
   try {
     //wait 1/2 second before displaying another letter
     delay(600);
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

void vibrateKey(char k) {
   try {
    
     k = Character.toLowerCase(k);
   switch (k) {
     case 'a' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         delay(wait);
          ellipse(x1, y1, diameter, diameter);
      break;
     case 'b' :
            // vibrate only pins that need to vibrate :-)
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
          ellipse(x1, y1, diameter, diameter);
	  ellipse(x2, y2, diameter, diameter);
        // wait a little
      delay(wait);
            break;
     case 'c' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
         delay(wait);
      break;
      case 'd' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
         delay(wait);
      break;
      case 'e' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
         delay(wait);
      break;
      case 'f' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
         delay(wait);
      break;
      case 'g' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
         delay(wait);
      break;
      case 'h' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
         delay(wait);
      break;
      case 'i' :
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
         delay(wait);
      break;
      case 'j' :
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
         delay(wait);
      break;
      case 'k' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
         delay(wait);
      break;
      case 'l' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
         delay(wait);
      break;
      case 'm' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
         delay(wait);
      break;
      case 'n' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
         delay(wait);
      break;
      case 'o' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
         delay(wait);
      break;
      case 'p' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
         delay(wait);
      break;
      case 'r' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
	 ellipse(x1, y3, diameter, diameter);
         delay(wait);
      break;
      case 'q' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
         delay(wait);
      break;
      case 's' :
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
         delay(wait);
      break;
      case 't' :
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
         delay(wait);
      break;
      case 'u' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
	 ellipse(x6, y6, diameter, diameter);
         delay(wait);
      break;
      case 'v' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
	 ellipse(x6, y6, diameter, diameter);
         delay(wait);
      break;
      case 'w' :
         r.digitalWrite(ROCKETuC.PIN_2_1, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
	 ellipse(x2, y2, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
	 ellipse(x6, y6, diameter, diameter);
         delay(wait);
      break;
      case 'x' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
	 ellipse(x6, y6, diameter, diameter);
         delay(wait);
      break;
      case 'y' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_3, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x4, y4, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
	 ellipse(x6, y6, diameter, diameter);
         delay(wait);
      break;
      case 'z' :
         r.digitalWrite(ROCKETuC.PIN_1_0, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_4, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_1_5, ROCKETuC.TOGGLE);
         r.digitalWrite(ROCKETuC.PIN_2_2, ROCKETuC.TOGGLE);
	 ellipse(x1, y1, diameter, diameter);
	 ellipse(x5, y5, diameter, diameter);
	 ellipse(x6, y6, diameter, diameter);
	 ellipse(x3, y3, diameter, diameter);
         delay(wait);
      break;
      
   
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
void draw() {


   background(0); // Set background to black

  // Draw the pressed keyboard letter to the center of the screen
  textSize(100);
 // text(letter, 100, 128);
 
   vibrateKey(letter);

 
 
  }
 



void keyPressed() {
  try{
    resetKey();// turn off all keys to refresh screen
  // The variable "key" always contains the value
  // of the most recent key pressed.
  if( key >= 'A' && key <= 'z' || key >= 0 && key <= 9) {
       letter = key;
     String s ="" + key;
 
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
void stop()
{
 
  resetKey();
  super.stop();
}
