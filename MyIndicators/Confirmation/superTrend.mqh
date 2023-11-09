#ifndef SUPERTREND_MQH
#define SUPERTREND_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class SuperTrend: public CIndicatorBase {
    public:
        SuperTrend(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int period,
            double multiplier
        );

        CIndicatorSignal computeSignal();

    private:
        int period_;
        double multiplier_;

        static string SUPERTREND_NAME_;
};

//---------------------- Constants ----------------------
string SuperTrend::SUPERTREND_NAME_ = "MyIndicators/SuperTrendUpdated";

//---------------------- Definitions ----------------------

SuperTrend::SuperTrend(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int period,
    double multiplier
) :
    CIndicatorBase(symbol, timeframe),
    period_(period),
    multiplier_(multiplier)
{}

//----------
CIndicatorSignal SuperTrend::computeSignal() {
    double trend_up = iCustom(
        symbol_,
        timeframe_,
        SUPERTREND_NAME_,
        period_,
        multiplier_,
        0,
        0
    );

    double trend_down = iCustom(
        symbol_,
        timeframe_,
        SUPERTREND_NAME_,
        period_,
        multiplier_,
        1,
        0
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (trend_up != EMPTY_VALUE) {
        signal = CIndicatorSignal::BUY;
    } else if (trend_down != EMPTY_VALUE) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif