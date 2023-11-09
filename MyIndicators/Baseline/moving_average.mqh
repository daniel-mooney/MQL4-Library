#ifndef MOVING_AVERAGE_INDI_MQH
#define MOVING_AVERAGE_INDI_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class MovingAverage: public CIndicatorBase {
    public:
        MovingAverage(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int period,
            int shift,
            ENUM_MA_METHOD method,
            ENUM_APPLIED_PRICE applied_price
        );

        CIndicatorSignal computeSignal(
            int shift = 0
        );
    
    private:
        int period_;
        int shift_;
        ENUM_MA_METHOD method_;
        ENUM_APPLIED_PRICE applied_price_;
};

// ---------------------- Definitions
MovingAverage::MovingAverage(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int period,
    int shift,
    ENUM_MA_METHOD method,
    ENUM_APPLIED_PRICE applied_price
) :
    CIndicatorBase(symbol, timeframe),
    period_(period),
    method_(method),
    applied_price_(applied_price),
    shift_(shift)
{}

// ----------
CIndicatorSignal MovingAverage::computeSignal(
    int shift
) {
    double ma = iMA(
        symbol_,
        timeframe_,
        period_,
        shift_,
        method_,
        applied_price_,
        shift
    );

    double price = iClose(
        symbol_,
        timeframe_,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (price > ma) {
        signal = CIndicatorSignal::BUY;
    } else if (price < ma) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif