//+------------------------------------------------------------------+
//|                                               XBotChangeLife.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#define MACD_MAGIC 20190109
#include <Trade\Trade.mqh>
//+------------------------------------------------------------------+
input double               InpLots=1; // Lots
input int                  InpTP=50;  // Take Profit (in pips)
input int                  InpDistancePendingOrder=150;
input int                  InpTicksToRestart=50;
input int                  InpBandsPeriod=80;
input int                  InpBandsShift=0;
input double               InpDeviation=2.0;
input ENUM_APPLIED_PRICE   InpAppliedPrice=PRICE_CLOSE;
//+------------------------------------------------------------------+
CTrade     trade;
int        bandsHandle;
bool       onTrade=false;
//---
string s=Symbol();
ENUM_TIMEFRAMES p=Period();
long c=ChartID();
//---
double tickSize=SymbolInfoDouble(s,SYMBOL_TRADE_TICK_SIZE);
double volumeStep=SymbolInfoDouble(s,SYMBOL_VOLUME_STEP);;
//---
double spread=0;
double ask=0;
double bid=0;
int ordersTotal=0;
int positionsTotal=0;
int dealsTotal=0;
int historyOrdersTotal=0;
//---

double curLots=0;
int ticksToRestart=0;

MqlTick    lastTick;
//---
struct sSignal
  {
   bool              Buy;
   bool              Sell;
  };
//--
sSignal isBuyOrSell()
  {
   sSignal res={false,false};
   double         UpperBuffer[];
   double         LowerBuffer[];
   double         MiddleBuffer[];
   ArraySetAsSeries(MiddleBuffer,true);
   CopyBuffer(bandsHandle,0,0,1,MiddleBuffer);
   ArraySetAsSeries(UpperBuffer,true);
   CopyBuffer(bandsHandle,1,0,1,UpperBuffer);
   ArraySetAsSeries(LowerBuffer,true);
   CopyBuffer(bandsHandle,2,0,1,LowerBuffer);
   double L[];
   double H[];
   ArraySetAsSeries(L,true);
   CopyLow(_Symbol,_Period,0,1,L);
   ArraySetAsSeries(H,true);
   CopyHigh(_Symbol,_Period,0,1,H);

   LabelTextChange(c,"labelStatus",StringFormat("H: %g | L: %g | UB: %g | MB: %g | LB: %g",H[0],L[0],UpperBuffer[0],MiddleBuffer[0],LowerBuffer[0]));

   LabelTextChange(c,"labelIfs",StringFormat("Check IFs: %s && %s || %s && %s",(H[0]>UpperBuffer[0]? "T" : "F"),(L[0]>MiddleBuffer[0]? "T" : "F"),(L[0]<LowerBuffer[0]? "T" : "F"),(H[0]<MiddleBuffer[0]? "T" : "F")));
   if(H[0]>UpperBuffer[0] && L[0]>MiddleBuffer[0])
      res.Sell=true;
   if(L[0]<LowerBuffer[0] && H[0]<MiddleBuffer[0])
      res.Buy=true;
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   LabelCreate(c,"labelIfs",0,10,50,CORNER_RIGHT_UPPER,ANCHOR_RIGHT_UPPER,"...","Arial",20,0xb9936c);
   LabelCreate(c,"labelStatus",0,10,80,CORNER_RIGHT_UPPER,ANCHOR_RIGHT_UPPER,"...","Arial",10,0xb9936c);
   LabelCreate(c,"labelData",0,10,100,CORNER_RIGHT_UPPER,ANCHOR_RIGHT_UPPER,"...","Arial",10,0xb9936c);
//---
   bandsHandle=iBands(s,p,InpBandsPeriod,InpBandsShift,InpDeviation,InpAppliedPrice);
   if(bandsHandle==INVALID_HANDLE)
      return(INIT_FAILED);
   else
      onTrade=true;
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   LabelDelete(c,"labelIfs");
   LabelDelete(c,"labelData");
   LabelDelete(c,"labelStatus");

//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   refreshDatas();
   refreshLabels();

   if(onTrade)
     {
      sSignal signal=isBuyOrSell();
      //--- BUY
      if(signal.Buy)
        {
         if(!PositionSelect(s))
           {
            double tp=ask+InpTP;
            double startOrdemPend=ask-InpDistancePendingOrder;
            curLots=InpLots;
            if(trade.PositionOpen(s,ORDER_TYPE_BUY,NormalizeDouble(curLots,0),ask,0,tp,"BUY: new position"))
              {
               // pending parameters
               double askp=(ask+startOrdemPend)/2;
               double tpp=askp+InpTP;
               trade.OrderOpen(s,ORDER_TYPE_BUY_LIMIT,NormalizeDouble(curLots,0),startOrdemPend,startOrdemPend,0,tpp,0,0,"Level: 1");
               onTrade=false;
              }
           }
        }
     }
   else
     {
      if(ticksToRestart>0)
        {
         ticksToRestart=ticksToRestart -1;
         if(ticksToRestart==0) onTrade=true;
        }
     }
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   Print("### OnTrade ###");
   if(!PositionSelect(s))
     {
      for(int i=ordersTotal-1;i>=0;i--)
        {
         ulong ticket=OrderGetTicket(i);
         if(OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL)==s)
           {
            Print("# OrderDelete: " + IntegerToString(ticket));
            trade.OrderDelete(ticket);
            ticksToRestart=InpTicksToRestart;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
//---

//+------------------------------------------------------------------+
  }
//+------------------------------------------------------------------+
void refreshDatas()
  {
   SymbolInfoTick(s,lastTick);
   ask=lastTick.ask;
   bid=lastTick.bid;
   spread=ask-bid;
   ordersTotal=OrdersTotal();
   positionsTotal=PositionsTotal();
   dealsTotal=HistoryDealsTotal();
   historyOrdersTotal=HistoryOrdersTotal();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void refreshLabels()
  {
   LabelTextChange(ChartID(),"labelData",StringFormat("tickSize: %g | Spread: %g ",tickSize,spread));
  }
//+------------------------------------------------------------------+
//| Criar um a etiqueta de texto                                     |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID=0,// ID do gráfico
                 const string            name="Label",             // nome da etiqueta
                 const int               sub_window=0,             // índice da sub-janela
                 const int               x=0,                      // coordenada X
                 const int               y=0,                      // coordenada Y
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // canto do gráfico para ancoragem
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // tipo de ancoragem
                 const string            text="Label",             // texto
                 const string            font="Arial",             // fonte
                 const int               font_size=10,             // tamanho da fonte
                 const color             clr=clrRed,               // cor
                 const double            angle=0.0,                // inclinação do texto
                 const bool              back=false,               // no fundo
                 const bool              selection=false,          // destaque para mover
                 const bool              hidden=true,              // ocultar na lista de objetos
                 const long              z_order=0)                // prioridade para clicar no mouse
  {
//--- redefine o valor de erro
   ResetLastError();
//--- criar um a etiqueta de texto
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": falha ao criar uma etiqueta de texto! Código de erro = ",GetLastError());
      return(false);
     }
//--- definir coordenadas da etiqueta
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- determinar o canto do gráfico onde as coordenadas do ponto são definidas
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- definir o texto
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- definir o texto fonte
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- definir tamanho da fonte
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- definir o ângulo de inclinação do texto
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- tipo de definição de ancoragem
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- definir cor
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- exibir em primeiro plano (false) ou fundo (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- Habilitar (true) ou desabilitar (false) o modo de movimento da etiqueta pelo mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- ocultar (true) ou exibir (false) o nome do objeto gráfico na lista de objeto 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- definir a prioridade para receber o evento com um clique do mouse no gráfico
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- sucesso na execução
   return(true);
  }
//+------------------------------------------------------------------+
//| Alterar o texto do objeto                                        |
//+------------------------------------------------------------------+
bool LabelTextChange(const long   chart_ID=0,   // ID do gráfico
                     const string name="Label", // nome do objeto
                     const string text="Text")  // texto
  {
//--- redefine o valor de erro
   ResetLastError();
//--- alterar texto do objeto
   if(!ObjectSetString(chart_ID,name,OBJPROP_TEXT,text))
     {
      Print(__FUNCTION__,
            ": falha ao alterar texto! Código de erro = ",GetLastError());
      return(false);
     }
//--- sucesso na execução
   return(true);
  }
//+------------------------------------------------------------------+
//| Apagar uma etiqueta de texto                                     |
//+------------------------------------------------------------------+
bool LabelDelete(const long   chart_ID=0,   // ID do gráfico
                 const string name="Label") // nome da etiqueta
  {
//--- redefine o valor de erro
   ResetLastError();
//--- excluir a etiqueta
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": falha ao excluir a etiqueta de texto! Código de erro = ",GetLastError());
      return(false);
     }
//--- sucesso na execução
   return(true);
  }
//+------------------------------------------------------------------+
