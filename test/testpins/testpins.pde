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

/**
 * This example shows:
 * 
 * how to connect to a MCU through a serial line
 * how to configure pins for digital output (p1.0+p1.6, the internal LEDs on the Launchpad)
 * how to toggle the state of an digital output (blink the LED) 
 */

import rocketuc.processing.*;

// our instance of the ROCKETuC API
ROCKETuC r;
byte pin = ROCKETuC.PIN_2_3;
boolean on= false;
/**
 * setup function called by processing on startup
 */
void setup() {  
  try {
    // connect to MCU
    r = new ROCKETuC(this, "/dev/ttyACM0");
    
    // configure p1.0 (build in LED) as digital output, initially set HIGH
    r.pinMode(pin, ROCKETuC.OUTPUT);
    r.digitalWrite(pin, ROCKETuC.LOW);
    println("OK");

  
    
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
  
    r.digitalWrite(pin, ROCKETuC.HIGH);
     // wait a little 
  delay(200);
    r.digitalWrite(pin, ROCKETuC.LOW);
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
