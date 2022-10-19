/*

Module:  raw-halconfig.ino

Function:
  Auto-configured raw test example, for Adafruit Feather M0 LoRa

Copyright notice and License:
  See LICENSE file accompanying this project.

Author:
    Matthijs Kooijman  2015
    Terry Moore, MCCI Corporation	2018

*/

/*******************************************************************************
 * Copyright (c) 2015 Matthijs Kooijman
 *
 * Permission is hereby granted, free of charge, to anyone
 * obtaining a copy of this document and accompanying files,
 * to do whatever they want with them without any restriction,
 * including, but not limited to, copying, modification and redistribution.
 * NO WARRANTY OF ANY KIND IS PROVIDED.
 *
 * This example transmits data on hardcoded channel and receives data
 * when not transmitting. Running this sketch on two nodes should allow
 * them to communicate.
 *******************************************************************************/

#include <lmic.h>
#include <hal/hal.h>
#include <arduino_lmic_hal_boards.h>

#include <SPI.h>

#include <stdarg.h>
#include <stdio.h>

// we formerly would check this configuration; but now there is a flag,
// in the LMIC, LMIC.noRXIQinversion;
// if we set that during init, we get the same effect.  If
// DISABLE_INVERT_IQ_ON_RX is defined, it means that LMIC.noRXIQinversion is
// treated as always set.
//
// #if !defined(DISABLE_INVERT_IQ_ON_RX)
// #error This example requires DISABLE_INVERT_IQ_ON_RX to be set. Update \
//        lmic_project_config.h in arduino-lmic/project_config to set it.
// #endif

// How often to send a packet. Note that this sketch bypasses the normal
// LMIC duty cycle limiting, so when you change anything in this sketch
// (payload length, frequency, spreading factor), be sure to check if
// this interval should not also be increased.
// See this spreadsheet for an easy airtime and duty cycle calculator:
// https://docs.google.com/spreadsheets/d/1voGAtQAjC1qBmaVuP1ApNKs1ekgUjavHuVQIXyYSvNc

#define TRX_INTERVAL 20        // milliseconds
#define FREQ_CNFG 917000000

// Pin mapping
const lmic_pinmap lmic_pins = {
  .nss = D10,
  .rxtx = LMIC_UNUSED_PIN,
  .rst = A0,
  .dio = {2, 3, 4},
};


// These callbacks are only used in over-the-air activation, so they are
// left empty here (we cannot leave them out completely unless
// DISABLE_JOIN is set in arduino-lmoc/project_config/lmic_project_config.h,
// otherwise the linker will complain).
void os_getArtEui (u1_t* buf) { }
void os_getDevEui (u1_t* buf) { }
void os_getDevKey (u1_t* buf) { }

// this gets callled by the library but we choose not to display any info;
// and no action is required.
void onEvent (ev_t ev) {
}


osjob_t txjob;
osjob_t timeoutjob;
static void tx_func (osjob_t* job);

// WCSNG

// Serial Buffer(s)
byte buf_in[5];
byte buf_out[5];
byte reg_array[48];
u4_t freq_array[24];
//

// Transmit the given string and call the given function afterwards
void tx(osjobcb_t func) {
  // the radio is probably in RX mode; stop it.
  os_radio(RADIO_RST);
  // wait a bit so the radio can come out of RX mode
  delay(1);
  // prepare data
  LMIC.dataLen = 4;
  LMIC.frame[0] = buf_out[1];
  LMIC.frame[1] = buf_out[2];
  LMIC.frame[2] = buf_out[3];
  LMIC.frame[3] = buf_out[4];
  // set completion function.
  LMIC.osjob.func = func;
  // start the transmission
  os_radio(RADIO_TX);
}

// Enable rx mode and call func when a packet is received
void rx(osjobcb_t func) {
  LMIC.osjob.func = func;
  LMIC.rxtime = os_getTime(); // RX _now_
  // Enable "continuous" RX (e.g. without a timeout, still stops after
  // receiving a packet)
  os_radio(RADIO_RXON);
}

static void rxtimeout_func(osjob_t *job) {
  digitalWrite(LED_BUILTIN, LOW); // off
  // The radio is probably in Rx Mode, kill it;
  os_radio(RADIO_RST);
  delay(1);

  buf_out[0] = 1;
  buf_out[1] = 255;
  buf_out[2] = 255;
  buf_out[3] = 255;
  buf_out[4] = 255;

  Serial.write(buf_out,5);

  os_setCallback(&txjob, arbiter_fn);
}

static void rxdone_func (osjob_t* job) {
  // Unlink the timeout job if you receive
  os_clearCallback (&timeoutjob);

  if(!LMIC.sysname_crc_err){
    buf_out[0] = 1;
    buf_out[1] = LMIC.frame[0];
    buf_out[2] = LMIC.frame[1];
    buf_out[3] = LMIC.frame[2];
    buf_out[4] = LMIC.frame[3];
    reg_array[buf_out[1]] = LMIC.rssi;
  } else{
    buf_out[0] = 1;
    buf_out[1] = 255;
    buf_out[2] = 255;
    buf_out[3] = 255;
    buf_out[4] = 255;
  }

  Serial.write(buf_out,5);
  // Arbiter
  os_setCallback(job, arbiter_fn);
  
}

static void rx_func (osjob_t* job) {
  // GET BUF_OUT
  os_setTimedCallback(&timeoutjob, os_getTime() + ms2osticks(10*TRX_INTERVAL), rxtimeout_func);
  rx(rxdone_func);
}

static void rxdone2_func (osjob_t* job) {
  // Unlink the timeout job if you receive
  os_clearCallback (&timeoutjob);
  reg_array[LMIC.frame[0]] = LMIC.rssi;

  Serial.write(LMIC.frame,LMIC.dataLen);
  // Arbiter
  os_setCallback(job, arbiter_fn);
  
}

static void rxdone3_func (osjob_t* job) {
  // Unlink the timeout job if you receive
  os_clearCallback (&timeoutjob);
  reg_array[LMIC.frame[0]] = LMIC.rssi;

  Serial.write(LMIC.frame,LMIC.dataLen);
  // Arbiter
  os_setCallback(job, rx3_func);
  
}

static void rx2_func (osjob_t* job) {
  // This one is for arbitrary Rx.
  os_setTimedCallback(&timeoutjob, os_getTime() + ms2osticks(10*TRX_INTERVAL), rxtimeout_func);
  rx(rxdone2_func);
}

static void rx3_func (osjob_t* job) {
  // This one is for arbitrary nbyte Rx.
  os_setTimedCallback(&timeoutjob, os_getTime() + ms2osticks(20*TRX_INTERVAL), rxtimeout_func);
  rx(rxdone3_func);
}

static void txdone_func (osjob_t* job) {
  // Immediately start listening
  os_setCallback(job, rx_func);
}

static void txdone_noack_func (osjob_t* job) {
  // Immediately go to arbiter
  os_setCallback(job, arbiter_fn);
}

static void txdone_mass_read (osjob_t* job) {
  // Immediately go to rx3
  os_setCallback(job, rx3_func);
}

// log text to USART and toggle LED
static void tx_func (osjob_t* job) {
  // Send BUF OUT
  tx(txdone_func);
}

// log text to USART and toggle LED
static void tx_func_mass_read (osjob_t* job) {
  // Send BUF OUT
  tx(txdone_mass_read);
}

// log text to USART and toggle LED
static void tx_func_noack (osjob_t* job) {
  // Send BUF OUT
  tx(txdone_noack_func);
}

static void arbiter_fn (osjob_t* job) {

  // Three bytes for buf_in
  // byte 0    : Command to arbiter
  // byte 1    : Node Idx
  // byte 2    : Command to Node
  // byte 3    : Register
  // byte 4    : Value
  if((Serial.available()>=5)){
    Serial.readBytes(buf_in, 5);
    switch(buf_in[0]){
      case 0:
        // Signal Gateway Alive
        buf_in[0] = 0;
        buf_in[1] = 0;
        buf_in[2] = 0;
        buf_in[3] = 0;
        buf_in[4] = 0;
        buf_out[0] = 0;
        buf_out[1] = 0;
        buf_out[2] = 0;
        buf_out[3] = 0;
        buf_out[4] = 0;
        Serial.write(buf_out,5);
        os_setCallback(job, arbiter_fn);
      break;
      case 1:
        // Transmit Four Bytes and Get Ack
        buf_out[1] = buf_in[1];
        buf_out[2] = buf_in[2];
        buf_out[3] = buf_in[3];
        buf_out[4] = buf_in[4];
        os_setCallback(job, tx_func);
        break;
      case 2:
        // Transmit Four Bytes and Stop
        buf_out[1] = buf_in[1];
        buf_out[2] = buf_in[2];
        buf_out[3] = buf_in[3];
        buf_out[4] = buf_in[4];
        os_setCallback(job, tx_func_noack);
      break;
      case 3:
        // Receive Some Bytes and Stop
        os_setCallback(job, rx2_func);
      break;
      case 4:
        // Readback registers from trx gateway
        buf_out[0] = 4;
        buf_out[1] = buf_in[1];
        buf_out[2] = 0;
        buf_out[3] = 0;
        buf_out[4] = reg_array[buf_in[1]];
        buf_in[0] = 0;
        buf_in[1] = 0;
        buf_in[2] = 0;
        buf_in[3] = 0;
        buf_in[4] = 0;
        Serial.write(buf_out,5);
        os_setCallback(job, arbiter_fn);
      break;
      case 5:
        // Retune the gateway
        LMIC.freq = freq_array[buf_in[1]];
        buf_out[0] = 5;
        buf_out[1] = buf_in[1];
        buf_out[2] = 0;
        buf_out[3] = 0;
        buf_out[4] = 0;
        buf_in[0] = 0;
        buf_in[1] = 0;
        buf_in[2] = 0;
        buf_in[3] = 0;
        buf_in[4] = 0;
        Serial.write(buf_out,5);
        os_setCallback(job, arbiter_fn);
      break;
      case 6:
        // Transmit, then
        // Receive Continuously till an Rx timeout
        buf_out[1] = buf_in[1];
        buf_out[2] = buf_in[2];
        buf_out[3] = buf_in[3];
        buf_out[4] = buf_in[4];
        os_setCallback(job, tx_func_mass_read);
      break;
      default:
        buf_in[0] = 0;
        buf_in[1] = 0;
        buf_in[2] = 0;
        buf_in[3] = 0;
        buf_in[4] = 0;
        buf_out[0] = 0;
        buf_out[1] = 0;
        buf_out[2] = 0;
        buf_out[3] = 0;
        buf_out[4] = 0;
        Serial.write(buf_out,5);
        os_setCallback(job, arbiter_fn);
      
    } 
  } else {
    os_setCallback(job, arbiter_fn);
  }
 
}

// application entry point
void setup() {
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  // initialize runtime env
  os_init();

  // disable RX IQ inversion
  LMIC.noRXIQinversion = true;
  LMIC.freq = 922000000;//FREQ_CNFG; // WCSNG
//  LMIC.rps = MAKERPS(SF8 , BW500, CR_4_8, 0, 0); // WCSNG
//  LMIC.sysname_tx_rps = MAKERPS(SF8 , BW500, CR_4_8, 0, 0);
  LMIC.rps = MAKERPS(SF8 , BW125, CR_4_8, 0, 0); // WCSNG
  LMIC.sysname_tx_rps = MAKERPS(SF8 , BW125, CR_4_8, 0, 0);
  LMIC.txpow = 21;
  LMIC.radio_txpow = 21; // WCSNG

  Serial.flush();

  // Setup Registers
  buf_in[0] == 0;
  buf_in[1] == 0;
  buf_in[2] == 0;
  buf_in[3] == 0;
  buf_in[4] == 0;

  for(byte ind=0;ind<48;ind++)
    reg_array[ind] = 0;

  for(byte ind=0;ind<24;ind++)
    freq_array[ind] = 904000000 + (u4_t)ind * 1000000;

  // setup initial job
  os_setCallback(&txjob, arbiter_fn);

}

void loop() {
  // execute scheduled jobs and events
  os_runloop_once();
}
