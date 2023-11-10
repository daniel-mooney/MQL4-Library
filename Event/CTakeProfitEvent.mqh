#ifndef CTAKEPROFITEVENT_MQH
#define CTAKEPROFITEVENT_MQH

#property copyright "No copyright, Daniel Mooney"
#property version   "1.0"

#include <MQL4Library/Event/COrderEventBase.mqh>
#include <MQL4Library/Order/COrderPool.mqh>
#include <Arrays/ArrayObj.mqh>

/**
 * @brief A class that monitors whether a take profit event has taken place
 * 
 */
class CTakeProfitEvent: public COrderEventBase {
    public:
        CTakeProfitEvent(
            COrderPool* order_pool
        );

        /**
         * @brief Checks whether a take profit event has taken place
         * Notifies all listeners if it has taken place.
         */
        int eventMonitor() override;
};

// ---------- Definitions ----------

CTakeProfitEvent::CTakeProfitEvent(
    COrderPool* order_pool
)   : COrderEventBase(order_pool)
{}

// ----------
int CTakeProfitEvent::eventMonitor() {
    CArrayObj* orders = order_pool_.Orders();
    int event_count = 0;
    
    // Check close type of orders
    for (int i = 0; i < orders.Total(); i++) {
        COrder* order = orders.At(i);
        if (order == NULL) {
            Print("CTakeProfitEvent::eventMonitor(): Order is NULL");
            continue;
        }
        // Check if order is closed
        if (order.getCloseType() == CT_TAKEPROFIT) {
            // Notify listeners
            CEventListenerBase* listener = listeners_.GetFirstNode();
            int k = 0;

            while (listener != NULL) {
                listener.takeProfitCallback(*order);
                listener = listeners_.GetNextNode();
            }

            event_count++;
        }
    }

    orders.Shutdown();
    delete orders;

    return event_count;
}

#endif