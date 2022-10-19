/*

  Module:  raw-halconfig.ino

  Function:
  Auto-configured raw test example, for Adafruit Feather M0 LoRa

  Copyright notice and License:
  See LICENSE file accompanying this project.

  Author:
    Matthijs Kooijman  2015
    Terry Moore, MCCI Corporation  2018

*/

/*******************************************************************************
   Copyright (c) 2015 Matthijs Kooijman

   Permission is hereby granted, free of charge, to anyone
   obtaining a copy of this document and accompanying files,
   to do whatever they want with them without any restriction,
   including, but not limited to, copying, modification and redistribution.
   NO WARRANTY OF ANY KIND IS PROVIDED.

   This example transmits data on hardcoded channel and receives data
   when not transmitting. Running this sketch on two nodes should allow
   them to communicate.
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

#define NODE_IDX 42
#define RSSI_RESET_VAL 128
#define SCHEDULE_LEN 10
#define FREQ_EXPT 920000000

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

osjob_t arbiter_job, backhaul_job;

// Enable rx mode and call func when a packet is received
void rx(osjobcb_t func) {
  LMIC.osjob.func = func;
  LMIC.rxtime = os_getTime(); // RX _now_
  // Enable "continuous" RX (e.g. without a timeout, still stops after
  // receiving a packet)

  os_radio(RADIO_RXON);

//  Serial.print("RxStart: ");
//  Serial.print(os_getTime());
//  Serial.print("\n");
}

static void backhaul_data (osjob_t* job) {
  // Asynchronous backhaul job
  for (u2_t ind = 0; ind <  LMIC.dataLen; ind++) {
    if (LMIC.frame[ind] > 15)
      Serial.print(LMIC.frame[ind], HEX);
    else {
      Serial.print("0");
      Serial.print(LMIC.frame[ind], HEX);
    }
  }
  Serial.print(", ");
  Serial.print(LMIC.rssi);
  Serial.print(", ");
  Serial.print(LMIC.snr);
  Serial.print("\n");
}

static void rxdone_func (osjob_t* job) {
  // Arbiter
  os_setCallback(job, rx_func);
  // Backhaul
  os_setTimedCallback(&backhaul_job, os_getTime() + 100, backhaul_data);
  
}

static void rx_func (osjob_t* job) {
  // GET BUF_OUT
  rx(rxdone_func);
}


// application entry point
void setup() {
  Serial.begin(2000000);
  pinMode(LED_BUILTIN, OUTPUT);
  // initialize runtime env
  os_init();

  // disable RX IQ inversion
  LMIC.noRXIQinversion = true;
  LMIC.freq = FREQ_EXPT; // WCSNG
  // MAKERPS(SF8 , BW500, CR_4_8, 0, 0)
  // MAKERPS(SF7 , BW500, CR_4_5, 0, 0)
  LMIC.rps = MAKERPS(SF8 , BW125, CR_4_8, 0, 0); // WCSNG
  LMIC.sysname_tx_rps =  MAKERPS(SF8 , BW125, CR_4_8, 0, 0);
  LMIC.txpow = 21;
  LMIC.radio_txpow = 21; // WCSNG

  Serial.flush();

  // setup initial job
  os_setCallback(&arbiter_job, rx_func);

  digitalWrite(LED_BUILTIN, HIGH); // on

}

void loop() {
  // execute scheduled jobs and events
  os_runloop_once();
}
