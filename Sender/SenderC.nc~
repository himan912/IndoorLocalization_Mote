#include "Localization.h"

module SenderC {
  uses interface Boot;
  uses interface Timer<TMilli> as SendTimer;
  
  uses interface AMSend as MsgSend;
  uses interface SplitControl as RadioControl;
  uses interface Packet;
  uses interface Leds;
} implementation {

  message_t pkt;

  bool busy = FALSE;

  int16_t source = 4;
  int16_t coord_x = 10;
  int16_t coord_y = 5;
  
  event void Boot.booted(){
    call RadioControl.start();
  }

  event void RadioControl.startDone(error_t result){
    call SendTimer.startPeriodic(SEND_INTERVAL_MS);
  }

  event void RadioControl.stopDone(error_t result){}


  event void SendTimer.fired(){
    if(!busy){
      RssMsg* rssmsg = (RssMsg*)call Packet.getPayload(&pkt, sizeof(RssMsg));
      if (rssmsg == NULL) {
      	return;
      }

      rssmsg->source=source;
      rssmsg->coord_x=coord_x;
      rssmsg->coord_y=coord_y;

      if (call MsgSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(RssMsg)) == SUCCESS) {
        call Leds.led1Toggle();
        busy = TRUE;
      }
    }
  }

  event void MsgSend.sendDone(message_t *m, error_t error){
    if (&pkt == m) {
      busy = FALSE;
    }
  }
}
