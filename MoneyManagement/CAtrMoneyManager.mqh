#property copyright "No copyright, Daniel Mooney"
#property version   "1.0"
#property library
#property strict

#ifndef ATR_MM_MQH
#define ATR_MM_MQH

#include <MQL4Library/MoneyManagement/CMoneyManagementBase.mqh>
#include <MQL4Library/Order/COrderPool.mqh>
#include <MQL4Library/Order/COrder.mqh>

class CAtrMoneyManager: public CMoneyManagementBase {
    public:
        /**
         * @brief Construct a new CAtrMoneyManager object
         * 
         * @param order_pool NULL if you don't want to use the order pool.
         * @param risk Risk per trade in percentage of account balance.
         * @param stoploss_multiplier Multiple of ATR to use for stoploss.
         * @param takeprofit_multiplier Multiple of ATR to use for takeprofit.
         * @param atr_period 
         * @param atr_shift 
         */
        CAtrMoneyManager(
            COrderPool* order_pool,
            double risk,
            double stoploss_multiplier,
            double takeprofit_multiplier,
            int atr_period = 14,
            int atr_shift = 0
        );

        /**
         * @brief Determines the parameters for a single
         * order using the ATR method.
         * 
         * @param symbol 
         * @param timeframe 
         * @param order_type 
         * @param price
         * @param stoploss 
         * @param takeprofit 
         * @param lots 
         */
        void calculateOrderParameters(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            ENUM_OrderType order_type,
            double& price,
            double& stoploss,
            double& takeprofit,
            double& lots
        );
    
    protected:
        double risk_;
        double stoploss_multiplier_;
        double takeprofit_multiplier_;
        int atr_period_;
        int atr_shift_;
};

// ---------------------- Definitions ----------------------

CAtrMoneyManager::CAtrMoneyManager(
    COrderPool* order_pool,
    double risk,
    double stoploss_multiplier,
    double takeprofit_multiplier,
    int atr_period,
    int atr_shift
)   : CMoneyManagementBase(order_pool),
    risk_(risk),
    stoploss_multiplier_(stoploss_multiplier),
    takeprofit_multiplier_(takeprofit_multiplier),
    atr_period_(atr_period),
    atr_shift_(atr_shift)
{}

// ----------
void CAtrMoneyManager::calculateOrderParameters(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    ENUM_OrderType order_type,
    double& price,
    double& stoploss,
    double& takeprofit,
    double& lots
) {
    if (order_type == OT_NONE) return;

    double atr = iATR(
        symbol,
        timeframe,
        atr_period_,
        atr_shift_
    );
    
    // Calculate Stoploss and Take profit levels
    double delta_TP = takeprofit_multiplier_ * atr;
    double delta_SL = stoploss_multiplier_ * atr;

    int k = 0;

    if (order_type == ENUM_OrderType::OT_BUY) {
        price = SymbolInfoDouble(symbol, SYMBOL_ASK);
        k = 1;
    } else if (order_type == ENUM_OrderType::OT_SELL) {
        price = SymbolInfoDouble(symbol, SYMBOL_BID);
        k = -1;
    }

    stoploss = price - k * delta_SL;
    takeprofit = price + k * delta_TP;

    // Calculate lot size
    double trade_value = (risk_ / 100.0) * AccountBalance();
    double tick_value = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
    double stoploss_points = delta_SL / Point;

    lots = trade_value / (stoploss_points * tick_value);

    // round down to nearest 0.01
    lots = MathFloor(lots * 100) / 100;

    return;
}


#endif