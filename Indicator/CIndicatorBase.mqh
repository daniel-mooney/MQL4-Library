#ifndef CINDICATOR_MQH
#define CINDICATOR_MQH

#property copyright     "No copyright, Daniel Mooney"
#property version       "1.0"
#property library

#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

/**
 * @brief A base class for all indicator logic implementations.
 * 
 */
class CIndicatorBase {
    public:
        CIndicatorBase(
            string symbol,
            ENUM_TIMEFRAMES timeframe
        );

        /**
         * @brief Returns the signal of the indicator
         *  for the current bar
         * 
         * @return IndicatorSignal 
         */
        virtual CIndicatorSignal computeSignal(
            int shift = 0
        ) = 0;
    
    protected:
        string symbol_;
        ENUM_TIMEFRAMES timeframe_;
};

// ---------------------- Definitions
CIndicatorBase::CIndicatorBase(
    string symbol,
    ENUM_TIMEFRAMES timeframe
) :
    symbol_(symbol),
    timeframe_(timeframe)
{}

#endif  // CINDICATOR_MQH