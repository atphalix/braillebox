/* 
 * This file is part of the ROCKETuC Processing Library project
 *
 * Copyright (C) 2012 Stefan Wendler <sw@kaltpost.de>
 *
 * The ROCKETuC Processing Library is free software; you can redistribute 
 * it and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * ROCKETuC Processing Library is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with the JRocket firmware; if not, write to the Free
 * Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 * 02111-1307 USA.  
 */


/*
 * Braille to pin mapping diagram:
 *PIN_1_0-o o-PIN_1_3
 *PIN_2_1-o o-PIN_1_4
 *PIN_2_2-o o-PIN_1_5
 *
 */
 
import rocketuc.processing.*;

// our instance of the ROCKETuC API
ROCKETuC r;
byte pin1 = ROCKETuC.PIN_1_0;
byte pin2 = ROCKETuC.PIN_2_1;
byte pin3 = ROCKETuC.PIN_2_2;
byte pin4 = ROCKETuC.PIN_1_3;
byte pin5 = ROCKETuC.PIN_1_4;
byte pin6 = ROCKETuC.PIN_1_5;// change to pin I want to test
//working byte pin = ROCKETuC.PIN_2_1;
boolean on= false;
/**
 * setup function called by processing on startup
 */
void setup() {  
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

    println("initialize OK");

  
    
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
  try {
    // toggle p1.0 between high/low state (LED on/off)
  
    r.digitalWrite(pin1, ROCKETuC.HIGH);
    r.digitalWrite(pin2, ROCKETuC.HIGH);
    r.digitalWrite(pin3, ROCKETuC.HIGH);
    r.digitalWrite(pin4, ROCKETuC.HIGH);
    r.digitalWrite(pin5, ROCKETuC.HIGH);
    r.digitalWrite(pin6, ROCKETuC.HIGH);
     // wait a little 
  delay(200);
    r.digitalWrite(pin1, ROCKETuC.LOW);
    r.digitalWrite(pin2, ROCKETuC.LOW);
    r.digitalWrite(pin3, ROCKETuC.LOW);
    r.digitalWrite(pin4, ROCKETuC.LOW);
    r.digitalWrite(pin5, ROCKETuC.LOW);
    r.digitalWrite(pin6, ROCKETuC.LOW);
    delay(200);
  }
  catch(Exception e) {
    // If something goes wrong while communication with the MCU
    // the catch block will be processed. Here the error handling
    // should be done. 
    println(e.getMessage());
	exit();
  }
  
 
}
