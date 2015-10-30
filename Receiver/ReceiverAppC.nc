#include "Localization.h"

configuration ReceiverAppC {}
implementation {
  components ReceiverC as App, MainC;
  components SerialActiveMessageC as AM;
  components ActiveMessageC;

  components BaseStationC;
  components CC2420ActiveMessageC;
  components LedsC;

  App.Boot -> MainC.Boot;
  App.Control -> AM;
  App.AMSend -> AM.AMSend[AM_TEST_SERIAL_MSG];
  App.Packet -> AM;
  App.Leds -> LedsC
;
  App -> ActiveMessageC.AMPacket;
  App -> CC2420ActiveMessageC.CC2420Packet;
  App-> BaseStationC.RadioIntercept[AM_RSSIMSG];
}
