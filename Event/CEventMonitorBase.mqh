#ifndef EVENTMONITOR_MQH
#define EVENTMONITOR_MQH

#include <Object.mqh>
#include <Arrays/List.mqh>
#include <MQL4Library/Order/COrder.mqh>
#include <MQL4Library/Event/CEventListenerBase.mqh>

class CEventMonitorBase: public CObject {
    public:
        CEventMonitorBase();

        /**
         * @brief Destroy the CEventMonitorBase object
         * @details Frees the listeners_ list
         * 
         */
        virtual ~CEventMonitorBase();

        /**
         * @brief Adds a class as a listener to the event.
         * @note The listener must implement a callback function 
         *  that matches the event type.
         * 
         * @param listener 
         */
        void addListener(CEventListenerBase* listener);

        /**
         * @brief Checks whether an event has taken place
         * 
         * @return int How many events have taken place
         */
        virtual int eventMonitor() = 0;
    
    protected:
        CList* listeners_;
};

// ---------- Common event types

typedef void (*TradeEventCallback)(const COrder& order);

// ---------- Definitions ----------
CEventMonitorBase::CEventMonitorBase() {
    listeners_ = new CList();
    listeners_.FreeMode(false);    // do not free memory when deleting nodes
}

// ----------
CEventMonitorBase::~CEventMonitorBase() {
    listeners_.Clear();
    delete listeners_;
}

// ----------
void CEventMonitorBase::addListener(CEventListenerBase* listener) {
    listeners_.Add(listener);
}

#endif // EVENTMONITOR_MQH