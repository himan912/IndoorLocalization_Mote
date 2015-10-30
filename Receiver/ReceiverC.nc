#include "Localization.h"

module ReceiverC {
  uses {
    interface SplitControl as Control;
    interface Boot;
    interface AMSend;
    interface Packet;
    interface AMPacket;
    interface Leds;

    interface Intercept as RssiMsgIntercept;
    interface CC2420Packet;
  }
}
implementation {
  
  message_t packet;

  event void Boot.booted() {
    call Control.start();
    call Leds.led1Toggle();
  }

  // get info and forward
  int16_t getRss(message_t *msg);
  
  event bool RssiMsgIntercept.forward(message_t *msg, void *payload, uint8_t len) {
    RssMsg *rssMsg = (RssMsg*) payload;

    RssMsg* rcm = (RssMsg*)call Packet.getPayload(&packet, sizeof(RssMsg));
    rcm->rssi = getRss(msg);
    rcm->source = call AMPacket.source(msg);
    rcm->coord_x = rssMsg->coord_x;
    rcm->coord_y = rssMsg->coord_y;

    call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(RssMsg));
    return TRUE;
  }

  int16_t getRss(message_t *msg){
    return (int16_t) call CC2420Packet.getRssi(msg);
  }
  //

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {}
  event void Control.startDone(error_t err) {}
  event void Control.stopDone(error_t err) {}
}

