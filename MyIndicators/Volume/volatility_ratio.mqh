#ifndef VOLATILITY_RATIO_MQH
#define VOLATILITY_RATIO_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class VolatilityRatio: public CIndicatorBase {
    public:
        VolatilityRatio(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int period
        );

        CIndicatorSignal computeSignal(
            int shift = 0
        );

    private:
        int period_;

        static string VOLATILITY_RATIO_NAME_;
};

//---------------------- Constants ----------------------
string VolatilityRatio::VOLATILITY_RATIO_NAME_ = "MyIndicators/Volatility ratio";

//---------------------- Definitions ----------------------

VolatilityRatio::VolatilityRatio(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int period
) :
    CIndicatorBase(symbol, timeframe),
    period_(period)
{}

//----------
CIndicatorSignal VolatilityRatio::computeSignal(
    int shift
) {
    double volatility_ratio = iCustom(
        symbol_,
        timeframe_,
        VOLATILITY_RATIO_NAME_,
        period_,
        0,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (volatility_ratio > 1.0) {
        signal = CIndicatorSignal::NEUTRAL;
    }

    return signal;
}

#endif