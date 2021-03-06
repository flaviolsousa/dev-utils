//+------------------------------------------------------------------+
//|                                                   Strategy_7.mq5 |
//|                                Copyright 2017, Alexander Fedosov |
//|                           https://www.mql5.com/en/users/alex2356 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Alexander Fedosov"
#property link      "https://www.mql5.com/en/users/alex2356"
#property version   "1.00"

#include "TradeFunctions.mqh" 
#include <SmoothAlgorithms.mqh> 

CTradeBase Trade;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum Applied_Extrem //Type of extreme points
  {
   HIGH_LOW,
   HIGH_LOW_OPEN,
   HIGH_LOW_CLOSE,
   OPEN_HIGH_LOW,
   CLOSE_HIGH_LOW
  };
//+------------------------------------------------------------------+
//| Expert Advisor input parameters                                  |
//+------------------------------------------------------------------+
input string               Inp_EaComment="Strategy #7";                 //EA Comment
input double               Inp_Lot=0.01;                                //Lot
input MarginMode           Inp_MMode=LOT;                               //MM
input int                  Inp_MagicNum=1111;                           //Magic number
input int                  Inp_StopLoss=400;                            //Stop Loss(points)
input int                  Inp_TakeProfit=600;                          //Take Profit(points)
input int                  Inp_Deviation = 20;                          //Deviation(points)
//--- Donchian Channel System indicator parameters

input uint                 DonchianPeriod=12;                           //Period of Averaging
input Applied_Extrem       Extremes=HIGH_LOW_CLOSE;                     //Type of Extremum

//--- CronexAO indicator parameters

input Smooth_Method        XMA_Method=MODE_ParMA;                        //Method of Averaging
input uint                 FastPeriod=14;                               //Period of Fast averaging
input uint                 SlowPeriod=25;                               //Period of Flow averaging
input int                  XPhase=15;                                   //Smoothing parameter

int InpInd_Handle1,InpInd_Handle2;
double dcs_up[],dcs_low[],cao_fast[],cao_slow[],close[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Checking connection to a trade server

   if(!TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      Print(Inp_EaComment,": No Connection!");
      return(INIT_FAILED);
     }
//--- Checking if automated trading is enabled

   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
     {
      Print(Inp_EaComment,": Trade is not allowed!");
      return(INIT_FAILED);
     }
//--- Getting the handle of the Donchian Channel System indicator

   InpInd_Handle1=iCustom(Symbol(),PERIOD_H1,"10Trend\\donchian_channels_system",
                          DonchianPeriod,
                          Extremes
                          );
   if(InpInd_Handle1==INVALID_HANDLE)
     {
      Print(Inp_EaComment,": Failed to get Donchian Channel System handle");
      Print("Handle = ",InpInd_Handle1,"  error = ",GetLastError());
      return(INIT_FAILED);
     }
//--- Getting handle of the CronexAO indicator

   InpInd_Handle2=iCustom(Symbol(),PERIOD_H1,"10Trend\\cronexao",
                          XMA_Method,
                          FastPeriod,
                          SlowPeriod,
                          XPhase
                          );
   if(InpInd_Handle2==INVALID_HANDLE)
     {
      Print(Inp_EaComment,": Failed to get CronexAO handle");
      Print("Handle = ",InpInd_Handle2,"  error = ",GetLastError());
      return(INIT_FAILED);
     }
//---
   ArrayInitialize(dcs_up,0.0);
   ArrayInitialize(dcs_low,0.0);
   ArrayInitialize(cao_fast,0.0);
   ArrayInitialize(cao_slow,0.0);
   ArrayInitialize(close,0.0);

   ArraySetAsSeries(dcs_up,true);
   ArraySetAsSeries(dcs_low,true);
   ArraySetAsSeries(cao_fast,true);
   ArraySetAsSeries(cao_slow,true);
   ArraySetAsSeries(close,true);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- Checking orders previously opened by the EA
   if(!Trade.IsOpened(Inp_MagicNum))
     {
      //--- Getting data for calculations

      if(!GetIndValue())
         return;

      //--- Opening an order if there is a buy signal

      if(BuySignal())
         Trade.BuyPositionOpen(true,Symbol(),Inp_Lot,Inp_MMode,Inp_Deviation,Inp_StopLoss,Inp_TakeProfit,Inp_MagicNum,Inp_EaComment);
      //--- Opening an order if there is a sell signal

      if(SellSignal())
         Trade.SellPositionOpen(true,Symbol(),Inp_Lot,Inp_MMode,Inp_Deviation,Inp_StopLoss,Inp_TakeProfit,Inp_MagicNum,Inp_EaComment);
     }
  }
//+------------------------------------------------------------------+
//| Buy conditions                                                   |
//+------------------------------------------------------------------+
bool BuySignal()
  {
   return(cao_fast[0]>cao_slow[0] && close[0]>dcs_up[0])?true:false;
  }
//+------------------------------------------------------------------+
//| Sell conditions                                                  |
//+------------------------------------------------------------------+
bool SellSignal()
  {
   return(cao_fast[0]<cao_slow[0] && close[0]<dcs_low[0])?true:false;
  }
//+------------------------------------------------------------------+
//| Getting the current values of indicators                         |
//+------------------------------------------------------------------+
bool GetIndValue()
  {
   return(CopyBuffer(InpInd_Handle1,0,0,2,dcs_up)<=0 ||
          CopyBuffer(InpInd_Handle1,1,0,2,dcs_low)<=0 || 
          CopyBuffer(InpInd_Handle2,0,0,2,cao_fast)<=0 ||
          CopyBuffer(InpInd_Handle2,1,0,2,cao_slow)<=0 ||
          CopyClose(Symbol(),PERIOD_H1,0,2,close)<=0
          )?false:true;
  }
//+------------------------------------------------------------------+
