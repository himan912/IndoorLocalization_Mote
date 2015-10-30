#include "Localization.h"

configuration SenderAppC {
} implementation {
  components SenderC as App;  
  components MainC;  
  components ActiveMessageC;
  components new AMSenderC(AM_RSSIMSG) as MsgSender;
  components new TimerMilliC() as SendTimer;
  components LedsC;

  App.Boot -> MainC;
  App.SendTimer -> SendTimer;
  App.Leds -> LedsC;
  
  App.MsgSend -> MsgSender;
  App.RadioControl -> ActiveMessageC;
  App.Packet -> ActiveMessageC;
}
