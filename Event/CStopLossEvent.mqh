#property copyright "No copyright, Daniel Mooney"
#property version   "1.0"
#property library
#property strict

#ifndef STOPLOSS_EVENT_MQH
#define STOPLOSS_EVENT_MQH

#include <Arrays/List.mqh>
#include <MQL4Library/Event/COrderEventBase.mqh>
#include <MQL4Library/Order/COrderPool.mqh>
#include <MQL4Library/Order/COrder.mqh>

class CStopLossEvent: public COrderEventBase {
    public:
        CStopLossEvent(
            COrderPool* order_pool
        );

        /**
         * @brief Checks if a stop loss event has taken place.
         * Notifies all listeners if it has taken place.
         */
        void eventMonitor() override;
};

// ---------- Definitions ----------

CStopLossEvent::CStopLossEvent(
    COrderPool* order_pool
)   : COrderEventBase(order_pool)
{}

// ----------
void CStopLossEvent::eventMonitor() {
    CArrayObj* orders = order_pool_.Orders();
    
    // Check close type of orders
    for (int i = 0; i < orders.Total(); i++) {
        COrder* order = orders.At(i);
        if (order == NULL) {
            Print("CStopLossEvent::eventMonitor(): Order is NULL");
            continue;
        }

        // Check if order is closed
        if (order.getCloseType() == CT_STOPLOSS) {
            // Notify listeners
            CEventListenerBase* listener = listeners_.GetFirstNode();

            while (listener != NULL) {
                listener.stopLossCallback(*order);
                listener = listeners_.GetNextNode();
            }
        }
    }

    orders.Shutdown();
    delete orders;

    return;
}


#endif