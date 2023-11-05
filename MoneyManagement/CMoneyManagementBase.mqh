#property copyright "No copyright, Daniel Mooney"
#property version   "1.0"
#property library
#property strict

#ifndef MONEY_MANAGEMENT_MQH
#define MONEY_MANAGEMENT_MQH

#include <Arrays/List.mqh>
#include <MQL4Library/Order/COrderPool.mqh>
#include <MQL4Library/Event/CEventListenerBase.mqh>

/**
 * @brief A base class for money management strategies.
 * @details All memory allocated for orders is owned
 *      by the CMoneyManagementBase object.
 * 
 */
class CMoneyManagementBase: public CEventListenerBase {
    public:
        /**
         * @brief Constructs a new CMoneyManagementBase object
         * @details Initialise the orders list.
         * 
         */
        CMoneyManagementBase(
            COrderPool* order_pool
        );

    protected:
        COrderPool* order_pool_;
};


// ---------------------- Definitions ----------------------
CMoneyManagementBase::CMoneyManagementBase(
    COrderPool* order_pool
)   : order_pool_(order_pool)
{}

#endif