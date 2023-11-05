#property copyright "No copyright, Daniel Mooney"
#property version   "1.0"
#property library
#property strict

#ifndef NNF_MONEYMANAGEMENT_MQH
#define NNF_MONEYMANAGEMENT_MQH

#include <MQL4Library/MoneyManagement/CAtrMoneyManager.mqh>

class CNNFXMoneyManager: public CAtrMoneyManager {
    public:
        /**
         * @brief Construct a new CNNFXMoneyManager object
         * 
         * @param order_pool NULL if you don't want to use the order pool.
         * @param max_risk Maximum risk per trade in percentage of account balance.
         * @param stoploss_multiplier Multiple of ATR to use for stoploss.
         * @param takeprofit_multiplier Multiple of ATR to use for takeprofit.
         * @param atr_period 
         * @param atr_shift 
         */
        CNNFXMoneyManager(
            COrderPool* order_pool,
            double max_risk,
            double stoploss_multiplier,
            double takeprofit_multiplier,
            int atr_period = 14,
            int atr_shift = 0
        );

        /**
         * @brief Determines the parameters for an order
         * in the style of No nonsense forex.
         * 
         * @param symbol 
         * @param timeframe 
         * @param order_type 
         * @param stoploss 
         * @param takeprofit 
         * @param lots_1 The lots for the TP order
         * @param lots_2 The lots for the runner order
         */
        void calculateOrderParameters(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            ENUM_OrderType order_type,
            double& price,
            double& stoploss,
            double& takeprofit,
            double& lots_1,
            double& lots_2
        );
};

// ---------------------- Implementation ----------------------

CNNFXMoneyManager::CNNFXMoneyManager(
    COrderPool* order_pool,
    double max_risk,
    double stoploss_multiplier,
    double takeprofit_multiplier,
    int atr_period,
    int atr_shift
): CAtrMoneyManager(
    order_pool,
    max_risk,
    stoploss_multiplier,
    takeprofit_multiplier,
    atr_period,
    atr_shift
) {}

// ----------
void CNNFXMoneyManager::calculateOrderParameters(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    ENUM_OrderType order_type,
    double& price,
    double& stoploss,
    double& takeprofit,
    double& lots_1,
    double& lots_2
) {
    // Todo: Change risk based on exposure to other symbols
    // if (order_pool_ != NULL) {

    // }

    double total_lots = 0.0;
    CAtrMoneyManager::calculateOrderParameters(
        symbol,
        timeframe,
        order_type,
        price,
        stoploss,
        takeprofit,
        total_lots
    );

    total_lots *= 100;

    lots_1 = MathCeil(total_lots / 2.0) / 100.0;
    lots_2 = MathFloor(total_lots / 2.0) / 100.0;

    return;
}

#endif