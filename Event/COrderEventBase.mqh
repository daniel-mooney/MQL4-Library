#property copyright "No copyright, Daniel Mooney"
#property version   "1.0"
#property library
#property strict

#ifndef ORDER_EVENT_MQH
#define ORDER_EVENT_MQH

#include <MQL4Library/Event/CEventMonitorBase.mqh>
#include <MQL4Library/Order/COrderPool.mqh>

/**
 * @brief Base class for events that are triggered
 * by a change in state of an order.
 * 
 */
class COrderEventBase: public CEventMonitorBase {
    public:
        COrderEventBase(
            COrderPool* order_pool
        );

    protected:
        COrderPool* order_pool_;
};

// ---------- Definitions ----------

COrderEventBase::COrderEventBase(
    COrderPool* order_pool
)   : order_pool_(order_pool)
{}

#endif