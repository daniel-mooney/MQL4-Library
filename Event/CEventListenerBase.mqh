#property copyright "No, copyright, Daniel Mooney"
#property version   "1.0"
#property library
#property strict

#ifndef EVENT_LISTENER_BASE_MQH
#define EVENT_LISTENER_BASE_MQH

#include <MQL4Library/Order/COrder.mqh>
#include <Object.mqh>

/**
 * @brief Workaround for the lack of multiple inheritance
 * and Object callback ability in MQL4.
 * 
 */
class CEventListenerBase: public CObject {
    public:
        CEventListenerBase();

        virtual void takeProfitCallback(const COrder& order);

        virtual void stopLossCallback(const COrder& order);
};

// ---------- Definitions ----------

CEventListenerBase::CEventListenerBase() {}

void CEventListenerBase::takeProfitCallback(const COrder& order) {
    Print("CEventListenerBase::takeProfitCallback(): Take profit callback");
}

void CEventListenerBase::stopLossCallback(const COrder& order) {
    Print("CEventListenerBase::stopLossCallback(): Stop loss callback");
}

#endif